package com.civildebatewall {
	
	import com.civildebatewall.data.Data;
	import com.civildebatewall.data.containers.Post;
	import com.civildebatewall.data.containers.Question;
	import com.civildebatewall.data.containers.Thread;
	import com.kitschpatrol.futil.utilitites.ArrayUtil;
	import com.kitschpatrol.futil.utilitites.NumberUtil;
	
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.geom.Rectangle;
	
	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.getLogger;

	public class State extends EventDispatcher {

		private static const logger:ILogger = getLogger(State);
		
		// events
		public static const VIEW_CHANGE:String = "viewChange";
		public static const ACTIVE_THREAD_CHANGE:String = "activeThreadChange";
		public static const USER_STANCE_CHANGE_EVENT:String = "userStanceChange";
		public static const SORT_CHANGE:String = "sortChange";
		public static const SUPERLATIVE_POST_CHANGE:String = "superlativePostChange";
		public static const ON_STATS_VIEW_CHANGE:String = "onStatsViewChange";
		public static const ON_ACTIVE_POST_CHANGE:String = "onActivePostChange";
		public static const ON_HIGHLIGHT_WORD_CHANGE:String = "onHighlightWord";
		
		// constants
		// sort types
		public static const SORT_BY_RECENT:int = 0;
		public static const SORT_BY_YES:int = 1;
		public static const SORT_BY_NO:int = 2;
		public static const SORT_BY_MOST_DEBATED:int = 3;
		
		// stat superlative types
		public static const VIEW_MOST_DEBATED:int = 0;
		public static const VIEW_MOST_LIKED:int = 1;
		
		// network performance, TODO put on dashboard
		public var updateQuestionTime:int;
		public var updateThreadsTime:int;
		public var updatePostsAndUsersTime:int;
		public var updateStatsTime:int;
		public var updateTotalTime:int;
		public var photoLoadTime:int;		
		
		
		// ACTUAL STATE (THAT MATTERS) ========================================================================
		
		// user activity
		public var userActive:Boolean = true;
		public var secondsInactive:int = 0;
		public var inactivityOverlayArmed:Boolean = true;
		
		// navigation
		private static const VIEW_HISTORY_DEPTH:int = 10;		
		
		public var lastView:Function; // need this because back button pops off history
		public var activeQuestion:Question;
		public var viewHistory:Array = []; // for back button, newest at front, oldest aty back
		public var firstLoad:Boolean;
		public var lastThread:Thread = null;		
		public var activeThread:Thread = null;
		public var nextThread:Thread = null;		
		public var activePost:Post = null;		
		public var previousThread:Thread = null;		
		public var superlativePost:Post = null; // from stats
		
		public var sortMode:int = SORT_BY_RECENT;		
		public var statsView:int = VIEW_MOST_DEBATED; // triggers events
		
		// user (TODO wrap this up in the object?)
		public var userStance:String = "yes";
		public var userName:String = "";
		public var userOpinion:String = "";
		public var userPhoneNumber:String = "";
		public var userID:String = "";
		public var userThreadID:String = "";
		public var userPostID:String = "";		
		public var userImage:Bitmap = null;
		public var userImageFull:Bitmap = null;				
		public var userRespondingTo:Post; // which post we're debating
		public var userIsDebating:Boolean = false; // true if we're entering a debate through the "let's debate" button
		
		public var userStanceColorLight:uint;
		public var userStanceColorMedium:uint;
		public var userStanceColorDark:uint;
		public var userStanceColorOverlay:uint;
		public var userStanceColorDisabled:uint;
		
		public var highlightWordColor:uint = 0x000000;
		public var highlightWord:String = null;		
				
		public function State()	{
			CivilDebateWall.data.addEventListener(Data.DATA_PRE_UPDATE_EVENT, onDataPreUpdate);
		}
		
		private function onDataPreUpdate(e:Event):void {
			CivilDebateWall.data.removeEventListener(Data.DATA_UPDATE_EVENT, onDataPreUpdate);	
			// Initialize some stuff. only runs once at startup.
			CivilDebateWall.state.setActiveThread(ArrayUtil.randomElement(CivilDebateWall.data.threads));
			CivilDebateWall.state.setView(CivilDebateWall.kiosk.homeView);
		}				
		
		// SETTERS (with event dispatching) ================================================================================================================
		
		public function setStatsView(type:int):void {
			statsView = type;
			dispatchEvent(new Event(ON_STATS_VIEW_CHANGE));
		}		
		
		public function setSuperlativePost(post:Post):void {
			superlativePost = post;
			logger.info("Superlative post: " + superlativePost.id);			
			dispatchEvent(new Event(SUPERLATIVE_POST_CHANGE));
		}
		
		public function setActivePost(post:Post):void {
			activePost = post;
			logger.info("Active post: " + activePost.id);
			dispatchEvent(new Event(ON_ACTIVE_POST_CHANGE));
		}		
		
		public function setHighlightWord(word:String, color:uint = 0x000000):void {
			highlightWord = word;
			highlightWordColor = color;
			logger.info("Highlighting: " + highlightWord);
			dispatchEvent(new Event(ON_HIGHLIGHT_WORD_CHANGE));
		}		
		
		public function setSort(sortMode:int):void {
			this.sortMode = sortMode;
			
			// sort the debate list
			switch (sortMode) {
				case SORT_BY_RECENT:
					logger.info("Sorting by recent");
					CivilDebateWall.data.threads.sortOn("created", Array.DESCENDING | Array.NUMERIC); // newest first // Is this working?                   
					break;
				case SORT_BY_YES:
					logger.info("Sorting by yes");					
					CivilDebateWall.data.threads.sortOn("firstStance", Array.DESCENDING); // newest first // Is this working?                   
					break;
				case SORT_BY_NO:
					logger.info("Sorting by no");					
					CivilDebateWall.data.threads.sortOn("firstStance"); // newest first // Is this working?                 
					break;              
				case SORT_BY_MOST_DEBATED:
					logger.info("Sorting by most debated");					
					CivilDebateWall.data.threads.sortOn("postCount", Array.DESCENDING | Array.NUMERIC); // newest first // Is this working?                 
					break;              
				default:
					logger.error("Invalid thread sort mode '" + sortMode + "'");
			}
			
			// TODO update next / previous / etc.
			this.dispatchEvent(new Event(SORT_CHANGE));
		}
		
		public function setUserStance(s:String):void {
			userStance = s;	
			
			if (userStance == "yes") {
				userStanceColorLight = Assets.COLOR_YES_LIGHT;
				userStanceColorMedium = Assets.COLOR_YES_MEDIUM;
				userStanceColorDark = Assets.COLOR_YES_DARK;
				userStanceColorOverlay = Assets.COLOR_YES_OVERLAY;
				userStanceColorDisabled = Assets.COLOR_YES_DISABLED;
			}
			else if (userStance == "no") {
				userStanceColorLight = Assets.COLOR_NO_LIGHT;
				userStanceColorMedium = Assets.COLOR_NO_MEDIUM;
				userStanceColorDark = Assets.COLOR_NO_DARK;
				userStanceColorOverlay = Assets.COLOR_NO_OVERLAY;
				userStanceColorDisabled = Assets.COLOR_NO_DISABLED;				
			}
			else {
				logger.error("Invalid user stance '" + userStance + "'");
			}
			
			this.dispatchEvent(new Event(USER_STANCE_CHANGE_EVENT));
		}
		
		public function setView(view:Function, overrideLast:Function = null):void {
			if (view == activeView) {
				logger.warn("Already on view " + getViewName(activeView) + ", no need to change");			
			}
			else {
				// special case to pass in last view from back function
				if (overrideLast != null) {
					lastView = overrideLast;
				}
				else {
					lastView = activeView;
				}
				
				viewHistory.unshift(view); // keep track of where we've been
				
				logger.info("Changing view: " + getViewName(lastView) + " --> " + getViewName(view));		
				
				while (viewHistory.length > VIEW_HISTORY_DEPTH) viewHistory.pop(); // clear old history
			
				//logger.info(getHistoryLog());
			
				// clear the highlighting unless we're coming from the stats page 
				if ((highlightWord != null) && (highlightWord != "") && (lastView != CivilDebateWall.kiosk.statsView)) {
					logger.info("Clearing highlight");
					setHighlightWord("");
				}
				
				dispatchEvent(new Event(VIEW_CHANGE));
			}
		}
		
		public function setActiveThread(thread:Thread):void {
			if (activeThread == thread) {
				logger.warn("Already on thread " + thread.id + ", no need to change");
			}
			else {
				logger.info("Setting active thread to " + thread.id);			
				
				lastThread = activeThread;
				activeThread = thread;

				// clear the highlighting if unless we're coming from the stats page 
				if ((highlightWord != null) && (highlightWord != "") && (activeView != CivilDebateWall.kiosk.statsView)) {
					setHighlightWord("");
				}
	
				if (activeThread != null) {
					this.dispatchEvent(new Event(ACTIVE_THREAD_CHANGE));
				}			
			}
		}
		
		// HELPERS =======================================================================================================================		
		
		// convenience for grabbing from the top of the view history
		public function get activeView():Function { return viewHistory[0]; }
		//public function get lastView():Function { return viewHistory[1]; } 
	
		
		
		
		// should really move to controller
		public function goBack():void  {

		//logger.info(getHistoryLog());
			
			// manages history
			if (viewHistory.length == 0) {
				logger.error("Empty view history");
			}
			else {
				var overrideLast:Function = activeView;
				logger.info("Going back from " + getViewName(activeView) + " to " + getViewName(viewHistory[1]));
				viewHistory.shift() // clear current
				setView(viewHistory.shift(), overrideLast);
			}
		}
		
		public function clearUser():void {
			logger.info("Clearing user");
			userID = "";
			userName = "";
			if (userImage != null) userImage.bitmapData.dispose();
			userImage = null;
			userPhoneNumber = "";
			userOpinion = "";
			userIsDebating = false;
			if (userImageFull != null) userImageFull.bitmapData.dispose();
			userImageFull = null;
			userRespondingTo = null;
		}		
		
		public function getRightThread():Thread {
			var activeThreadIndex:int = CivilDebateWall.data.threads.indexOf(CivilDebateWall.state.activeThread);
			return (activeThreadIndex == CivilDebateWall.data.threads.length - 1) ? null : CivilDebateWall.data.threads[activeThreadIndex + 1]; 
		}
		
		public function getLeftThread():Thread {
			var activeThreadIndex:int = CivilDebateWall.data.threads.indexOf(CivilDebateWall.state.activeThread);
			//logger.info("Active thread index is: " + activeThreadIndex);
			return (activeThreadIndex == 0) ? null : CivilDebateWall.data.threads[activeThreadIndex - 1];
		}		
		
		// LOGGING HELPERS =======================================================================================================================
		
		public function stateLog():String {
			var out:String = "";
			out += "--- GLOBAL ---\n"
			out += varToString("activeThread.id");
			out += varToString("activePost.id");
			out += varToString("highlightWord");
			out += "--- USER ---\n"
			out += varToString("userPhoneNumber");
			out += varToString("userName");
			out += varToString("userStance");
			out += varToString("userOpinion");			
			out += varToString("userImageFull");
			out += varToString("userImage");
			out += varToString("userIsDebating");
			out += varToString("userRespondingTo.id");
			out += varToString("userThreadID");
			out += varToString("userPostID");
			out += "--- PERFORMANCE ---\n"
			out += varToString("updateQuestionTime");
			out += varToString("updateThreadsTime");
			out += varToString("updatePostsAndUsersTime");
			out += varToString("updateStatsTime");
			out += varToString("updateTotalTime");
			return out;
		}
		
		public function getHistoryLog():String {
			var maxDigits:int = viewHistory.length.toString().length;
			var out:String = "History stack:";

			if (viewHistory.length == 0) {
				out += " EMPTY";
			}
			else {
				out += "\n";
				for (var i:int = 0; i < viewHistory.length; i++) {
					out += NumberUtil.zeroPad(i, maxDigits)  + ". " + getViewName(viewHistory[i]);
					if (i < viewHistory.length - 1) out += "\n";
				}
			}

			return out;
		}
		
		public function getUpdateTimeString():String {
			return "Question: " + updateQuestionTime + " Threads: " + updateThreadsTime + " Posts and Users:" + updatePostsAndUsersTime +  " Stats:" + updateStatsTime + " Total:" + updateTotalTime; 			
		}	

		private function varToString(name:String):String {
			var parts:Array = name.split(".");
			var out:String = name + ": ";
			
			var target:Object = this;			
			for (var i:int = 0; i < parts.length; i++) {
				if (target == null) {
					target = "null";
					break;
				}
				else {		
					target = target[parts[i]];
				}
			}
			
			out += target + "\n";
			return out;
		}
		
		
		// Logging helper allows logging of function names, this is ugly
		// views should be objects instead
		public function getViewName(f:Function):String {
			if (f == CivilDebateWall.kiosk.homeView) return "home";
			if (f == CivilDebateWall.kiosk.inactivityOverlayView) return "inactivityOverlay";
			if (f == CivilDebateWall.kiosk.cameraCalibrationOverlayView) return "cameraCalibrationOverlay";
			if (f == CivilDebateWall.kiosk.debateStancePickerView) return "debateStancePicker";
			if (f == CivilDebateWall.kiosk.debateTypePickerView) return "debateTypePicker";
			if (f == CivilDebateWall.kiosk.flagOverlayView) return "flagOverlay";
			if (f == CivilDebateWall.kiosk.photoBoothView) return "photoBooth";
			if (f == CivilDebateWall.kiosk.opinionReviewView) return "opinionReview";
			if (f == CivilDebateWall.kiosk.smsPromptView) return "smsPrompt";
			if (f == CivilDebateWall.kiosk.statsView) return "stats";
			if (f == CivilDebateWall.kiosk.termsAndConditionsView) return "termsAndConditions";
			if (f == CivilDebateWall.kiosk.threadView) return "thread";
			if (f == CivilDebateWall.kiosk.opinionEntryView) return "opinionEntry";
			return "Unknown View";
		}				
		
	}
}
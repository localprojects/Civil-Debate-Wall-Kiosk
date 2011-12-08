package com.civildebatewall {
	
	import com.civildebatewall.data.Data;
	import com.civildebatewall.data.Post;
	import com.civildebatewall.data.Question;
	import com.civildebatewall.data.Thread;
	import com.kitschpatrol.futil.utilitites.ArrayUtil;
	
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
		public static const USER_STANCE_CHANGE:String = "userStanceChange";
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
		public var activeQuestion:Question;
		public var activeView:Function;
		public var lastView:Function;
		public var backDestination:Function;
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
			CivilDebateWall.state.activeView = CivilDebateWall.kiosk.homeView;
			CivilDebateWall.state.setActiveThread(ArrayUtil.randomElement(CivilDebateWall.data.threads));
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
			
			this.dispatchEvent(new Event(USER_STANCE_CHANGE));
		}
		
		public function setView(view:Function):void {
			// clear the highlighting if unless we're coming from the stats page 
			if ((highlightWord != null) && (highlightWord != "")) {
				if (lastView != CivilDebateWall.kiosk.statsView) {
					logger.info("Clearing highlight");
					setHighlightWord("");
				}
			}			
			
			lastView = activeView;
			activeView = view;
			
			logger.info("Changing view: " + lastView + " --> " + activeView);			
			dispatchEvent(new Event(VIEW_CHANGE));
		}
		
		public function setActiveThread(thread:Thread, overridePrevious:Thread = null, overrideNext:Thread = null):void {
			lastThread = activeThread;
			activeThread = thread;
			
			logger.info("Setting active thread to " + activeThread.id);
			
			// clear the highlighting if unless we're coming from the stats page 
			if ((highlightWord != null) && (highlightWord != "")) {
				if (activeView != CivilDebateWall.kiosk.statsView) {
					setHighlightWord("");
				}
			}

			// funky overrides for big-jump transitions
			/*
			if (overridePrevious != null) {
				previousThread = overridePrevious; 
			}
			else {
				previousThread = getPreviousThread();
			}					
			
			if (overrideNext != null) {
				nextThread =overrideNext; 
			}
			else {
				nextThread = getNextThread();
			}
			*/

			if (activeThread != null) {
				this.dispatchEvent(new Event(ACTIVE_THREAD_CHANGE));
			}			
		}
		
		// HELPERS =======================================================================================================================		
		
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
		
		
//		public function getFunctionName(f:Function):String {
//			//if (CivilDebateWall.kiosk.viewNameLookupTable.hasOwnProperty(f)) {
//				return CivilDebateWall.kiosk.viewNameLookupTable[f];
//			//}
//			//else {
//			//	return "Function"
//			//}
//		}
		
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
		
	}
}
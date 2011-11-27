package com.civildebatewall {
	import com.civildebatewall.data.Data;
	import com.civildebatewall.data.Post;
	import com.civildebatewall.data.TextMessage;
	import com.civildebatewall.data.Thread;
	import com.civildebatewall.kiosk.core.Kiosk;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	
	
	
	public class State extends EventDispatcher {
		
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
		public var statsView:int = VIEW_MOST_DEBATED; // triggers events
		
		// navigation
		public var activeView:Function;
		public var lastView:Function;
		public var backDestination:Function;
		
		
		public function setStatsView(type:int):void {
			statsView = type;
			dispatchEvent(new Event(ON_STATS_VIEW_CHANGE));
		}
		
		public var sortMode:int = SORT_BY_RECENT;
		

		
		public var lastThread:Thread = null;		
		public var activeThread:Thread = null;
		public var activePost:Post = null;		
		public var nextThread:Thread = null;
		public var previousThread:Thread = null;		
		public var threadOverlayOpen:Boolean = false;
		
		// for persistence accross reloads
		// TODO ditch this?
		public var activeThreadID:String = '';		
		public var activePostID:String = '';		
		

		// stats
		public var superlativePost:Post = null; // from stats
		
		public function setSuperlativePost(post:Post):void {
			superlativePost = post;
			dispatchEvent(new Event(SUPERLATIVE_POST_CHANGE));
		}
		
		public function setActivePost(post:Post):void {
			activePost = post;
			dispatchEvent(new Event(ON_ACTIVE_POST_CHANGE));
		}
				
		
		// scratch user... TODO wrap this up in the object?
		public var userStance:String = 'yes';
		public var userName:String = '';
		public var userOpinion:String = '';
		public var userPhoneNumber:String = '#########';
		public var userID:String = '';
		public var userImage:Bitmap = null;
		public var userImageFull:Bitmap = null;		
		public var lastTextMessageTime:Date;
		public var textMessage:TextMessage; // the message we're working with
		public var userStanceText:String = ''; // add exclamation point		
		public var userRespondingTo:Post; // which post we're debating
		
		public function setHighlightWord(word:String, color:uint = 0x000000):void {
			highlightWord = word;
			highlightWordColor = color;
			dispatchEvent(new Event(ON_HIGHLIGHT_WORD_CHANGE));
		}
		
		public var highlightWordColor:uint = 0x000000;
		public var highlightWord:String = null;
		
		
		
		// color state
		public var userStanceColorLight:uint;
		public var userStanceColorMedium:uint;
		public var userStanceColorDark:uint;
		public var userStanceColorOverlay:uint;
		public var userStanceColorDisabled:uint;		
		
		public var activeComment:String = null;
		public var userIsDebating:Boolean = false; // true if we're entering a debate through the "let's debate" button
		
		public var questionTextColor:uint = 0xff0000;

		
		public function State()	{
			//activeView = CivilDebateWall.kiosk.view.homeView; // Start at home
			CivilDebateWall.data.addEventListener(Data.DATA_PRE_UPDATE_EVENT, onDataPreUpdate);
		}
		
		private function onDataPreUpdate(e:Event):void {
			// Initialize some stuff. only runs once at startup.
			CivilDebateWall.state.activeView = CivilDebateWall.kiosk.view.homeView;
			CivilDebateWall.state.setActiveThread(CivilDebateWall.data.threads[0]);
			CivilDebateWall.data.removeEventListener(Data.DATA_UPDATE_EVENT, onDataPreUpdate);
						
		}				
		
		
		public function setSort(sortMode:int):void {
			this.sortMode = sortMode;
			
			// sort the debate list
			
			trace("sorting by " + sortMode);
			
			switch (sortMode) {
				case SORT_BY_RECENT:
					CivilDebateWall.data.threads.sortOn('created', Array.DESCENDING | Array.NUMERIC); // newest first // Is this working?					
					break;
				
				case SORT_BY_YES:
					CivilDebateWall.data.threads.sortOn('firstStance', Array.DESCENDING); // newest first // Is this working?					
					break;
				
				case SORT_BY_NO:
					CivilDebateWall.data.threads.sortOn('firstStance'); // newest first // Is this working?					
					break;				
				
				case SORT_BY_MOST_DEBATED:
					CivilDebateWall.data.threads.sortOn('postCount', Array.DESCENDING | Array.NUMERIC); // newest first // Is this working?					
					break;				
				
				default:
					trace("invalid sort type");
			}
			
			
			this.dispatchEvent(new Event(SORT_CHANGE));
		}
		
		
		
 
		public function clearUser():void {
			userID = '';
			userName = '';
			userImage = null;
			userPhoneNumber = '';
			userOpinion = '';
			userIsDebating = false;
			userImageFull = null;
			userRespondingTo = null;
			textMessage = null;
			lastTextMessageTime = null;
			//highlightWord = null;
		}
		
		public function setUserStance(s:String):void {
			userStance = s;
			
			userStanceText = userStance.toUpperCase() + '!';	
			
			if (userStance == 'yes') {
				userStanceColorLight = Assets.COLOR_YES_LIGHT;
				userStanceColorMedium = Assets.COLOR_YES_MEDIUM;
				userStanceColorDark = Assets.COLOR_YES_DARK;
				userStanceColorOverlay = Assets.COLOR_YES_OVERLAY;
				userStanceColorDisabled = Assets.COLOR_YES_DISABLED;
			}
			else {
				userStanceColorLight = Assets.COLOR_NO_LIGHT;
				userStanceColorMedium = Assets.COLOR_NO_MEDIUM;
				userStanceColorDark = Assets.COLOR_NO_DARK;
				userStanceColorOverlay = Assets.COLOR_NO_OVERLAY;
				userStanceColorDisabled = Assets.COLOR_NO_DISABLED;				
			}
			
			this.dispatchEvent(new Event(USER_STANCE_CHANGE));
		}
		
		public function setView(view:Function):void {
			lastView = activeView;
			activeView = view;
			dispatchEvent(new Event(VIEW_CHANGE));
		}
		
		
		public function setActiveThread(thread:Thread, overridePrevious:Thread = null, overrideNext:Thread = null):void {
			lastThread = activeThread;
			activeThread = thread;


			// logs backwards... ugh
			// CivilDebateWall.dashboard.log('---------------------------------');			
			
			for (var i:uint = activeThread.posts.length - 1; i > 0; i--) {
				trace(i);
				// CivilDebateWall.dashboard.log(activeThread.posts[i].id);
			}
			// CivilDebateWall.dashboard.log(activeThread.posts[0].id);
			
			// CivilDebateWall.dashboard.log('Posts:');			
			// CivilDebateWall.dashboard.log("Active thread:\n\t" + activeThread.id);			
			
			// CivilDebateWall.dashboard.log('---------------------------------');			
			
			// funky overrides for big-jump transitions
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

			trace("Prev: " + previousThread);
			trace("Active: " + activeThread);
			trace("Next: " + nextThread);
			
			this.dispatchEvent(new Event(ACTIVE_THREAD_CHANGE));
			
		}
		
		public function getNextThread():Thread {
			var grabNext:Boolean;
			
			// walk the object
			for each (var thread:Thread in CivilDebateWall.data.threads) {
				if (grabNext) {
					return thread;
				}
				
				if (thread.id == activeThread.id) {
					grabNext = true;
				}
			}
			
			return null;
		}
		
		public function getPreviousThread():Thread {
			var lastThread:Thread = null;
			
			// walk the object
			for each (var thread:Thread in CivilDebateWall.data.threads) {
				if (thread.id == activeThread.id) {
					return lastThread;
				}
				else {
					lastThread = thread;
				}
			}
			
			return null;
		}		
		
		
		

	}
}
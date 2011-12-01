package com.civildebatewall.data {
	import com.adobe.protocols.dict.Database;
	import com.adobe.serialization.json.JSON;
	import com.civildebatewall.CivilDebateWall;
	import com.civildebatewall.kiosk.core.Kiosk;
	import com.demonsters.debugger.MonsterDebugger;
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.DataLoader;
	import com.greensock.loading.LoaderMax;
	
	
	public class Thread {
		
		private var _id:String;
		private var _posts:Array;
		private var _firstPost:Post;
		private var _postCount:uint;
		private var _created:Date;
		private var _createdRaw:uint;
		
		
		public function Thread(jsonObject:Object)	{
			_id = jsonObject['id'];
			_posts = []; // load later
		}
		
		
		public function get id():String { return _id;	}
		public function get posts():Array { return _posts;	}
		public function get firstPost():Post { return _firstPost;	}
		public function get firstStance():String { return _firstPost.stance }
		public function get postCount():uint { return _postCount; }
		public function get created():Date { return _created; }	
		public function get createdRaw():uint { return _createdRaw; }	
		
		// sorting			
		// negative means a before b
		// positive means a after b
		// zero means no difference
		public static function compareCreatedDescending(a:Thread, b:Thread):Number {
			return b.created.time - a.created.time;
		}
		
		public static function compareStanceYes(a:Thread, b:Thread):Number {
			if ((a.firstStance == Post.STANCE_YES) && (b.firstStance == Post.STANCE_NO)) return -1;
			if ((a.firstStance == Post.STANCE_NO) && (b.firstStance == Post.STANCE_YES)) return 1;
			return 0;
		}		
		
		public static function compareStanceNo(a:Thread, b:Thread):Number {
			if ((a.firstStance == Post.STANCE_YES) && (b.firstStance == Post.STANCE_NO)) return 1;
			if ((a.firstStance == Post.STANCE_NO) && (b.firstStance == Post.STANCE_YES)) return -1;
			return 0;
		}				
		
		public static function comparePostCountDescending(a:Thread, b:Thread):Number {
			return b.postCount - a.postCount;
		}
		
		// sets a bunch of convenience variables after the posts are loaded
		public function init():void {
			_posts.sortOn('created', Array.NUMERIC);			
			_firstPost = posts[0];
			_firstPost.isThreadStarter = true;
			_created = _firstPost.created;
			_createdRaw = _created.time;
			_postCount = _posts.length;
			
			// disable first level at replies
			// null out the response to for first level respondents
			// @replies for first level seems overkill
			for each (var post:Post in _posts) {
				if ((post.responseToID != null) && (post.responseToID == _firstPost.id)) {
					post.responseToID = null;
				}			
			}	

		}
			
		//			
		//			
		//			MonsterDebugger.trace(this, "Posts: " + _posts.length);
		//			
		//			_created = _posts[0].created; // use the first post as the created date...
		//			createdRaw = _created.time;
		//			
		//			_firstPost = _posts[0];
		//			_firstPost.isThreadStarter = true;
		//			
		//			// sort by date, newest last
		//			_posts.sortOn('created');		
		//			
		//			_postCount = _posts.length;
		//			
		//			
		//			// disable first level at replies
		//			// null out the response to for first level respondents
		//			// @replies for first level seems overkill
		//			for each (tempPost in _posts) {
		//				if ((tempPost.responseToID != null) && (tempPost.responseToID == _firstPost.id)) {
		//					tempPost.responseToID = null;
		//				}			
		//			}			
		//			
		//		}						
			
		
	}
}
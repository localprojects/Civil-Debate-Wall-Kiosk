package com.civildebatewall.data.containers {
	
	public class Thread {
		
		private var _id:String;
		private var _posts:Array;
		private var _firstPost:Post;
		private var _postCount:uint;
		private var _created:Date;
		private var _createdRaw:uint;
		
		public function Thread(jsonObject:Object)	{
			_id = jsonObject["id"];
			_posts = []; // load later
		}
			
		// sets a bunch of convenience variables after the posts are loaded
		public function init():void {
			_posts = _posts.sortOn("created", Array.NUMERIC);			
			_firstPost = posts[0];
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
		
		public function get id():String { return _id;	}
		public function get posts():Array { return _posts;	}
		public function get firstPost():Post { return _firstPost;	}
		public function get firstStance():String { return _firstPost.stance }
		public function get postCount():uint { return _postCount; }
		public function get responseCount():uint { return _postCount - 1; }		
		public function get created():Date { return _created; }	
		public function get createdRaw():uint { return _createdRaw; }		
		
	}
}
package com.civildebatewall.data {
	import com.adobe.protocols.dict.Database;
	import com.adobe.serialization.json.JSON;
	import com.civildebatewall.CDW;
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.DataLoader;
	import com.greensock.loading.LoaderMax;
	
	
	public class Thread {
		
		private var _id:String;
		private var _posts:Array;
		private var _firstPost:Post;
		private var _postCount:uint;
		private var _created:Date;
		public var createdRaw:Number;
		
		
		public function Thread(jsonObject:Object)	{
			_id = jsonObject['id'];
			trace("creating thread " + _id);
			_posts = [];
			
			// queue up post loading
			CDW.database.postQueue.append(new DataLoader(CDW.settings.serverPath + '/api/threads/' + _id, {name: _id, estimatedBytes:2400, onComplete: onPostsLoaded}) );
		}
		
		private function onPostsLoaded(e:LoaderEvent):void {
			trace("Loaded posts for " + _id);

			var jsonObject:Object = JSON.decode(LoaderMax.getContent(_id));	
				
			for each (var jsonPost:Object in jsonObject['posts']) {
				var tempPost:Post = new Post(jsonPost, this);
				_posts.push(tempPost); // one copy in the thread
				trace("Created: " + tempPost.text); 				
				CDW.database.posts.push(tempPost); // and one copy globally
			}
			

			_posts.sortOn('created', Array.NUMERIC);
			
			_created = _posts[0].created; // use the first post as the created date...
			createdRaw = _created.time;
			
			_firstPost = _posts[0];
			_firstPost.isThreadStarter = true;
			
			// sort by date, newest last
			_posts.sortOn('created');		
			
			_postCount = _posts.length;
			
			
			// disable first level at replies
			// null out the response to for first level respondents
			// @replies for first level seems overkill
			for each (tempPost in _posts) {
				if ((tempPost.responseToID != null) && (tempPost.responseToID == _firstPost.id)) {
					tempPost.responseToID = null;
				}			
			}			
			
		}
		
		public function get id():String { return _id;	}
		public function get posts():Array { return _posts;	}
		public function get firstPost():Post { return _firstPost;	}
		public function get postCount():uint { return _postCount; }
		public function get created():Date { return _created; }		
	}
}
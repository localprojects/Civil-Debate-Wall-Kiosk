package com.civildebatewall.data {
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
				var tempPost:Post = new Post(jsonPost);
				_posts.push(tempPost); // one copy in the thread
				CDW.database.posts.push(tempPost); // and one copy globally
			}
			
			// TODO sort by date
			
		}
		
		public function get id():String { return _id;	}
		public function get posts():Array { return _posts;	}
		public function get firstPost():Post { return _posts[0];	}
		public function get postCount():uint { return _posts.length; }
	}
}
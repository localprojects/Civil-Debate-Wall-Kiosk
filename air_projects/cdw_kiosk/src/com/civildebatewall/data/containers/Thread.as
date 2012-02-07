/*--------------------------------------------------------------------
Civil Debate Wall Kiosk
Copyright (c) 2012 Local Projects. All rights reserved.

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as
published by the Free Software Foundation, either version 2 of the
License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public
License along with this program. 

If not, see <http://www.gnu.org/licenses/>.
--------------------------------------------------------------------*/

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

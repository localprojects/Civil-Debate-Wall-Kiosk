package com.civildebatewall.data {
	
	import com.civildebatewall.kiosk.Kiosk;
	
	public class Word extends Object {
	
		public var yesCases:uint = 0;
		public var noCases:uint = 0;
		public var total:uint = 0;
		public var posts:Array = [];
		public var word:String;	
		public var difference:Number;
		public var normalDifference:Number;		
		
				
		public function Word(theWord:String) {
			word = theWord;
		}
					

//		private var _yesCases:uint;
//		private var _noCases:uint;
//		private var _total:uint;
//		private var _posts:Array;
//		private var _word:String;
//		
//		public function Word(jsonObject:Object) {
//			
//			_yesCases = jsonObject['yesCases'];
//			_noCases = jsonObject['noCases'];
//			_total = jsonObject['total'];
//			
//			for each (var postID:String in jsonObject['posts']) {
//				_posts.push(CDW.database.getPostByID(postID));
//			}
//			// TODO sort order?
//		}
//		
//		public function get yesCases():uint { return _yesCases; }
//		public function get noCases():uint { return _noCases; }
//		public function get total():uint { return _total; }
//		public function get word():String { return _word; }
//		public function get posts():Array { return _posts; }				
		
	}
}
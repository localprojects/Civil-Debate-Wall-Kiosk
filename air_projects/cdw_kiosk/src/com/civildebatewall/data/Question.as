package com.civildebatewall.data {
	import com.civildebatewall.CivilDebateWall;
	
	public class Question {
		
		private var _text:String;
		private var _id:String;
		private var _category:Category;
		
		public function Question(jsonObject:Object)	{
			_text = jsonObject["text"];
			_id = jsonObject["id"];
			_category = CivilDebateWall.data.getCategoryById(jsonObject["category"]["id"]);
		}
		
		public function get text():String {	return _text;	}
		public function get id():String {	return _id;	}
		public function get category():Category { return _category; }
		
	}
}
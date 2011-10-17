package com.civildebatewall.data {
	
	public class Question extends Object {
		
		private var _text:String;
		private var _id:String;
		
		public function Question(jsonObject:Object)	{
			super();
			_text = jsonObject['text'];
			_id = jsonObject['id'];
		}
		
		public function get text():String {
			return _text;
		}
		
		public function get id():String {
			return _id;
		}		

		
	}
}
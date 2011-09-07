package com.civildebatewall.data {
	
	public class Question extends Object {
		
		private var _question:String;
		private var _id:String;
		
		public function Question(jsonObject:Object)	{
			super();
			_question = jsonObject['text'];
			_id = jsonObject['id'];
		}
		
		public function get question():String {
			return _question;
		}
		
		public function get id():String {
			return _id;
		}		

		
	}
}
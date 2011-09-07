package com.civildebatewall.data {
	import com.civildebatewall.Utilities;
	
	public class TextMessage extends Object {
		
		private var _text:String;
		private var _created:Date;
		private var _phoneNumber:String;
		
		public function TextMessage(jsonObject:Object) {
			_text = jsonObject['message'];
			_created = Utilities.parseJsonDate(jsonObject['created']);
			_phoneNumber = jsonObject['phoneNumber'];
		}
		
		public function get text():String { return _text; }
		public function get created():Date { return _created; }
		public function get phoneNumber():String { return _phoneNumber; }
		
		// for testing
		public function set text(s:String):void { _text = s; }
		public function set created(d:Date):void { _created = d; }
		public function set phoneNumber(s:String):void { _phoneNumber = s; }		
	}
}
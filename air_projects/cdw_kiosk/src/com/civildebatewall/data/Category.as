package com.civildebatewall.data {
	
	public class Category	{
		
		private var _id:String;
		private var _name:String;
		
		public function Category(jsonObject:Object) {
			_id = jsonObject['id'];
			_name = jsonObject['name']; 
		}
		
		public function get id():String {	return _id;	}
		public function get name():String {	return _name;	}
		
	}
}
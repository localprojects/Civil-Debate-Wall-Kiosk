package com.civildebatewall.data {
	
	import com.civildebatewall.kiosk.core.Kiosk;
	
	public class Word extends Object {
	
		public var yesCases:uint = 0;
		public var noCases:uint = 0;
		public var total:uint = 0;
		public var posts:Array = [];
		public var theWord:String;	
		public var difference:Number;
		public var normalDifference:Number;		
		
				
		public function Word(theWord:String) {
			this.theWord = theWord;
		}
		

		public function toString():String {
			return theWord + "\tTotal: " + total + "\n";
		}
	}
}
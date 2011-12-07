package com.civildebatewall.data {
	
	public class Word extends Object {
	
		public var yesCases:uint;
		public var noCases:uint;
		public var total:uint;
		public var posts:Array;
		public var theWord:String;	
		public var difference:Number;
		public var normalDifference:Number;		
		
		public function Word(theWord:String) {
			yesCases = 0;
			noCases = 0;
			total = 0;
			posts = [];
			
			this.theWord = theWord;
		}

		public function toString():String {
			return theWord + "\tTotal: " + total + "\n";
		}
		
	}
}
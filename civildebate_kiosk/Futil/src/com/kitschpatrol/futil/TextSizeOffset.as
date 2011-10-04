package com.kitschpatrol.futil {
	
	internal class TextSizeOffset {
		
		// Holds the leftovers from optical trimming
		public var topWhitespace:int;
		public var textFieldSize:int;
		public var bottomWhitespace:int;
		
		public function TextSizeOffset(textFieldSize:int, topWhitespace:int, bottomWhitespace:int)	{
			this.textFieldSize = textFieldSize;
			this.topWhitespace = topWhitespace;
			this.bottomWhitespace = bottomWhitespace;
		}
		
		public function toString():String {
			return textFieldSize.toString();
		}
	}
}
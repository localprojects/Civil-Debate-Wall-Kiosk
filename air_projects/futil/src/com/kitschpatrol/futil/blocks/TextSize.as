package com.kitschpatrol.futil.blocks {
	
	internal class TextSize {
		
		// Holds the leftovers from optical trimming
		public var textPixelSize:Number;
		public var textFieldSize:Number;
		public var topWhitespace:Number;
		public var rightWhitespace:Number;
		public var bottomWhitespace:Number;
		public var leftWhitespace:Number;		
		

		public function TextSize(textPixelSize:Number = 0, textFieldSize:Number = 0, topWhitespace:Number = 0, rightWhitespace:Number = 0, bottomWhitespace:Number = 0, leftWhitespace:Number = 0)	{
			this.textPixelSize = textPixelSize;
			this.textFieldSize = textFieldSize;
			this.topWhitespace = topWhitespace;
			this.rightWhitespace = rightWhitespace;
			this.bottomWhitespace = bottomWhitespace;
			this.leftWhitespace = leftWhitespace;
		}
		
		public function get fieldHeight():Number {
			return topWhitespace + textPixelSize + bottomWhitespace;
		}
		
		public function get leadingOffset():Number {
			return -((bottomWhitespace - 2) + (topWhitespace - 2));			
		}
		
	}
}
//-------------------------------------------------------------------------------
// Copyright (c) 2012 Eric Mika
// 
// Permission is hereby granted, free of charge, to any person obtaining a copy 
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights 
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell 
// copies of the Software, and to permit persons to whom the Software is 
// furnished to do so, subject to the following conditions:
// 	
// 	The above copyright notice and this permission notice shall be included in 
// 	all copies or substantial portions of the Software.
// 		
// 	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, 
// 	EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF 
// 	MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. 
// 	IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY 
// 	CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT 
// 	OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR 
// 	THE	USE OR OTHER DEALINGS IN THE SOFTWARE.
//-------------------------------------------------------------------------------

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

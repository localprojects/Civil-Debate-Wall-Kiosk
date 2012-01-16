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

package com.kitschpatrol.futil.easing {
	
	public class EaseMap {
		// Sloppy mapping of Penner's easing equations from the time / begin / change / duration
		// format to the map() argument style of input val / input min / input max / output min / output max
		
		public static function easeOutExpo(value:Number, low1:Number, high1:Number, low2:Number, high2:Number):Number {
			return Ease.easeOutExpo(value - low1, low2, high2 - low2, high1 - low1);
		}
		
		public static function easeInExpo(value:Number, low1:Number, high1:Number, low2:Number, high2:Number):Number {
			return Ease.easeInExpo(value - low1, low2, high2 - low2, high1 - low1);
		}	
		
		public static function easeInOutExpo(value:Number, low1:Number, high1:Number, low2:Number, high2:Number):Number {
			return Ease.easeInOutExpo(value - low1, low2, high2 - low2, high1 - low1);
		}
		
		public static function easeOutQuart(value:Number, low1:Number, high1:Number, low2:Number, high2:Number):Number {
			return Ease.easeOutQuart(value - low1, low2, high2 - low2, high1 - low1);
		}
		
		public static function easeInQuart(value:Number, low1:Number, high1:Number, low2:Number, high2:Number):Number {
			return Ease.easeInQuart(value - low1, low2, high2 - low2, high1 - low1);
		}	
		
		public static function easeInOutQuart(value:Number, low1:Number, high1:Number, low2:Number, high2:Number):Number {
			return Ease.easeInOutQuart(value - low1, low2, high2 - low2, high1 - low1);
		}		
		
	}
}

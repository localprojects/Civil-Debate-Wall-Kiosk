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

package com.kitschpatrol.futil {
	
	public class Math2 {
		
		public function Math2() {
			throw new Error("Futil's Math2 is a static class and cannot be instantiated.");
		}		
		
		public static function map(value:Number, min1:Number, max1:Number, min2:Number, max2:Number):Number {
			return min2 + (max2 - min2) * ((value - min1) / (max1 - min1));
		}		
		
		public static function mapClamp(value:Number, min1:Number, max1:Number, min2:Number, max2:Number):Number {
			return clamp(map(value, min1, max1, min2, max2), min2, max2);
		}				
		
		public static function clamp(value:Number, min:Number, max:Number):Number {
			//return (value <= min) ? min : max;
			if (value < min) return min;
			if (value > max) return max;
			return value;
		}
		

		public static function degToRad(degrees:Number):Number {
			return degrees * Math.PI / 180; 
		}
		
		public static function radToDeg(radians:Number):Number {
			return radians * 180 / Math.PI; 
		}		
		
	}
}

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

package com.kitschpatrol.futil.utilitites {
	import com.kitschpatrol.futil.Math2;
	
	public class NumberUtil {
		
		
		// adds zeros to the right
		public static function zeroPad(number:*, width:int):String {
			var ret:String = ""+ number.toString();
			while( ret.length < width )
				ret= "0" + ret;
			return ret;
		}
		
		
		public static function formatPhoneNumber(s:String):String {
			// remove country code
			s = s.replace("+1", "");
			
			// put it into US format...
		//return "(" + s.substr(0, 3) + ") " + s.substr(3, 3) + "-" + s.substr(6);
			return s.substr(0, 3) + "-" + s.substr(3, 3) + "-" + s.substr(6);			
		}		
		
		
		// takes a number between 0 and 1 and steps it by the step value
		// like adjustring precision, but more flexible
		public static function quantize(normal:Number, stepSize:Number):Number {
			return int(normal / stepSize) * stepSize;
		}
		
		
		// only returns 0 or 1 if we are exactly on them, otherwise counts steps
		public static function quantizeInclusive(normal:Number, stepSize:Number):Number {
			if (normal == 0) return normal;
			if (normal == 1) return normal;
			
			// TODO last step already equals destination
			return int(Math2.map(normal, 0, 1, stepSize, 1) / stepSize) * stepSize;
		}
		
		
		public static function formatDynamicPhoneNumber(number:String):String {
			// format the phone number intelligently as it builds. similar to the iPhone's dial pad.
			var bareNumber:String = number.replace(/[^\d]/gs, ""); 
			
			if (bareNumber.length >= 8) {
				return "(" + bareNumber.substr(0, 3) + ") " + bareNumber.substr(3, 3) + "-" + bareNumber.substr(6);				
			}
			else if (bareNumber.length >= 4) {
				return bareNumber.substr(0, 3) + "-" + bareNumber.substr(3);
			}
			else {
				return bareNumber;
			}
		}		
	
		// The start of a unit test for the above
		/*
		var counts:Object = {}; // keep stats
		for(var i:Number = 0; i <= 1; i += 0.01) {
			var quantized:Number = NumberUtil.quantizeInclusive(i, 0.2); 
			
			// intiialize
			if (!counts.hasOwnProperty(quantized.toString())) counts[quantized.toString()] = 0;
			
			// increment
			counts[quantized.toString()]++;
		}
		
		*/
		
		
		
	}
}

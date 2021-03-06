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
	import com.kitschpatrol.futil.Random;
	
	public class ArrayUtil {

		public static function removeElement(a:Array, theItem:*):void{
			for (var i:int = 0; i < a.length; i++){
				if (a[i] == theItem){
					a.splice(i,1);
					i-=1;
				}
			}
		}
		
		public static function randomElement(a:Array):* {
			return a[int(Random.range(0, a.length - 1))];
		}
		
		public static function average(a:Array):Number {
			var sum:Number = 0;
			
			for (var i:int = 0; i < a.length; i++) {
				sum += a[i];
			}
			
			return sum / a.length;
		}		
		
		
		public static function twoDimensionalArray(cols:int, rows:int):Array {
			var a:Array = new Array(cols);
			for(var i:int = 0; i < a.length; i++) {
				a[i] = new Array(rows);
			}
			return a;
		}
		
		
		public static function contains(needle:Object, haystack:Array):Boolean {
			return (haystack.indexOf(needle) > -1);
		}		
		
		// returns a copy
		public static function shuffle(a:Array):Array {
			var a2:Array = [];
			while (a.length > 0) {
				a2.push(a.splice(Math.round(Math.random() * (a.length - 1)), 1)[0]);
			}
			return a2;
		}		
		
		// adapted from weave
		public static function flatten(a:Array, a2:Array = null):Array	{
			if (a2 == null)
				a2 = [];
			if (a == null)
				return a2;
			
			for (var i:int = 0; i < a.length; i++)
				if (a[i] is Array)
					flatten(a[i], a2);
				else
					a2.push(a[i]);
			return a2;
		}
		
		
		// Adds an element to an array if it doesn't already exist
		// Regardless, returns the length of the array
		public static function pushIfUnique(array:Array, item:*):uint {
			for each (var existingItem:* in array) {
				if (item == existingItem) return array.length;
			}
			return array.push(item);
		}
		
		// Merges two arrays, without duplicates
		// e.g. [1, 2, 3] and [1, 2, 4] returns [1, 2, 3, 4]
		public static function mergeUnique(a1:Array, a2:Array):Array {
			var aOut:Array = [];
			
			for each (var item1:* in a1) {
				pushIfUnique(aOut, item1);
			}			
			
			for each (var item2:* in a2) {
				pushIfUnique(aOut, item2);
			}
			
			return aOut;
		}		
		
		
		// looks through a numerical field of each object in an an array of objects, returns max value
		public static function maxInObjectArray(array:Array, field:String):Number {
			var maxValue:Number = Number.MIN_VALUE;
			
			for each (var o:Object in array) {
				if (o[field] > maxValue) maxValue = o[field];
			}
			
			return maxValue;
		}
		
		// looks through a numerical field of each object in an an array of objects, returns min value	
		public static function minInObjectArray(array:Array, field:String):Number {
			var minValue:Number = Number.MAX_VALUE;
			
			for each (var o:Object in array) {
				if (o[field] < minValue) minValue = o[field];
			}
			
			return minValue;
		}		
		
		

	}
}

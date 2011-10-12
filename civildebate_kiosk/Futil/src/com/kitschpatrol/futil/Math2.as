package com.kitschpatrol.futil {
	
	public class Math2 {
		
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
		
		public static function randRange(low:int, high:int):int {
			return Math.floor(Math.random() * (high - low + 1) + low);			
		}			
		
		public static function degToRad(degrees:Number):Number {
			return degrees * Math.PI / 180; 
		}
		
		public static function radToDeg(radians:Number):Number {
			return radians * 180 / Math.PI; 
		}		
		
	}
}
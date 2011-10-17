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
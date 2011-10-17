package com.kitschpatrol.futil.utilitites {
	
	public class ColorUtil {
		
		
		public static function rgb(r:int, g:int, b:int):uint {
			return r << 16 | g << 8 | b;
		}
		
		public static function gray(v:int):uint {
			return v << 16 | v << 8 | v;
		}
		
		public static function grayPercent(percent:Number):uint {
			var v:int = 255 - ((percent / 100) * 255);
			return v << 16 | v << 8 | v;
		}		
				
		
	}
}
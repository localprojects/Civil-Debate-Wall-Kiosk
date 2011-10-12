package com.kitschpatrol.futil.utilitites {
	
	
	import flash.geom.Rectangle;
	
	public class GeomUtil {

		public static function scaleRect(rectangle:Rectangle, scaleFactor:Number):Rectangle {
			return new Rectangle(rectangle.x * scaleFactor, rectangle.y * scaleFactor, rectangle.width * scaleFactor, rectangle.height * scaleFactor);
		}
	}
}
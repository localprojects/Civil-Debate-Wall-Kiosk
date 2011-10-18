package com.kitschpatrol.futil.utilitites {
	
	
	import flash.geom.Rectangle;
	import flash.display.DisplayObject;
	import flash.geom.Point;
	
	public class GeomUtil {

		public static function scaleRect(rectangle:Rectangle, scaleFactor:Number):Rectangle {
			return new Rectangle(rectangle.x * scaleFactor, rectangle.y * scaleFactor, rectangle.width * scaleFactor, rectangle.height * scaleFactor);
		}
		
		// Move to DisplayObjectUtil class?
		public static function centerWithin(containee:DisplayObject, container:DisplayObject):void {
			containee.x = (container.width / 2) - (containee.width / 2);
			containee.y = (container.height / 2) - (containee.height / 2);			
		}
		
		// returns a point at the center of a rectangle
		public static function centerPoint(rect:Rectangle):Point {
			return new Point(rect.x + (rect.width / 2), rect.y + (rect.height / 2));
		}		
		
	}
}
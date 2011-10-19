package com.kitschpatrol.futil.utilitites {
	
	
	import flash.display.DisplayObject;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
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
		
		
		// resizes childrect to fit in targetREct (assumes 0 x and y);
		public static function scaleToFit(childRect:Rectangle, targetRect:Rectangle):Rectangle {
			var widthRatio:Number = targetRect.width / childRect.width;
			var heightRatio:Number = targetRect.height/ childRect.height;
			var scaleRatio:Number = Math.min(widthRatio, heightRatio);
			
			return scaleRect(childRect, scaleRatio);
		}		
		
	}
}
package com.kitschpatrol.futil.utilitites {
	import flash.display.Shape;
	import flash.geom.Rectangle;
	
	public class GraphicsUtil {

		// Draw rectangles
		public static function shapeFromRect(rect:Rectangle, color:uint = 0x000000):Shape {
			var shape:Shape = new Shape();
			shape.graphics.beginFill(color);
			shape.graphics.drawRect(rect.x, rect.y, rect.width, rect.height);
			shape.graphics.endFill();
			return shape;
		}
		
		public static function shapeFromSize(width:Number, height:Number, color:uint = 0x000000):Shape {
			var shape:Shape = new Shape();
			shape.graphics.beginFill(color);
			shape.graphics.drawRect(0, 0, width, height);
			shape.graphics.endFill();
			return shape;
		}		
		
	}
}
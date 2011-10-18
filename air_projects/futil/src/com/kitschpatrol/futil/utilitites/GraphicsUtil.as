package com.kitschpatrol.futil.utilitites {
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.Matrix;
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
		
		// Removes ALL children, returns number removed
		public static function removeChildren(o:DisplayObjectContainer):uint {
			var numRemoved:uint = 0;
			while (o.numChildren > 0) {
				o.removeChild(o.getChildAt(0));
				numRemoved++;				
			}						
			return numRemoved;
		}		
		
		
		// Put in futil? or kind of heretical?
		// blocks to this better
		public static function setRegistrationPoint(s:DisplayObject, regx:Number, regy:Number, showRegistration:Boolean = false):void {
			//translate movieclip 
			s.transform.matrix = new Matrix(1, 0, 0, 1, -regx, -regy);
			
			//registration point.
			if (showRegistration)	{
				var mark:Sprite = new Sprite();
				mark.graphics.lineStyle(1, 0x000000);
				mark.graphics.moveTo(-5, -5);
				mark.graphics.lineTo(5, 5);
				mark.graphics.moveTo(-5, 5);
				mark.graphics.lineTo(5, -5);
				s.parent.addChild(mark);
			}
		}		
		
		
	}
}
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
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Graphics;
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
		
		
		// these operate in place on any graphics object
		public static function fillRect(g:Graphics, width:Number, height:Number, color:uint = 0x000000, alpha:Number = 1):void {
			g.beginFill(color, alpha);
			g.drawRect(0, 0, width, height);
			g.endFill();
		}		
		
		
	}
}

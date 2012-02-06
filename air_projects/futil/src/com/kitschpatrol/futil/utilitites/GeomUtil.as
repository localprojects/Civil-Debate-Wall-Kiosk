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
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	public class GeomUtil {

		public static function scaleRect(rectangle:Rectangle, scaleFactor:Number):Rectangle {
			return new Rectangle(rectangle.x * scaleFactor, rectangle.y * scaleFactor, rectangle.width * scaleFactor, rectangle.height * scaleFactor);
		}
		
		// Move to DisplayObjectUtil class?
		public static function centerWithin(containee:DisplayObject, container:DisplayObject = null):void {
			// use parent if null
			if (container == null) {
				container = containee.parent;
			}
			
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

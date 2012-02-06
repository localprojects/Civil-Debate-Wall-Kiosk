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
	
	import com.kitschpatrol.futil.Math2;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.PixelSnapping;
	import flash.geom.Matrix;

	public class BitmapUtil {
				
		// scales down a bitmap data object so it fits with the width and height specified
		public static function scaleDataToFit(b:BitmapData, maxWidth:int, maxHeight:int):BitmapData {
			var widthRatio:Number = maxWidth / b.width;
			var heightRatio:Number = maxHeight / b.height;
			var scaleRatio:Number = Math.min(widthRatio, heightRatio);
			
			var matrix:Matrix = new Matrix();
			matrix.scale(scaleRatio, scaleRatio);
			
			var o:BitmapData = new BitmapData(b.width * scaleRatio, b.height * scaleRatio);
			o.draw(b, matrix);
			return o;
		}
		
		public static function scaleToFit(b:Bitmap, maxWidth:int, maxHeight:int):Bitmap {
			return new Bitmap(scaleDataToFit(b.bitmapData, maxWidth, maxHeight), PixelSnapping.AUTO, true);
		}
		
		// scales down a bitmap data object so it fills the width and height specified, even if it has to crop		
		public static function scaleDataToFill(b:BitmapData, newWidth:int, newHeight:int):BitmapData {
			// scale
			var widthRatio:Number = newWidth / b.width;
			var heightRatio:Number = newHeight / b.height;
			var scaleRatio:Number = Math.max(widthRatio, heightRatio);
			
			var matrix:Matrix = new Matrix();
			matrix.scale(scaleRatio, scaleRatio);
			
			// crop and center
			matrix.tx = ((b.width * scaleRatio) - newWidth) / -2;
			matrix.ty = ((b.height * scaleRatio) - newHeight) / -2;			
			
			var o:BitmapData = new BitmapData(newWidth, newHeight);
			o.draw(b, matrix);
			return o;
		}
		
		public static function scaleToFill(b:Bitmap, maxWidth:int, maxHeight:int):Bitmap {
			return new Bitmap(scaleDataToFill(b.bitmapData, maxWidth, maxHeight), PixelSnapping.AUTO, true);
		}		
		

		// finds position inside a bitmap using a normal		
		// useful for picking gradient colors from horizontal bitmaps
		public static function getPixelAtNormal(b:Bitmap, x:Number, y:Number):uint {
			return b.bitmapData.getPixel(Math.floor(Math2.mapClamp(x, 0, 1, 0, b.width - 1)), Math.floor(Math2.mapClamp(y, 0, 1, 0, b.height - 1)));
		}
		
	}
}

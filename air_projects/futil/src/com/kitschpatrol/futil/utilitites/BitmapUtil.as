package com.kitschpatrol.futil.utilitites {
	
	import com.kitschpatrol.futil.Math2;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Matrix;

	public class BitmapUtil {
				
		// scales down a bitmap data object so it fits with the width and height specified
		public static function scaleToFit(b:BitmapData, maxWidth:int, maxHeight:int):BitmapData {
			var widthRatio:Number = maxWidth / b.width;
			var heightRatio:Number = maxHeight / b.height;
			var scaleRatio:Number = Math.min(widthRatio, heightRatio);
			
			var matrix:Matrix = new Matrix();
			matrix.scale(scaleRatio, scaleRatio);
			
			var o:BitmapData = new BitmapData(b.width * scaleRatio, b.height * scaleRatio);
			o.draw(b, matrix);
			return o;
		}
		
		// scales down a bitmap data object so it fills the width and height specified, even if it has to crop		
		public static function scaleToFill(b:BitmapData, newWidth:int, newHeight:int):BitmapData {
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
		

		// finds position inside a bitmap using a normal		
		// useful for picking gradient colors from horizontal bitmaps
		public static function getPixelAtNormal(b:Bitmap, x:Number, y:Number):uint {
			return b.bitmapData.getPixel(Math.floor(Math2.mapClamp(x, 0, 1, 0, b.width - 1)), Math.floor(Math2.mapClamp(y, 0, 1, 0, b.height - 1)));
		}
		
	}
}
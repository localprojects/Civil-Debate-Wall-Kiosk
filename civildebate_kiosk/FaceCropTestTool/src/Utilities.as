package {
	import flash.display.*;
	import flash.geom.*;
	import flash.events.*;
	import flash.filesystem.*;
	import flash.net.*;
	
	public class Utilities {
		public function Utilities()
		{
		}
		
		// From CDW Wall Utilities.as
		public static function cropToFace(sourceBitmap:Bitmap, sourceFaceRectangle:Rectangle, targetFaceRectangle:Rectangle):Bitmap {
			// lots of stuff hard coded here... dimensions of target, location of face in target
			
			// give up if the target face rectangle is too far away?
			var targetBounds:Rectangle = new Rectangle(0, 0, 1080, 1920);			
			var sourceBounds:Rectangle = sourceBitmap.bitmapData.rect;
			
			// Figure out scale required to fit face rect in target rect
			var rectWidthRatio:Number = targetFaceRectangle.width / sourceFaceRectangle.width;
			var rectHeightRatio:Number = targetFaceRectangle.height / sourceFaceRectangle.height;
			var rectScaleRatio:Number = Math.min(rectWidthRatio, rectHeightRatio);
			
			// Scale the source stuff so face sizes match
			var scaledSourceBounds:Rectangle = scaleRect(sourceBounds, rectScaleRatio);			
			var scaledFaceRectangle:Rectangle = scaleRect(sourceFaceRectangle, rectScaleRatio);
			
			// align face centers 
			var targetCenter:Point = centerPoint(targetFaceRectangle);
			var scaledSourceCenter:Point = centerPoint(scaledFaceRectangle);
			var sourceTranslation:Point = targetCenter.subtract(scaledSourceCenter);
			
			scaledSourceBounds.x = sourceTranslation.x; 
			scaledSourceBounds.y = sourceTranslation.y;			
			
			// TODO nudge left and right before growing unnecessarily			
			
			// grow around face point until it fits the target bitmap...
			var aspectRatio:Number = scaledSourceBounds.width / scaledSourceBounds.height;
			var originalWidth:Number = scaledSourceBounds.width;
			var originalHeight:Number = scaledSourceBounds.height;
			
			// TODO abort safety
			while (!scaledSourceBounds.containsRect(targetBounds)) {
				trace("Scaling... " + scaledSourceBounds);
				trace("To fit within: " + targetBounds);
				scaledSourceBounds.width += 1  * aspectRatio;
				scaledSourceBounds.x -= (scaledSourceCenter.x / originalWidth) * aspectRatio;
				
				scaledSourceBounds.height += 1;				
				scaledSourceBounds.y -= (scaledSourceCenter.y / originalHeight);								
			}
			
			var totalScaleX:Number = scaledSourceBounds.width / sourceBitmap.width;
			var totalScaleY:Number = scaledSourceBounds.height / sourceBitmap.height;			
			
			trace("Scaled: " + totalScaleX + " x " + totalScaleY);
			
			// TODO set some kind of scale threshold
			
			// now it fits, we have the the bounds of the final rectangle
			trace("This fits: " + scaledSourceBounds);
			
			// draw the face cropped image it into a bitmap
			var portraitBitmap:Bitmap = new Bitmap(new BitmapData(1080, 1920), PixelSnapping.NEVER, true);
			
			// turn the rectangle representation of the new position and scale into a matrix
			var drawMatrix:Matrix = new Matrix();
			drawMatrix.scale(totalScaleX, totalScaleY);
			drawMatrix.tx = Math.floor(scaledSourceBounds.x);
			drawMatrix.ty = Math.floor(scaledSourceBounds.y);			
			
			// draw it into a bitmao
			var faceCroppedBitmap:Bitmap = new Bitmap(new BitmapData(1080, 1920), PixelSnapping.NEVER, true);
			faceCroppedBitmap.bitmapData.draw(sourceBitmap, drawMatrix, null, null, null, true);
			return faceCroppedBitmap;
		}
		
		public static function scaleRect(rectangle:Rectangle, scaleFactor:Number):Rectangle {
			return new Rectangle(rectangle.x * scaleFactor, rectangle.y * scaleFactor, rectangle.width * scaleFactor, rectangle.height * scaleFactor);
		}
		
		public static function centerPoint(rect:Rectangle):Point {
			return new Point(rect.x + (rect.width / 2), rect.y + (rect.height / 2));
		}
		
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
		
		// loads a bitmap, passes it to the callback
		public static function loadImageFromDisk(path:String, callback:Function):void {
			trace("loading");
			var file:File = new File(path);
			
			var imageLoader:Loader = new Loader();
			imageLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, function(e:Event):void {
				callback(imageLoader.content as Bitmap);
			});
			
			imageLoader.load(new URLRequest(file.url));
		}
				
		
		

	}
}
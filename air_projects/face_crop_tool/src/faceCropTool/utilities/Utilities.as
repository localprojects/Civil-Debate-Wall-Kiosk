/*------------------------------------------------------------------------------
Copyright (c) 2012 Local Projects. All rights reserved.

This file is part of The Civil Debate Wall.

The Civil Debate Wall is free software: you can redistribute it and/or modify
it under the terms of the GNU Affero General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

The Civil Debate Wall is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU Affero General Public License for more details.

You should have received a copy of the GNU Affero General Public License
along with The Civil Debate Wall.  If not, see <http://www.gnu.org/licenses/>.
------------------------------------------------------------------------------*/

package faceCropTool.utilities {
	import com.kitschpatrol.futil.utilitites.GeomUtil;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.PixelSnapping;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.URLRequest;
	
	
	public class Utilities {
		
		// From CDW Wall Utilities.as, TODO merge them back over?
		public static function cropToFace(sourceBitmap:Bitmap, sourceFaceRectangle:Rectangle, targetFaceRectangle:Rectangle, targetWidth:int, targetHeight:int):Bitmap {
			// lots of stuff hard coded here... dimensions of target, location of face in target
			
			// give up if the target face rectangle is too far away?
			var targetBounds:Rectangle = new Rectangle(0, 0, targetWidth, targetHeight);			
			var sourceBounds:Rectangle = sourceBitmap.bitmapData.rect;
			
			// Figure out scale required to fit face rect in target rect
			var rectWidthRatio:Number = targetFaceRectangle.width / sourceFaceRectangle.width;
			var rectHeightRatio:Number = targetFaceRectangle.height / sourceFaceRectangle.height;
			var rectScaleRatio:Number = Math.min(rectWidthRatio, rectHeightRatio);
			
			// Scale the source stuff so face sizes match
			var scaledSourceBounds:Rectangle = GeomUtil.scaleRect(sourceBounds, rectScaleRatio);			
			var scaledFaceRectangle:Rectangle = GeomUtil.scaleRect(sourceFaceRectangle, rectScaleRatio);
			
			// align face centers 
			var targetCenter:Point = GeomUtil.centerPoint(targetFaceRectangle);
			var scaledSourceCenter:Point = GeomUtil.centerPoint(scaledFaceRectangle);
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
				//trace("Scaling... " + scaledSourceBounds);
				//trace("To fit within: " + targetBounds);
				scaledSourceBounds.width += 1  * aspectRatio;
				scaledSourceBounds.x -= (scaledSourceCenter.x / originalWidth) * aspectRatio;
				
				scaledSourceBounds.height += 1;				
				scaledSourceBounds.y -= (scaledSourceCenter.y / originalHeight);								
			}
			
			var totalScaleX:Number = scaledSourceBounds.width / sourceBitmap.width;
			var totalScaleY:Number = scaledSourceBounds.height / sourceBitmap.height;			
			
			//trace("Scaled: " + totalScaleX + " x " + totalScaleY);
			
			// TODO set some kind of scale threshold
			
			// now it fits, we have the the bounds of the final rectangle
			//trace("This fits: " + scaledSourceBounds);
			
			// draw the face cropped image it into a bitmap
			var portraitBitmap:Bitmap = new Bitmap(new BitmapData(targetWidth, targetHeight), PixelSnapping.NEVER, true);
			
			// turn the rectangle representation of the new position and scale into a matrix
			var drawMatrix:Matrix = new Matrix();
			drawMatrix.scale(totalScaleX, totalScaleY);
			drawMatrix.tx = Math.floor(scaledSourceBounds.x);
			drawMatrix.ty = Math.floor(scaledSourceBounds.y);			
			
			// draw it into a bitmao
			var faceCroppedBitmap:Bitmap = new Bitmap(new BitmapData(targetWidth, targetHeight), PixelSnapping.NEVER, true);
			faceCroppedBitmap.bitmapData.draw(sourceBitmap, drawMatrix, null, null, null, true);
			return faceCroppedBitmap;
		}
		

		public static function loadImageFaceCrop(path:String, callback:Function):void {
			var file:File = new File(path);
			
			var imageLoader:Loader = new Loader();
			imageLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, function(e:Event):void {
				callback(imageLoader.content as Bitmap, file.name);
			});
			
			imageLoader.load(new URLRequest(file.url));
		}

		
	}
}
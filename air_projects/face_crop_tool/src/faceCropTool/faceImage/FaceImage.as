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

package faceCropTool.faceImage {
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;

	
	public class FaceImage extends Sprite {
	
		public static const FACE_SELECTED:String = "faceSelected";		
		
		public var faceRect:Rectangle;
		public var fileName:String;
		public var originalBitmap:Bitmap;
		public var cropBitmap:Bitmap;
		public var faceCropBitmap:Bitmap;
		public var faceCropBitmapOverlay:Bitmap;
		public var cropBitmapOverlay:Bitmap;
	
		
		public function FaceImage() {
			faceRect = null;
			this.buttonMode = true;
			
			this.addEventListener(MouseEvent.CLICK, onClicked);
		}
		
		
		private function onClicked(e:MouseEvent):void {			
			this.dispatchEvent(new FaceImageEvent(FaceImage.FACE_SELECTED, true));
			
		}
		
	}
}
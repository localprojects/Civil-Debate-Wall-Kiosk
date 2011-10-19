package faceCropTool
{
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	
	public class FaceImage extends Sprite {
		
		public var faceRect:Rectangle;
		public var fileName:String;
		public var originalBitmap:Bitmap;
		public var cropBitmap:Bitmap;
		public var faceCropBitmap:Bitmap;
		public var faceCropBitmapOverlay:Bitmap;
		public var cropBitmapOverlay:Bitmap;
		
		public function FaceImage() {
			faceRect = null;
		}
	}
}
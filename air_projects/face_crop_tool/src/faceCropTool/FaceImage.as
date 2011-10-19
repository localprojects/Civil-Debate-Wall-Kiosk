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
		public var croppedBitmap:Bitmap;
		
		public function FaceImage() {
			faceRect = null;
		}
	}
}
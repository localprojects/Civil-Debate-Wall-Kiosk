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
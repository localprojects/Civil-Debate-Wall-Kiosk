package net.localprojects.blocks {
	
	import com.adobe.images.JPGEncoder;
	import com.greensock.events.TweenEvent;
	
	import flash.display.*;
	import flash.events.*;
	
	import jp.maaash.ObjectDetection.ObjectDetectorEvent;
	
	
	import mx.utils.Base64Encoder;
	
	import net.localprojects.Utilities;
	import net.localprojects.camera.*;
	import flash.utils.ByteArray;
	import com.adobe.images.*;
	import net.localprojects.CDW;
	
	
	
	public class PortraitCamera extends BlockBase {
		
		private var cameraFeed:ICameraFeed;
		public var cameraBitmap:Bitmap;		
		private var faceDetector:FaceDetector;

		public function PortraitCamera() {
			super();
			init();
		}
		
		private function init():void {
			cameraBitmap = new Bitmap();			
			addChild(cameraBitmap);
			
			cameraFeed = new WebcamFeed();
			cameraFeed.addEventListener(CameraFeedEvent.NEW_FRAME_EVENT, onNewFrame);			
			
			faceDetector = new FaceDetector();
			faceDetector.addEventListener(ObjectDetectorEvent.DETECTION_COMPLETE, onFaceFound);
			
			cameraFeed.start(); // TODO better not to leave it on?
			cameraFeed.pause();						
		}

		
		private function onFaceFound(e:ObjectDetectorEvent):void {
			trace("Face!");
			trace(e.target.faceRect);
			
		}
		
		override protected function beforeTweenIn():void {
			super.beforeTweenIn();
			// Automatically start webcam capture
			cameraFeed.play();
			trace("playing camera")
		}
		
		override protected function afterTweenOut():void {
			super.afterTweenOut();
			// Automatically stop webcam capture			
			cameraFeed.pause();
			trace("pausing camera")			
		}
		
		private function onNewFrame(e:CameraFeedEvent):void {
			//cameraBitmap.bitmapData = Utilities.scaleToFill(e.target.frame, 1080, 1920);
			cameraBitmap.bitmapData = e.target.frame;			
			//faceDetector.processBitmap(cameraBitmap.bitmapData);
		}
		
		

		
		public function takePhoto():void {
			trace("taking photo");
			
			
			// movie this to view.as?
			// if webcam only, just save that
			
			
			
//			cameraBitmap.bitmapData = Utilities.scaleToFill(cameraBitmap.bitmapData, 100, 100);			
//			var jpgEncoder:JPGEncoder = new JPGEncoder(98);
//			var byteArray:ByteArray = jpgEncoder.encode(cameraBitmap.bitmapData);		
//			var encoder:Base64Encoder = new Base64Encoder();
//			encoder.encodeBytes(byteArray);			
//			trace(encoder.toString());
			
		}
				
	}
}
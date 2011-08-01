package net.localprojects.blocks {
	
	import com.greensock.events.TweenEvent;
	
	import flash.display.*;
	import flash.events.*;
	
	import jp.maaash.ObjectDetection.ObjectDetectorEvent;
	
	import net.localprojects.Utilities;
	import net.localprojects.camera.*;
	
	
	public class PortraitCamera extends BlockBase {
		
		private var cameraFeed:ICameraFeed;
		private var cameraBitmap:Bitmap;		
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
			cameraBitmap.bitmapData = Utilities.scaleToFill(e.target.frame, 1080, 1920);
			//faceDetector.processBitmap(cameraBitmap.bitmapData);
		}
		
		public function takePhoto():void {
			trace("taking photo");
		}
				
	}
}
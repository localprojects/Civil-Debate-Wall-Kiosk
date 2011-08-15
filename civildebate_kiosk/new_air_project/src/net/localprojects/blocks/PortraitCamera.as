package net.localprojects.blocks {
	
	import com.adobe.images.*;
	import com.adobe.images.JPGEncoder;
	import com.greensock.events.TweenEvent;
	
	import flash.display.*;
	import flash.events.*;
	import flash.utils.ByteArray;
	import flash.utils.Timer;
	
	import jp.maaash.ObjectDetection.ObjectDetectorEvent;
	
	import mx.utils.Base64Encoder;
	
	import net.localprojects.CDW;
	import net.localprojects.Utilities;
	import net.localprojects.camera.*;
	
	
	
	public class PortraitCamera extends BlockBase {
		
		private var cameraFeed:ICameraFeed;
		public var cameraBitmap:Bitmap;		
		private var faceDetector:FaceDetector;
		
		private var faceCounter:int; // counts how many faces were found within an interval
		private var facePersistenceTimer:Timer;
		private var faceCountThreshold:int; // how many we need to find within interval in order to fire shutter
		
		public var detectFaces:Boolean;

		private var onFaceShutter:Function;
		
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
			
			faceCounter = 0;
			
			// go by frames instead?
			facePersistenceTimer = new Timer(3000, 0);
			facePersistenceTimer.stop();
			facePersistenceTimer.addEventListener(TimerEvent.TIMER, onFacePersistenceTimerComplete);
			
			faceCountThreshold = 10;
		}

		
		private function onFaceFound(e:ObjectDetectorEvent):void {
			trace("Face!");
			trace(e.target.faceRect);
			
			if(!facePersistenceTimer.running) {
				facePersistenceTimer.reset();
				facePersistenceTimer.start();
			}
			else {
				trace("Found " + faceCounter + " faces");
				faceCounter++;
			}
			
			
		}
		
		private function onFacePersistenceTimerComplete(e:TimerEvent):void {
			trace("Found " + faceCounter + " faces in last five seconds");
			
			// if enough, take the picture....
			if (faceCounter > faceCountThreshold) {
				onFaceShutter(new Event("FaceShutter"));
			}
			
			facePersistenceTimer.stop();
			faceCounter = 0;
		}
		
		override protected function beforeTweenIn():void {
			super.beforeTweenIn();
			// Automatically start webcam capture
			cameraFeed.play();
			trace("playing camera")
		}
		
		override protected function afterTweenIn():void {
			super.afterTweenIn();
			detectFaces = true;
		}
		
		override protected function beforeTweenOut():void {
			super.beforeTweenOut();
			detectFaces = false;
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
			
			// only run face detection if we're tweened in
			// so the transitions won't stutter
			if (detectFaces) {			
				faceDetector.processBitmap(cameraBitmap.bitmapData);
			}
		}
		
		public function setOnFaceShutter(f:Function):void {
			onFaceShutter = f;
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
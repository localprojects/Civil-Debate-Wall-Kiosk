package net.localprojects.blocks {
	
	import com.adobe.images.*;
	import com.adobe.images.JPGEncoder;
	import com.greensock.TweenMax;
	import com.greensock.easing.*;
	import com.greensock.events.TweenEvent;
	
	import flash.display.*;
	import flash.events.*;
	import flash.geom.Point;
	import flash.utils.ByteArray;
	import flash.utils.Timer;
	
	import jp.maaash.ObjectDetection.ObjectDetectorEvent;
	
	import mx.utils.Base64Encoder;
	
	import net.localprojects.Assets;
	import net.localprojects.BitmapPlus;
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
		
		
		private var blurBitmap:BitmapPlus; 
		private var maskBitmap:Bitmap;		
		private var maskContainer:Sprite;
		
		private var faceCircle:Shape;
		private var faceTarget:BitmapPlus;
		
		public var slr:SLRCamera;
		
		
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
			facePersistenceTimer = new Timer(4000, 0);
			facePersistenceTimer.stop();
			facePersistenceTimer.addEventListener(TimerEvent.TIMER, onFacePersistenceTimerComplete);
			
			faceCountThreshold = 10;
			
			// blur mask
			blurBitmap = new BitmapPlus(new BitmapData(stageWidth, stageHeight, true, 0));
			maskBitmap = Assets.portraitBlurMask;
			maskBitmap.x = -540;
			maskBitmap.y = -960;					
			
			maskContainer = new Sprite();
			maskContainer.blendMode = BlendMode.LAYER;
			maskBitmap.blendMode = BlendMode.ALPHA;
			maskContainer.addChild(blurBitmap);
			maskContainer.addChild(maskBitmap);			
			addChild(maskContainer);
			
			
			blurBitmap.blur = 40;
			blurBitmap.saturation = 0;
			blurBitmap.brightness = 1.5
			
			
			// create the face circle
			faceCircle = new Shape();
			faceCircle.graphics.lineStyle(30, Assets.COLOR_YES_LIGHT, 1);
			faceCircle.graphics.drawCircle(-120, -120, 240);
			faceCircle.alpha = 0;
			addChild(faceCircle);
			
			faceTarget = new BitmapPlus(Assets.faceTarget.bitmapData);
			faceTarget.tintAmount = 1;
			faceTarget.tintColor = Assets.COLOR_YES_DARK;
			
			faceTarget.x = 285;
			faceTarget.y = 404;
			addChild(faceTarget);
			
			if (!CDW.settings.webcamOnly) {
				slr = new SLRCamera();
			}
			
		}
		
		
		private function onFaceFound(e:ObjectDetectorEvent):void {
			trace("Face!");
			trace(e.target.faceRect);
			
			
			var faceCenter:Point = Utilities.centerPoint(e.target.faceRect);
			faceCenter.x *= (stageWidth / faceDetector.monitor.width);
			faceCenter.y *= (stageHeight / faceDetector.monitor.height);			
			
			// a little offset?
			// TODO WTF
			faceCenter.x += 50;
			faceCenter.y += 50;			
			
			
			TweenMax.to(faceCircle, 0.5, {alpha: 1, x: faceCenter.x, y: faceCenter.y, ease: Quart.easeInOut});
			
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
			
			// fade out the face circle
			TweenMax.to(faceCircle, 5, {alpha: 0});
			
			
			// if enough, take the picture....
			if (faceCounter > faceCountThreshold) {
				// disabled for demo
				//onFaceShutter(new Event("FaceShutter"));
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
		
		
		private var frameCount:int = 0;
		private var faceInterval:int = 1; // detect every n frames
		
		private function onNewFrame(e:CameraFeedEvent):void {
			frameCount++;
			
			
			//cameraBitmap.bitmapData = Utilities.scaleToFill(e.target.frame, 1080, 1920);
			cameraBitmap.bitmapData = e.target.frame;
			
			// only run face detection if we're tweened in
			// so the transitions won't stutter
			if (detectFaces && ((frameCount % faceInterval) == 0)) {			
				faceDetector.processBitmap(cameraBitmap.bitmapData);
			}
			
			
			// apply blur and desaturation masking
			blurBitmap.bitmapData = cameraBitmap.bitmapData.clone();			
			
			
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
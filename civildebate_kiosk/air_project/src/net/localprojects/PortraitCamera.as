package net.localprojects {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.media.Camera;
	import flash.media.Video;
	import flash.geom.Matrix;
	
	// TODO easier to use face detection for the shutter? Detect face and then "3 2 1"?
	public class PortraitCamera extends Sprite {
		
		private var camera:Camera;
		private var video:Video;
		private var videoBitmap:Bitmap;
		private var cameraWidth:int;
		private var cameraHeight:int;
		private var cropWidth:int;
		private var cropHeight:int;
		
		public function PortraitCamera() {
			super();
			
			cameraWidth = 800;
			cameraHeight = 600;
			
			cropWidth = 450;
			cropHeight = 600;
			
			// set up the camera
			camera = Camera.getCamera();
			camera.setMode(cameraWidth, cameraHeight, 30);
			
			video = new Video(cameraWidth, cameraHeight);
			video.attachCamera(camera);
			video.addEventListener(Event.ENTER_FRAME, onVideoFrame);
			videoBitmap = new Bitmap(new BitmapData(cropWidth, cropHeight, false, 0));
			addChild(videoBitmap);
			
			// add the overlay
			Assets.cameraSilhouette.alpha = 0.5;			
			addChild(Assets.cameraSilhouette);
		}
		
		private function onVideoFrame(e:Event):void {
			// copy a crop into the video bitmap
			var matrix:Matrix = new Matrix();
			matrix.scale(-1, 1); // flip horizontally
			matrix.translate(cameraWidth - ((cameraWidth - cropWidth) / 2), 0);
			
			videoBitmap.bitmapData.draw(video, matrix);
		}
		
		private function onShutter(e:Event):void {
			// detach the camera
			this.video.removeEventListener(Event.ENTER_FRAME, onVideoFrame);
			video.attachCamera(null);
			
			
//			faceProcessor.urlLoader.addEventListener(Event.COMPLETE, onFaceProcessComplete);
//			faceProcessor.process(videoBitmap.bitmapData);
//			this.dispatchEvent(new Event(FaceGrabber.PROCESSING));
		}		
		
	}
}
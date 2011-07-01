package net.localprojects {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.events.EventDispatcher;
	import jp.maaash.ObjectDetection.ObjectDetector;
	import jp.maaash.ObjectDetection.ObjectDetectorEvent;
	import jp.maaash.ObjectDetection.ObjectDetectorOptions;
	
	// Adapted from Mario Klingemann's code
	// http://www.quasimondo.com/archives/000687.php
	// License situation TBA
	public class FaceDetector extends EventDispatcher 	{
		
		private var detector:ObjectDetector;
		private var options:ObjectDetectorOptions;		
		private var detectionMap:BitmapData;
			
		public function FaceDetector() {
			super();
			
			detector = new ObjectDetector();
			var options:ObjectDetectorOptions = new ObjectDetectorOptions();
			options.min_size  = 30;
			detector.options = options;
			detector.addEventListener(ObjectDetectorEvent.DETECTION_COMPLETE, detectionHandler);
		}
		
		private function detectionHandler(e:ObjectDetectorEvent):void {
			// compensate for scale, and then forward the event
			if (e.rects.length > 0) {
				this.dispatchEvent(e);
			}
		}
		
		public function processBitmap(photo:Bitmap):void {
			detector.detect(photo.bitmapData);		
		}
		
		
		
	}
}


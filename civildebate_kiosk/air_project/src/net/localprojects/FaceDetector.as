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
		private var drawMatrix:Matrix;
		private var scaleFactor:int = 4;
		
		private var sourceWidth:int = 640;
		private var sourceHeight:int = 480;
			
		public function FaceDetector(_sourceWidth:int, _sourceHeight:int) {
			super();
			sourceWidth = _sourceWidth;
			sourceHeight = _sourceHeight;			
			
			detector = new ObjectDetector();
			
			var options:ObjectDetectorOptions = new ObjectDetectorOptions();
			options.min_size  = 30;
			detector.options = options;
			detector.addEventListener(ObjectDetectorEvent.DETECTION_COMPLETE, detectionHandler);
			
			detectionMap = new BitmapData(sourceWidth / scaleFactor, sourceHeight / scaleFactor, false, 0 );
			drawMatrix = new Matrix(1 / scaleFactor, 0, 0, 1 / scaleFactor);			
		}
		
		private function detectionHandler(e:ObjectDetectorEvent):void {
			// compensate for scale, and then forward the event
			if (e.rects.length > 0) {				
				for (var i:int = 0; i < e.rects.length; i++) {
					e.rects[i].x *= scaleFactor;
					e.rects[i].y *= scaleFactor;				
					e.rects[i].width *= scaleFactor;
					e.rects[i].height *= scaleFactor;
				}			
				
				this.dispatchEvent(e);
			}
		}
		
		public function processBitmap(photo:Bitmap):void {
			detectionMap.draw(photo.bitmapData, drawMatrix, null, "normal", null, true);
			detector.detect(detectionMap);		
		}
		
		
		
	}
}


package net.localprojects.camera {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.EventDispatcher;
	import flash.geom.Matrix;
	import flash.geom.Rectangle;
	import net.localprojects.Utilities;
	
	import jp.maaash.ObjectDetection.ObjectDetector;
	import jp.maaash.ObjectDetection.ObjectDetectorEvent;
	import jp.maaash.ObjectDetection.ObjectDetectorOptions;
	import flash.geom.Point;
	import net.localprojects.CDW;
	
	// Adapted from Mario Klingemann's code
	// http://www.quasimondo.com/archives/000687.php
	// License situation TBA
	public class FaceDetector extends EventDispatcher 	{
		
		private var detector:ObjectDetector;
		private var options:ObjectDetectorOptions;		
		private var detectionMap:BitmapData;
		public var faceRect:Rectangle;
		
		private var maxSourceWidth:int;
		private var maxSourceHeight:int;
		private var sourceCenter:Point;
		
		public function FaceDetector() {
			super();
			init();
		}
		
		private function init():void {
			detector = new ObjectDetector();
			var options:ObjectDetectorOptions = new ObjectDetectorOptions();
			options.min_size = 30;
			detector.options = options;
			detector.addEventListener(ObjectDetectorEvent.DETECTION_COMPLETE, detectionHandler);
			
			faceRect = new Rectangle();
			
			maxSourceWidth = 200;
			maxSourceHeight = 200;
		}
		
		private function detectionHandler(e:ObjectDetectorEvent):void {
			// compensate for scale, and then forward the event
			if (e.rects.length > 0) {
				
				
				if (e.rects.length == 1) {
					// just return the first and only face
					faceRect = e.rects[0];
				}
				else {
					// find the rectangle that's closest to the center
					var closestIndex:int = 0;
					var closestDistance:Number = Number.MAX_VALUE;
					
					for (var i:int = 0; i < e.rects.length; i++) {
							var distance:Number = Point.distance(sourceCenter, Utilities.centerPoint(e.rects[i]));
							
							if (distance < closestDistance) {
								closestDistance = distance;
								closestIndex = i;
							}
					}
					
					faceRect = e.rects[closestIndex];
				}
				
				this.dispatchEvent(e);
				
				CDW.dashboard.log("Face detected");
			}
			else {
				// no faces found... increment timer for back-up button?
				CDW.dashboard.log("---------");
			}
		}
		
		public function processBitmap(photo:BitmapData):void {
			// resize
			photo = Utilities.scaleToFit(photo, maxSourceWidth, maxSourceHeight);
			sourceCenter = new Point(photo.width / 2, photo.height / 2);
			detector.detect(photo);
		}

	}
}


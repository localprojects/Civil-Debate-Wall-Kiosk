package com.civildebatewall.camera {
	import com.civildebatewall.CDW;
	import com.civildebatewall.Utilities;
	import com.kitschpatrol.futil.utilitites.BitmapUtil;
	import com.kitschpatrol.futil.utilitites.GeomUtil;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.EventDispatcher;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import ObjectDetection.ObjectDetector;
	import ObjectDetection.ObjectDetectorEvent;
	import ObjectDetection.ObjectDetectorOptions;
	
	// Adapted from Mario Klingemann's code
	// http://www.quasimondo.com/archives/000687.php
	public class FaceDetector extends EventDispatcher 	{
		
		private var detector:ObjectDetector;
		private var options:ObjectDetectorOptions;		
		private var detectionMap:BitmapData;
		public var faceRect:Rectangle;
		
		public var maxSourceWidth:int;
		public var maxSourceHeight:int;
		private var sourceCenter:Point;
		
		public var monitor:Bitmap;
		
		public function FaceDetector() {
			super();
			init();
		}
		
		private function init():void {
			detector = new ObjectDetector();
			var options:ObjectDetectorOptions = new ObjectDetectorOptions();
			options.min_size = 20;
			detector.options = options;
			detector.addEventListener(ObjectDetectorEvent.DETECTION_COMPLETE, detectionHandler);
			
			faceRect = new Rectangle();
			
			// respect aspect ratios
			if(CDW.settings.webcamOnly) {
				maxSourceWidth = Math.round(190);
				maxSourceHeight = Math.round(320);
			}
			else {
				maxSourceWidth = 213;
				maxSourceHeight = 320;
			}
		}
		
		private function detectionHandler(e:ObjectDetectorEvent):void {
			
			// compensate for scale, and then forward the event
			if (e.rects.length > 0) {
				
				if (e.rects.length == 1) {
					// just return the first and only face
					faceRect = e.rects[0];
				}
				else {
					// find the rectangle that's closest to the 2
					var closesDistancetIndex:int = 0;
					var closestDistance:Number = Number.MAX_VALUE;
					
					var largestAreaIndex:int = 0;				
					var largestArea:Number = Number.MIN_VALUE;
					
					for (var i:int = 0; i < e.rects.length; i++) {
							var distance:Number = Point.distance(sourceCenter, GeomUtil.centerPoint(e.rects[i]));
							
							if (distance < closestDistance) {
								closestDistance = distance;
								closesDistancetIndex = i;
							}
							
							var area:Number = e.rects[i].width * e.rects[i].height;
							
							if (area > largestArea) {
								largestArea = area;
								largestAreaIndex = i;
							}						
					}
					
					// choose by distance, or area?
					// faceRect = e.rects[closestIndex];
					faceRect = e.rects[largestAreaIndex];
				}
			}
			else {
				// no faces found... increment timer for back-up button?
				faceRect = null;
			}
			
			this.dispatchEvent(e);			
		}
		
		public function searchBitmap(photo:BitmapData):void {
			// resize
			photo = BitmapUtil.scaleToFit(photo, maxSourceWidth, maxSourceHeight);
			sourceCenter = new Point(photo.width / 2, photo.height / 2);
			detector.detect(photo);
		}

	}
}


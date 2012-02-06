/*--------------------------------------------------------------------
Civil Debate Wall Kiosk
Copyright (c) 2012 Local Projects. All rights reserved.

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU Affero General Public License as
published by the Free Software Foundation, either version 3 of the
License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU Affero General Public License for more details.

You should have received a copy of the GNU Affero General Public
License along with this program. 

If not, see <http://www.gnu.org/licenses/>.
--------------------------------------------------------------------*/

package com.civildebatewall.kiosk.camera {
	
	import ObjectDetection.ObjectDetector;
	import ObjectDetection.ObjectDetectorEvent;
	import ObjectDetection.ObjectDetectorOptions;
	
	import com.civildebatewall.CivilDebateWall;
	import com.kitschpatrol.futil.utilitites.BitmapUtil;
	import com.kitschpatrol.futil.utilitites.GeomUtil;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.events.EventDispatcher;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
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
			
			// just use native ratio if we're useing a pseudocam
			maxSourceWidth = 1080 / 6;
			maxSourceHeight = 1920 / 6;			
			
			// fall through to webcam...
			if(CivilDebateWall.settings.useWebcam) {
				maxSourceWidth = Math.round(190);
				maxSourceHeight = Math.round(320);
			}
			
			// fall through to this if we're using an SLR
			if (CivilDebateWall.settings.useSLR) {
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
					var closestDistancetIndex:int = 0;
					var closestDistance:Number = Number.MAX_VALUE;

					var largestAreaIndex:int = 0;				
					var largestArea:Number = Number.MIN_VALUE;
					
					for (var i:int = 0; i < e.rects.length; i++) {
							var distance:Number = Point.distance(sourceCenter, GeomUtil.centerPoint(e.rects[i]));
							
							if (distance < closestDistance) {
								closestDistance = distance;
								closestDistancetIndex = i;
							}
							
							var area:Number = e.rects[i].width * e.rects[i].height;
							
							if (area > largestArea) {
								largestArea = area;
							largestAreaIndex = i;
							}						
					}
					
					// choose by distance, or area?
					faceRect = e.rects[closestDistancetIndex];
					// faceRect = e.rects[largestAreaIndex];
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
			photo = BitmapUtil.scaleDataToFit(photo, maxSourceWidth, maxSourceHeight);
			sourceCenter = new Point(photo.width / 2, photo.height / 2);
			detector.detect(photo);
		}

	}
}

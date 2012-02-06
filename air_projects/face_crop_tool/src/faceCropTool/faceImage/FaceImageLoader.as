/*------------------------------------------------------------------------------
Copyright (c) 2012 Local Projects. All rights reserved.

This file is part of The Civil Debate Wall.

The Civil Debate Wall is free software: you can redistribute it and/or modify
it under the terms of the GNU Affero General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

The Civil Debate Wall is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU Affero General Public License for more details.

You should have received a copy of the GNU Affero General Public License
along with The Civil Debate Wall.  If not, see <http://www.gnu.org/licenses/>.
------------------------------------------------------------------------------*/

package faceCropTool.faceImage {

	import com.kitschpatrol.futil.utilitites.BitmapUtil;
	import com.kitschpatrol.futil.utilitites.FileUtil;
	import com.kitschpatrol.futil.utilitites.GeomUtil;
	import com.kitschpatrol.futil.utilitites.StringUtil;
	
	import faceCropTool.core.State;
	import faceCropTool.utilities.FaceDetector;
	import faceCropTool.utilities.Utilities;
	
	import flash.display.Bitmap;
	import flash.display.PixelSnapping;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.filesystem.File;
	import flash.geom.Rectangle;
	
	import ObjectDetection.ObjectDetectorEvent;

	// Loads all of the jpegs in a directory, detects faces if they're not in the cache
	public class FaceImageLoader extends EventDispatcher {
		
		private var imagesRequested:int;
		private var imagesLoaded:int;
		private var faceCache:Array;
		private var faceDetector:FaceDetector;
		private var searchingFace:FaceImage; // reference to face we're searching
		
		
		public function FaceImageLoader()		{
			// Nothing to construct
		}
		
		
		public function loadFromDirectory(directory:File):void {
			State.images = [];
			
			// Load the face cache
			faceCache = FileUtil.loadStrings(State.cachePath);
			trace(faceCache);
			
			// Load images from folder
			State.images = [];
			imagesRequested = 0;
			imagesLoaded = 0;
			
			for each (var file:File in directory.getDirectoryListing()) {
				if (StringUtil.contains(file.url, ".jpg")) {
					imagesRequested++;
					Utilities.loadImageFaceCrop(file.url, onImageLoad);
				}
			}			
		}
		
		
		private function onImageLoad(b:Bitmap, name:String):void {
			var image:FaceImage = new FaceImage();
			image.originalBitmap = new Bitmap(b.bitmapData.clone(), "auto", true);
			image.cropBitmap = new Bitmap(BitmapUtil.scaleDataToFill(b.bitmapData.clone(), State.targetWidth, State.targetHeight), PixelSnapping.AUTO, true);
			
			image.fileName = name;
			trace("Loaded " + name);			
			
			// Check cache
			for each (var line:String in faceCache) {
				if (StringUtil.contains(line, name)) {
					trace("have cache for " + name + " loading rect");
					var cacheRow:Array = line.split(",");
					
					// TODO add MD5 hash to cache index, no too slow
					// Cache row is in format "name,x,y,w,h"
					image.faceRect = new Rectangle(parseFloat(cacheRow[1]), parseFloat(cacheRow[2]), parseFloat(cacheRow[3]), parseFloat(cacheRow[4]));
				}
			}
			
			State.images.push(image);
			imagesLoaded++;
			
			if (imagesLoaded == imagesRequested) {
				trace("loaded " + imagesLoaded);
				trace(State.images);				
				
				trace("detecting faces as needed");
				faceDetector = new FaceDetector();
				faceDetector.addEventListener(ObjectDetectorEvent.DETECTION_COMPLETE, onFaceDetected);
				detectFaces();
			}
		}
		

		private function detectFaces():void {			
			for each (var image:FaceImage in State.images) {
				if (image.faceRect == null) {
					trace("detecting face in image " + image);
					searchingFace = image;
					faceDetector.searchBitmap(image.originalBitmap.bitmapData);
					return;	// skip the rest...			
				}
			}
			
			trace("detected them all!");
			faceDetector.removeEventListener(ObjectDetectorEvent.DETECTION_COMPLETE, onFaceDetected);			
			
			trace("Saving Cache");
			FileUtil.saveStrings(faceCache, State.cachePath);
			
			this.dispatchEvent(new Event(Event.COMPLETE));
		}
		
		
		private function onFaceDetected(e:Event):void {
			trace("found face: " + faceDetector.faceRect + " in " + searchingFace.fileName);
			
			 
			 // scale the face to match the original size of the image
			var scaleFactor:Number = searchingFace.originalBitmap.bitmapData.height / faceDetector.maxSourceHeight; 
			searchingFace.faceRect = GeomUtil.scaleRect(faceDetector.faceRect, scaleFactor);								
			
			// Cache row is in format "name,x,y,w,h"			
			//var hash:String = MD5.hashBinary(searchingFace.originalBitmap.bitmapData.getPixels(searchingFace.originalBitmap.bitmapData.rect));
			// Too slow!
						
			faceCache.push(searchingFace.fileName + "," + searchingFace.faceRect.x + "," + searchingFace.faceRect.y + "," + searchingFace.faceRect.width + "," + searchingFace.faceRect.height);			
			
			// keep going, kind ugly and GOTO ish...
			detectFaces();
		}				

	}
}
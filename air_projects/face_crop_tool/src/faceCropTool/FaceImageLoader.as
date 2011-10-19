package faceCropTool
{
	import com.kitschpatrol.futil.utilitites.FileUtil;
	import com.kitschpatrol.futil.utilitites.StringUtil;
	
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.filesystem.File;
	import flash.geom.Rectangle;
	
	import jp.maaash.ObjectDetection.ObjectDetectorEvent;

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
			image.fileName = name;
			trace("Loaded " + name);			
			
			// Check cache
			for each (var line:String in faceCache) {
				if (StringUtil.contains(line, name)) {
					trace("have cache for " + name + " loading rect");
					var cacheRow:Array = line.split(",");
					
					// Cache row is in format "name,x,y,w,h"
					image.faceRect = new Rectangle(parseInt(cacheRow[1]), parseInt(cacheRow[2]), parseInt(cacheRow[3]), parseInt(cacheRow[4]));
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
			searchingFace.faceRect = new Rectangle(faceDetector.faceRect.x, faceDetector.faceRect.y, faceDetector.faceRect.width, faceDetector.faceRect.height);
			faceCache.push(searchingFace.fileName + "," + searchingFace.faceRect.x + "," + searchingFace.faceRect.y + "," + searchingFace.faceRect.width + "," + searchingFace.faceRect.height);			
			
			// keep going, kind ugly and GOTO ish...
			detectFaces();
		}				

		
	}
}
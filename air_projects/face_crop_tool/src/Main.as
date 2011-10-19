package {
	import faceCropTool.FaceCropTool;
	import faceCropTool.FaceDetector;
	import faceCropTool.Utilities;
	
	import flash.display.*;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.geom.*;
	
	import jp.maaash.ObjectDetection.ObjectDetectorEvent;
	
	[SWF(width="880", height="1000", frameRate="60")]
	public class Main extends Sprite {
		
//	
//	private const PORTRAIT_DIRECTORY:String = "/Users/Mika/Desktop/CDWTestImages";
//	private var portraitsFull:Vector.<Bitmap> = new Vector.<Bitmap>(0);
//	private var portraitsCropped:Vector.<Bitmap> = new Vector.<Bitmap>(0);	
//	private var faces:Vector.<Rectangle> = new Vector.<Rectangle>(0);
//	private var faceDetector:FaceDetector = new FaceDetector();
//	private var imagesRequested:int = 0;
//	private var imagesLoaded:int = 0;
//	private var faceDetectionIndex:int = 0;
//	private var targetFaceRectangle:Rectangle = new Rectangle(294, 352, 494, 576);	
//	
//	
	
	
		
	public function Main() {
		var faceCropTool:FaceCropTool = new FaceCropTool();
		addChild(faceCropTool);
		
		//		// load all jpg images from dir
//		var portraitDirectory:File = new File(PORTRAIT_DIRECTORY);
//		
//		for each (var file:File in portraitDirectory.getDirectoryListing()) {
//			if (file.url.indexOf(".jpg") > -1) {	
//				imagesRequested++;
//				Utilities.loadImageFromDisk(file.url, onImageLoad);
//				break;
//			}
//		}
		
	}
	
//	private function onImageLoad(b:Bitmap):void {
//		portraitsFull.push(new Bitmap(b.bitmapData.clone(), "auto", true));
//		imagesLoaded++;
//		
//		if(imagesLoaded == imagesRequested) {
//			trace("loaded " + imagesLoaded);
//			
//			// start face detection
//			faceDetector.addEventListener(ObjectDetectorEvent.DETECTION_COMPLETE, onFaceDetected);			
//			detectFace();
//		}
//	}
//
//		
//		private function detectFace():void {
//			trace("detecting face in image " + faceDetectionIndex);
//			faceDetector.searchBitmap(portraitsFull[faceDetectionIndex].bitmapData);
//		}
//		
//		private function onFaceDetected(e:Event):void {
//			trace("found face: " + faceDetector.faceRect);
//			
//			faceDetectionIndex++;			
//			
//			trace(portraitsFull.length);
//			
//			
//			faces.push(new Rectangle(faceDetector.faceRect.x, faceDetector.faceRect.y, faceDetector.faceRect.width, faceDetector.faceRect.height));
//			
//			
//			if (faceDetectionIndex >= portraitsFull.length - 1) {
//				trace("done detecting");
//				init();
//			}
//			else {
//				detectFace();
//			}
//		}
//		
//		
//		
//		private var gridRows:int;
//		private var gridCols:int;
//		private var gridPhotoWidth:Number;
//		private var gridPhotoHeight:Number;
//		
//		private function init():void {
//			trace(init);
//			
//			
//			faceGrid.graphics.beginFill(0);
//			faceGrid.graphics.drawRect(0, 0, 1080, 1920);
//			faceGrid.graphics.endFill();
//			addChild(faceGrid);
//			
//			
//			// lay out grid
//			// Proportion of the screen
//			// w,h width and height of your rectangles
//			// W,H width and height of the screen
//			// N number of your rectangles that you would like to fit in
//			
//			// ratio
//
//			
//			// This ratio is important since we can define the following relationship
//			// nbRows and nbColumns are what you are looking for
//			// nbColumns = nbRows * r (there will be problems of integers)
//			// we are looking for the minimum values of nbRows and nbColumns such that
//			// N <= nbRows * nbColumns = (nbRows ^ 2) * r
//			var numPhotos:int = portraitsFull.length;
//			gridRows = Math.ceil( Math.sqrt( numPhotos / 1 ) ); // r is positive...
//			gridCols = Math.ceil( numPhotos / gridRows);
//			
//			gridPhotoWidth = 1080 / gridRows;
//			gridPhotoHeight = 1920 / gridRows;
//			
//			updateCrops();
//			
//		}
//		
//		private function updateCrops():void {
//			
//			// update the face grid
//			while(faceGrid.numChildren > 0) faceGrid.removeChildAt(0);			
//			
//			for (var i:int = 0; i < portraitsFull.length; i++) {
//				
//				var scaleFactor:Number = portraitsFull[i].height / faceDetector.maxSourceHeight; 
//				var scaledFaceRect:Rectangle = Utilities.scaleRect(faces[i], scaleFactor);
//				
//				
//				
//				portraitsCropped[i] = Utilities.cropToFace(portraitsFull[i], scaledFaceRect, targetFaceRectangle);
//				
//				
//				// Stopped here
//				
//				//portraitsCropped[i].addEve
//				
//				
//				
//				
//				
//			}
//			
//
//			
//			
//			
//			
//			
//			
//			
//			
//			
//			
//		}
//		
//		
//		private var faceGrid:Sprite = new Sprite();
//		
		
		
	}		

}
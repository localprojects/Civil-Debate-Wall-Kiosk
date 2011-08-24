package net.localprojects.blocks {
	
	import com.adobe.images.*;
	import com.adobe.images.JPGEncoder;
	import com.greensock.TweenMax;
	import com.greensock.easing.*;
	import com.greensock.events.TweenEvent;
	
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;

	import flash.media.*;	
	
	
	import net.localprojects.Assets;
	import net.localprojects.BitmapPlus;
	import net.localprojects.CDW;
	import net.localprojects.Utilities;
	import net.localprojects.camera.*;
	
	
	
	public class PortraitCamera extends BlockBase {
		
		public var cameraBitmap:Bitmap;
		private var onFaceShutter:Function;
		public var slr:SLRCamera;
		
		
		private var cameraWidth:int;
		private var cameraHeight:int;
		private var undersampleFactor:int;
		
		
		private var camera:Camera;
		private var video:Video;
		private var matrix:Matrix;		
		
		
		public function PortraitCamera() {
			super();
			init();
		}
		
		
		private function init():void {
			cameraBitmap = new Bitmap(new BitmapData(1080, 1920));
			
			undersampleFactor = 2; // increase this to improve performance at the expense of quality			
			cameraWidth = 1920 / undersampleFactor;
			cameraHeight = 1080 / undersampleFactor;
			
			camera = Camera.getCamera();
			camera.setQuality(0, 1); // TODO does this do anything?
			camera.setMode(cameraWidth, cameraHeight, 30);
			
			video = new Video(cameraWidth, cameraHeight);
			

			// TODO crop and zoom
			matrix = new Matrix();
			matrix.scale(undersampleFactor, undersampleFactor);
			matrix.rotate(Utilities.degToRad(-90));
			matrix.scale(-1, 1);
			matrix.tx = 1080;			
			matrix.ty = 1920;			
			
			video.transform.matrix = matrix;
			
			video.attachCamera(camera);			
			addChild(video);
				
			if (!CDW.settings.webcamOnly) {
				slr = new SLRCamera();
			}
			
		}


		public function takePhoto():void {
			trace("taking photo");
			cameraBitmap.bitmapData.draw(video, matrix, null, null, null, true);
			// TODO face detection
		}
		
	}
}
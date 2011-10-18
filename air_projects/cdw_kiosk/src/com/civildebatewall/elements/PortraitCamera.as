package com.civildebatewall.elements {
	
	import com.adobe.images.*;
	import com.civildebatewall.CDW;
	import com.civildebatewall.blocks.BlockBase;
	import com.civildebatewall.camera.*;
	import com.greensock.easing.*;
	import com.kitschpatrol.futil.Math2;
	
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.media.*;
	
	public class PortraitCamera extends BlockBase {
		
		public var cameraBitmap:Bitmap;
		private var onFaceShutter:Function;
		public var slr:SLRCamera;
		
		private var cameraWidth:int;
		private var cameraHeight:int;
		private var undersampleFactor:int;
		
		private var camera:Camera;
		private var video:Video;
		private var baseMatrix:Matrix;
		private var scaleMatrix:Matrix;
		private var combinedMatrix:Matrix;
		
		private var focalLength:Number;
		
		
		public function PortraitCamera() {
			super();
			init();
		}
		
		
		private function init():void {
			cameraBitmap = new Bitmap(new BitmapData(1080, 1920));
			
			undersampleFactor = 2; // increase this to improve performance at the expense of quality			
			cameraWidth = 1920 / undersampleFactor;
			cameraHeight = 1080 / undersampleFactor;
		
			// always pick last camera to skip isight on the mac			
			var cameras:Array = Camera.names;
					
			if (cameras.length > 1)
				camera = Camera.getCamera(cameras[cameras.length - 1]) 
			else
				camera = Camera.getCamera();

			camera.setMode(cameraWidth, cameraHeight, 30);
			
			video = new Video(cameraWidth, cameraHeight);
			
			// rotate and crop
			
			
			
			combinedMatrix = new Matrix();
			baseMatrix = new Matrix();
			baseMatrix.scale(undersampleFactor, undersampleFactor);
			baseMatrix.rotate(Math2.degToRad(-90));
			
			if (CDW.settings.flipWebcamVertical) {
				baseMatrix.scale(1, -1);
			}
			else {
				baseMatrix.scale(-1, 1);
				baseMatrix.tx = 1080;           
				baseMatrix.ty = 1920;  
			}
			
			video.transform.matrix = baseMatrix;
			
			// zoom around center
			scaleMatrix = new Matrix();
			focalLength = 1;
			setFocalLength(focalLength);
			
			video.attachCamera(camera);			
			addChild(video);
				
			if (!CDW.settings.webcamOnly)
				slr = new SLRCamera();
		}
		
		
		public function setFocalLength(value:Number):void {
			focalLength = value;
			
			scaleMatrix.identity();
			scaleMatrix.translate(1080 / -2, 1920 / -2);
			scaleMatrix.scale(focalLength, focalLength);
			scaleMatrix.translate(1080 / 2, 1920 / 2);			

			combinedMatrix.identity();
			combinedMatrix.concat(baseMatrix);
			combinedMatrix.concat(scaleMatrix);
			
			video.transform.matrix = combinedMatrix;
		}


		public function takePhoto():void {
			cameraBitmap.bitmapData.draw(video, video.transform.matrix, null, null, null, true);
		}
		
	}
}
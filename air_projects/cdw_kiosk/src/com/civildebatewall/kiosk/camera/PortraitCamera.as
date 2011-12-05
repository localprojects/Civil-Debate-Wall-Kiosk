package com.civildebatewall.kiosk.camera {
	
	import com.adobe.images.*;
	import com.civildebatewall.Assets;
	import com.civildebatewall.CivilDebateWall;
	import com.civildebatewall.Settings;
	import com.civildebatewall.kiosk.core.Kiosk;
	import com.civildebatewall.kiosk.legacy.OldBlockBase;
	import com.demonsters.debugger.MonsterDebugger;
	import com.greensock.easing.*;
	import com.kitschpatrol.futil.Math2;
	
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.media.*;
	
	public class PortraitCamera extends OldBlockBase {
		
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
			
			if (CivilDebateWall.settings.useWebcam) {
				undersampleFactor = CivilDebateWall.settings.webCamUndersampleFactor; // increase this to improve performance at the expense of quality			
				cameraWidth = 1920 / undersampleFactor;
				cameraHeight = 1080 / undersampleFactor;	
				
				var cameras:Array = Camera.names;
			
				// always pick last camera to skip isight on the mac				
				if (cameras.length > 1) {
					camera = Camera.getCamera(cameras[cameras.length - 1])
				}
				else {
					camera = Camera.getCamera();
				}

				camera.setMode(cameraWidth, cameraHeight, 30);
				video = new Video(cameraWidth, cameraHeight);
			
				// rotate and crop
				combinedMatrix = new Matrix();
				baseMatrix = new Matrix();
				baseMatrix.scale(undersampleFactor, undersampleFactor);
				baseMatrix.rotate(Math2.degToRad(-90));
			
				if (CivilDebateWall.settings.flipWebcamVertical) {
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
				focalLength = CivilDebateWall.settings.webCamFocalLength;
				setFocalLength(focalLength);
				
				video.attachCamera(camera);			
				addChild(video);
				
				MonsterDebugger.trace(null, "Set up webcam.");		
			}
			else {
				// No webcam, just use placeholder
				cameraBitmap = Assets.getPortraitPlaceholder();
			}
				
			if (CivilDebateWall.settings.useSLR) {
				slr = new SLRCamera();
			}
			
			
		}
		
		
		public function getFocalLength():Number {
			return focalLength;
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
			if (CivilDebateWall.settings.useWebcam) {
				cameraBitmap.bitmapData.draw(video, video.transform.matrix, null, null, null, true);
			}
			else {
				// do nothing if we don't have a web cam...
				
			}
		}
		
	}
}
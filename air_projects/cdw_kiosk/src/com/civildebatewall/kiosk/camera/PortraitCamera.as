/*--------------------------------------------------------------------
Civil Debate Wall Kiosk
Copyright (c) 2012 Local Projects. All rights reserved.

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as
published by the Free Software Foundation, either version 2 of the
License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public
License along with this program. 

If not, see <http://www.gnu.org/licenses/>.
--------------------------------------------------------------------*/

package com.civildebatewall.kiosk.camera {

	import com.civildebatewall.Assets;
	import com.civildebatewall.CivilDebateWall;
	import com.civildebatewall.kiosk.legacy.OldBlockBase;
	import com.kitschpatrol.futil.Math2;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.geom.Matrix;
	import flash.media.Camera;
	import flash.media.Video;
	
	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.getLogger;
	
	public class PortraitCamera extends OldBlockBase {
		
		private static const logger:ILogger = getLogger(PortraitCamera);
		
		public var cameraBitmap:Bitmap;
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
				logger.info("Seting up webcam...");
				
				undersampleFactor = CivilDebateWall.settings.webCamUndersampleFactor; // increase this to improve performance at the expense of quality			
				cameraWidth = 1920 / undersampleFactor;
				cameraHeight = 1080 / undersampleFactor;	
				
				var cameras:Array = Camera.names;
			
				logger.info("Cameras: " + cameras);				
				
				// always pick last camera to skip isight on the mac				
				if (cameras.length > 1) {
					logger.info("Found more than one camera... choosing the last one: " + (cameras[cameras.length - 1]));					
					camera = Camera.getCamera(cameras[cameras.length - 1]);
				}
				else {
					camera = Camera.getCamera();
				}
				
				logger.info("Using camera: " + camera.name);				

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
				
				logger.info("...Set up webcam");
			}
			else {
				// No webcam, just use placeholder
				cameraBitmap = Assets.getPortraitPlaceholder();
				logger.warn("No webcam, using pseudocam per the settings file");
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
				logger.info("Taking webcam photo");
				cameraBitmap.bitmapData.draw(video, video.transform.matrix, null, null, null, true);
			}
			else {
				logger.warn("No webcam, using placeholder as camera photo");
			}
		}
		
	}
}

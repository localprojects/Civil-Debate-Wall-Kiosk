package net.localprojects {
	import com.adobe.images.JPGEncoder;
	import com.adobe.images.PNGEncoder;
	import com.bit101.components.PushButton;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.media.Camera;
	import flash.media.Video;
	import flash.net.URLLoader;
	import flash.net.URLLoaderDataFormat;
	import flash.net.URLRequest;
	import flash.net.URLRequestMethod;
	import flash.net.URLVariables;
	import flash.utils.ByteArray;
	
	import jp.maaash.ObjectDetection.ObjectDetectorEvent;
	
	import mx.utils.Base64Encoder;
	
	
	// TODO easier to use face detection for the shutter? Detect face and then "3 2 1"?
	public class PortraitCamera extends Sprite {
		
		private var camera:Camera;
		private var video:Video;
		private var videoBitmap:Bitmap;
		private var cameraWidth:int;
		private var cameraHeight:int;
		private var cropWidth:int;
		private var cropHeight:int;
		
		private var faceZone:Bitmap;
		private var faceDetector:FaceDetector;		
		
		
		// supported image upload file types (store a local mirror?)
		private const JPG:String = "jpg";
		private const PNG:String = "png";
		

		public function PortraitCamera() {
			super();
			
			cameraWidth = 800;
			cameraHeight = 600;
			
			cropWidth = 450;
			cropHeight = 600;
			
			
			// face detector
			faceDetector = new FaceDetector(cropWidth, cropHeight);			
			faceDetector.addEventListener(ObjectDetectorEvent.DETECTION_COMPLETE, detectionHandler);
			
			trace("attaching camera");
			camera = Camera.getCamera();
			camera.setMode(cameraWidth, cameraHeight, 30);
			
			video = new Video(cameraWidth, cameraHeight);
			video.attachCamera(camera);
			video.addEventListener(Event.ENTER_FRAME, onVideoFrame);
			videoBitmap = new Bitmap(new BitmapData(cropWidth, cropHeight, false, 0));
			addChild(videoBitmap);
			
			// add the overlay
			Assets.cameraSilhouette.alpha = 0.5;
			addChild(Assets.cameraSilhouette);
			
//			faceZone = new Bitmap(new BitmapData(240, 288, false));
//			faceZone.x = 0;
//			faceZone.y = 300;			
//			addChild(faceZone);
		}
		
		private function detectionHandler(e:ObjectDetectorEvent):void {
			trace("got face event in camera");

				
				for (var i:int = 0; i < e.rects.length; i++) {
					
					var r:Rectangle = e.rects[i];
					
					trace(r);
//					
//					this.graphics.beginFill(0xff0000);
//					this.graphics.drawRect(r.x * 8, r.y * 8, r.width * 8, r.height * 8);
//					this.graphics.endFill();
				}
				
						
		}

		
		
		public function activateCamera():void {
			video.addEventListener(Event.ENTER_FRAME, onVideoFrame);			
		}

		
		public function deactivateCamera():void {
			this.video.removeEventListener(Event.ENTER_FRAME, onVideoFrame);
		}
		
		
		public function takePhoto():Bitmap {
			// make a copy of the current video pixels
			return new Bitmap(videoBitmap.bitmapData.clone());
		}		
		
		
		private function onVideoFrame(e:Event):void {
			// copy a crop into the video bitmap
			var matrix:Matrix = new Matrix();
			matrix.scale(-1, 1); // flip horizontally
			matrix.translate(cameraWidth - ((cameraWidth - cropWidth) / 2), 0);
			
			videoBitmap.bitmapData.draw(video, matrix);
			
			// take the face selection

			// copy rectangle?
			// var faceSourceRect:Rectangle = new Rectangle(96, 31, 240, 288);
			//faceZone.bitmapData.copyPixels(videoBitmap.bitmapData, faceSourceRect, new Point(0, 0));
			
			// detect faces
			// faceDetector.processBitmap(faceZone);			
		}
		

		private function upload(picture:BitmapData, format:String = JPG):void {

			var urlLoader:URLLoader = new URLLoader();
			
			// encode image to ByteArray
			var byteArray:ByteArray;			
			
			// encode in the requested file format
			switch (format)	{
				case JPG:
					// encode as JPG
					var jpgEncoder:JPGEncoder = new JPGEncoder(98);
					byteArray = jpgEncoder.encode(picture);
					break;
				
				case PNG:
					// encode as PNG
					byteArray = PNGEncoder.encode(picture);
					break;
				
				default:
					trace("error! fell through upload image format switch case");
					break;
			}
			
			// convert binary ByteArray to plain-text, for transmission in POST data
			var encoder:Base64Encoder = new Base64Encoder();
			encoder.encodeBytes(byteArray);
			
			// set upload destination
			var request:URLRequest = new URLRequest("http://ampliface.com/scripts/image-saver.py");
			request.method = URLRequestMethod.POST;
			
			// set data to send
			var variables:URLVariables = new URLVariables();
			variables.format = format;
			variables.image = encoder.toString();
			request.data = variables;
			
			
			trace(request);
			trace("sending");
			urlLoader.dataFormat = URLLoaderDataFormat.TEXT;
			urlLoader.load(request);
		}		
		
		
	}
}
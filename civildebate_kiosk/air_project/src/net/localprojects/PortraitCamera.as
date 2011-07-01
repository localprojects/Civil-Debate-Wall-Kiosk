package net.localprojects {
	import com.adobe.images.*;
	import com.bit101.components.*;
	
	import flash.display.*;
	import flash.events.*;
	import flash.filters.*;
	import flash.geom.*;
	import flash.media.*;
	import flash.net.*;
	import flash.utils.*;
	
	import jp.maaash.ObjectDetection.ObjectDetectorEvent;
	
	import mx.utils.Base64Encoder;
	
	
	// TODO easier to use face detection for the shutter? Detect face and then "3 2 1"?
	public class PortraitCamera extends Sprite {
		
		// portrait
		private const cameraWidth:int = 1024;
		private const cameraHeight:int = 768;
		private const cropWidth:int = 1080;
		private const cropHeight:int = 1920;
		private const portraitScale:Number = cropHeight / cameraHeight;
		private const portraitMatrix:Matrix = new Matrix(-portraitScale, 0, 0, portraitScale, (cameraWidth * portraitScale) - (((cameraWidth * portraitScale) - (cropWidth)) / 2), 0);
		private var camera:Camera;
		private var video:Video = new Video(cameraWidth, cameraHeight);
		private var videoBitmap:Bitmap = new Bitmap(new BitmapData(cropWidth, cropHeight, false, 0));
		
		// tiny portrait
		private var tinyPortraitScale:Number = 0.5;
		private var tinyPortrait:Bitmap;
		
		// face detection zone
		private const faceWidth:int = 390;
		private const faceHeight:int = 470;
		private const faceOffsetX:int = 317;
		private const faceOffsetY:int = 54;
		private const faceScale:Number = 0.1;
		private const faceMatrix:Matrix = new Matrix(-faceScale, 0, 0, faceScale, (faceWidth * faceScale) + (faceOffsetX * faceScale), faceOffsetY * -faceScale);
		private var faceZone:Bitmap = new Bitmap(new BitmapData(faceWidth * faceScale, faceHeight * faceScale, false));	
			
		private var faceDetector:FaceDetector = new FaceDetector();		
		
		// face overlay
		private var faceOverlay:Sprite = new Sprite();
		
		// blur shader
		private var shader:Shader;
		private var shaderFilter:ShaderFilter;		
		
		// supported image upload file types (store a local mirror?)
		private const JPG:String = "jpg";
		private const PNG:String = "png";
		
		
		// temp gui
		private var gui:Window;
		private var saturationSlider:HUISlider;
		private var blurSlider:HUISlider;		
		private var faceOffsetSliderX:HUISlider;
		private var faceOffsetSliderY:HUISlider;		
		

		public function PortraitCamera() {
			super();

			faceDetector.addEventListener(ObjectDetectorEvent.DETECTION_COMPLETE, detectionHandler);
			trace("attaching camera");
			camera = Camera.getCamera();
			camera.setMode(cameraWidth, cameraHeight, 30);
			video.attachCamera(camera);
			video.addEventListener(Event.ENTER_FRAME, onVideoFrame);
			addChild(videoBitmap);
			addChild(faceOverlay);			
			addChild(Assets.portraitOverlay);
			addChild(faceZone);
			
			shader = new Shader(new Assets.PortraitBlurFilter() as ByteArray);
			shader.data.amount.value = [0.0];
			shader.data.src.input = videoBitmap.bitmapData;
			shader.data.mask.input = Assets.portraitBlurMask.bitmapData;			
			shaderFilter = new ShaderFilter(shader);
			
			videoBitmap.filters = [shaderFilter];
			

			// set up gui
			gui = new Window(this, 5, 5, "Settings");			
			gui.hasMinimizeButton = true;
			gui.width = 260;
			gui.height = 205;			
			
			// set up background suder(gui, 5, 130, "Blur Amount", onBlurSlider);		
			saturationSlider = new HUISlider(gui, 5, 5, "Saturation", onSlider);
			saturationSlider.minimum = shader.data.saturation.minValue;
			saturationSlider.maximum = shader.data.saturation.maxValue;
			saturationSlider.value = shader.data.saturation.defaultValue;
				
			faceOffsetSliderX = new HUISlider(gui, 5, 25, "Offset X", onSlider);
			faceOffsetSliderX.minimum = -1080;
			faceOffsetSliderX.maximum = 1080;
			
			
			faceOffsetSliderY = new HUISlider(gui, 5, 45, "Offset Y", onSlider);
			faceOffsetSliderY.minimum = -1920;
			faceOffsetSliderY.maximum = 1920;			
			
			blurSlider = new HUISlider(gui, 5, 65, "Blur Amount", onSlider);
			blurSlider.minimum = shader.data.amount.minValue;
			blurSlider.maximum = 50;
			blurSlider.value = shader.data.amount.defaultValue;					
			
			
			var fps:FPSMeter = new FPSMeter(gui, 140, 160);
			
			gui.scaleX = 2;
			gui.scaleY = 2;
		}
		
		
		private function onSlider(e:Event):void {
			shader.data.saturation.value = [saturationSlider.value];
			//shader.data.maskOffset.value = [faceOffsetSliderX.value, faceOffsetSliderY.value];
			shader.data.maskOffset.value = [faceOffsetSliderX.value, faceOffsetSliderY.value];			
			shader.data.amount.value = [blurSlider.value];
			videoBitmap.filters = [shaderFilter];
		}
		

		
		private function detectionHandler(e:ObjectDetectorEvent):void {
			trace("got face event in camera");

				faceOverlay.graphics.clear();
			
				// TODO which face is closest to center?
				
				for (var i:int = 0; i < e.rects.length; i++) {
					var r:Rectangle = e.rects[i];
					
					trace(r);
					
					r.x = (((r.x / faceScale) + faceOffsetX) * portraitScale) - (portraitMatrix.tx - cropWidth);
					r.y = (((r.y / faceScale) + faceOffsetY) * portraitScale); // - (portraitMatrix.ty - cropHeight);
					r.width = (r.width / faceScale) * portraitScale;
					r.height = (r.height / faceScale) * portraitScale;
					
					
					trace(portraitMatrix.tx);
					trace(r);
					
//					faceOverlay.graphics.beginFill(0xccff0000);
//					faceOverlay.graphics.drawRect(r.x, r.y, r.width, r.height);
//					faceOverlay.graphics.endFill();
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
			// TODO faster to use copyPixels?
			
			// crop and scale the camera feed
			videoBitmap.bitmapData.draw(video, portraitMatrix);
			
			// take the face selection from the original camera	
			faceZone.bitmapData.draw(video, faceMatrix);
			
			// detect faces in selection
			faceDetector.processBitmap(faceZone);			
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
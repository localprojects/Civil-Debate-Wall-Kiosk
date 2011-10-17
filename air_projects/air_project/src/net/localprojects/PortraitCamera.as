package net.localprojects {
	import com.adobe.images.*;
	import com.bit101.components.*;
	import com.greensock.*;
	
	import flash.display.*;
	import flash.events.*;
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
		private const portraitWidth:int = 1080;
		private const portraitHeight:int = 1920 ;
		private const cropWidth:int = 1080 + 100; // oversample for blur edges
		private const cropHeight:int = 1920 + 100;
		private const portraitScale:Number = cropHeight / cameraHeight;
		private const portraitMatrix:Matrix = new Matrix(-portraitScale, 0, 0, portraitScale, (cameraWidth * portraitScale) - (((cameraWidth * portraitScale) - (cropWidth)) / 2), 0);
		private var camera:Camera;
		private var video:Video = new Video(cameraWidth, cameraHeight);
		private var videoBitmap:BitmapPlus = new BitmapPlus(new BitmapData(cropWidth, cropHeight, true, 0));
		private var portraitBitmap:Bitmap = new Bitmap(new BitmapData(cropWidth, cropHeight, true, 0)); // holds the image for storage / upload
		private var blurBitmap:BitmapPlus = new BitmapPlus(new BitmapData(cropWidth, cropHeight, true, 0));
		private var maskBitmap:Bitmap = Assets.

		// container for blur
		private var maskContianer:Sprite = new Sprite();
		private var portraitContianer:Sprite = new Sprite();		
		
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
		
		// supported image upload file types (store a local mirror?)
		// TODO move to bitmap plus?
		private const JPG:String = "jpg";
		private const PNG:String = "png";
		
		// temp gui
		private var gui:Window;
		private var maskOffsetSliderX:HUISlider;
		private var maskOffsetSliderY:HUISlider;	
		private var blurSlider:HUISlider;
		private var saturationSlider:HUISlider;
		private var brightnessSlider:HUISlider;
		private var contrastSlider:HUISlider;		
		private var portraitSaturationSlider:HUISlider;
		private var portraitBrightnessSlider:HUISlider;
		private var portraitContrastSlider:HUISlider;		
		

		public function PortraitCamera() {
			super();

			maskBitmap.bitmapData = Assets.portraitBlurMask.bitmapData.clone();			
			maskBitmap.x = -520;
			maskBitmap.y = -975;					
			
			faceDetector.addEventListener(ObjectDetectorEvent.DETECTION_COMPLETE, detectionHandler);
			camera = Camera.getCamera();
			camera.setMode(cameraWidth, cameraHeight, 30);
			video.attachCamera(camera);
			video.addEventListener(Event.ENTER_FRAME, onVideoFrame);
			

			// blending is faster than using a shader or copying channels
			maskContianer.blendMode = BlendMode.LAYER;
			maskBitmap.blendMode = BlendMode.ALPHA;
			maskContianer.addChild(blurBitmap);
			maskContianer.addChild(maskBitmap);
			
			portraitContianer.addChild(videoBitmap);
			portraitContianer.addChild(maskContianer);p
			addChild(portraitContianer);
			addChild(Assets.portraitOverlay);			
			
			// set up gui
			gui = new Window(this, 5, 5, "Settings");			
			gui.hasMinimizeButton = true;
			gui.width = 200;
			gui.height = 205;			
			
			var maskLabel:Label = new Label(gui, 5, 5, "MASK");
			
			maskOffsetSliderX = new HUISlider(gui, 5, 15, "Mask Offset X", onSlider);
			maskOffsetSliderX.minimum = -1080;
			maskOffsetSliderX.maximum = 1080;
			maskOffsetSliderX.value = maskBitmap.x
			
			maskOffsetSliderY = new HUISlider(gui, 5, 30, "Mask Offset Y", onSlider);
			maskOffsetSliderY.minimum = -1920;
			maskOffsetSliderY.maximum = 1920;			
			maskOffsetSliderY.value = maskBitmap.y;			

			blurSlider = new HUISlider(gui, 5, 45, "Blur", onSlider);
			blurSlider.minimum = 0;
			blurSlider.maximum = 100;
			blurSlider.value = 1;						
			
			saturationSlider = new HUISlider(gui, 5, 60, "Saturation", onSlider);
			saturationSlider.minimum = 0;
			saturationSlider.maximum = 3;
			saturationSlider.value = 1;
			
			brightnessSlider = new HUISlider(gui, 5, 75, "Brightness", onSlider);
			brightnessSlider.minimum = -3;
			brightnessSlider.maximum = 3;
			brightnessSlider.value = 1;
			
			contrastSlider = new HUISlider(gui, 5, 90, "Contrast", onSlider);
			contrastSlider.minimum = -5;
			contrastSlider.maximum = 5;
			contrastSlider.value = 1;
			
			var portraitLabel:Label = new Label(gui, 5, 110, "PORTRAIT");						
			
			portraitSaturationSlider = new HUISlider(gui, 5, 125, "Saturation", onSlider);
			portraitSaturationSlider.minimum = 0;
			portraitSaturationSlider.maximum = 3;
			portraitSaturationSlider.value = 1;
			
			portraitBrightnessSlider = new HUISlider(gui, 5, 140, "Brightness", onSlider);
			portraitBrightnessSlider.minimum = -3;
			portraitBrightnessSlider.maximum = 3;
			portraitBrightnessSlider.value = 1;
			
			portraitContrastSlider = new HUISlider(gui, 5, 155, "Contrast", onSlider);
			portraitContrastSlider.minimum = -5;
			portraitContrastSlider.maximum = 5;
			portraitContrastSlider.value = 1;			
			
			gui.scaleX = 2;
			gui.scaleY = 2;
		}
		
		
		private function onSlider(e:Event):void {				
			maskBitmap.x = maskOffsetSliderX.value;
			maskBitmap.y = maskOffsetSliderY.value;

			blurBitmap.blur = blurSlider.value;
			blurBitmap.saturation = saturationSlider.value;
			blurBitmap.brightness = brightnessSlider.value;			
			blurBitmap.contrast = contrastSlider.value;
			
			videoBitmap.saturation = portraitSaturationSlider.value;
			videoBitmap.brightness = portraitBrightnessSlider.value;			
			videoBitmap.contrast = portraitContrastSlider.value;			
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
			// store the current portrait in a bitmap
			// TODO cropwidth vs. portraitwidth centering issues?
			portraitBitmap.bitmapData = new BitmapData(portraitWidth, portraitHeight, true, 0);
			var tx:Number = (cropWidth - portraitWidth) / -2;
			var ty:Number = (cropHeight - portraitHeight) / -2;			
			portraitBitmap.bitmapData.draw(portraitContianer, new Matrix(1, 0, 0, 1, tx, ty));
			return new Bitmap(portraitBitmap.bitmapData.clone());
		}		
		
		
		private function onVideoFrame(e:Event):void {
			// crop and scale the camera feed
			videoBitmap.bitmapData.draw(video, portraitMatrix);
			
			// take the face selection from the original camera	
			faceZone.bitmapData.draw(video, faceMatrix);
			
			blurBitmap.bitmapData = videoBitmap.bitmapData.clone();
			
			// detect faces in selection
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
			var request:URLRequest = new URLRequest('upload url here');
			request.method = URLRequestMethod.POST;
			
			// set data to send
			var variables:URLVariables = new URLVariables();
			variables.format = format;
			variables.image = encoder.toString();
			request.data = variables;
			
			urlLoader.dataFormat = URLLoaderDataFormat.TEXT;
			urlLoader.load(request);
		}		
		
		
	}
}
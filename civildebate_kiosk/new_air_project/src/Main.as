package {
	
	import com.bit101.components.ColorChooser;
	import com.bit101.components.FPSMeter;
	import com.bit101.components.HSlider;
	import com.bit101.components.PushButton;
	import com.greensock.*;
	import com.greensock.easing.*;
	
	import flash.display.*;
	import flash.display.Sprite;
	import flash.events.*;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.*;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;
	import flash.ui.MouseCursorData;
	
	import jp.maaash.ObjectDetection.ObjectDetectorEvent;
	
	import net.localprojects.*;
	import net.localprojects.blocks.*;
	import net.localprojects.camera.*;
	import net.localprojects.elements.*;
	import net.localprojects.keyboard.*;
	import net.localprojects.text.Text;
	import net.localprojects.ui.*;
	

	//import net.localprojects.CDW;
	
	[SWF(width="1080", height="1920", frameRate="60")]
	public class Main extends Sprite	{
		private var slr:SLRCamera;
		private var faceDetector:FaceDetector;
		
		private function onShutter(e:Event):void {
			trace("shutter");
			slr.takePhoto();
		}
		
		var sample:Bitmap;
		
		private function onPhotoTaken(e:Event):void {
			trace("got it");
			
			
			
			 sample = new Bitmap(Utilities.scaleToFit(slr.image.bitmapData, 500, 500));
			sample.y = 50;
			addChild(sample);
			
			faceDetector.searchBitmap(slr.image.bitmapData);
			
			
			
			
			
		}
		
		private function onFaceDetected(e:Event):void {
			trace("face detection complete");
			
			if(faceDetector.faceRect != null) {
				
			
				
				trace(faceDetector.faceRect);
				// Scale the face detector rectangle
				var scaleFactor:Number = slr.image.height / faceDetector.maxSourceHeight; 
				var scaledFaceRect:Rectangle = Utilities.scaleRect(faceDetector.faceRect, scaleFactor);			
				
				
				var temp:Bitmap = Utilities.cropToFace(slr.image, scaledFaceRect);		
				var cropped:Bitmap = new Bitmap(Utilities.scaleToFit(temp.bitmapData, 500, 500));
				cropped.x = 500;
				addChild(cropped);
			}
			

			
		}
		
		public function Main() {
			faceDetector = new FaceDetector();
			faceDetector.addEventListener(ObjectDetectorEvent.DETECTION_COMPLETE, onFaceDetected);
				
				
			
			// SLR test area
			var button:PushButton = new PushButton(this, 0, 0, "Shutter", onShutter);
			slr = new SLRCamera();

			slr.addEventListener(CameraFeedEvent.NEW_FRAME_EVENT, onPhotoTaken);
			
	
			
			/* 
			// TEXT DEVELOPMENT ZONE
			
			trace("doing text dev");			
			
			///TweenPlugin.activate([BlurFilterPlugin]); //activation is permanent in the SWF, so this line only needs to be run once.
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP;
			stage.nativeWindow.width = 1080;
			stage.nativeWindow.height = 1920;
			
			var text:Text = new Text("Hello world");
			addChild(text);
			text.x = 400;
			text.y = 400;
			
			
			// Tween Sliders
			var sizeSlider:HSlider = new HSlider(this, 0, 0, function():void{ text.textSize = sizeSlider.value });
			sizeSlider.minimum = 0;
			sizeSlider.maximum = 200;
			var colorChooser:ColorChooser = new ColorChooser(this, 0, 0, 0, function():void { text.textColor = colorChooser.value });
			var spacingSlider:HSlider = new HSlider(this, 0, 0, function():void{ text.textLetterSpacing = spacingSlider.value });
			spacingSlider.minimum = -50;
			spacingSlider.maximum = 50;
			
			var randomText:PushButton = new PushButton(this, 0, 0, "Change Text", function():void { text.setText(Utilities.dummyText(50)) });
			var left:PushButton = new PushButton(this, 0, 0, "Align Left", function():void { text.setTextAlign(Text.LEFT) });
			var center:PushButton = new PushButton(this, 0, 0, "Align Center", function():void { text.setTextAlign(Text.CENTER) });
			var right:PushButton = new PushButton(this, 0, 0, "Align Right", function():void { text.setTextAlign(Text.RIGHT) });						
			
			// Position controls automatically
			var controls:Array = [sizeSlider, colorChooser, spacingSlider, randomText, left, center, right];
			var yAccumulator:Number = 5;
			
			for (var i:int = 0; i < controls.length; i++) {
				controls[i].x = 5;
				controls[i].y = yAccumulator;
				yAccumulator = controls[i].y + controls[i].height + 5; 
			}
			
			*/
			
			//var civilDebateWall:CDW = new CDW();
			//addChild(civilDebateWall);
			

		}
	}
}

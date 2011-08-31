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
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.*;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;
	import flash.ui.MouseCursorData;
	
	import net.localprojects.*;
	import net.localprojects.blocks.*;
	import net.localprojects.camera.*;
	import net.localprojects.elements.*;
	import net.localprojects.keyboard.*;
	import net.localprojects.text.Text;
	import net.localprojects.ui.*;
	
	import sekati.layout.Arrange;
	
	//import net.localprojects.CDW;
	
	[SWF(width="1080", height="1920", frameRate="60")]
	public class Main extends Sprite	{
		
		public function Main() {
			trace("doing text dev");
			
			///TweenPlugin.activate([BlurFilterPlugin]); //activation is permanent in the SWF, so this line only needs to be run once.
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP;
			stage.nativeWindow.width = 1080;
			stage.nativeWindow.height = 1920;
			
			// give up if the target face rectangle is too far away?

			var targetBounds:Rectangle = new Rectangle(0, 0, 1080, 1920);			
			var targetFaceRectangle:Rectangle = new Rectangle(294, 352, 494, 576);
			
			var sourceBitmap:Bitmap = Assets.getSample();
			var sourceBounds:Rectangle = sourceBitmap.bitmapData.rect;			
			var sourceFaceRectangle:Rectangle = new Rectangle(1038, 1749, 693, 843);
			
			// Figure out scale required to fit face rect in target rect
			var rectWidthRatio:Number = targetFaceRectangle.width / sourceFaceRectangle.width;
			var rectHeightRatio:Number = targetFaceRectangle.height / sourceFaceRectangle.height;
			var rectScaleRatio:Number = Math.min(rectWidthRatio, rectHeightRatio);
			
			// Scale the bitmap and the rectangle
			var scaledFaceRectangle:Rectangle = Utilities.scaleRect(sourceFaceRectangle, rectScaleRatio);
			var scaledSourceBounds:Rectangle = Utilities.scaleRect(sourceBounds, rectScaleRatio);
			
			// target point center relative to 
			trace("Scaled face rectangle: " + scaledFaceRectangle);
			var targetCenter:Point = Utilities.centerPoint(targetFaceRectangle);
			var scaledSourceCenter:Point = Utilities.centerPoint(scaledFaceRectangle);
			var sourceTranslation:Point = targetCenter.subtract(scaledSourceCenter);
			
			scaledSourceBounds.x = sourceTranslation.x; 
			scaledSourceBounds.y = sourceTranslation.y;			
			

			// for centered scaling
			//scaledSourceCenter.normalize(1);
			
			//trace("Normal scale source center: " + scaledSourceCenter);
			
//			// grow until it fits...
			
			var aspectRatio:Number = scaledSourceBounds.width / scaledSourceBounds.height;
			
//			while (!scaledSourceBounds.containsRect(targetBounds)) {
//				trace("growing: " + scaledSourceBounds);
//				// scale up the source from the face center until it fits
//				scaledSourceBounds.width += 1 * aspectRatio;
//				scaledSourceBounds.height += 1;				
//				scaledSourceBounds.x -= scaledSourceCenter.x;
//				scaledSourceBounds.y -= scaledSourceCenter.y;
//			}
			
			var originalWidth:Number = scaledSourceBounds.width;
			var originalHeight:Number = scaledSourceBounds.height;
			
			while(scaledSourceBounds.width < 2000) {
				scaledSourceBounds.width += 1  * aspectRatio;
				scaledSourceBounds.x -= (scaledSourceCenter.x / originalWidth) * aspectRatio;
				
				scaledSourceBounds.height += 1;				
				scaledSourceBounds.y -= (scaledSourceCenter.y / originalHeight);								
			}
			
			// now it fits, we have the the bounds of the final rectangle
			trace("This fits: " + scaledSourceBounds);
			sourceBitmap.x = Math.floor(scaledSourceBounds.x);
			sourceBitmap.y = Math.floor(scaledSourceBounds.y);			
			sourceBitmap.width = Math.ceil(scaledSourceBounds.width);
			sourceBitmap.height = Math.ceil(scaledSourceBounds.height);			


//			
			
			addChild(sourceBitmap);
			
			
			
			var target:Shape = new Shape();
			target.graphics.lineStyle(10, 0x00ff00);
			target.graphics.drawRect(targetFaceRectangle.x, targetFaceRectangle.y, targetFaceRectangle.width, targetFaceRectangle.height);
			target.graphics.drawRect(scaledFaceRectangle.x, scaledFaceRectangle.y, scaledFaceRectangle.width, scaledFaceRectangle.height);			
			target.graphics.drawCircle(targetCenter.x, targetCenter.y, 10)	
				
			addChild(target);

			
//			
//			
//			// figure out the new dimensions
//			var scaledSourceWidth:int = Math.floor(sourceBitmap.width * rectScaleRatio);
//			var scaledSourceHeight:int = Math.floor(sourceBitmap.height * rectScaleRatio);			
//			
//			// is the scaled source image within the target bounds?
//			var topEdge:Number = sourceCenter.y - (scaledSourceHeight / 2);
//			var rightEdge:Number = sourceCenter.x + (scaledSourceWidth / 2);
//			var bottomEdge:Number = sourceCenter.y + (scaledSourceHeight / 2);			
//			var leftEdge:Number = sourceCenter.x - (scaledSourceWidth / 2);
//			
//			
//			
//			
			
						
			
			
			
			
//			
//			
//			
//			var matrix:Matrix = new Matrix();
//			matrix.scale(scaleRatio, scaleRatio);
//			
//			var o:BitmapData = new BitmapData(b.width * scaleRatio, b.height * scaleRatio);
//			o.draw(b, matrix);			
//			
//			
//			
			 
			/*
			
						
			
			
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
			
			
			
			//TweenMax.to(text, 5, {x: 1000, y:1000, blurFilter:{blurX:10, blurY:10}});			
			
			
			// Position controls automatically
			var controls:Array = [sizeSlider, colorChooser, spacingSlider, randomText, left, center, right];
			var yAccumulator:Number = 5;
			
			for (var i:int = 0; i < controls.length; i++) {
				controls[i].x = 5;
				controls[i].y = yAccumulator;
				yAccumulator = controls[i].y + controls[i].height + 5; 
			}
			
			
				
			
			//var civilDebateWall:CDW = new CDW();
			//addChild(civilDebateWall);
			
			*/
		}
	}
}

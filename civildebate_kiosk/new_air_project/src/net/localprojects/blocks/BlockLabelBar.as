package net.localprojects.blocks {
	import com.bit101.components.Text;
	import com.greensock.TweenMax;
	import com.greensock.easing.*;
	
	import flash.display.*;
	import flash.geom.Rectangle;
	import flash.text.*;
	
	import net.localprojects.Utilities;
	
	
	
	public class BlockLabelBar extends BlockLabel {
		
		private var _backgroundWidth:Number;
		private var _backgroundHeight:Number;
		private var bar:Bitmap;
		
		public function BlockLabelBar(text:String, textSize:Number, textColor:uint, backgroundWidth:Number, backgroundHeight:Number, backgroundColor:uint, font:String=null) {
			_backgroundColor = backgroundColor;
			_backgroundWidth = backgroundWidth;
			_backgroundHeight = backgroundHeight;
			preInit();
			super(text, textSize, textColor, backgroundColor, font, false);

			postInit();
		}
		
		private function preInit():void {
			bar = new Bitmap(new BitmapData(_backgroundWidth, _backgroundHeight, false, _backgroundColor), PixelSnapping.ALWAYS, false);
			addChild(bar);			
		}
		
		private function postInit():void {
			Utilities.centerWithin(textField, bar);
			bar.pixelSnapping = PixelSnapping.ALWAYS;
			cacheAsBitmap = true;
		}
		
		
		override public function setText(s:String, instant:Boolean = false):void {
			// make sure it's a change
			if (textField.text != s) {			
				
				instantTween = instant;			
				var textOutDuration:Number = instant ? 0 : 0.1;
				var backgroundDuration:Number = instant ? 0 : 0.2;			
				newText = s;			
				
				if (instant) {
					textField.text = newText;		
					drawBackground();
				}
				else {
					// crossfade text
					TweenMax.to(textField, textOutDuration, {alpha: 0, ease: Quart.easeOut, onComplete: afterFade});
					TweenMax.to(background, backgroundDuration, {width: getBackgroundDimensions(newText).width, height: getBackgroundDimensions(newText).height, ease: Quart.easeIn});					
				}
				
				// resize the background
				
			}
		}
		
		override public function afterFade():void {
			textField.text = newText;				
			//drawBackground();				
			var textInDuration:Number = instantTween ? 0 : 0.1;
			textField.x = (_backgroundWidth - textField.width) / 2;
			TweenMax.to(textField, textInDuration, {alpha: 1, ease: Quart.easeIn});
		}		
	}
}
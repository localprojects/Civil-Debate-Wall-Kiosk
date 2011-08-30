package net.localprojects.elements {
	import com.greensock.TweenMax;
	import com.greensock.easing.*;
	
	import flash.display.*;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	
	import net.localprojects.*;
	import net.localprojects.blocks.BlockBase;
	
	import sekati.utils.ColorUtil;
	
	public class Portrait extends BlockBase {
		
		private var image:Bitmap;
		private var targetImage:Bitmap;
		private var questionSampleRect:Rectangle;
		private var averagePixels:ByteArray;
		
		public function Portrait() {
			super();
			init();
		}
		
		private function init():void {
			image = new Bitmap();
			targetImage = new Bitmap();			
			
			addChild(image);
			addChild(targetImage);
			
			targetImage.alpha = 0;
			
			questionSampleRect = new Rectangle(29, 117, 1022, 117);
		}
		
		public function setImage(i:Bitmap, instant:Boolean = false):void {
			var duration:Number = instant ? 0 : 0.5;
			
			if(image.bitmapData == i.bitmapData) {
				// image is already correct, get rid of the target
				TweenMax.to(targetImage, duration, {alpha: 0});				
			}
			else {
				// figure out the color behind the text
				// cache this somewhere? it's slow. Only reading 1 / 1000 of the pixels
				var brightness:int = ColorUtil.averageLightness(i, 0.001, questionSampleRect);
				trace("Average brightness: " + brightness);				
				
				// TODO figure out thresholf
				if (brightness > 200) {
					CDW.state.questionTextColor = Assets.COLOR_GRAY_90;
				}
				else {
					CDW.state.questionTextColor = Assets.COLOR_GRAY_15;					
				}
				
				
				
				targetImage.bitmapData = i.bitmapData;
				TweenMax.to(targetImage, duration, {alpha: 1, onComplete: onFadeIn});				
			}
		}
		
		private function onFadeIn():void {
			image.bitmapData = targetImage.bitmapData;
			targetImage.alpha = 0;
		}		
		
		public function setIntermediateImage(i:Bitmap, step:Number):void {
			if (targetImage.bitmapData != i.bitmapData) {
				targetImage.bitmapData = i.bitmapData;
			}
			targetImage.alpha = step;
		}
		
	
	}
}
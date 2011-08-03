package net.localprojects.blocks {
	import com.greensock.TweenMax;
	import com.greensock.easing.*;
	
	import flash.display.*;
	
	import net.localprojects.*;
	
	public class Portrait extends BlockBase {
		
		private var currentImage:Bitmap;
		private var lastImage:Bitmap; // double buffer for the crossfade
		
		public function Portrait() {
			super();
			init();
		}
		
		private function init():void {
			currentImage = new Bitmap(Assets.portraitPlaceholder.bitmapData);
			addChild(currentImage);
		}
		
		public function setImage(i:Bitmap, instant:Boolean = false):void {
			
			if (instant) {
				removeChild(currentImage);
				currentImage = new Bitmap(i.bitmapData);				
				addChild(currentImage);		
			}
			else {
				// swaps images so we get a nice crossfade
				lastImage = new Bitmap(currentImage.bitmapData);
				
				removeChild(currentImage);
				currentImage = new Bitmap(i.bitmapData);
				addChild(currentImage);			
				
				addChild(lastImage);
				TweenMax.to(lastImage, 0.5, {alpha: 0, ease: Quart.easeInOut, onComplete: onFadeOut});
			}
		}
		
		private function onFadeOut():void {
			removeChild(lastImage);
		}
	}
}
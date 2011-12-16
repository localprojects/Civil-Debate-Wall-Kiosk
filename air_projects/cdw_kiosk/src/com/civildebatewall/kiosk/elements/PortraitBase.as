package com.civildebatewall.kiosk.elements {
	
	import com.greensock.TweenMax;
	import com.kitschpatrol.futil.blocks.BlockBase;
	import com.kitschpatrol.futil.utilitites.GraphicsUtil;
	
	import flash.display.Bitmap;
	import flash.display.Shape;

	public class PortraitBase extends BlockBase {
		
		private var image:Bitmap;
		private var targetImage:Bitmap;
		private var blackOverlay:Shape;
		
		public function PortraitBase() {
			super();
			init();
		}
		
		private function init():void {
			image = new Bitmap();
			targetImage = new Bitmap();			
			
			addChild(image);
			addChild(targetImage);
			
			targetImage.alpha = 0;
			
			// work around for weird alpha interaction
			blackOverlay = GraphicsUtil.shapeFromSize(500,500, 0x000000);
			blackOverlay.alpha = 0;
			addChild(blackOverlay);
		}
		
		public function set overlayAlpha(value:Number):void {
			blackOverlay.alpha = value;
		}
		
		public function get overlayAlpha():Number {
			return blackOverlay.alpha;
		}
		
		public function setImage(i:Bitmap, instant:Boolean = false):void {
			var duration:Number = instant ? 0 : 0.5;
			
			if(image.bitmapData == i.bitmapData) {
				// image is already correct, get rid of the target
				TweenMax.to(targetImage, duration, {alpha: 0});				
			}
			else {
				targetImage.bitmapData = i.bitmapData;
				TweenMax.to(targetImage, duration, {alpha: 1, onComplete: onFadeIn});				
			}
			
			// pseudo alpha kludge
			blackOverlay.width = targetImage.width;
			blackOverlay.height = targetImage.height;
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
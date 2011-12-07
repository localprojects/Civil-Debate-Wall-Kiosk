package com.civildebatewall.kiosk.elements {

	import com.civildebatewall.CivilDebateWall;
	import com.civildebatewall.State;
	import com.greensock.TweenMax;
	import com.kitschpatrol.futil.blocks.BlockBase;
	
	import flash.display.Bitmap;
	import flash.events.Event;
	
	public class PortraitMain extends BlockBase {
		
		private var image:Bitmap;
		private var targetImage:Bitmap;
		
		public function PortraitMain() {
			super();
			init();
		}
		
		private function onActiveDebateChange(e:Event):void {
			if (CivilDebateWall.state.activeThread != null) {
				setImage(CivilDebateWall.state.activeThread.firstPost.user.photo);
			}
		}
		
		private function init():void {
			image = new Bitmap();
			targetImage = new Bitmap();			
			
			addChild(image);
			addChild(targetImage);
			
			targetImage.alpha = 0;
			
			CivilDebateWall.state.addEventListener(State.ACTIVE_THREAD_CHANGE, onActiveDebateChange);
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
package com.civildebatewall.kiosk.elements {
	import com.civildebatewall.*;
	import com.civildebatewall.kiosk.blocks.OldBlockBase;
	import com.greensock.TweenMax;
	import com.greensock.easing.*;
	
	import flash.display.*;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.utils.ByteArray;
	
	
	
	public class Portrait extends OldBlockBase {
		
		private var image:Bitmap;
		private var targetImage:Bitmap;
		
		
		public function Portrait() {
			super();
			init();
			
			
		}
		
		private function onActiveDebateChange(e:Event):void {
			setImage(CivilDebateWall.state.activeThread.firstPost.user.photo);
		}
		
		private function init():void {
			image = new Bitmap();
			targetImage = new Bitmap();			
			
			addChild(image);
			addChild(targetImage);
			
			targetImage.alpha = 0;
			
			CivilDebateWall.state.addEventListener(State.ACTIVE_DEBATE_CHANGE, onActiveDebateChange);
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
				var brightness:int = 0;
				//var brightness:int = CDW.database.brightness[i];
				//trace("Average brightness: " + brightness);				
				
				
				if (i is MetaBitmap) {
				
					CivilDebateWall.dashboard.log("Brightness: " + (i as MetaBitmap).brightness);
					
					// TODO figure out thresholf
					if ((i as MetaBitmap).brightness > 200) {
						CivilDebateWall.state.questionTextColor = Assets.COLOR_GRAY_90;
					}
					else {
						CivilDebateWall.state.questionTextColor = 0xffffff;					
					}
				}
				else {
					// it's the placeholder...
					CivilDebateWall.state.questionTextColor = Assets.COLOR_GRAY_90;
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
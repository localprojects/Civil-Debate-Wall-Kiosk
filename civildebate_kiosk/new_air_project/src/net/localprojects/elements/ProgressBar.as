package net.localprojects.elements {
	import com.greensock.*;
	import com.greensock.easing.Linear;
	
	import flash.display.Shape;
	
	import net.localprojects.Assets;
	import net.localprojects.blocks.BlockBase;
	
	public class ProgressBar extends BlockBase {
		
		private var _barWidth:Number;
		private var _barHeight:Number;		
		private var _barDuration:Number;
		private var background:Shape;		
		private var bar:Shape;
		protected var onProgressComplete:Function;
		
		public function ProgressBar(barWidth:Number, barHeight:Number, barDuration:Number) {
			_barWidth = barWidth;
			_barHeight = barHeight;
			_barDuration = barDuration;
			super();
			init();
		}
		
		private function init():void {
			 background = new Shape();
			 background.graphics.beginFill(Assets.COLOR_GRAY_75);
			 background.graphics.drawRect(0, 0, _barWidth, _barHeight);
			 background.graphics.endFill();
			 background.alpha = 0; // disable per jonathan review
			 
			 bar = new Shape();
			 bar.graphics.beginFill(0xffffff);
			 bar.graphics.drawRect(0, 0, _barWidth, _barHeight);
			 bar.graphics.endFill();
			 bar.scaleX = 0;
			 
			 addChild(background);
			 addChild(bar);
		}
		
		public function pause():void {
			TweenMax.killTweensOf(bar);
		}
		
		override protected function afterTweenIn():void {
			TweenMax.to(bar, _barDuration, {scaleX: 1, onComplete: onCompeteFunction, ease: Linear.easeIn});
		}
		
		override protected function afterTweenOut():void {
			super.afterTweenOut();
			
			bar.scaleX = 0;
		}		
		
		override protected function beforeTweenOut():void {
			TweenMax.killTweensOf(bar);
		}
				
		
		private function onCompeteFunction():void {
			onProgressComplete();
		}
		
		public function setOnComplete(f:Function):void {
			onProgressComplete = f;
		}

	}
}
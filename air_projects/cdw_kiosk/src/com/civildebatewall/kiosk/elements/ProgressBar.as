package com.civildebatewall.kiosk.elements {
	import com.civildebatewall.Assets;
	import com.civildebatewall.kiosk.legacy.OldBlockBase;
	import com.greensock.*;
	import com.greensock.easing.Linear;
	import com.kitschpatrol.futil.blocks.BlockBase;
	import com.kitschpatrol.futil.blocks.BlockShape;
	import com.kitschpatrol.futil.constants.Alignment;
	
	import flash.display.Shape;
	import flash.events.Event;

	public class ProgressBar extends BlockBase {
		
		private var _duration:Number; // how long to scroll
		private var _targetWidth:Number;
		private var barTween:TweenMax;
		
		public var onProgressComplete:Vector.<Function>;		
		
		public function ProgressBar(params:Object = null) {
			duration = 1; // default

			super(params);
			this.background.backgroundImage = Assets.getProgressGradient();			
			
			onProgressComplete = new Vector.<Function>(0);
		}
		
		public function get duration():Number { return _duration; }
		public function set duration(value:Number):void {	_duration = value; }
		
		public function pause():void {
			if (barTween != null) barTween.kill();
		}
		
		override protected function afterTweenIn():void {
			barTween = TweenMax.to(this, _duration, {width: _targetWidth, onComplete: onCompleteFunctionInternal, ease: Linear.easeIn});
			super.afterTweenIn();
		}
		
		override protected function beforeTweenIn():void {
			_targetWidth = 880; // TODO not hard coded
			width = 0;
			super.beforeTweenIn();
		}		
		
		override protected function beforeTweenOut():void {
			pause();
			super.beforeTweenOut();			
		}
		
		override protected function afterTweenOut():void {
			width = _targetWidth;
		}
		
		private function onCompleteFunctionInternal():void {
			executeAll(onProgressComplete);
		}
		

	}
}
/*--------------------------------------------------------------------
Civil Debate Wall Kiosk
Copyright (c) 2012 Local Projects. All rights reserved.

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as
published by the Free Software Foundation, either version 2 of the
License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public
License along with this program. 

If not, see <http://www.gnu.org/licenses/>.
--------------------------------------------------------------------*/

package com.civildebatewall.kiosk.elements {
	
	import com.civildebatewall.Assets;
	import com.greensock.TweenMax;
	import com.greensock.easing.Linear;
	import com.kitschpatrol.futil.blocks.BlockBase;

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

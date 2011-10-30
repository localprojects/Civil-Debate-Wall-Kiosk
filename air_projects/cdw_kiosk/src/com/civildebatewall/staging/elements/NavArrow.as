package com.civildebatewall.staging.elements
{
	import com.civildebatewall.staging.futilProxies.BlockBitmapTweenable;
	import com.greensock.TweenMax;
	
	import flash.events.MouseEvent;
	
	public class NavArrow extends BlockBitmapTweenable {
		
		public var _upColor:uint;
		public var _downColor:uint;
		
		public function NavArrow(params:Object=null) {
			super(params);
			enable();
		}
		
		public function get upColor():uint { return _upColor; }
		public function set upColor(c:uint):void {
			_upColor = c;
			TweenMax.to(this, 1, {colorMatrixFilter:{colorize: _upColor, amount: 1}});				
		}
		
		public function get downColor():uint { return _downColor; }
		public function set downColor(c:uint):void {
			_downColor = c;
			//TweenMax.to(this, 1, {colorMatrixFilter:{colorize: _downColor, amount: 1}});				
		}
		
		override protected function onMouseDown(e:MouseEvent):void {
			TweenMax.to(this, 0, {colorMatrixFilter:{colorize: _downColor, amount: 1}});			
			super.onMouseDown(e);
		}
		
		override protected function onMouseUp(e:MouseEvent):void {
			TweenMax.to(this, 0.5, {colorMatrixFilter:{colorize: _upColor, amount: 1}});			
			super.onMouseUp(e);
		}
		
		
		
		
	}
}
package com.civildebatewall.staging.elements {
	import com.civildebatewall.staging.futilProxies.BlockBitmapTweenable;
	import com.greensock.TweenMax;
	
	import flash.events.MouseEvent;
	
	public class NavArrow extends BlockBitmapTweenable {
		
		public var upColor:uint;
		public var downColor:uint;
		
		public function NavArrow(params:Object=null) {
			super(params);
			buttonMode = true;
			
			trace("Function: ");
			trace(down);
			onButtonDown.push(down);
			onButtonUp.push(up);
		}
		
		private function down(e:MouseEvent):void {
			TweenMax.to(this, 0, {colorMatrixFilter:{colorize: downColor, amount: 1}});
		}
				
		private function up(e:MouseEvent):void {
			TweenMax.to(this, 0.5, {colorMatrixFilter:{colorize: upColor, amount: 1}});			
		}

	}
}
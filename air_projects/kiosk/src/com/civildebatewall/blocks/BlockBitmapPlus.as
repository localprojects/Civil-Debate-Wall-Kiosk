package com.civildebatewall.blocks {
	import com.civildebatewall.BitmapPlus;
	import com.greensock.TweenMax;
	
	import flash.display.Bitmap;
	import flash.display.PixelSnapping;
	
	// Like block bitmap, but with control over color and such
	public class BlockBitmapPlus extends BlockBase {
		
		private var b:BitmapPlus;
		
		public function BlockBitmapPlus(source:Bitmap) {
			super();
			b = new BitmapPlus(source.bitmapData, PixelSnapping.ALWAYS, true);
			init();
		}
		
		
		private function init():void {
			addChild(b);
			b.tintAmount = 1;			
		}
		
		public function setColor(c:uint, instant:Boolean):void {
			var duration:Number = instant ? 0 : 1;
			TweenMax.to(b, duration, {hexColors:{tintColor: c}});
		}
	}
}
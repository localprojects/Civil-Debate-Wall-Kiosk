package net.localprojects.blocks {
	import fl.motion.Color;
	
	import flash.display.Bitmap;
	
	import net.localprojects.BitmapPlus;
	
	public class BlockBitmap extends BlockBase {
		
		private var b:BitmapPlus;
		private var color:uint;
		
		public function BlockBitmap(source:Bitmap) {
			super();
			b = new BitmapPlus(source.bitmapData);
			init();
		}
		
		private function init():void {
			addChild(b);
		}
		
		public function setColor(c:uint, instant:Boolean = false):void {
			color = c;
//			b.tintAmount = 1;
//			b.tintColor = c;
		}
		 
	}
}
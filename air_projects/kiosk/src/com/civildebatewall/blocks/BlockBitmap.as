package com.civildebatewall.blocks {
	import flash.display.Bitmap;
	
	public class BlockBitmap extends BlockBase {
		
		private var b:Bitmap;
		
		
		public function BlockBitmap(source:Bitmap) {
			super();
			b = source;
			init();
		}

		
		private function init():void {
			addChild(b);
			//mouseEnabled = false; // let clicks through
		}
		 
	}
}
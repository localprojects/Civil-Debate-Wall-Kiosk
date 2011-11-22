package com.kitschpatrol.futil.blocks {
	import flash.display.Bitmap;
	
	public class BlockBitmap extends BlockBase {
		
		protected var b:Bitmap;
		
		
		public function BlockBitmap(params:Object) {
			super(params);
			
			if (b == null) b = new Bitmap();
			
			addChild(b);
		}
		
		public function set bitmap(b:Bitmap):void {
			this.b = b;
		}
		
		public function get bitmap():Bitmap {
			return b;
		}
		
		override public function get width():Number { return contentWidth; };
		override public function get height():Number { return contentHeight; };
		
	}
}
package com.kitschpatrol.flashspan {
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	public class SpanSprite extends Sprite {

		public var totalWidth:int;
		public var totalHeight:int;				
		
		public function SpanSprite(w:int, h:int, _totalWidth:int, _totalHeight:int, xOffset:int, yOffset:int, background:uint = 0xffffff) {
			super();
			
			totalWidth = _totalWidth;
			totalHeight = _totalHeight;			
			
			// testing
			this.graphics.beginFill(background);
			this.graphics.drawRect(0, 0, totalWidth, totalHeight);
			this.graphics.endFill();
			
			
			// draw a unique rectangle in each section, for testing
//			var tempXOffset:int = 0;
//			while(tempXOffset < totalWidth) {
//				this.graphics.beginFill(Math.random() * uint.MAX_VALUE);
//				this.graphics.drawRect(tempXOffset, 0, w, h);
//				this.graphics.endFill();
//				tempXOffset += w;
//			}
			

			// mask if needed?
			
			// set offset TODO test this
			this.x = -xOffset;
			this.y = -yOffset;
		}
		
		
	}
}
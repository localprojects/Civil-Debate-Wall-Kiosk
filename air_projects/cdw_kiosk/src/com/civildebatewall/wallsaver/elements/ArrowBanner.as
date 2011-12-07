package com.civildebatewall.wallsaver.elements {
	
	import flash.display.Sprite;
	
	public class ArrowBanner extends Sprite	{
		
		public static const RIGHT:String = "right";
		public static const LEFT:String = "left";		
		
		private var direction:String;
		private var size:int;
		private var color:uint;
		private var arrowWidth:int;
		private var arrowHeight:int;
		
		public function ArrowBanner(size:int, arrowWidth:int, arrowHeight:int, color:uint, direction:String) {
			super();
			this.size = size;
			this.arrowWidth = arrowWidth;
			this.arrowHeight = arrowHeight;
			this.color = color;
			this.direction = direction;
			
			draw();
		}

		private function draw():void {
			graphics.clear();
			graphics.beginFill(color);			
			
			if (direction == RIGHT) { 			
				graphics.moveTo(0, 0); // top left
				graphics.lineTo(size + arrowWidth, 0); // top right
				graphics.lineTo(size + arrowWidth + arrowWidth, arrowHeight / 2); // arrow point
				graphics.lineTo(size + arrowWidth, arrowHeight) // bottom right
				graphics.lineTo(0, arrowHeight); // bottom left
				graphics.lineTo(arrowWidth, arrowHeight / 2); // arrow indent
				graphics.lineTo(0, 0); // back to top left
			}
			else if (direction == LEFT) {
				graphics.moveTo(0, arrowHeight / 2); // arrow point
				graphics.lineTo(arrowWidth, 0); // top left
				graphics.lineTo(size + arrowWidth + arrowWidth, 0); // top right
				graphics.lineTo(size + arrowWidth, arrowHeight / 2); // arrow indent
				graphics.lineTo(size + arrowWidth + arrowWidth, arrowHeight); // bottom right
				graphics.lineTo(arrowWidth, arrowHeight); // bottom left
				graphics.lineTo(0, arrowHeight / 2); // arrow point
			}
			else {
				throw new Error("Invalid arrow direction \"" + direction + "\""); 
			}
			
			graphics.endFill();			
		}
		
	}
}
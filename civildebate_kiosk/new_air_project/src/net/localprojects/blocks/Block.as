package net.localprojects.blocks {
	import flash.display.Sprite;
	import flash.geom.Point;
	
	public class Block extends Sprite {
		
		public var targetX:Number;
		public var targetY:Number;
			
		public function Block() {
			super();
		}
		
		public function setTarget(x:Number, y:Number):void {
			targetX = x;
			targetY = y;
		}
		
		public function getTarget():Point {
			return new Point(targetX, targetY);
		}		
		
	}
}
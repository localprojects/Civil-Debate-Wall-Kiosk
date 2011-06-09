package net.localprojects {
	import flash.display.Sprite;
	import flash.geom.Matrix;
	
	
	public class MugShot extends Sprite	{
		
		public var w:Number;
		public var h:Number;		
		
		public function MugShot() {
			super();
			
			w = 235;
			h = 350;
			
			var matrix:Matrix = new Matrix();
			matrix.translate(Assets.obama.width - ((Assets.obama.width - w) / 2), 0);						
			matrix.scale(.5, .5); // flip horizontally
			
			
			this.graphics.beginBitmapFill(Assets.obama.bitmapData, matrix);
			this.graphics.drawRect(0, 0, w, h);
			this.graphics.endFill();
			
		}
	}
}
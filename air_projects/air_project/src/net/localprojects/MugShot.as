package net.localprojects {
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.PerspectiveProjection;
	import flash.geom.Point;
	
	
	
	public class MugShot extends Sprite	{
		
		public var w:Number;
		public var h:Number;		
		
		public function MugShot() {
			super();
			
			w = 220;
			h = 330;
			
			var matrix:Matrix = new Matrix();
			matrix.translate(w * .5, h * .5);						
			
			
			this.graphics.beginBitmapFill(Assets.silhouette.bitmapData, matrix);
			this.graphics.drawRect(w / -2, h / -2, w, h);
			this.graphics.endFill();
			
		}
	}
}
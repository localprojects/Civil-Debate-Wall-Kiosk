package com.civildebatewall.kiosk.overlays.smsfun {
	
	import com.civildebatewall.Assets;
	import com.kitschpatrol.futil.drawing.DashedLine;
	
	import flash.display.CapsStyle;
	import flash.display.LineScaleMode;
	import flash.display.Shape;
	import flash.geom.Point;
	
	public class Connection extends DashedLine {
		
		private var dot:Shape;
		
		public function Connection() {
			// pick random color
			var yes:Boolean = (Math.random() > 0.5);
			var colorA:uint = yes ? Assets.COLOR_YES_LIGHT : Assets.COLOR_NO_LIGHT;
			var colorB:uint = yes ? Assets.COLOR_YES_DARK : Assets.COLOR_NO_DARK;
			super(20 / 4, 25 / 4, 20 / 4, colorA, colorB, CapsStyle.NONE, LineScaleMode.NORMAL);
			
			// create the line point dot
			dot = new Shape();
			dot.graphics.beginFill(colorA);
			dot.graphics.drawCircle(0, 0, 8);
			dot.graphics.endFill();
			addChild(dot);
		}
		
		public function get penPosition():Point {
			return path.pointAt(step);
		}
		
		override protected function draw():void {
			// make the pen dot follow the line
			var penHead:Point = path.pointAt(step);
			dot.x = penHead.x;
			dot.y = penHead.y;	
			
			super.draw();
		}		
	}
}
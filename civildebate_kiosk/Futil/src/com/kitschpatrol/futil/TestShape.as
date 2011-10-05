package com.kitschpatrol.futil {
	import flash.display.Shape;
	import flash.display.Sprite;
	
	
	public class TestShape extends BlockContainer {
		
		
		
		public function TestShape(params:Object = null)	{
			super();


			var shape:Shape = new Shape();
			shape.graphics.beginFill(0xff0000);
			shape.graphics.drawRect(0, 0, 100, 100);
			shape.graphics.endFill();
			
//			shape.graphics.beginFill(0x0f00f0);
//			shape.graphics.drawCircle(90, 50, 20);
//			shape.graphics.endFill();
			
			//foreground.addChild(shape);
			addChild(shape);
			
//			var otherShape:Shape = new Shape();
//			otherShape.graphics.beginFill(0x0fffff);
//			otherShape.graphics.drawEllipse(0, 0, 100, 50);
//			otherShape.graphics.endFill();
//			
//			otherShape.x = 150;
//			otherShape.y = 150;
//			
//			
//			addChild(otherShape);
			
			
			// some issue with the order...
			setParams(params);
		}
		
		
		
		
	}
}
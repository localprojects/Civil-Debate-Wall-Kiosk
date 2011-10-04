package com.kitschpatrol.futil {
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	// nested display object approach to registration management, better to just run through everything?
	public class NestTest extends Sprite {
		
		// registrationPoint
		// translationPoint
		
		
		private var _origin:Point; // this is relative to the actual top left of the content
		private var contentPane:Sprite;
		private var originMarker:Shape;
		private var contentOriginMarker:Shape;
		
		public function NestTest()	{
			super();

			
			contentPane = new Sprite();
			addChild(contentPane);
			
			contentPane.graphics.clear();
			contentPane.graphics.beginFill(uint.MAX_VALUE * Math.random());
			contentPane.graphics.drawRect(0, 0, 100, 100);
			contentPane.graphics.endFill();
//			contentPane.graphics.beginFill(0xff00ff);
//			contentPane.graphics.drawCircle(0, 0, 10);
//			contentPane.graphics.endFill();			

			
			originMarker = new Shape();
			originMarker.graphics.beginFill(0xff0000);
			originMarker.graphics.drawCircle(0, 0, 10);
			originMarker.graphics.endFill();			
			addChild(originMarker);
			
			contentOriginMarker = new Shape();
			contentOriginMarker.graphics.beginFill(0x00ff00);
			contentOriginMarker.graphics.drawCircle(0, 0, 10);
			contentOriginMarker.graphics.endFill();			
			addChild(contentOriginMarker);			
			
			origin = new Point(0, 0);
		}
		
		// x, y is the translation origin
		// rx, ry is the registration origin
		// width and height, however is the actual content
		
//		override public function set scaleX(scale:Number):void {
//			contentPane.scaleX = scale;
//		}
		
		

		public function get origin():Point { return origin };
		public function set origin(point:Point):void {
			_origin = point;
			

			contentPane.x = -_origin.x;
			contentPane.y = -_origin.y;

			trace(contentPane.x);
			trace(contentPane.y);
			trace(contentPane.width, contentPane.height);
			trace(width, height);
			
			contentOriginMarker.x = contentPane.x;
			contentOriginMarker.y = contentPane.y;
			
		};
		
		// Proxy to the container
		
		// WOuld need to override all of these
		
		// what about width and height!?
		
//		public function addChild(child:DisplayObject):DisplayObject
//			
//		public function addChildAt(child:DisplayObject, index:int):DisplayObject
//			
//		public function getChildAt(index:int):DisplayObject
//			
//		
//		public function getChildByName(name:String):DisplayObject
//		
//		public function getChildIndex(child:DisplayObject):int
//		
//		
//		public function removeChild(child:DisplayObject):DisplayObject
//		
//			
//		public function removeChildAt(index:int):DisplayObject
//			
//		public function setChildIndex(child:DisplayObject, index:int):void
//			
//		public function swapChildren(child1:DisplayObject, child2:DisplayObject):void			
//		
//			
//		public function swapChildrenAt(index1:int, index2:int):void			
//			
		// Convenience
		
		
		
	}
}
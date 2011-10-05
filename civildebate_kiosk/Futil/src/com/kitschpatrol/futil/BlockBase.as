package com.kitschpatrol.futil {
	
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.Point;
	
	// Nested display object approach to registration management.
	
	// TODO Performance tests of this approach agains just iterating through
	// the display list and nudging and objects children one by one.
	// Are the overrides too ugly and a lot of overhead?
	
	// TODO what about translation point vs. registration point?
	// Just use TweenMax for translation point manipulations?
	
	// merge this with block container?
	
	public class BlockBase extends Sprite {
		
		// registration point
		private var _registrationPoint:Point; // this is relative to the actual top left of the content
		internal var contentPane:Sprite;
		private var registrationMarker:Shape;
		private var _showRegistrationMarker:Boolean;
		
		// TODO pass in params
		public function BlockBase(params:Object = null)	{
			super();

			contentPane = new Sprite();
			super.addChild(contentPane);
			
			_showRegistrationMarker = false;			
			registrationMarker = new Shape();
			registrationMarker.graphics.beginFill(0xff0000);
			// Add crosshair
			registrationMarker.graphics.drawCircle(0, 0, 10);
			registrationMarker.graphics.endFill();
			
			origin = new Point(0, 0);
		}
		

		public function set showRegistrationMarker(show:Boolean):void {
			_showRegistrationMarker = show;
			if (_showRegistrationMarker)
				super.addChild(registrationMarker);
			else
				super.removeChild(registrationMarker);
		}
		
		
		// convenience
		public function set originX(offset:Number):void {
			_registrationPoint.x = offset;
			updateOrigin();
			
		}
		
		public function set originY(offset:Number):void {
			_registrationPoint.y = offset;
			updateOrigin();
		}		
		
		public function get origin():Point { return origin };
		public function set origin(point:Point):void {
			_registrationPoint = point;
			
			updateOrigin();
			
			//contentOriginMarker.x = contentPane.x;
			//contentOriginMarker.y = contentPane.y;			
		}
		
		internal function updateOrigin():void {
			contentPane.x = -(_registrationPoint.x * contentPane.width);
			contentPane.y = -(_registrationPoint.y * contentPane.height);			
		}
		
		
		// This class acts as a transparent proxy to the content pane.
		// It should seem as though we're just manipulating the content pane directly.
		
		// Overrides to show true width.
		override public function get width():Number { return contentPane.width; }
		override public function set width(value:Number):void { contentPane.width = value }
		
		override public function get height():Number { return contentPane.height; }
		override public function set height(value:Number):void { contentPane.height = value }		

		// Overrides to proxy out container.
		override public function addChild(child:DisplayObject):DisplayObject { return contentPane.addChild(child);	}
		override public function addChildAt(child:DisplayObject, index:int):DisplayObject { return contentPane.addChildAt(child, index); }
		override public function getChildAt(index:int):DisplayObject { return contentPane.getChildAt(index);	} 
		override public function getChildByName(name:String):DisplayObject { return contentPane.getChildByName(name);	}
		override public function getChildIndex(child:DisplayObject):int { return contentPane.getChildIndex(child); }
		override public function removeChild(child:DisplayObject):DisplayObject { return contentPane.removeChild(child); }
		override public function removeChildAt(index:int):DisplayObject { return contentPane.removeChildAt(index); }
		override public function setChildIndex(child:DisplayObject, index:int):void { contentPane.setChildIndex(child, index); }
		override public function swapChildren(child1:DisplayObject, child2:DisplayObject):void { contentPane.swapChildren(child1, child2); }
		override public function swapChildrenAt(index1:int, index2:int):void { contentPane.swapChildrenAt(index1, index2); }
	}
}
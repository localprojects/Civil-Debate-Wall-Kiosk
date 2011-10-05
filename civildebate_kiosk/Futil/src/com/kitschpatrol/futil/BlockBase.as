package com.kitschpatrol.futil {
	
	import com.kitschpatrol.futil.constants.Alignment;
	
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
		internal var lockUpdates:Boolean; // prevents update from firing... useful when queueing a bunch of changes // TODO getter and setter?
		
		// internal alignment point, normalized relative to width of background
		private var _alignmentPoint:Point;

		// Size (padding is additive)
		internal var _maxSizeBehavior:String; // TODO scope to private?
		public static const MAX_SIZE_CLIPS:String = "maxSizeClips"; // masks off
		public static const MAX_SIZE_TRUNCATES:String = "maxSizeTruncates"; // ellipses or whatever
		public static const MAX_SIZE_OVERFLOWS:String = "maxSizeOverflows"; // nothing happen, text just sticks out
		public static const MAX_SIZE_BREAKS_LINE:String = "maxSizeBreaksLine"; // nothing happen, text just sticks out			
		
		// TODO Scope to private?
		internal var _minWidth:Number;
		internal var _minHeight:Number;
		internal var _maxWidth:Number;
		internal var _maxHeight:Number;						
			
		// Background
		private var background:BlockShape;
		
		// Padding
		private var _padding:Padding; // Padding, note convenience getters and setters for all, top/bottom, and left/right
		

		
			
		// TODO pass in params
		public function BlockBase(params:Object = null)	{
			super();

			background = new BlockShape();
			super.addChild(background);
			
			contentPane = new Sprite();
			super.addChild(contentPane);
			
			
			_padding = new Padding();
			
			// background and border panes... put them in their own classes? override width and height to redraw to scale?

			_showRegistrationMarker = false;			
			registrationMarker = new Shape();
			registrationMarker.graphics.beginFill(0xff0000);
			// Add crosshair
			registrationMarker.graphics.drawCircle(0, 0, 10);
			registrationMarker.graphics.endFill();

			
			_alignmentPoint = new Point(0, 0);
			_registrationPoint = new Point(0, 0);
			
			// Size
			_minWidth = 0;
			_minHeight = 0;
			_maxWidth = Number.MAX_VALUE;
			_maxHeight = Number.MAX_VALUE;
			_maxSizeBehavior = MAX_SIZE_OVERFLOWS;	
			
			
			
			
			// TODO devise and flip the update booleans (e.g. invalidate everything)

			// overwrites defaults
			setParams(params);
			update();
		}
		
		// set a bunch of fields at once
		public function setParams(params:Object):void {
			if (params != null) {
				lockUpdates = true;
				
				// set multiple settings in one pass
				for (var key:String in params) {
					if (this.hasOwnProperty(key)) {
						// set local
						trace("Setting " + key + " to " + params[key]);
						this[key] = params[key];
					}
					else {
						trace("NO SUCH PROPERTY: " + key);
						// TODO throw error. This is a big problem?
					}
				}
				
				lockUpdates = false;
				update();
			}
			// TODO update anyway?
		}		
		
		
		// scope to private? use object dimensions instead?
		internal var lastBackgroundWidth:Number;
		internal var lastBackgroundHeight:Number;
		internal var backgroundWidth:Number;
		internal var backgroundHeight:Number;		
		
		
		public function update():void {
			if (!lockUpdates) {

				
				// only if needed
				background.width = Math2.clamp(contentPane.width, _minWidth, _maxWidth + _padding.horizontal) + _padding.horizontal; // stretch max for padding
				background.height = Math2.clamp(contentPane.height, _minHeight, _maxHeight + _padding.vertical) + _padding.vertical;
				
				//contentPane.x = _padding.left; // positioning offset
				//contentPane.y = _padding.top; // plus positioning offset
				
					
				// only if bounds changed... TODO
				updateOrigin();
				
				
			}
			else {
				
			}
		}
		
		
		// Draws the background, but doesn't update dimensions. Good for color changes.
		private function drawBackground():void {

		}		
		

		public function set showRegistrationMarker(show:Boolean):void {
			_showRegistrationMarker = show;
			if (_showRegistrationMarker)
				super.addChild(registrationMarker);
			else
				super.removeChild(registrationMarker);
		}
		
		

		
		
		// registration point
		private var lastRegistrationPoint:Point = new Point();
		public function get registrationPoint():Point { return _registrationPoint };
		public function set registrationPoint(point:Point):void {
			_registrationPoint = point;
			updateOrigin();
		}
		

		
		
		internal function updateOrigin():void {
			// Compensate for padding, which always accumulates on the outsize of the content
			
			contentPane.x = -(_registrationPoint.x * (background.width - _padding.horizontal));
			contentPane.y = -(_registrationPoint.y * (background.height - _padding.vertical));
			background.x = contentPane.x - _padding.left;
			background.y = contentPane.y - _padding.top;  			
			
			// align content
			contentPane.x += _alignmentPoint.x * ((background.width - _padding.horizontal) - contentPane.width);
			contentPane.y += _alignmentPoint.y * ((background.height - _padding.vertical) - contentPane.height);
			//contentPane.y += (_alignmentPoint.y * (contentPane.height - (background.height - _padding.vertical)));			
			
			//this.x += (_registrationPoint.x * (background.width - _padding.horizontal));
			
//			
//			var lastX:Number = this.x;
//			
//			
//			// Set content position based on both the registration point and the alignment point relative to the background
//			contentPane.x = -(_registrationPoint.x * (background.width - _padding.horizontal));
//			contentPane.y = -(_registrationPoint.y * (background.height - _padding.vertical))
//			
//			//contentPane.x += (_alignmentPoint.x * (contentPane.width - (background.width - _padding.horizontal)));
//			//contentPane.y += (_alignmentPoint.y * (contentPane.height - (background.height - _padding.vertical)));
//			
//			// Set background position based on registration point 
//			//background.x = -(_registrationPoint.x * background.width) - _padding.left;
//			//background.y = -(_registrationPoint.y * background.height) - _padding.top;
//			
//			
//				this.x += 25;
//				
//			//this.x += background.x - lastX;
			
		}
		

		// TODO AUTOMATIC ALIGNMENT!!!
		
		
		
		// Content alignment
		// TODO, tween plugin for this? TO TWEEN, look up the constant and use contentOffsetNormalX and contentOffsetNormalY to actually tween there.
		public function get alignmentPoint():Point { return _alignmentPoint; }
		public function set alignmentPoint(point:Point):void {
			_alignmentPoint = point;
			update();
		}
		

	
		// Size
		public function get minWidth():Number { return _minWidth; }
		public function set minWidth(w:Number):void {
			_minWidth = w;
			if (_minWidth > _maxWidth) _maxWidth = _minWidth; 
			update(); // resize
		}
		
		public function get minHeight():Number { return _minHeight; }
		public function set minHeight(h:Number):void {
			_minHeight = h;
			if (_minHeight > _maxHeight) _maxHeight = _minHeight;			
			update(); // resize
		}		
		
		public function get maxWidth():Number { return _maxWidth; }
		public function set maxWidth(w:Number):void {
			_maxWidth = w;
			if (_maxWidth < _minWidth) _minWidth = _maxWidth;
			update(); // resize
		}
		
		public function get maxHeight():Number { return _maxHeight; }
		public function set maxHeight(w:Number):void {
			_maxHeight = w;
			if (_maxHeight < _minHeight) _minHeight = _maxHeight;
			update(); // resize
		}		
		
		
		// TODO, tween plugin for this?
		public function get maxSizeBehavior():String { return _maxSizeBehavior; }
		public function set maxSizeBehavior(behavior:String):void {
			_maxSizeBehavior = behavior;
			update();
		}		
		
		
		// Padding Proxy
		public function get paddingTop():Number { return _padding.top; }
		public function set paddingTop(amount:Number):void {
			
			_padding.top = amount;
			// bounds changed TODO
			
			update();
		}
		
		public function get paddingRight():Number { return _padding.right; }
		public function set paddingRight(amount:Number):void {
			_padding.right = amount;
			// bounds changed TODO			
			update();
		}		
		
		
		public function get paddingBottom():Number { return _padding.bottom; }
		public function set paddingBottom(amount:Number):void {
			_padding.bottom = amount;
			update();
		}
		
		public function get paddingLeft():Number { return _padding.left; }
		public function set paddingLeft(amount:Number):void {
			_padding.left = amount;
			update();
		}
		

		
		public function get padding():Number { return _padding.top;	} // TODO fix this
		public function set padding(amount:Number):void {
			_padding.horizontal = amount;
			_padding.vertical = amount;
			update();
		}
		

		// Background Proxy
		public function get backgroundRadius():Number { return background.radius; }
		public function set backgroundRadius(radius:Number):void { background.radius = radius; }
		
		public function get backgroundColor():uint { return background.backgroundColor; }
		public function set backgroundColor(color:uint):void {
			background.backgroundColor = color;
			update();
		}		
		
		public function get borderThickness():Number { return background.borderThickness; }
		public function set borderThickness(thickness:Number):void {
			background.borderThickness = thickness;
			update();
		}		
		
		
		// This class acts as a transparent proxy to the content pane.
		// It should seem as though we're just manipulating the content pane directly.
		
		// Overrides to show true width.
		override public function get width():Number { return background.width; }
		override public function set width(value:Number):void { 
			_minWidth = value;
			_maxWidth = value;
			update();
		}
		
		override public function get height():Number { return background.height; }
		override public function set height(value:Number):void {
			_minHeight = value;
			_maxHeight = value;
			update();
		}

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
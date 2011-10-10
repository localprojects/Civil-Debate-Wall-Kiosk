package com.kitschpatrol.futil {
	
	import com.kitschpatrol.futil.constants.Alignment;
	
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	// Nested display object approach to registration management.
	
	// TODO Performance tests of this approach agains just iterating through
	// the display list and nudging and objects children one by one.
	// Are the overrides too ugly and a lot of overhead?
	
	// TODO what about translation point vs. registration point?
	// Just use TweenMax for translation point manipulations?

	
	public class BlockBase extends Sprite {
		
		// Hidden children keep things in alignment while presenting
		// a pure display object container elsewhere.
		internal var content:Sprite;
		internal var background:BlockShape; // note special block shape class for background and border
		private var registrationMarker:Shape;

		internal var _padding:Padding; // Padding, note convenience getters and setters for all, top/bottom, and left/right
		private var _alignmentPoint:Point; // the alignment of the content relative to the background (less padding)
		private var _registrationPoint:Point; // the origin of the block, normalized relative to the top left of the background
		private var _showRegistrationPoint:Boolean;
			
		// Padding mode
		private var  _paddingMode:String;
		public static const PADDING_INSIDE:String = "paddingIndside";
		public static const PADDING_OUTSIDE:String = "paddingOutside";
		
		
		// Size (padding is additive)
		internal var _maxSizeBehavior:String; // TODO scope to private?, implement!
		public static const MAX_SIZE_CLIPS:String = "maxSizeClips"; // masks off
		public static const MAX_SIZE_TRUNCATES:String = "maxSizeTruncates"; // ellipses or whatever
		public static const MAX_SIZE_OVERFLOWS:String = "maxSizeOverflows"; // nothing happen, text just sticks out
		public static const MAX_SIZE_BREAKS_LINE:String = "maxSizeBreaksLine"; // nothing happen, text just sticks out			
		
		internal var _minWidth:Number;
		internal var _minHeight:Number;
		internal var _maxWidth:Number;
		internal var _maxHeight:Number;
		
		private var _contentCrop:Padding;
		
		
		internal var lockUpdates:Boolean; // prevents update from firing... useful when queueing a bunch of changes // TODO getter and setter?		
			
	
		public function BlockBase(params:Object = null)	{
			//super();

			background = new BlockShape();
			super.addChild(background); // call super since the content sprite intercepts display list calls to .this
			
			content = new Sprite();
			super.addChild(content);

			registrationMarker = new Shape(); // TODO add for detecting rotation?
			registrationMarker.graphics.beginFill(0xff0000);
			registrationMarker.graphics.drawCircle(0, 0, 5);
			registrationMarker.graphics.endFill();			
			
			// Sensible defaults
			_padding = new Padding();
			_showRegistrationPoint = false;
			_registrationPoint = Alignment.TOP_LEFT;
			_alignmentPoint = Alignment.TOP_LEFT;
			_minWidth = 0;
			_minHeight = 0;
			_maxWidth = 1024; // Number.MAX_VALUE;
			_maxHeight = 768; // Number.MAX_VALUE;
			_maxSizeBehavior = MAX_SIZE_OVERFLOWS;
			_contentCrop = new Padding();
			_paddingMode = PADDING_INSIDE;
			
			// Other initializations
						
			
			// TODO devise and flip the update booleans (e.g. invalidate everything)

			// overwrites defaults and calls update
			setParams(params);
			
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
			}
			
			
			// update regardless
			update();
		}
		
		
		public function update(contentWidth:Number = -1, contentHeight:Number = -1):void {
			if (!lockUpdates) {
				
				// allow override of content width and height (for animation)
				if (contentWidth == -1) contentWidth = content.width;
				if (contentHeight == -1) contentHeight = content.height;
				
				
				if (_paddingMode == PADDING_OUTSIDE) {
					// only if needed
					background.width = Math2.clamp(contentWidth - _contentCrop.horizontal, _minWidth, _maxWidth + _padding.horizontal) + _padding.horizontal; // stretch max for padding
					background.height = Math2.clamp(contentHeight - _contentCrop.vertical, _minHeight, _maxHeight + _padding.vertical) + _padding.vertical;
				
					
					
					// Compensate for padding, which always accumulates on the outsize of the content
					content.x = -(_registrationPoint.x * (background.width - _padding.horizontal));
					content.y = -(_registrationPoint.y * (background.height - _padding.vertical));
					
					background.x = content.x - _padding.left;
					background.y = content.y - _padding.top;					
				}				
				else {
					// padding internal!
					
					// only if needed
					background.width = Math2.clamp(contentWidth - _contentCrop.horizontal + _padding.horizontal, _minWidth, _maxWidth); // do not stretch max for padding
					background.height = Math2.clamp(contentHeight - _contentCrop.vertical + _padding.vertical, _minHeight, _maxHeight);
					
					// Compensate for padding, which always accumulates on the outsize of the content
					content.x =  -(_registrationPoint.x * background.width) + _padding.left;
					content.y = -(_registrationPoint.y * background.height) + _padding.top;
					
					background.x = -(_registrationPoint.x * background.width);
					background.y = -(_registrationPoint.y * background.height);				
				}
				
  			
				
				// Align content
				content.x += _alignmentPoint.x * ((background.width - _padding.horizontal) - (contentWidth - _contentCrop.horizontal));
				content.y += _alignmentPoint.y * ((background.height - _padding.vertical) - (contentHeight - _contentCrop.vertical));
				
				// Crop if we need to
				content.x -= _contentCrop.left;
				content.y -= _contentCrop.top;
				
				// Hilite the content area for debug
//				content.graphics.clear();
//				content.graphics.beginFill(0xfff000);
//				content.graphics.drawRect(0, 0, content.width, content.height);
//				content.graphics.endFill();
				
			}
		}
		
		
		

		
		
		
		// Getters and Setters
		
		public function get showRegistrationPoint():Boolean { return _showRegistrationPoint; }
		public function set showRegistrationPoint(show:Boolean):void {
			_showRegistrationPoint = show;
			if (_showRegistrationPoint)
				super.addChild(registrationMarker);
			else
				super.removeChild(registrationMarker);
		}
		
		
		// registration point
		public function get registrationPoint():Point { return _registrationPoint };
		public function set registrationPoint(point:Point):void {
			var lastRegistrationPoint:Point = _registrationPoint;			
			_registrationPoint = point.clone();
			
			// nudge the parent to keep X and Y anchored globally
			// TODO move to update()?
			// TODO wrap in modal conditional?
			// TODO this accumulates rounding errors....
			x += (_registrationPoint.x - lastRegistrationPoint.x) * width;
			y += (_registrationPoint.y - lastRegistrationPoint.y) * height;
			
			update();
		}
		
		public function get registrationPointX():Number { return _registrationPoint.x; }
		public function set registrationPointX(value:Number):void {
			registrationPoint = new Point(value, _registrationPoint.y); 			
		}
		
		public function get registrationPointY():Number { return _registrationPoint.y; }
		public function set registrationPointY(value:Number):void {
			registrationPoint = new Point(_registrationPoint.x, value); 
		}		
				
		

		// Content alignment
		public function get alignmentPoint():Point { return _alignmentPoint; }
		public function set alignmentPoint(point:Point):void {
			trace("Set point to: " + point);
			_alignmentPoint = point.clone();
			update();
		}
		
		public function get alignmentPointX():Number { return _alignmentPoint.x; }
		public function set alignmentPointX(value:Number):void {
			_alignmentPoint.x = value;
			alignmentPoint = _alignmentPoint; 
		}
		
		public function get alignmentPointY():Number { return _alignmentPoint.y; }
		public function set alignmentPointY(value:Number):void {
			_alignmentPoint.y = value;
			alignmentPoint = _alignmentPoint; 
		}		
		
		

		// Size
		public function get minWidth():Number { return _minWidth; }
		public function set minWidth(width:Number):void {
			_minWidth = width;
			if (_minWidth > _maxWidth) _maxWidth = _minWidth; 
			update();
		}
		
		public function get minHeight():Number { return _minHeight; }
		public function set minHeight(height:Number):void {
			_minHeight = height;
			if (_minHeight > _maxHeight) _maxHeight = _minHeight;			
			update();
		}		
		
		public function get maxWidth():Number { return _maxWidth; }
		public function set maxWidth(width:Number):void {
			_maxWidth = width;
			if (_maxWidth < _minWidth) _minWidth = _maxWidth;
			update();
		}
		
		public function get maxHeight():Number { return _maxHeight; }
		public function set maxHeight(width:Number):void {
			_maxHeight = width;
			if (_maxHeight < _minHeight) _minHeight = _maxHeight;
			update();
		}		
		
		
		// TODO, implement, then tween plugin for this?
		public function get maxSizeBehavior():String { return _maxSizeBehavior; }
		public function set maxSizeBehavior(behavior:String):void {
			_maxSizeBehavior = behavior;
			update();
		}	
		
		
		// Mostly for dealing with sloppy text fields, this can make the content sprite
		// Appear smaller than it actually is to the background generator
		public function get contentCropTop():Number { return _contentCrop.top; }
		public function set contentCropTop(amount:Number):void {
			_contentCrop.top = amount;
			update();
		}
		
		public function get contentCropRight():Number { return _contentCrop.right; }
		public function set contentCropRight(amount:Number):void {
			_contentCrop.right = amount;
			update();
		}		
		
		public function get contentCropBottom():Number { return _contentCrop.bottom; }
		public function set contentCropBottom(amount:Number):void {
			_contentCrop.bottom = amount;
			update();
		}				
		
		public function get contentCropLeft():Number { return _contentCrop.left; }
		public function set contentCropLeft(amount:Number):void {
			_contentCrop.left = amount;
			update();
		}		
		
		
		// Padding Proxy
		// TODO tween plugin for this?
		public function get paddingTop():Number { return _padding.top; }
		public function set paddingTop(amount:Number):void {
			_padding.top = amount;
			update();
		}
		
		public function get paddingRight():Number { return _padding.right; }
		public function set paddingRight(amount:Number):void {
			_padding.right = amount;
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

		public function get padding():Number { return _padding.top;	} // TODO fix this, should really return object
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
		
		
		public function get borderColor():uint { return background.borderColor; }
		public function set borderColor(color:uint):void {
			background.borderColor = color;
			update();
		}				
		
		public function get borderThickness():Number { return background.borderThickness; }
		public function set borderThickness(thickness:Number):void {
			background.borderThickness = thickness;
			update();
		}		
		
		public function get showBorder():Boolean { return background.showBorder; }
		public function set showBorder(show:Boolean):void {
			background.showBorder = show;
			update();
		}				
		
		public function get paddingMOde():String { return _paddingMode; }
		public function set paddingMode(mode:String):void {
			_paddingMode = mode;
			update();
		}
		
		
		// This class acts as a transparent proxy to the content pane.
		// It should seem as though we're just manipulating the content pane directly.
		
		// Overrides to show true width.
		public function get contentWidth():Number { return content.width; }
		public function get contentHeight():Number { return content.height; }
		
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
		override public function addChild(child:DisplayObject):DisplayObject { return content.addChild(child);	}
		override public function addChildAt(child:DisplayObject, index:int):DisplayObject { return content.addChildAt(child, index); }
		override public function getChildAt(index:int):DisplayObject { return content.getChildAt(index);	} 
		override public function getChildByName(name:String):DisplayObject { return content.getChildByName(name);	}
		override public function getChildIndex(child:DisplayObject):int { return content.getChildIndex(child); }
		override public function removeChild(child:DisplayObject):DisplayObject { return content.removeChild(child); }
		override public function removeChildAt(index:int):DisplayObject { return content.removeChildAt(index); }
		override public function setChildIndex(child:DisplayObject, index:int):void { content.setChildIndex(child, index); }
		override public function swapChildren(child1:DisplayObject, child2:DisplayObject):void { content.swapChildren(child1, child2); }
		override public function swapChildrenAt(index1:int, index2:int):void { content.swapChildrenAt(index1, index2); }
	}
}
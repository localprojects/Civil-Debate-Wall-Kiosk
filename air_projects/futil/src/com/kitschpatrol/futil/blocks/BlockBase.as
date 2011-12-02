package com.kitschpatrol.futil.blocks {
	
	import com.greensock.TweenMax;
	import com.greensock.easing.Quart;
	import com.kitschpatrol.futil.Math2;
	import com.kitschpatrol.futil.constants.Alignment;
	import com.kitschpatrol.futil.utilitites.GraphicsUtil;
	import com.kitschpatrol.futil.utilitites.ObjectUtil;
	
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	import flash.utils.Timer;
	
	// Nested display object approach to registration management.
	
	// TODO Performance tests of this approach agains just iterating through
	// the display list and nudging and objects children one by one.
	// Are the overrides too ugly and a lot of overhead?
	
	// TODO what about translation point vs. registration point?
	// Just use TweenMax for translation point manipulations?

	
	public class BlockBase extends Sprite {
		
		
		// Hidden children keep things in alignment while presenting
		// a pure display object container elsewhere.
		protected var content:Sprite;
		public var background:BlockShape; // note special block shape class for background and border
		private var registrationMarker:Shape;

		internal var _padding:Padding; // Padding, note convenience getters and setters for all, top/bottom, and left/right
		private var _alignmentPoint:Point; // the alignment of the content relative to the background (less padding)
		private var _registrationPoint:Point; // the origin of the block, normalized relative to the top left of the background
		private var _showRegistrationPoint:Boolean;
		
		private var _scrollLimitMode:String;
		public static const SCROLL_LIMIT_AUTO:String = "scrollLimitAuto"; // scroll bounds are automatically set to show all content, but nothing more
		public static const SCROLL_LIMIT_MANUAL:String = "scrollLimitManual"; // user defines scroll limit
		internal var _minScrollX:Number;
		internal var _minScrollY:Number;
		internal var _maxScrollX:Number;
		internal var _maxScrollY:Number;
		
		// Size (padding is additive)
		internal var _maxSizeBehavior:String; // TODO scope to private?, implement!
		public static const MAX_SIZE_CLIPS:String = "maxSizeClips"; // masks off
		public static const MAX_SIZE_OVERFLOWS:String = "maxSizeOverflows"; // nothing happen, text just sticks out
					
		
		internal var _minWidth:Number;
		internal var _minHeight:Number;
		internal var _maxWidth:Number;
		internal var _maxHeight:Number;

		private var _contentCrop:Padding;
		
		
		private var _blockChildCounter:int = 0; // if we need to check the bounds for content cropping...
		
		// TODO?
		//private var _constrainScroll:Boolean; // whether or not we can scroll content beyond the boundaries of the container
		
		
		
		
		
		public var lockUpdates:Boolean; // prevents update from firing... useful when queueing a bunch of changes // TODO getter and setter?		
	
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
			_maxWidth = Number.MAX_VALUE;
			_maxHeight = Number.MAX_VALUE;
			_maxSizeBehavior = MAX_SIZE_OVERFLOWS;
			_contentCrop = new Padding();
			_scrollLimitMode = SCROLL_LIMIT_AUTO;
			_minScrollX = 0;
			_minScrollY = 0;
			_maxScrollX = 0; // will get redefined when switching to manual
			_maxScrollY = 0; // will get redefined when switching to manual
			active = false;			// for tween animation
			visible = false;				// for tween animation
			
			// Button stuff
			buttonTimer = new Timer(0);
			buttonTimer.addEventListener(TimerEvent.TIMER, onTimeout);
			
			onButtonDown = new Vector.<Function>(0);
			onButtonUp = new Vector.<Function>(0);
			onStageUp = new Vector.<Function>(0);
			onButtonLock = new Vector.<Function>(0);
			onButtonUnlock = new Vector.<Function>(0);
			onButtonCancel = new Vector.<Function>(0);
			onButtonOver = new Vector.<Function>(0);
			onButtonOut = new Vector.<Function>(0);
			
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
						//trace("Setting " + key + " to " + params[key]);
						this[key] = params[key];
					}
					else {
						throw new Error("NO SUCH PROPERTY: " + key + " on " + this);
						// TODO throw error. This is a big problem?
					}
				}
				
				lockUpdates = false;
			}
			update(); // update regardless
		}
		
		
		public function update(contentWidth:Number = -1, contentHeight:Number = -1):void {
			if (!lockUpdates) {
				
				// allow override of content width and height (for animation)
				if (contentWidth == -1) contentWidth = content.width;
				if (contentHeight == -1) contentHeight = content.height;
				

				// compensate for children with content crops... pretty unruly
				// problem with wrong background bounds for blocks with embedded block text blocks.
				if (_blockChildCounter > 0) {
					// find limits
					var minX:Number = Number.MAX_VALUE;
					var minY:Number = Number.MAX_VALUE;
					var maxX:Number = Number.MIN_VALUE;
					var maxY:Number = Number.MIN_VALUE;
					
					for (var i:int = 0; i < this.numChildren; i++) {
						var child:DisplayObject = this.getChildAt(i);
						// takes advantage of x, y, width and height override lies
						minX = Math.min(minX, child.x);
						minY = Math.min(minY, child.y);
						maxX = Math.max(maxX, child.x + child.width);
						maxY = Math.max(maxY, child.y + child.height);
					}
					
					// make the parent fit the child's image of themselves (with content cropping)
					contentWidth = maxX - minX;
					contentHeight = maxY - minY;						
				}
					
				background.width = Math2.clamp(contentWidth - _contentCrop.horizontal + _padding.horizontal, _minWidth, _maxWidth); // do not stretch max for padding
				background.height = Math2.clamp(contentHeight - _contentCrop.vertical + _padding.vertical, _minHeight, _maxHeight);
				
				// Compensate for padding, which always accumulates on the inside of the block
				content.x =  -(_registrationPoint.x * background.width) + _padding.left;
				content.y = -(_registrationPoint.y * background.height) + _padding.top;
				
				background.x = -(_registrationPoint.x * background.width);
				background.y = -(_registrationPoint.y * background.height);				
				
				
				// Align content
				content.x += _alignmentPoint.x * ((background.width - _padding.horizontal) - (contentWidth - _contentCrop.horizontal));
				content.y += _alignmentPoint.y * ((background.height - _padding.vertical) - (contentHeight - _contentCrop.vertical));
				
				
				// Crop if we need to
				content.x -= _contentCrop.left;
				content.y -= _contentCrop.top;
				
				// Update the mask if needed
				if (_maxSizeBehavior == BlockBase.MAX_SIZE_CLIPS) {
					clippingMask.x = background.x + _padding.left;
					clippingMask.y = background.y + _padding.top;
					clippingMask.width = background.width - _padding.horizontal;
					clippingMask.height = background.height - _padding.vertical;
				}
				
				// Hilite the content area for debug
				// content.graphics.clear();
				// content.graphics.beginFill(0xfff000);
				// content.graphics.drawRect(0, 0, content.width, content.height);
				// content.graphics.endFill();
				
				// if dimensions change, should update parent, too
				if (this.parent is BlockBase) (this.parent as BlockBase).update();
				
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
		
		public function get registrationX():Number { return _registrationPoint.x; }
		public function set registrationX(value:Number):void {
			registrationPoint = new Point(value, _registrationPoint.y); 			
		}
		
		public function get registrationY():Number { return _registrationPoint.y; }
		public function set registrationY(value:Number):void {
			registrationPoint = new Point(_registrationPoint.x, value); 
		}		

		// Content alignment within the container
		public function get alignmentPoint():Point { return _alignmentPoint; }
		public function set alignmentPoint(point:Point):void {
			_alignmentPoint = point.clone();
			update();
		}
		
		public function get alignmentX():Number { return _alignmentPoint.x; }
		public function set alignmentX(value:Number):void {
			_alignmentPoint.x = value;
			alignmentPoint = _alignmentPoint; 
		}
		
		public function get alignmentY():Number { return _alignmentPoint.y; }
		public function set alignmentY(value:Number):void {
			_alignmentPoint.y = value;
			alignmentPoint = _alignmentPoint; 
		}
		
		// scrolling is a different way of thinking about the alignment point
		public function set scrollLimitMode(mode:String):void {
			if (mode == SCROLL_LIMIT_MANUAL) {
				_minScrollX = 0;
				_minScrollY = 0;
				_maxScrollX = maxScrollX;
				_maxScrollY = maxScrollY;
			}
			
			_scrollLimitMode = mode;
		}
		
		public function get scrollLimitMode():String {
			return _scrollLimitMode;
		}
		
		public function get scrollX():Number {
			return (contentWidth - (background.width - _padding.horizontal)) * _alignmentPoint.x;
		}
		
		public function set scrollX(pixels:Number):void { 			
			alignmentX = pixels / (contentWidth - (background.width - _padding.horizontal));			
		}
		
		public function get minScrollX():Number {
			if (scrollLimitMode == SCROLL_LIMIT_AUTO) {			
				return 0;
			}
			else if (scrollLimitMode == SCROLL_LIMIT_MANUAL) {
				return _minScrollX; 
			}
			return 0;
		}
		
		public function set minScrollX(limit:Number):void {
				_minScrollX = limit; 
		}


		public function get maxScrollX():Number {
			if (scrollLimitMode == SCROLL_LIMIT_AUTO) {			
				return (contentWidth - (background.width - _padding.horizontal));
			}
			else if (scrollLimitMode == SCROLL_LIMIT_MANUAL) {
				return _maxScrollX; 
			}
			return 0;
		}
		
		public function set maxScrollX(limit:Number):void {
			_maxScrollX = limit;
		}		
		
		
		
		public function get scrollY():Number {
			return (contentHeight - (background.height - _padding.vertical)) * _alignmentPoint.y;
		}
		
		public function set scrollY(pixels:Number):void { 			
			
//			trace("pixels: " + pixels);
//			// check for divide by zero, can't scroll something with zero height
//			trace("height: " + (contentHeight - (background.height - _padding.vertical)));
				if ((contentHeight - (background.height - _padding.vertical)) > 0) {
					alignmentY = pixels / (contentHeight - (background.height - _padding.vertical));
				}
				else {
					alignmentY = pixels / ((contentHeight - (background.height - _padding.vertical) + 1));					
				}
		}		
		
		public function get minScrollY():Number {
			if (scrollLimitMode == SCROLL_LIMIT_AUTO) {			
				return 0;
			}
			else if (scrollLimitMode == SCROLL_LIMIT_MANUAL) {
				return _minScrollY; 
			}
			return 0;
		}
		
		public function set minScrollY(limit:Number):void {
			_minScrollY = limit; 
		}
		
		
		public function get isOverflowY():Boolean {
			if (scrollLimitMode == SCROLL_LIMIT_MANUAL) return true;			
			return (contentHeight > (background.height - _padding.vertical));
		}
		
		public function get isOverflowX():Boolean {
			if (scrollLimitMode == SCROLL_LIMIT_MANUAL) return true;
			return (contentWidth > (background.width - _padding.horizontal));
		}		
		
		public function get maxScrollY():Number {
			if (scrollLimitMode == SCROLL_LIMIT_AUTO) {			
				return (contentHeight - (background.height - _padding.vertical));
			}
			else if (scrollLimitMode == SCROLL_LIMIT_MANUAL) {
				return _maxScrollY; 
			}
			return 0;
		}
		
		public function set maxScrollY(limit:Number):void {
			_maxScrollY = limit;
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
		
		
		protected var clippingMask:Shape;
		
		// TODO, implement, then tween plugin for this?
		public function get maxSizeBehavior():String { return _maxSizeBehavior; }
		public function set maxSizeBehavior(behavior:String):void {
			_maxSizeBehavior = behavior;
			
			if (_maxSizeBehavior == MAX_SIZE_CLIPS) {
				// add the mask
				clippingMask = GraphicsUtil.shapeFromSize(10, 10);
				super.addChild(clippingMask);
				content.mask = clippingMask;
			}
			else {
				if (clippingMask != null && super.contains(clippingMask)) super.removeChild(clippingMask);
			}
			
			update();
		}	
		
		
		// Mostly for dealing with sloppy text fields, this can make the content sprite
		// Appear smaller than it actually is to the background generator
		// Would it be better to just manually define a bounds rect?
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
		public function get backgroundRadiusTopLeft():Number { return background.radiusTopLeft; }
		public function set backgroundRadiusTopLeft(radius:Number):void { background.radiusTopLeft = radius; }
		public function get backgroundRadiusTopRight():Number { return background.radiusTopRight; }
		public function set backgroundRadiusTopRight(radius:Number):void { background.radiusTopRight = radius; }
		public function get backgroundRadiusBottomLeft():Number { return background.radiusBottomLeft; }
		public function set backgroundRadiusBottomLeft(radius:Number):void { background.radiusBottomLeft = radius; }
		public function get backgroundRadiusBottomRight():Number { return background.radiusBottomRight; }
		public function set backgroundRadiusBottomRight(radius:Number):void { background.radiusBottomRight = radius; }		
		
		
		public function get backgroundColor():uint { return background.backgroundColor; }
		public function set backgroundColor(color:uint):void {
			background.backgroundColor = color;
			update();
		}
		
		public function get backgroundAlpha():Number { return background.backgroundAlpha; }
		public function set backgroundAlpha(a:Number):void {
			background.backgroundAlpha = a;
			update();
		}
		
		public function get showBackground():Boolean { return background.showBackground; }
		public function set showBackground(show:Boolean):void {
			background.showBackground = show;
			update();
		}
		
		public function get borderColor():uint { return background.borderColor; }
		public function set borderColor(color:uint):void {
			background.borderColor = color;
			update();
		}				
		
		public function get borderAlpha():Number { return background.borderAlpha; }
		public function set borderAlpha(a:Number):void {
			background.borderAlpha = a;
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
		

		// Convenience
		public function get left():Number { return x; }
		public function get top():Number { return y; }
		public function get right():Number { return x + width; }
		public function get bottom():Number { return y + height; }		
		
		
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
		
		
		
		// Interaction
		
		// Enable button mode by setting buttonMode = true
		// Then, push functions onto the callback vectors
		
		// toggle?
		
		public var onButtonDown:Vector.<Function>;
		public var onButtonUp:Vector.<Function>;
		public var onStageUp:Vector.<Function>;
		public var onButtonLock:Vector.<Function>;
		public var onButtonUnlock:Vector.<Function>;
		public var onButtonCancel:Vector.<Function>; // useful for inertial scroll fields
		public var onButtonOver:Vector.<Function>;
		public var onButtonOut:Vector.<Function>;		
		
		
		protected var buttonTimer:Timer;
		public var locked:Boolean;
		protected var tempEvent:Event;
		
		// Register events
		override public function get buttonMode():Boolean {
			return super.buttonMode;
		}
		
		override public function set buttonMode(value:Boolean):void {
			super.buttonMode = value;
			
			if (buttonMode) {
				// enable listeners
				this.addEventListener(MouseEvent.MOUSE_DOWN, onButtonDownInternal);
				this.addEventListener(MouseEvent.MOUSE_UP, onButtonUpInternal);
				this.addEventListener(MouseEvent.MOUSE_OVER, onButtonOverInternal);
				this.addEventListener(MouseEvent.MOUSE_OUT, onButtonOutInternal);	
								
			}
			else {
				// disable listeners
				this.removeEventListener(MouseEvent.MOUSE_DOWN, onButtonDownInternal);
				this.removeEventListener(MouseEvent.MOUSE_UP, onButtonUpInternal);	
				this.removeEventListener(MouseEvent.MOUSE_OVER, onButtonOverInternal);
				this.removeEventListener(MouseEvent.MOUSE_OUT, onButtonOutInternal);	
			}
		}
		
		public function get buttonTimeout():Number {
			return buttonTimer.delay;
		}
		
		public function set buttonTimeout(time:Number):void {
			buttonTimer.delay = time;
			buttonTimer.reset();
			buttonTimer.stop();
		}
		
		override public function get mouseEnabled():Boolean {
			return super.mouseEnabled;
		}
		
		override public function set mouseEnabled(enabled:Boolean):void {
			super.mouseEnabled = enabled;
			
			if (!super.mouseEnabled) {
				executeAll(onButtonCancel);
			}
		}
		
		// useful for cancelling events after mouse down
		// note that it just gets added again on the next mouse down event
		public function removeStageUpListener():void {
			stage.removeEventListener(MouseEvent.MOUSE_UP, onStageUpInternal);			
		}
		
		private function onButtonDownInternal(e:MouseEvent):void {
			tempEvent = e;
			
			if (!locked) {
				stage.addEventListener(MouseEvent.MOUSE_UP, onStageUpInternal);
				executeAll(onButtonDown);
			}
		}
		
		private function onButtonUpInternal(e:MouseEvent):void {
			tempEvent = e;

			if (!locked) {
				// Stage always fires, and this fires first, so we handle lock in there.				
				executeAll(onButtonUp);
			}

		}
		
		private function onButtonOverInternal(e:MouseEvent):void {
			tempEvent = e;
			
			if (!locked) {
				
				executeAll(onButtonOver);
			}
		}
		
		
		private function onButtonOutInternal(e:MouseEvent):void {
						
			executeAll(onButtonOut);
		}
		
		
		private function onStageUpInternal(e:MouseEvent):void {
			tempEvent = e;
			
			// note mouse enabled check! useful for blocking clickthrough in inertial scroll fields
			if (!locked && mouseEnabled) {
				stage.removeEventListener(MouseEvent.MOUSE_UP, onStageUpInternal);
				
				executeAll(onStageUp);
				
				if (buttonTimeout > 0) {
					locked = true;
					buttonTimer.reset();
					buttonTimer.start();
					executeAll(onButtonLock);
				}							
				
			}			
		}
		
		private function onTimeout(e:TimerEvent):void {
			//trace('button back!');
			unlock();
		}
		
		public function lock():void {
			locked = true;
			executeAll(onButtonLock);			
		}
		
		public function unlock():void {
			//trace("Button unlocked");
			locked = false;
			buttonTimer.stop();
			executeAll(onButtonUnlock);
		}
		
		
		// Calls each function in a vector
		public function executeAll(functions:Vector.<Function>):void {
			for (var i:int = 0; i < functions.length; i++) {
				functions[i](tempEvent);
			}			
		}
		
		
		// handy for tweening
		public function get scale():Number {
			return scaleX;
		}
		public function set scale(value:Number):void {
			scaleX = value;
			scaleY = value;
		}
		
		
		
		
		// Overrides to proxy out container.
		// make sure everything updates after the content changes
		override public function addChild(child:DisplayObject):DisplayObject {
			if (child is BlockBase) _blockChildCounter++; // keep track of child blocks so we can recalculate bounds based on their contentcrop values 
			var added:DisplayObject = content.addChild(child);
			update();
			return added;
		}
		
		override public function addChildAt(child:DisplayObject, index:int):DisplayObject {
			if (child is BlockBase) _blockChildCounter++;			
			var added:DisplayObject = content.addChildAt(child, index);
			update();
			return added;
		}
		
		override public function get numChildren():int { return content.numChildren; }
		override public function getChildAt(index:int):DisplayObject { return content.getChildAt(index);	} 
		override public function getChildByName(name:String):DisplayObject { return content.getChildByName(name);	}
		override public function getChildIndex(child:DisplayObject):int { return content.getChildIndex(child); }
		
		override public function removeChild(child:DisplayObject):DisplayObject {
			if (child is BlockBase) _blockChildCounter--;			
			var removed:DisplayObject = content.removeChild(child);
			update();
			return removed;
		}
		
		override public function removeChildAt(index:int):DisplayObject {
			if (index is BlockBase) _blockChildCounter--;			
			var removed:DisplayObject = content.removeChildAt(index);
			update();
			return removed;
		}
		
		override public function setChildIndex(child:DisplayObject, index:int):void { content.setChildIndex(child, index); }
		override public function swapChildren(child1:DisplayObject, child2:DisplayObject):void { content.swapChildren(child1, child2); }
		override public function swapChildrenAt(index1:int, index2:int):void { content.swapChildrenAt(index1, index2); }

		//-------------
		
		// Animation stuff for CDW... this breaks Futil's the tween engine agnostic approach  
		// Multiple inheritance sure would be nice...
		// Defining stuff here is ugly, but keeps it out of the constructors
		private var defaultTweenVars:Object = {}; // temp turn off cache as bitmap...might fix twitching
		private var defaultTweenInVars:Object = ObjectUtil.mergeObjects(defaultTweenVars, {ease: Quart.easeOut, onInit: beforeTweenIn, onComplete: afterTweenIn});
		private var defaultTweenOutVars:Object = ObjectUtil.mergeObjects(defaultTweenVars, {ease: Quart.easeOut, onInit: beforeTweenOut, onComplete: afterTweenOut});
		private var defaultDuration:Number = 1;
		private var defaultInDuration:Number = defaultDuration;
		private var defaultOutDuration:Number = 0.75;
		public var active:Boolean;
		
		private var theTweenIn:TweenMax;
		private var theTweenOut:TweenMax;
		
		public function setDefaultTweenIn(duration:Number, params:Object):void {
			defaultInDuration = duration;
			defaultTweenInVars = ObjectUtil.mergeObjects(defaultTweenInVars, params);
		}
		
		public function setDefaultTweenOut(duration:Number, params:Object):void {
			defaultOutDuration = duration;
			defaultTweenOutVars = ObjectUtil.mergeObjects(defaultTweenOutVars, params);
		}				
		
		// A little tweening abstraction... sets overridable default parameters
		// manages visibility / invisibility
		protected function beforeTweenIn():void {
			this.visible = true;
			this.mouseEnabled = true;
			this.mouseChildren = true;			
		}
		
		protected function afterTweenIn():void {
			// override me
		}		
		
		protected function beforeTweenOut():void {
			// override me
			this.mouseEnabled = false;
			this.mouseChildren = false;			
		}
		
		protected function afterTweenOut():void {
			this.visible = false;
			
			// restore position so overriden out tweens restart from their canonical location
			defaultTweenOutVars.onComplete = null;
			
			TweenMax.to(this, 0, defaultTweenOutVars); // note that we have to preprocess again othwerise it will try to tween to the name shortcuts
			defaultTweenOutVars.onComplete = afterTweenOut;
		}		
		
		public function tween(duration:Number, params:Object):void {
			TweenMax.to(this, duration, ObjectUtil.mergeObjects(defaultTweenVars, params));
			active = true;
		}
		
		// Tweens to default location, or takes modifiers if called without arguments
		public function tweenIn(duration:Number = -1, params:Object = null):void {
			// THIS TRIES TO FIX THE MISSING BLOCK PROBLEM!!! // IT WORKS!s
			//TweenMax.killTweensOf(this); // stop tweening out if we're tweening out, keeps afterTweenOut from firing...
			if (theTweenOut != null) theTweenOut.kill(); // try to be kinder and gentler
			
			active = true;
			
			if (duration == -1) duration = defaultInDuration;
			if (params == null) params = defaultTweenInVars;
			else params = ObjectUtil.mergeObjects(defaultTweenInVars, params);
			
			theTweenIn = TweenMax.to(this, duration, params);
		}		
		
		public function tweenOut(duration:Number = -1, params:Object = null):void {
			if (duration == -1)	duration = defaultOutDuration;
			if (params == null)	params = defaultTweenOutVars;
			else params = ObjectUtil.mergeObjects(defaultTweenOutVars, params);
			
			theTweenOut = TweenMax.to(this, duration, params);
			active = true; // TODO WHY WAS THIS FALSE?
		}
		
		
		// to do, call these automatically?
//		public function markAllInactive():void {
//			// marks all FIRST LEVEL blocks as inactive
//			for (var i:int = 0; i < this.numChildren; i++) {				
//				if (this.getChildAt(i) is BlockBase) {				
//					(this.getChildAt(i) as BlockBase).active = false;
//				}
//			}
//		}
//		
//		public function tweenOutInactive(instant:Boolean = false):void {	
//			for (var i:int = 0; i < this.numChildren; i++) {
//				if ((this.getChildAt(i) is BlockBase) && !(this.getChildAt(i) as BlockBase).active) {
//					if (instant)
//						(this.getChildAt(i) as BlockBase).tweenOut(0);
//					else
//						(this.getChildAt(i) as BlockBase).tweenOut();
//				}
//			}		
//		}		
		
		
	}
}
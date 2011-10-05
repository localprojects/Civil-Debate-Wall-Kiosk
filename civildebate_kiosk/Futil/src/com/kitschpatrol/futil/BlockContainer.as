package com.kitschpatrol.futil {

	import flash.display.CapsStyle;
	import flash.display.DisplayObject;
	import flash.display.JointStyle;
	import flash.display.LineScaleMode;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Matrix;
	import flash.geom.Point;
	
	public class BlockContainer extends BlockBase {
		

		private var _padding:Padding; // Padding, note convenience getters and setters for all, top/bottom, and left/right
		// private var paddingChanged:Boolean; // TODO flags to speed up the draw call?
				
		// Background
		private var background:Shape;		
		private var _showBackground:Boolean;
		private var _backgroundColor:uint;
		private var _paddingColor:uint;
		private var _backgroundRadius:Number;
		private var changedBackground:Boolean;

		
		// Border
		private var border:Shape;		
		private var _showBorder:Boolean;
		private var _borderColor:uint;
		private var _borderThickness:Number; // pixels
		private var _borderRadius:Number;
		// padding, etc.
		

		// PADDING internal vs external?
		


			
			// CHANGE this to POINT? move it to nesttest?
		// normalized, where to pin the content relative to the container ("0" is all the way to the left, "1" is all the way to the right)
		private var _contentOffsetNormalX:Number; // getters and setters for these!
		private var _contentOffsetNormalY:Number;

		// keep track of offset (combines padding and cenering offsets)
		protected var contentOffsetX:Number;
		private var lastContentOffsetX:Number;
		protected var contentOffsetY:Number;
		private var lastContentOffsetY:Number;		
				
	//	internal var lockUpdates:Boolean; // prevents update from firing... useful when queueing a bunch of changes // TODO getter and setter?
		

		
		public function BlockContainer(params:Object = null)	{
			super();
			
			background = new Shape();			
			addChild(background);
			changedBackground = true;
			lastBackgroundWidth = 0;
			lastBackgroundHeight = 0;			
			
			border = new Shape();
			addChild(border);
			
			
			// Defaults Settings
			// Padding
			_padding = new Padding();
			_paddingColor = 0x00000000; // starts transparent
			
		
			
			// Content alignment (top left by default) // TODO change to point
			_contentOffsetNormalX = 0;
			_contentOffsetNormalY = 0;
			lastContentOffsetX = 0;
			lastContentOffsetY = 0;
			
			// Background
			_backgroundColor = 0xcccccc;
			_showBackground = true;
			_backgroundRadius = 0;

			
			// Border
			_borderColor = 0x000000;
			_showBorder = false;
			_borderThickness = 5;

			// call set vars on constructor input
			setParams(params);
		}
		
		
		// set a bunch of fields at once
		override public function setParams(params:Object):void {
			if(params != null) {
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

		// split update and draw? (e.g. for color changes?)
		
		
			
		
		
		override internal function update():void {
			if (!lockUpdates) {
				trace("container update");
	
				// clear background to measure foreground content
				//if (_showBackground) background.visible = false;
				//if (_showBorder) border.visible = false;

				background.graphics.clear();
				border.graphics.clear();
				
				// TODO scope these to the class?
				var contentWidth:Number = this.width;
				var contentHeight:Number = this.height;

				

	
				// Calculate offset due to padding and content alignment
				
				trace(contentWidth);
				
				contentOffsetX = _padding.left + ((backgroundWidth - contentWidth) * _contentOffsetNormalX);
				contentOffsetY = _padding.right + ((backgroundHeight - contentHeight) * _contentOffsetNormalY);
				
				// Then add padding to background
				backgroundWidth += _padding.horizontal;
				backgroundHeight += _padding.vertical;				
				
				trace(contentOffsetX);
		
				// Apply changes in offset, but only if we have to
				if ((contentOffsetX != lastContentOffsetX) || (contentOffsetY != lastContentOffsetY)) {
					var backgroundIndex:int = getChildIndex(this.background);
					var borderIndex:int = getChildIndex(this.border);				
					// optimization issue?
					// skip 1, it's always the background?
					// or set skip index when we add / remove children instead?
					
					for (var i:int = 0; i < this.numChildren; i++) {
						if (i != backgroundIndex && i != borderIndex) {
							this.getChildAt(i).x -= lastContentOffsetX;
							this.getChildAt(i).x += contentOffsetX;
							this.getChildAt(i).y -= lastContentOffsetY;
							this.getChildAt(i).y += contentOffsetY;						
							// getting rounding errorors if i don't do these a la carte	// weird.
						}				
					}
					
					lastContentOffsetX = contentOffsetX;
					lastContentOffsetY = contentOffsetY;
				}
				
				
				// ====== TODO Split into separate draw method here? =======
				
				
				// Updates over! Now draw.
				changedBackground = ((backgroundWidth != lastBackgroundWidth) || (backgroundHeight != lastBackgroundHeight));				
				
				changedBackground = true;
				
				if (_showBackground) background.visible = true;	
				if (_showBorder) border.visible = true;
				
				if (changedBackground) {
					drawBackground();
					drawBorder();
				}				
			
				updateOrigin();
				
				lastBackgroundHeight = backgroundHeight;
				lastBackgroundWidth = backgroundWidth;				
				
//
//				originMarker.x = 0;
//				originMarker.y = 0;
//				addChild(originMarker);
			}
			else {
				//trace("Update prevented by lock.");
			}
		}
		
		
		// Draws the background, but doesn't update dimensions. Good for color changes.
		private function drawBackground():void {
			background.graphics.clear();
			background.graphics.beginFill(_backgroundColor);
			
			// Curved or rectangular.
			if (_backgroundRadius > 0)
				background.graphics.drawRoundRect(0, 0, backgroundWidth, backgroundHeight, _backgroundRadius * 2, _backgroundRadius * 2);				
			else	
				background.graphics.drawRect(0, 0, backgroundWidth, backgroundHeight);
					
			background.graphics.endFill();
					
			// Optionally hilite the padding region in a different color.
			// But only if it's alpha is greater than 0. By default, alpha is 0 so padding color is effectively disabled. 
			if (((_paddingColor >>> 24) > 0) && (_paddingColor != _backgroundColor)) {
			 background.graphics.beginFill(_backgroundColor);
			 background.graphics.drawRect(0, 0, backgroundWidth, _padding.top);
			 background.graphics.drawRect(0, _padding.top, _padding.left, backgroundHeight - _padding.top - _padding.bottom);
			 background.graphics.drawRect(backgroundWidth - _padding.left, _padding.top, _padding.right, backgroundHeight- _padding.top - _padding.bottom);
			 background.graphics.drawRect(0, backgroundHeight - _padding.top, backgroundWidth, _padding.bottom);			
			 background.graphics.endFill();
			}
		}
		
		// Draws the border, but doesn't update dimensions. Good for color changes and border thickness changes.
		private function drawBorder():void {
			border.graphics.clear();
			border.x = _borderThickness / 2;
			border.y = _borderThickness / 2;
			
			// TODO, best settings here?
			border.graphics.lineStyle(_borderThickness, _borderColor, 1, false, LineScaleMode.NORMAL, CapsStyle.NONE, JointStyle.MITER);		
			
			if (_backgroundRadius > 0) {
				var borderRadiusCoefficient:Number = (backgroundWidth - _borderThickness * 2) / backgroundWidth;
				trace("borderRadiusCoefficient: " + borderRadiusCoefficient);
				var borderRadius:Number = _backgroundRadius * 2 * borderRadiusCoefficient * borderRadiusCoefficient;
				
				// TODO really get this right... background shows through sometimes
				borderRadius = Math.max(0, Math.floor((_backgroundRadius * 2) - _borderThickness));
				border.graphics.drawRoundRect(0, 0, backgroundWidth - _borderThickness, backgroundHeight - _borderThickness, borderRadius, borderRadius);				
			}
			else {
				border.graphics.drawRect(0, 0, backgroundWidth - _borderThickness, backgroundHeight - _borderThickness);				
			}
			
		}
		


		// override with vertex list based backgeround!
		
		
		// Background Proxy
		

		
		public function get showBackground():Boolean { return _showBackground; }
		public function set showBackground(show:Boolean):void {
			_showBackground = show;
			background.visible = _showBackground;
		}
		
		// Border Accessors
		public function get borderThickness():Number { return _borderThickness; }
		public function set borderThickness(thickness:Number):void {
			_borderThickness = thickness;
			
			// Just redraw the border, no need to update.
			// Borders are always internal, so they don't change bounding box.
			drawBorder();
		}
		
		public function get borderColor():uint { return _borderColor; }
		public function set borderColor(color:uint):void {
			_borderColor = color;
			drawBorder();
		}
		
		public function get showBorder():Boolean { return _showBorder; }
		public function set showBorder(show:Boolean):void {
			_showBorder = show;
			border.visible = _showBorder;
		}

		

		
		

		
		
		

		// TODO MOVE content alignment to NestTest?
		
		// Content offset accessors, note weird normalized implementation
		// TODO pixel implementation? just X and y?
		public function get contentOffsetNormalX():Number { return _contentOffsetNormalX; }
		public function set contentOffsetNormalX(offset:Number):void {
			_contentOffsetNormalX = offset;
			update();
		}
		
		public function get contentOffsetNormalY():Number { return _contentOffsetNormalY; }
		public function set contentOffsetNormalY(offset:Number):void {
			_contentOffsetNormalY = offset;
			update();
		}
		
		// point convenience
		public function get contentOffsetNormal():Point { return new Point(_contentOffsetNormalX, _contentOffsetNormalY); }
		public function set contentOffsetNormal(point:Point):void {
			_contentOffsetNormalX = point.x;
			_contentOffsetNormalY = point.y;
			update();
		}				
		
		

		

		
	}

}
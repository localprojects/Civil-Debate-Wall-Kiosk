package com.kitschpatrol.futil.blocks {
	import flash.display.BitmapData;
	import flash.display.CapsStyle;
	import flash.display.JointStyle;
	import flash.display.LineScaleMode;
	import flash.display.Shape;
	import flash.display.Sprite;
	
	// for background
	public class BlockShape extends Sprite {
		
		// Shape
		private var _width:Number;
		private var _height:Number;
		private var _radiusTopLeft:Number;
		private var _radiusTopRight:Number;
		private var _radiusBottomRight:Number;
		private var _radiusBottomLeft:Number;
				
		
		// Background
		private var _backgroundColor:uint;
		private var _showBackground:Boolean;
		private var _backgroundImage:BitmapData;
		private var _backgroundAlpha:Number;
		
		// Border
		private var _borderColor:uint;
		private var _borderAlpha:Number;
		private var _borderThickness:Number;
		private var _showBorder:Boolean;
		
		// Constructor
		public function BlockShape()	{
			super();
			
			// Sensible defaults
			_width = 0;
			_height = 0;
			_radiusTopLeft = 0;
			_radiusTopRight = 0;
			_radiusBottomRight = 0;
			_radiusBottomLeft = 0;
			_backgroundColor = 0x000000;
			_backgroundAlpha = 1.0;
			_showBackground = true;
			_borderColor = 0x00ff00;
			_borderAlpha = 1.0;
			_borderThickness = 5;
			_showBorder = false;
			
			update();
		}
		
		private function update():void {
			graphics.clear();			

			// Background
			if (_showBackground) {
				
				if (_backgroundImage != null) {
					graphics.beginBitmapFill(_backgroundImage, null, true, true);
				}
				else {
					graphics.beginFill(_backgroundColor, _backgroundAlpha);
				}
				
				if ((_radiusTopLeft > 0) || (_radiusTopRight > 0) || (_radiusBottomRight > 0) || (_radiusBottomLeft > 0)) {
					graphics.drawRoundRectComplex(0, 0, _width, _height, _radiusTopLeft, _radiusTopRight, _radiusBottomLeft, _radiusBottomRight);
				}
				else {
					graphics.drawRect(0, 0, _width, _height);
				}
				
				graphics.endFill();
			}
			
			// Border
			if (_showBorder) {
				graphics.lineStyle(_borderThickness, _borderColor, _borderAlpha, false, LineScaleMode.NORMAL, CapsStyle.NONE, JointStyle.MITER);		
				
				if ((_radiusTopLeft > 0) || (_radiusTopRight > 0) || (_radiusBottomRight > 0) || (_radiusBottomLeft > 0)) {
					var borderRadiusCoefficient:Number = (_width - _borderThickness * 2) / _width;
					
					var borderRadiusTopLeft:Number = _radiusTopLeft * 1 * borderRadiusCoefficient * borderRadiusCoefficient;
					var borderRadiusTopRight:Number = _radiusTopRight * 1 * borderRadiusCoefficient * borderRadiusCoefficient;
					var borderRadiusBottomRight:Number = _radiusBottomRight * 1 * borderRadiusCoefficient * borderRadiusCoefficient;
					var borderRadiusBottomLeft:Number = _radiusBottomLeft * 1 * borderRadiusCoefficient * borderRadiusCoefficient;
					
					// TODO really get this right... background shows through sometimes
					borderRadiusTopLeft = Math.max(0, Math.floor((_radiusTopLeft * 1) - _borderThickness));
					borderRadiusTopRight = Math.max(0, Math.floor((_radiusTopRight * 1) - _borderThickness));
					borderRadiusBottomRight = Math.max(0, Math.floor((_radiusBottomRight * 1) - _borderThickness));
					borderRadiusBottomLeft = Math.max(0, Math.floor((_radiusBottomLeft * 1) - _borderThickness));
					
					graphics.drawRoundRectComplex(_borderThickness / 2, _borderThickness / 2, _width - _borderThickness, _height - _borderThickness, borderRadiusTopLeft, borderRadiusTopRight, borderRadiusBottomLeft, borderRadiusBottomRight);
				}
				else {
					graphics.drawRect(_borderThickness / 2, _borderThickness / 2, _width - _borderThickness, _height - _borderThickness);				
				}
			}
						
			// Alternate block fill approach. Radiused corners looked too thick.
			// if (_showBorder) {
			// 	graphics.beginFill(_borderColor);
			// 	
			// 	if (_radius > 0) {
			// 		graphics.drawRoundRect(_borderThickness, _borderThickness, _width - _borderThickness * 2, _height - _borderThickness * 2, _radius * 2 - 1, _radius * 2 - 1);				
			// 	}
			// 	else {
			// 		graphics.drawRect(_borderThickness, _borderThickness, _width - _borderThickness * 2, _height - _borderThickness * 2);				
			// 	}
			// 	
			// 	graphics.endFill();
			// }
		}
		
		// Background Manipulation
		public function get radius():Number { return _radiusTopLeft; }
		public function set radius(radius:Number):void {
			_radiusTopLeft = radius;
			_radiusTopRight = radius;
			_radiusBottomRight = radius;
			_radiusBottomLeft = radius;
			update();
		}
		
		public function get radiusTopLeft():Number { return _radiusTopLeft; }
		public function set radiusTopLeft(radius:Number):void {
			_radiusTopLeft = radius;
			update();
		}
		
		public function get radiusTopRight():Number { return _radiusTopRight; }
		public function set radiusTopRight(radius:Number):void {
			_radiusTopRight= radius;
			update();
		}	
		
		public function get radiusBottomRight():Number { return _radiusBottomRight; }
		public function set radiusBottomRight(radius:Number):void {
			_radiusBottomRight= radius;
			update();
		}			
		
		public function get radiusBottomLeft():Number { return _radiusBottomLeft; }
		public function set radiusBottomLeft(radius:Number):void {
			_radiusBottomLeft = radius;
			update();
		}
		
		public function get backgroundColor():uint { return _backgroundColor; }
		public function set backgroundColor(color:uint):void {
			_backgroundColor = color;
			update();
		}
		
		public function get backgroundAlpha():Number { return _backgroundAlpha; }
		public function set backgroundAlpha(a:Number):void {
			_backgroundAlpha = a;
			update();
		}		
		
		
		public function get backgroundImage():BitmapData { return _backgroundImage; }
		public function set backgroundImage(image:BitmapData):void {
			_backgroundImage = image;
			update();
		}
		
		
		// generic accessor
		public function get background():* { 
			return (_backgroundImage != null) ? _backgroundImage : _backgroundColor;
		}
		public function set background(colorOrImage:*):void {
			if (colorOrImage is BitmapData)
				_backgroundImage = colorOrImage;
			else if (colorOrImage is uint)
				_backgroundColor = colorOrImage;
			else
				throw new Error("Invalid argument type. Background can only take BitmapData or uint types.");
		}
		
		
		
		public function get borderColor():uint { return _borderColor; }
		public function set borderColor(color:uint):void {
			_borderColor = color;
			update();
		}
		
		public function get borderAlpha():Number { return _borderAlpha; }
		public function set borderAlpha(a:Number):void {
			_borderAlpha = a;
			update();
		}				
		
		public function get showBackground():Boolean { return _showBackground; }
		public function set showBackground(show:Boolean):void {
			_showBackground = show;
			update();
		}
		
		public function get showBorder():Boolean { return _showBorder; }
		public function set showBorder(show:Boolean):void {
			_showBorder = show;
			update();
		}
		
		public function get borderThickness():Number { return _borderThickness; }
		public function set borderThickness(thickness:Number):void {
			_borderThickness = thickness;
			update();
		}
		
		// Redraw to scale.
		override public function get width():Number { return _width; }
		override public function set width(value:Number):void {
			_width = value;
			update();
		}
		
		override public function get height():Number { return _height; }
		override public function set height(value:Number):void {
			_height = value;
			update();
		}
	}
}
package com.civildebatewall {
	import com.greensock.*;
	
	import flash.display.*;
	import flash.filters.*;
	
	// like a bitmap, but with integrated tweaks for brightness, contrast, etc.
	public class BitmapPlus extends Bitmap {
		
		private var _tintColor:uint = 0xffffff; // 0x000000 – 0xffffff
		private var _tintAmount:Number = 0; // TODO range?
		private var _contrast:Number = 1; // TODO range?
		private var _brightness:Number = 1; // TODO range?
		private var _saturation:Number = 1; // TODO range?
		private var _blur:Number = 0; // TODO range?
		private var blurFilter:BlurFilter; // TODO range?		
		
		public function BitmapPlus(bitmapData:BitmapData=null, pixelSnapping:String="auto", smoothing:Boolean=false) {
			super(bitmapData, pixelSnapping, smoothing);
		}
		
		private function updateColor():void {
			// use tween max for colorization because it's handy, not because we need to tween
			TweenMax.to(this, 0, {colorMatrixFilter:{colorize: _tintColor, amount: _tintAmount, contrast: _contrast, brightness: _brightness, saturation: _saturation}});			
		}
		
		public function get tintColor():uint {
			return _tintColor;
		}
		
		public function set tintColor(color:uint):void {
			_tintColor = color;
			updateColor();			
		}
		
		public function get tintAmount():Number {
			return _tintAmount;
			updateColor();			
		}
		
		public function set tintAmount(amount:Number):void {
			_tintAmount = amount;
		}
		
		public function get contrast():Number {
			return _contrast;
		}
		
		public function set contrast(level:Number):void {
			_contrast = level;
			updateColor();
		}
		
		public function get brightness():Number {
			return _brightness;
		}
		
		public function set brightness(level:Number):void {
			_brightness = level;
			updateColor();			
		}
		
		public function get saturation():Number {
			return _saturation;
		}
		
		public function set saturation(level:Number):void {
			_saturation = level;
			updateColor();			
		}
		
		public function get blur():Number {
			return _blur;
		}
		
		public function set blur(level:Number):void {
			// make sure it's changed and that it's greater than 0
			if ((_blur != level) && (level > 0)) {
				_blur = level;
				blurFilter = new BlurFilter(_blur, _blur, 1);				
				this.filters = [blurFilter];
			}
			
		}		
	}
}
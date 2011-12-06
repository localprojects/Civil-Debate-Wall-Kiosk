package com.civildebatewall.wallsaver.elements {
	import com.civildebatewall.Assets;
	import com.greensock.TweenMax;
	import com.kitschpatrol.futil.blocks.BlockShape;
	import com.kitschpatrol.futil.utilitites.BitmapUtil;
	import com.kitschpatrol.futil.utilitites.NumberUtil;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	
	
	public class GridPortrait extends Sprite {

		private var portrait:Bitmap;
		private var background:BlockShape;		
		private var _step:Number;
		
		public function GridPortrait(stance:String, portrait:Bitmap)	{
			
			
			this.portrait = BitmapUtil.scaleToFill(portrait, 233, 311);
			
			_step = 0;			
			
			
			// tint the portrait based on stance
			background = new BlockShape();
			background.width = 233;
			background.height = 311;
			
			if (stance == "yes") {
				background.backgroundColor = Assets.COLOR_YES_MEDIUM;
			}			
			else {
				background.backgroundColor = Assets.COLOR_NO_MEDIUM;
			}
			
			TweenMax.to(this.portrait, 0, {colorMatrixFilter:{colorize: background.backgroundColor, amount:0.8, contrast:1.3, brightness:1.4, saturation:0}});			
				
			addChild(background);
			addChild(this.portrait);
		}
		
		
		// normalized animation abstraction
		public function get step():Number { return _step; }
		public function set step(value:Number):void {
			// make it steppy
			
//			if (value % .2 == 0) {
//				_step = value;
//			}
			
//			if (value > 0.8)  {
//				_step = 1;
//			}
//			else if (value < 0.2) {
//				_step = 0;
//			}
//			if (Math.abs(value - _step) >= .2) {
//				_step = value;
//			}
			
			_step = NumberUtil.quantizeInclusive(value, 0.2);
//			
			
			
			//MonsterDebugger.trace(this, "step: " + _step + " value: " + value); 
//			MonsterDebugger.trace(this, "step: " + step);
//			MonsterDebugger.trace(this, "value: " + value);
			
			// 0 to .5, fade in background
			background.alpha = _step * 2;
				
			// .5 to 1, fade in portrait
		 portrait.alpha = (_step * 2) - 1;
		}
		
		
		
	}
}		
package com.civildebatewall.wallsaver.elements {
	import com.kitschpatrol.futil.TextBlock;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	
	import mx.states.AddChild;
	
	
	public class OpinionBanner extends TextBlock {


		public var stance:String;
		
		public function OpinionBanner(quote:String, stance:String) {
			this.stance = stance;
			
			super({text: quote,
				paddingTop: 54,
				paddingLeft: 97,
				paddingRight: 97,
				textSizePixels: 117,
				textColor: 0xffffff,
				height: 240});
			
			if (stance == "yes") {
				backgroundColor = Assets.COLOR_YES_LIGHT;
			}
			else {
				backgroundColor = Assets.COLOR_NO_LIGHT;				
			}
			
			this.cacheAsBitmap = true;
			
		}
	}
}
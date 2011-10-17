package com.civildebatewall.wallsaver.elements {
	import com.civildebatewall.resources.Assets;
	import com.kitschpatrol.futil.TextBlock;
	
	public class OpinionBanner extends TextBlock {
		
		public var stance:String;
		
		
		public function OpinionBanner(quote:String, stance:String) {
			this.stance = stance;
			
			// Scale kludge to avoid textfield max width weirdness
			super({text: quote,
						 textFont: Assets.FONT_BOLD,
						 maxWidth: Number.MAX_VALUE,
						 paddingTop: 34 / 4,
						 paddingLeft: 97 / 4,
						 paddingRight: 97 / 4,
						 textSizePixels: 140 / 4,
						 textColor: 0xffffff,
						 height: 247 / 4});
			
			this.scaleX = 4;
			this.scaleY = 4;
			
			if (stance == "yes") {
				backgroundColor = Assets.COLOR_YES_LIGHT;
			}
			else {
				backgroundColor = Assets.COLOR_NO_LIGHT;				
			}
			
			this.cacheAsBitmap = true; // helps?
		}
		
		
	}
}
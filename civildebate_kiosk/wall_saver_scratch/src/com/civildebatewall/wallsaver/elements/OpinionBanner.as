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
						 paddingTop: 34 / 2,
						 paddingLeft: 97 / 2,
						 paddingRight: 97 / 2,
						 textSizePixels: 140 / 2,
						 textColor: 0xffffff,
						 height: 247 / 2});
			
			this.scaleX = 2;
			this.scaleY = 2;
			
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
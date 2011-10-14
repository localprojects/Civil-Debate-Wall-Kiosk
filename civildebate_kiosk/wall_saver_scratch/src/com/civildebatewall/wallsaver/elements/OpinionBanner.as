package com.civildebatewall.wallsaver.elements {
	import com.civildebatewall.resources.Assets;
	import com.kitschpatrol.futil.TextBlock;
	
	public class OpinionBanner extends TextBlock {
		
		public var stance:String;
		
		
		public function OpinionBanner(quote:String, stance:String) {
			this.stance = stance;
			
			super({text: quote,
						 textFont: Assets.FONT_BOLD,
						 paddingTop: 34,
						 paddingLeft: 97,
						 paddingRight: 97,
						 textSizePixels: 140,
						 textColor: 0xffffff,
						 height: 247});
			
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
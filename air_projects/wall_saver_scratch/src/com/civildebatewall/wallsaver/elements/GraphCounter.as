package com.civildebatewall.wallsaver.elements {
	import com.civildebatewall.resources.Assets;
	import com.kitschpatrol.futil.blocks.BlockText;
	import com.kitschpatrol.futil.constants.Alignment;
	import com.kitschpatrol.futil.constants.Char;
	
	public class GraphCounter extends BlockText {
		
		public function GraphCounter() {
			super({
				text: "0",
				textColor: 0xffffff,
				textFont: Assets.FONT_BOLD,
				sizeFactorGlyphs: Char.SET_OF_NUMBERS,															 
				textSize: 225,
				alignmentPoint: Alignment.CENTER,																 
				showBackground: false,
				textAlignmentMode: Alignment.TEXT_CENTER,
				width: 702,
				visible: true
			});
		}
		
		public function get count():Number {
			return parseInt(text);
		}
		
		public function set count(value:Number):void {
			text = Math.round(value).toString();
		}
		
	}
}
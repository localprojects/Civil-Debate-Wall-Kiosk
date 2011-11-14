package com.civildebatewall.wallsaver.elements {
	import com.civildebatewall.resources.Assets;
	import com.kitschpatrol.futil.blocks.BlockText;
	import com.kitschpatrol.futil.constants.Alignment;
	import com.kitschpatrol.futil.constants.Char;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	
	import flashx.textLayout.formats.TextAlign;
	
	
	public class GraphLabel extends Sprite {
		
		private var stanceText:Bitmap;
		private var countText:BlockText;
		private var _count:int;
		
		public function GraphLabel(stance:String) {
			super();
			
			// bitmap label text
			if (stance == "yes") {
				stanceText = Assets.getGraphLabelYes();
			}
			else {
				stanceText = Assets.getGraphLabelNo();
			}
			
			
			addChild(stanceText);
			
			// vote counter
			countText = new BlockText({
				text: "0",
				textColor: 0xffffff,
				textFont: Assets.FONT_BOLD,
				sizeFactorGlyphs: Char.SET_OF_NUMBERS,															 
				textSize: 225,
				alignmentPoint: Alignment.CENTER,																 
				showBackground: false,
				textAlignmentMode: TextAlign.CENTER,
				width: stanceText.width,
				y: stanceText.height + 90,
				visible: true
			});
			
			addChild(countText);			 
		}
		
		public function get count():Number { return _count; }
		public function set count(value:Number):void {
			_count = value;
			countText.text = _count.toString();
		}
		
	}
}
package com.civildebatewall.wallsaver.elements {
	import com.bit101.components.Text;
	import com.kitschpatrol.futil.TextBlock;
	import com.kitschpatrol.futil.constants.Alignment;
	import com.kitschpatrol.futil.constants.CharacterSet;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	
	import flashx.textLayout.formats.BackgroundColor;
	import flashx.textLayout.formats.TextAlign;
	import com.civildebatewall.resources.Assets;
	
	
	public class GraphLabel extends Sprite {
		
		
		private var stanceText:Bitmap;
		private var countText:TextBlock;
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
			countText = new TextBlock({text: "0",
																 textColor: 0xffffff,
																 sizeFactorGlyphs: CharacterSet.SET_OF_NUMBERS,															 
																 textSizePixels: 225,
																 alignmentPoint: Alignment.CENTER,																 
																 showBackground: false,
																 textAlignmentMode: TextAlign.CENTER,
																 width: stanceText.width,
																 y: stanceText.height + 90});
			
			addChild(countText);			 
		}
		
		public function get count():Number { return _count; }
		public function set count(value:Number):void {
			_count = value;
			countText.text = _count.toString();
		}
		
	}
}
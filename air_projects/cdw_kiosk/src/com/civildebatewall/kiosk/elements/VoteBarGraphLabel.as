package com.civildebatewall.kiosk.elements {
	import com.civildebatewall.Assets;
	import com.kitschpatrol.futil.blocks.BlockText;
	import com.kitschpatrol.futil.constants.Alignment;
	import com.kitschpatrol.futil.constants.Char;
	import com.kitschpatrol.futil.utilitites.GraphicsUtil;
	
	import flash.display.Bitmap;
	import flash.display.Shape;
	import flash.display.Sprite;

	public class VoteBarGraphLabel extends Sprite {
		
		public var maxScale:Number;
		public var minScale:Number;
		
		private var label:Bitmap;
		private var divider:Shape;
		private var counter:BlockText;
		
		private var _votes:int;
		
		public function VoteBarGraphLabel(label:Bitmap) {
			super();

			maxScale = 1;
			minScale = 13 / 23;			
			_votes = 0;

			// "Yes" or "No" text label
			this.label = label;
			addChild(label);

			// Dividing line
			divider = GraphicsUtil.shapeFromSize(label.width, 1, 0xFFFFFF);
			divider.y = 33;
			addChild(divider);
			
			// Numeric counter
			counter = new BlockText({
				width: label.width,
				height: 23,
				sizeFactorGlyphs: Char.SET_OF_NUMBERS,
				textFont: Assets.FONT_BOLD,
				textBold: true,
				textColor: 0xFFFFFF,
				showBackground: false,
				textAlignmentMode: Alignment.TEXT_CENTER,
				textSize: 23, 
				text: _votes.toString(),
				y: 44,
				visible: true
			});
			addChild(counter);
		}
		
		public function set votes(value:int):void {
			_votes = value;
			counter.text = _votes.toString();
		}
		
		public function get votes():int {
			return _votes;
		}
		
	}
}
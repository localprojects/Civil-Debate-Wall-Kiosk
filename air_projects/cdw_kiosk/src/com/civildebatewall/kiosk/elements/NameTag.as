package com.civildebatewall.kiosk.elements {

	import com.civildebatewall.Assets;
	
	import com.kitschpatrol.futil.blocks.BlockText;
	import com.kitschpatrol.futil.blocks.Padding;
	import com.kitschpatrol.futil.constants.Alignment;
	
	import flash.display.Bitmap;
	import flash.text.*;

	
	public class NameTag extends BlockText {
		
		public function NameTag() {
			super({
				text: 'Name',
				textFont: Assets.FONT_BOLD,
				textBold: true,
				textSize: 30,
				textColor: 0xffffff,
				backgroundColor: 0x000000,
				minWidth: 100,
				maxWidth: 880,
				paddingTop: 25,
				paddingLeft: 35,
				paddingRight: 35,				
				height: 78
			});

		}
		
	}
}
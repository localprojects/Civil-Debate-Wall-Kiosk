package com.civildebatewall.wallsaver.elements {
	import com.civildebatewall.Assets;
	import com.kitschpatrol.futil.blocks.BlockText;
	import com.kitschpatrol.futil.constants.Alignment;
	
	import flash.text.TextFormatAlign;
	
	public class JoinButton extends BlockText {
		public function JoinButton(params:Object=null) {

			// TODO add button functionality
			super({
				text: "JOIN THE DEBATE. TOUCH TO BEGIN.",
				backgroundColor: Assets.COLOR_GRAY_85,
				textFont: Assets.FONT_BOLD,
				textSize: 17,
				textColor: 0xffffff,
				backgroundRadius: 11,																		
				width: 590,
				height: 63,
				textAlignmentMode: TextFormatAlign.CENTER,
				registrationPoint: Alignment.BOTTOM_RIGHT,
				alignmentPoint: Alignment.CENTER,
				visible: true
			});
			
		}
	}
}
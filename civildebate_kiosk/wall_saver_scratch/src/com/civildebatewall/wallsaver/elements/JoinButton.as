package com.civildebatewall.wallsaver.elements {
	import com.kitschpatrol.futil.TextBlock;
	import com.kitschpatrol.futil.constants.Alignment;
	import flash.text.TextFormatAlign;
	
	public class JoinButton extends TextBlock {
		public function JoinButton(params:Object=null) {
			
			// TODO Create a new interactive class that extends TextBlock?			
			// TODO interaction
			
			super({
				text: "JOIN THE DEBATE. TOUCH TO BEGIN",
				backgroundColor: Assets.COLOR_GRAY_85,
				textSizePixels: 17,
				textColor: 0xffffff,
				backgroundRadius: 11,																		
				width: 590,
				height: 63,
				textAlignmentMode: TextFormatAlign.CENTER,
				registrationPoint: Alignment.BOTTOM_RIGHT,
				alignmentPoint: Alignment.CENTER			
			});
			
			
		}
	}
}
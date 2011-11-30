package com.civildebatewall.wallsaver.elements {
	import com.civildebatewall.Assets;
	import com.civildebatewall.CivilDebateWall;
	import com.greensock.TweenMax;
	import com.kitschpatrol.futil.blocks.BlockText;
	import com.kitschpatrol.futil.constants.Alignment;
	
	import flash.events.MouseEvent;
	import flash.text.TextFormatAlign;
	

	
	public class JoinButton extends BlockText {
		
		private var downBackgroundColor:uint; // alternates based on scree
		
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
				visible: true,
				buttonMode: true				
			});
			
			downBackgroundColor = ((CivilDebateWall.flashSpan.settings.thisScreen.id % 2) == 0) ? Assets.COLOR_YES_DARK : Assets.COLOR_NO_DARK;
			
			onButtonDown.push(onDown);
			onStageUp.push(onUp);
		}
		
		private function onDown(e:MouseEvent):void {
			TweenMax.to(this, 0, {backgroundColor: downBackgroundColor});
		}
		
		private function onUp(e:MouseEvent):void {
			TweenMax.to(this, 0.5, {backgroundColor: Assets.COLOR_GRAY_85});
			CivilDebateWall.flashSpan.stop(); // fades everything out
		}
		
		
	}
}
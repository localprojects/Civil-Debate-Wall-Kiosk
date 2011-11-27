package com.civildebatewall.kiosk.buttons {
	import com.civildebatewall.Assets;
	import com.civildebatewall.CivilDebateWall;
	import com.greensock.TweenMax;
	import com.kitschpatrol.futil.blocks.BlockText;
	import com.kitschpatrol.futil.constants.Alignment;
	import com.kitschpatrol.futil.utilitites.ColorUtil;
	
	import flash.events.MouseEvent;
	
	import flashx.textLayout.formats.TextAlign;
	
	public class RespondButton extends BlockText {
		
		public function RespondButton(params:Object=null) {
			super({
				buttonMode: true,
				text: "RESPOND TO THE QUESTION",
				textFont: Assets.FONT_BOLD,
				textBold: true,
				textSize: 18,
				letterSpacing: -1,
				textColor: ColorUtil.gray(77),
				backgroundColor: 0xffffff,
				textAlignmentMode: TextAlign.CENTER,
				width: 397,
				height: 143,
				backgroundRadius: 20,
				alignmentPoint: Alignment.CENTER
			});
			
			onButtonDown.push(onDown);
			onStageUp.push(onUp);
		}
		
		private function onDown(e:MouseEvent):void {
			backgroundColor = ColorUtil.gray(77);
			textColor = 0xffffff;
		}
		
		private function onUp(e:MouseEvent):void {
			TweenMax.to(this, 0.5, {backgroundColor: 0xffffff, textColor: ColorUtil.gray(77)});
			
			CivilDebateWall.state.userIsDebating = false;
			CivilDebateWall.state.setView(CivilDebateWall.kiosk.view.debateStancePickerView);
		}
		
	}
}
package com.civildebatewall.staging.elements {
	import com.civildebatewall.Assets;
	import com.civildebatewall.CivilDebateWall;
	import com.greensock.TweenMax;
	import com.kitschpatrol.futil.blocks.BlockText;
	import com.kitschpatrol.futil.constants.Alignment;
	import com.kitschpatrol.futil.utilitites.ColorUtil;
	
	import flash.events.MouseEvent;
	
	import flashx.textLayout.formats.TextAlign;
	
		public class SubmitButton extends BlockText	{
			
			
			public function SubmitButton(params:Object=null) {
				super({
					buttonMode: true,
					textFont: Assets.FONT_BOLD,
					textBold: true,
					textSize: 24,
					textColor: ColorUtil.gray(77),
					backgroundColor: 0xffffff,
					textAlignmentMode: TextAlign.CENTER,
					width: 432,
					height: 142,
					backgroundRadius: 13,
					alignmentPoint: Alignment.CENTER,
					text: "SUBMIT"
				});
				
				onButtonDown.push(onDown);
				onButtonUp.push(onUp);
			}
			
			private function onDown(e:MouseEvent):void {
				TweenMax.to(this, 0, {backgroundColor: ColorUtil.gray(77), textColor: 0xffffff});			
			}
			
			private function onUp(e:MouseEvent):void {
				TweenMax.to(this, 0.5, {backgroundColor: 0xffffff, textColor: ColorUtil.gray(77)});
				// Validation and processing handled in OpinionEntryOverlay
			}			
	}
}
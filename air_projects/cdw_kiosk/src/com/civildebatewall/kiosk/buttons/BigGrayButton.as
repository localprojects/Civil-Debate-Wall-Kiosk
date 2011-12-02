package com.civildebatewall.kiosk.buttons {
	import com.civildebatewall.Assets;
	import com.civildebatewall.CivilDebateWall;
	import com.greensock.TweenMax;
	import com.kitschpatrol.futil.blocks.BlockText;
	import com.kitschpatrol.futil.constants.Alignment;
	import com.kitschpatrol.futil.utilitites.ColorUtil;
	
	import flash.events.MouseEvent;
	
		public class BigGrayButton extends BlockText	{
			
			
			public function BigGrayButton(params:Object=null) {
				super({
					buttonMode: true,
					textFont: Assets.FONT_BOLD,
					textBold: true,
					textSize: 24,
					textColor: ColorUtil.gray(77),
					backgroundColor: 0xffffff,
					textAlignmentMode: Alignment.TEXT_CENTER,
					width: 432,
					height: 142,
					backgroundRadius: 13,
					alignmentPoint: Alignment.CENTER,
					text: "SUBMIT"
				});
				
				onButtonDown.push(onDown);
				onStageUp.push(onUp);
				onButtonCancel.push(onCancel);
			}
			
			private function onDown(e:MouseEvent):void {
				drawDown();			
			}
			
			private function onUp(e:MouseEvent):void {
				drawUp();
				// Validation and processing handled in OpinionEntryOverlay
			}
			
			private function onCancel(e:MouseEvent):void {
				removeStageUpListener();
				drawUp();
			}
			
			private function drawUp():void {
				TweenMax.to(this, 0.5, {backgroundColor: 0xffffff, textColor: ColorUtil.gray(77)});
			}
			
			private function drawDown():void {
				TweenMax.to(this, 0.5, {backgroundColor: ColorUtil.gray(77), textColor: 0xffffff});
			}
			
			
			
	}
}
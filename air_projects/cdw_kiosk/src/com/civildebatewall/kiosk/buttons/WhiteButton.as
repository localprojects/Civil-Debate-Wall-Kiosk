package com.civildebatewall.kiosk.buttons {
	import com.civildebatewall.Assets;
	import com.greensock.TweenMax;
	import com.kitschpatrol.futil.blocks.BlockText;
	import com.kitschpatrol.futil.constants.Alignment;
	import com.kitschpatrol.futil.utilitites.ColorUtil;
	
	import flash.events.MouseEvent;
	import flash.ui.Mouse;
	
	public class WhiteButton extends BlockText {

		public function WhiteButton(params:Object=null) {
			super({
				buttonMode: true,
				textFont: Assets.FONT_BOLD,
				textBold: true,
				textSize: 18,
				textColor: ColorUtil.gray(77),
				backgroundColor: 0xffffff,
				textAlignmentMode: Alignment.TEXT_CENTER,
				backgroundRadius: 8,
				alignmentPoint: Alignment.CENTER
			});
			
			onButtonDown.push(onDown);
			onStageUp.push(onUp);
			onButtonCancel.push(onCancel);
			
			setParams(params)	;
		}
		
		private function onDown(e:MouseEvent):void {
			TweenMax.to(this, 0, {backgroundColor: ColorUtil.gray(77), textColor: 0xffffff});			
		}
		
		private function onUp(e:MouseEvent):void {
			TweenMax.to(this, 0.5, {backgroundColor: 0xffffff, textColor: ColorUtil.gray(77)});
		}
		
		private function onCancel(e:MouseEvent):void {
			removeStageUpListener();
			TweenMax.to(this, 0.5, {backgroundColor: 0xffffff, textColor: ColorUtil.gray(77)});
		}
	}
}
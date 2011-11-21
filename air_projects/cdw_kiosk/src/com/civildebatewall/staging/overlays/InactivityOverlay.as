package com.civildebatewall.staging.overlays {
	import com.civildebatewall.Assets;
	import com.civildebatewall.CivilDebateWall;
	import com.civildebatewall.Utilities;
	import com.civildebatewall.kiosk.elements.ProgressBar;
	import com.civildebatewall.staging.elements.BigGrayButton;
	import com.greensock.TweenMax;
	import com.kitschpatrol.futil.blocks.BlockBase;
	import com.kitschpatrol.futil.blocks.BlockText;
	import com.kitschpatrol.futil.constants.Alignment;
	import com.kitschpatrol.futil.utilitites.ColorUtil;
	
	import flash.events.MouseEvent;
	
	import flashx.textLayout.formats.TextAlign;
	
	public class InactivityOverlay extends BlockBase {
		
		private var timerBar:ProgressBar;		
		private var yesButton:BigGrayButton;
		private var message:BlockText;		
		
		public function InactivityOverlay(params:Object = null)	{
			
			super({
				backgroundColor: 0x000000,
				width: 1080,
				height: 1920,
				backgroundAlpha: 0
			});
			
			yesButton = new BigGrayButton();
			yesButton.width = 880;
			yesButton.text = "YES!";
			yesButton.y = 1060;			
			yesButton.setDefaultTweenIn(1, {x: 100});
			yesButton.setDefaultTweenOut(1, {x: Alignment.OFF_STAGE_LEFT});	
			addChild(yesButton);
			
			// text set on tween in
			message = new BlockText({
				width: 880,
				height: 64,
				text: "ARE YOU STILL THERE?",
				backgroundColor: 0xffffff,
				textAlignmentMode: TextAlign.CENTER,
				textFont: Assets.FONT_BOLD,
				textBold: true,
				textSize: 18,
				textColor: ColorUtil.gray(77),
				alignmentPoint: Alignment.CENTER
			});
			message.x = 100;		
			
			message.setDefaultTweenIn(1, {y: 982});
			message.setDefaultTweenOut(1, {y: Alignment.OFF_STAGE_TOP});
			addChild(message);
			
			timerBar = new ProgressBar({width: 880, height: 10, duration: 10});
			timerBar.x = 100;
			timerBar.setDefaultTweenIn(1, {x: 100, y: 964});
			timerBar.setDefaultTweenOut(1, {x: 100, y: Alignment.OFF_STAGE_TOP});
			timerBar.onProgressComplete.push(goHome);
			addChild(timerBar);
			
			yesButton.onButtonUp.push(closeOverlay);
		}
		
		private function goHome(...args):void {
			closeOverlay();			
			CivilDebateWall.kiosk.view.homeView();
		}
		
		private function closeOverlay(...args):void {
			timerBar.pause();
			CivilDebateWall.kiosk.view.removeInactivityOverlayView();
		}
		
		override protected function beforeTweenIn():void {
			super.beforeTweenIn();
		}
		
		override protected function afterTweenIn():void {
			TweenMax.to(this, 1, {backgroundAlpha: 0.85});
			timerBar.tweenIn();
			yesButton.tweenIn();
			message.tweenIn();
			
			super.afterTweenIn();
		}
		
		override protected function beforeTweenOut():void {
			TweenMax.to(this, 1, {backgroundAlpha: 0});			
			timerBar.tweenOut();					
			yesButton.tweenOut();			
			message.tweenOut();			
			
			super.beforeTweenOut();
		}		
		
	}
}
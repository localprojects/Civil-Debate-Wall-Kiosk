package com.civildebatewall.kiosk.overlays {

	import com.civildebatewall.Assets;
	import com.civildebatewall.CivilDebateWall;
	import com.civildebatewall.kiosk.buttons.BigGrayButton;
	import com.civildebatewall.kiosk.elements.ProgressBar;
	import com.greensock.TweenMax;
	import com.kitschpatrol.futil.blocks.BlockBase;
	import com.kitschpatrol.futil.blocks.BlockText;
	import com.kitschpatrol.futil.constants.Alignment;
	import com.kitschpatrol.futil.utilitites.ColorUtil;
	
	import flash.events.Event;
	
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
			
			yesButton = new BigGrayButton(Assets.getBigYes());
			yesButton.width = 880;
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
				textAlignmentMode: Alignment.TEXT_CENTER,
				textFont: Assets.FONT_BOLD,
				textBold: true,
				textSize: 18,
				textColor: ColorUtil.gray(77),
				alignmentPoint: Alignment.CENTER
			});
			message.x = 100;		
			
			message.setDefaultTweenIn(1, {y: 982});
			message.setDefaultTweenOut(1, {y: Alignment.OFF_STAGE_LEFT});
			addChild(message);
			
			timerBar = new ProgressBar({width: 880, height: 1, duration: CivilDebateWall.settings.presenceCountdownTime});
			timerBar.x = 100;
			timerBar.setDefaultTweenIn(1, {x: 100, y: 964});
			timerBar.setDefaultTweenOut(1, {x: 100, y: Alignment.OFF_STAGE_TOP});
			timerBar.onProgressComplete.push(userMissing);
			addChild(timerBar);
			
			yesButton.onButtonUp.push(userPresent);
		}
		
		private function userMissing(...args):void {
			// time is up
			timerBar.pause();
			CivilDebateWall.state.setView(CivilDebateWall.kiosk.homeView);			
		}
		
		private function userPresent(...args):void {
			// user confirmed they're still there
			timerBar.pause();
			CivilDebateWall.state.goBack();
			CivilDebateWall.userActivityMonitor.onActivity(new Event(Event.ACTIVATE)); // reset the inactivity timer
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
package com.civildebatewall.kiosk.overlays {

	import com.civildebatewall.Assets;
	import com.civildebatewall.CivilDebateWall;
	import com.civildebatewall.data.containers.Post;
	import com.civildebatewall.kiosk.buttons.BigGrayButton;
	import com.civildebatewall.kiosk.elements.ProgressBar;
	import com.greensock.TweenMax;
	import com.kitschpatrol.futil.blocks.BlockBase;
	import com.kitschpatrol.futil.blocks.BlockText;
	import com.kitschpatrol.futil.constants.Alignment;
	import com.kitschpatrol.futil.utilitites.ColorUtil;
	
	import flash.events.MouseEvent;
	
	public class FlagOverlay extends BlockBase	{
		
		private var timerBar:ProgressBar;
		private var yesButton:BigGrayButton;
		private var noButton:BigGrayButton;
		private var message:BlockText;
		public var targetPost:Post;
		
		public function FlagOverlay(params:Object = null)	{
			
			super({
				backgroundColor: 0x000000,
				width: 1080,
				height: 1920,
				backgroundAlpha: 0
			});
			
			yesButton = new BigGrayButton(Assets.getBigYes());
			yesButton.y = 1060;			
			yesButton.setDefaultTweenIn(1, {x: 100});
			yesButton.setDefaultTweenOut(1, {x: Alignment.OFF_STAGE_LEFT});	
			addChild(yesButton);
			
			noButton = new BigGrayButton(Assets.getBigNo());
			noButton.y = 1060;			
			noButton.setDefaultTweenIn(1, {x: 547});
			noButton.setDefaultTweenOut(1, {x: Alignment.OFF_STAGE_RIGHT});	
			addChild(noButton);
			
			// text set on tween in
			message = new BlockText({
				width: 880,
				height: 64,
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
			message.setDefaultTweenOut(1, {y: Alignment.OFF_STAGE_TOP});
			addChild(message);

			timerBar = new ProgressBar({width: 880, height: 1, duration: 10});
			timerBar.x = 100;
			timerBar.setDefaultTweenIn(1, {x: 100, y: 964});
			timerBar.setDefaultTweenOut(1, {x: 100, y: Alignment.OFF_STAGE_TOP});
			timerBar.onProgressComplete.push(closeOverlay);
			
			addChild(timerBar);
			
			// actions
			noButton.onButtonUp.push(closeOverlay);
			yesButton.onButtonUp.push(flagItem);
		}
		
		private function closeOverlay(...args):void {
			timerBar.pause();
			CivilDebateWall.kiosk.removeFlagOverlayView();
		}
		
		private function flagItem(e:MouseEvent):void {			
			CivilDebateWall.data.flag(targetPost);

			TweenMax.to(message, 1, {text: "FLAGGED FOR REVIEW. WE WILL LOOK INTO IT."});			
			yesButton.tweenOut();
			noButton.tweenOut();
			
			// fade out the bar
			timerBar.pause();
			TweenMax.to(timerBar, 1, {alpha: 0});
			
			// after delay, go back
			TweenMax.delayedCall(3, closeOverlay);			
		}
		
		override protected function beforeTweenIn():void {
			message.text = "FLAG AS INAPPROPRIATE?";
			TweenMax.to(timerBar, 0, {alpha: 1});
			super.beforeTweenIn();
		}
		
		override protected function afterTweenIn():void {
			TweenMax.to(this, 1, {backgroundAlpha: 0.85});
			timerBar.tweenIn();
			noButton.tweenIn();
			yesButton.tweenIn();
			message.tweenIn();
			
			super.afterTweenIn();
		}
		
		override protected function beforeTweenOut():void {
			TweenMax.to(this, 1, {backgroundAlpha: 0});			
			timerBar.tweenOut();			
			noButton.tweenOut();			
			yesButton.tweenOut();			
			message.tweenOut();			
			
			super.beforeTweenOut();
		}
		
	}
}
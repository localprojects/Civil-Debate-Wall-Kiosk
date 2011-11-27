package com.civildebatewall.kiosk.buttons {
	import com.civildebatewall.Assets;
	import com.civildebatewall.CivilDebateWall;
	import com.greensock.TweenMax;
	import com.kitschpatrol.futil.blocks.BlockText;
	import com.kitschpatrol.futil.constants.Alignment;
	
	import flash.events.MouseEvent;

	
	public class BigBackButton extends BlockText	{
		
		public function BigBackButton() {
			super({
				buttonMode: true,
				text: "BACK TO HOME SCREEN",
				textFont: Assets.FONT_BOLD,
				textBold: true,
				textSize: 25,
				textColor: 0xffffff,
				textAlignmentMode: Alignment.TEXT_CENTER,
				width: 1024,
				height: 65,
				backgroundRadius: 12,
				alignmentPoint: Alignment.CENTER
			});
			
			onButtonDown.push(onDown);
			onStageUp.push(onUp);
		}
		
		override protected function beforeTweenIn():void {
			backgroundColor = CivilDebateWall.state.activeThread.firstPost.stanceColorMedium;
			super.beforeTweenIn();
		}
		
		private function onDown(e:MouseEvent):void {
			backgroundColor = CivilDebateWall.state.activeThread.firstPost.stanceColorDark;
		}
		
		private function onUp(e:MouseEvent):void {
			TweenMax.to(this, 0.5, {backgroundColor: CivilDebateWall.state.activeThread.firstPost.stanceColorMedium});
			CivilDebateWall.state.setView(CivilDebateWall.kiosk.view.homeView); // TODO dynamically go back to stats as well?
		}			
	}
}
package com.civildebatewall.kiosk.ui {
	import com.civildebatewall.Assets;
	import com.civildebatewall.CivilDebateWall;
	import com.greensock.TweenMax;
	import com.kitschpatrol.futil.blocks.BlockText;
	import com.kitschpatrol.futil.constants.Alignment;
	
	import flash.display.Bitmap;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import flashx.textLayout.formats.TextAlign;
	
	
	
	
	public class LowerMenuButton extends BlockText	{
	
		private var icon:Bitmap;
		
		public function LowerMenuButton() {
			super({
				buttonMode: true,
				text: "Lower Menu",
				textFont: Assets.FONT_BOLD,
				textBold: true,
				textSize: 18,
				textColor: 0xffffff,
				textAlignmentMode: TextAlign.LEFT,
				width: 238,
				height: 65,
				letterSpacing: -1,
				backgroundRadius: 12,
				paddingLeft: 27, //compensate for icon
				alignmentY: 0.5
			});
			
			onButtonDown.push(onDown);
			onStageUp.push(onUp);
			
			icon = Assets.getLowerMenuCarat();
			icon.x = 183;
			icon.y = 25;	
			background.addChild(icon);
			
			
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
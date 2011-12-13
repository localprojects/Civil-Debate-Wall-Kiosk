package com.civildebatewall.kiosk.buttons {

	import com.civildebatewall.Assets;
	import com.civildebatewall.CivilDebateWall;
	import com.civildebatewall.data.containers.Post;
	import com.greensock.TweenMax;
	import com.kitschpatrol.futil.blocks.BlockBase;
	import com.kitschpatrol.futil.constants.Alignment;
	
	import flash.events.MouseEvent;
	
	public class YesButton extends BlockBase {
		
		public function YesButton() 	{
			super({
				buttonMode: true,
				width: 260, 
				height: 143,
				backgroundRadius: 20,				
				backgroundColor: Assets.COLOR_YES_LIGHT,
				alignmentPoint: Alignment.CENTER
			});
			
			addChild(Assets.getYesButtonLabelText());
			
			onButtonDown.push(onDown);
			onStageUp.push(onUp);
		}
		
		private function onDown(e:MouseEvent):void {
			TweenMax.to(this, 0.5, {backgroundColor: Assets.COLOR_YES_MEDIUM});			
		}
		
		private function onUp(e:MouseEvent):void {
			CivilDebateWall.state.setUserStance(Post.STANCE_YES);
			CivilDebateWall.state.setView(CivilDebateWall.kiosk.opinionEntryView);
			
			TweenMax.to(this, 0.5, {backgroundColor: Assets.COLOR_YES_LIGHT});			
		}
		
	}
}
package com.civildebatewall.kiosk.buttons {
	
	import com.civildebatewall.Assets;
	import com.civildebatewall.CivilDebateWall;
	import com.civildebatewall.data.Post;
	import com.greensock.TweenMax;
	import com.kitschpatrol.futil.blocks.BlockBase;
	import com.kitschpatrol.futil.constants.Alignment;
	
	import flash.events.MouseEvent;
	
	public class NoButton extends BlockBase {
		
		public function NoButton() 	{
			super({
				buttonMode: true,
				width: 260, 
				height: 143,
				backgroundRadius: 20,				
				backgroundColor: Assets.COLOR_NO_LIGHT,
				alignmentPoint: Alignment.CENTER
			});
			
			addChild(Assets.getNoButtonLabelText());
			
			onButtonDown.push(onDown);
			onStageUp.push(onUp);
		}
		
		private function onDown(e:MouseEvent):void {
			TweenMax.to(this, 0, {backgroundColor: Assets.COLOR_NO_DARK});
		}
		
		private function onUp(e:MouseEvent):void {
			CivilDebateWall.state.setUserStance(Post.STANCE_NO);
			CivilDebateWall.state.setView(CivilDebateWall.kiosk.opinionEntryView);			
			
			TweenMax.to(this, 0.5, {backgroundColor: Assets.COLOR_NO_LIGHT});
		}
		
	}
}
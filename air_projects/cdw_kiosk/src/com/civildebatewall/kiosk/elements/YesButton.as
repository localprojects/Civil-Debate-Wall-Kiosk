package com.civildebatewall.kiosk.elements {
	import com.civildebatewall.Assets;
	import com.civildebatewall.CivilDebateWall;
	import com.civildebatewall.State;
	import com.civildebatewall.data.Data;
	import com.civildebatewall.data.Post;
	import com.civildebatewall.data.User;
	import com.greensock.TweenMax;
	import com.kitschpatrol.futil.blocks.BlockBase;
	import com.kitschpatrol.futil.constants.Alignment;
	import com.kitschpatrol.futil.utilitites.GeomUtil;
	
	import flash.display.Bitmap;
	import flash.events.MouseEvent;
	
	public class YesButton extends BlockBase {
		public function YesButton(params:Object=null) 	{
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
			CivilDebateWall.state.setView(CivilDebateWall.kiosk.view.opinionEntryView);
			
			TweenMax.to(this, 0.5, {backgroundColor: Assets.COLOR_YES_LIGHT});			
		}
		
	}
}
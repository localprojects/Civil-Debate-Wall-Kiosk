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
	
	public class NoButton extends BlockBase {
		public function NoButton(params:Object=null) 	{
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
			CivilDebateWall.state.userStance = Post.STANCE_NO;
			CivilDebateWall.state.setView(CivilDebateWall.kiosk.view.opinionEntryView);			
			
			TweenMax.to(this, 0.5, {backgroundColor: Assets.COLOR_NO_LIGHT});
		}
		
	}
}
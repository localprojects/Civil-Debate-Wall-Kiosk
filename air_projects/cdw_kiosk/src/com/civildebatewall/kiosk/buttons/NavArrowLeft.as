package com.civildebatewall.kiosk.buttons {
	
	import com.civildebatewall.Assets;
	import com.civildebatewall.CivilDebateWall;
	import com.greensock.TweenMax;
	import com.kitschpatrol.futil.constants.Alignment;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class NavArrowLeft extends NavArrowBase {
	
		public function NavArrowLeft() {
			super({bitmap: Assets.getLeftCaratBig()});
		}
		
		override protected function onActiveDebateChange(e:Event):void {
			super.onActiveDebateChange(e);
			// move the arrow off screen if we need to
			if (CivilDebateWall.state.getLeftThread() == null) {
				TweenMax.to(this, 0.5, {alpha: 0});
			}
			else {
				TweenMax.to(this, 0.5, {alpha: 1});								
			}
		}
		
		override protected function up(e:MouseEvent):void {
			super.up(e);
			if (CivilDebateWall.state.getLeftThread() != null) {
				CivilDebateWall.state.setActiveThread(CivilDebateWall.state.getLeftThread());
			}
		}		
		
	}
}
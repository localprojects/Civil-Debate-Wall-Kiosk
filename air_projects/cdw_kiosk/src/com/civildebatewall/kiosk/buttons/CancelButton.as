package com.civildebatewall.kiosk.buttons {
	import com.civildebatewall.CivilDebateWall;
	
	import flash.events.MouseEvent;
	
	public class CancelButton extends WhiteButton	{
		
		public function CancelButton(params:Object=null) {
			super({
				text: "CANCEL",
				width: 180,
				height: 64
			});
			
			onButtonUp.push(onUp);
		}
		
		private function onUp(e:MouseEvent):void {
			CivilDebateWall.state.clearUser();
			
			if (CivilDebateWall.data.threads.length == 0) {
				CivilDebateWall.state.setView(CivilDebateWall.kiosk.view.noOpinionView);				
			}
			else {
				CivilDebateWall.state.setView(CivilDebateWall.kiosk.view.homeView);
			}
		}
		
	}
}
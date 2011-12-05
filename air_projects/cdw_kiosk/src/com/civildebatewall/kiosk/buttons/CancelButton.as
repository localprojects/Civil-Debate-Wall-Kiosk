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
			CivilDebateWall.state.setView(CivilDebateWall.kiosk.view.homeView);
		}
		
	}
}
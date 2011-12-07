package com.civildebatewall.kiosk.buttons {
	
	import com.civildebatewall.CivilDebateWall;
	
	import flash.events.MouseEvent;
	
	public class CloseTermsButton extends WhiteButton	{
		public function CloseTermsButton() {
			super({
				text: "Close",
				width: 135,
				height: 41
			});
			
			onButtonUp.push(onUp);
		}
		
		private function onUp(e:MouseEvent):void {
			CivilDebateWall.state.setView(CivilDebateWall.kiosk.view.opinionReviewView);
		}
		
	}
}
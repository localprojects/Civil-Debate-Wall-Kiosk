package com.civildebatewall.kiosk.blocks {
	import com.civildebatewall.CivilDebateWall;
	import com.civildebatewall.kiosk.elements.WhiteButton;
	
	import flash.events.MouseEvent;
	
	public class CloseTermsButton extends WhiteButton	{
		public function CloseTermsButton(params:Object=null) {
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
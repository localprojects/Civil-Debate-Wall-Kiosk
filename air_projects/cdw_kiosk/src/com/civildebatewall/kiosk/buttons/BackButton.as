package com.civildebatewall.kiosk.buttons {
	
	import com.civildebatewall.CivilDebateWall;
	
	import flash.events.MouseEvent;
	
	public class BackButton extends WhiteButton	{
		
		public function BackButton(params:Object = null) {
			super({
				text: "BACK",
				width: 189,
				height: 64
			});
			
			setParams(params);
			
			onStageUp.push(onUp);			
		}

		private function onUp(e:MouseEvent):void {
			CivilDebateWall.state.setView(CivilDebateWall.state.backDestination);			
		}
		
	}
}
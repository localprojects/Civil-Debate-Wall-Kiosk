package com.civildebatewall.kiosk.buttons {
	
	import com.civildebatewall.CivilDebateWall;
	
	import flash.events.MouseEvent;

	public class RetakePhotoButton extends WhiteButton {
		
		public function RetakePhotoButton()	{
			super({
				text: "RETAKE PHOTO",
				width: 283,
				height: 64
			});
			
			onButtonUp.push(onUp);
		}
		
		private function onUp(e:MouseEvent):void {
			CivilDebateWall.state.setView(CivilDebateWall.kiosk.view.photoBoothView);
		}
	}
}
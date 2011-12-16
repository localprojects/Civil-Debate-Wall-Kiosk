package com.civildebatewall.kiosk.elements {

	import com.civildebatewall.Assets;
	import com.civildebatewall.CivilDebateWall;
	import com.civildebatewall.State;
	
	import flash.display.Bitmap;
	import flash.events.Event;
	
	public class PortraitMain extends PortraitBase {
		
		private var image:Bitmap;
		private var targetImage:Bitmap;
		
		public function PortraitMain() {
			super();
			CivilDebateWall.state.addEventListener(State.ACTIVE_THREAD_CHANGE, onActiveDebateChange);
		}
		
		private function onActiveDebateChange(e:Event):void {
			if (CivilDebateWall.state.activeThread != null) {
				setImage(CivilDebateWall.state.activeThread.firstPost.user.photo);
			}
			else {
				setImage(Assets.portraitPlaceholder);
			}
		}
		
	}
}
package com.civildebatewall.kiosk.buttons {
	import com.civildebatewall.Assets;
	import com.civildebatewall.CivilDebateWall;
	import com.civildebatewall.State;
	
	import flash.events.Event;

	public class HomeFlagButton extends FlagButton {
		public function HomeFlagButton() {
			super();
			
			setParams({
				width: 64,
				height: 64,
				backgroundRadius: 8
			});
			
			// resize flag icon
			icon.x = 0;
			icon.y = 0;
			icon.width = 20;
			icon.height = 20;

			// listens for updates to the active thread
			CivilDebateWall.state.addEventListener(State.ACTIVE_THREAD_CHANGE, onActiveDebateChange);			
		}
		
		private function onActiveDebateChange(e:Event):void {
			if (CivilDebateWall.state.activeThread != null) {
				targetPost = CivilDebateWall.state.activeThread.firstPost;
			}
		}		
	}
}
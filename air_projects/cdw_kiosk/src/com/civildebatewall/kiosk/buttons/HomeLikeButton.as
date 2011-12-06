package com.civildebatewall.kiosk.buttons {
	import com.civildebatewall.CivilDebateWall;
	import com.civildebatewall.State;
	
	import flash.events.Event;

	public class HomeLikeButton extends LikeButton {
		public function HomeLikeButton() {
			super();
			
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
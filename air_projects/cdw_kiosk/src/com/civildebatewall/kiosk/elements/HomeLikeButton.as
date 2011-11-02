package com.civildebatewall.kiosk.elements {
	import com.civildebatewall.CivilDebateWall;
	import com.civildebatewall.State;
	
	import flash.events.Event;

	public class HomeLikeButton extends LikeButton {
		public function HomeLikeButton() {
			super();
			
			// listens for updates to the active thread
			CivilDebateWall.state.addEventListener(State.ACTIVE_DEBATE_CHANGE, onActiveDebateChange);
		}
		
		private function onActiveDebateChange(e:Event):void {
			targetPost = CivilDebateWall.state.activeThread.firstPost;
		}		
		
	}
}
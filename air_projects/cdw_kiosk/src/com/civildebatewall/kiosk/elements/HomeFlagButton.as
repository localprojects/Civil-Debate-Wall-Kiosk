package com.civildebatewall.kiosk.elements {
	import com.civildebatewall.Assets;
	import com.civildebatewall.CivilDebateWall;
	import com.civildebatewall.State;
	
	import flash.events.Event;
	
	import mx.states.AddChild;

	public class HomeFlagButton extends FlagButton {
		public function HomeFlagButton() {
			super();
			
			setParams({
				width: 64,
				height: 64,
				backgroundRadius: 8
			});
			
			// replace smaller one
			removeChild(icon);
			icon = Assets.getFlagIcon();
			addChild(icon);
			
			// listens for updates to the active thread
			CivilDebateWall.state.addEventListener(State.ACTIVE_THREAD_CHANGE, onActiveDebateChange);			
		}
		
		private function onActiveDebateChange(e:Event):void {
			targetPost = CivilDebateWall.state.activeThread.firstPost;
		}		
	}
}
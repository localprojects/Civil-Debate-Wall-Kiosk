package com.civildebatewall.kiosk.elements.opinion_text {
	
	import com.civildebatewall.CivilDebateWall;
	import com.civildebatewall.State;
	
	import flash.events.Event;
	
	public class OpinionTextHome extends OpinionTextBase {

		public function OpinionTextHome()	{
			super();
			CivilDebateWall.state.addEventListener(State.ACTIVE_THREAD_CHANGE, onActiveDebateChange);
		}
		
		private function onActiveDebateChange(e:Event):void {
			setPost(CivilDebateWall.state.activeThread.firstPost);
			update();
		}
		
	}
}
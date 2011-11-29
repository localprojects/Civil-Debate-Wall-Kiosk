package com.civildebatewall.kiosk.elements
{
	import com.civildebatewall.Assets;
	import com.civildebatewall.CivilDebateWall;
	import com.civildebatewall.State;
	import com.demonsters.debugger.MonsterDebugger;
	import com.kitschpatrol.futil.blocks.BlockBase;
	import com.kitschpatrol.futil.blocks.BlockText;
	import com.kitschpatrol.futil.constants.Alignment;
	import com.kitschpatrol.futil.constants.Char;
	
	import flash.events.Event;
	
	
	public class OpinionTextHome extends OpinionTextBase	{


		public function OpinionTextHome()	{
			super();
							
			// listens
			CivilDebateWall.state.addEventListener(State.ACTIVE_THREAD_CHANGE, onActiveDebateChange);
		}
		
		
		private function onActiveDebateChange(e:Event):void {
			MonsterDebugger.trace(this, "debate change!");
			setPost(CivilDebateWall.state.activeThread.firstPost);
			
			// inside container, origin is still in top left, even when registratio point moves...
			
			//opinion.y = opinion.height;
			//nameTag.y = opinion.top - nameTag.height;
			
			update();
		}
		
//		override public function setPost(post:Post):void {
//			super.setPost(post);
//			
//			
//			
//		}
		
		
	}
}
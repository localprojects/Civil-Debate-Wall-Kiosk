package com.civildebatewall.kiosk.elements
{
	import com.civildebatewall.Assets;
	import com.civildebatewall.CivilDebateWall;
	import com.civildebatewall.State;
	import com.kitschpatrol.futil.blocks.BlockBase;
	import com.kitschpatrol.futil.blocks.BlockText;
	import com.kitschpatrol.futil.constants.Alignment;
	import com.kitschpatrol.futil.constants.Char;
	
	import flash.events.Event;
	
	
	public class OpinionText extends BlockBase	{

		private var opinion:BlockText;
		private var nameTag:BlockText;
		
		public function OpinionText()	{
			super({
				registrationPoint: Alignment.BOTTOM_LEFT,
				width: 880,
				maxHeight: 1000			
			});
							
			
			nameTag = new BlockText({
				minWidth: 100,
				maxWidth: 880,
				height: 78,
				paddingTop: 25,
				paddingLeft: 35,
				paddingRight: 35,				
				textFont: Assets.FONT_BOLD,
				textBold: true,
				textSize: 30,
				textColor: 0xffffff,
				visible: true
			});
		
			opinion = new BlockText({
				minWidth: 100,
				maxWidth: 880,
				maxHeight: 1000,				
				paddingTop: 25,
				paddingLeft: 35,
				paddingRight: 35,
				paddingBottom: 25,	
				textFont: Assets.FONT_REGULAR,
				textSize: 30,
				textColor: 0xffffff,
				visible: true
			});
			
			addChild(opinion);
			addChild(nameTag);

	
			CivilDebateWall.state.addEventListener(State.ACTIVE_DEBATE_CHANGE, onActiveDebateChange);
		}
		
		
		private function onActiveDebateChange(e:Event):void {
			trace("debate change!");
			nameTag.backgroundColor = CivilDebateWall.state.activeThread.firstPost.stanceColorDark;
			nameTag.text = (CivilDebateWall.state.activeThread.firstPost.user.username + " SAYS : " + CivilDebateWall.state.activeThread.firstPost.stance + "!").toUpperCase();
			
			opinion.backgroundColor = CivilDebateWall.state.activeThread.firstPost.stanceColorLight;
			opinion.text = Char.LEFT_QUOTE + CivilDebateWall.state.activeThread.firstPost.text + Char.RIGHT_QUOTE;
			
			// inside container, origin is still in top left, even when registratio point moves...
			
			opinion.y = opinion.height;
			nameTag.y = opinion.top - nameTag.height;
			
			update();
		}
		
		
	}
}
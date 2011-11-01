package com.civildebatewall.kiosk.elements
{
	import com.civildebatewall.Assets;
	import com.civildebatewall.CivilDebateWall;
	import com.civildebatewall.State;
	import com.civildebatewall.staging.futilProxies.BlockBaseTweenable;
	import com.kitschpatrol.futil.blocks.BlockText;
	import com.kitschpatrol.futil.constants.Alignment;
	import com.kitschpatrol.futil.constants.Char;
	
	import flash.events.Event;
	
	
	public class OpinionText extends BlockBaseTweenable	{

		private var opinion:BlockText;
		private var nameTag:BlockText;
		
		public function OpinionText()	{
			
			nameTag = new BlockText({
				textFont: Assets.FONT_BOLD,
				textBold: true,
				textSizePixels: 30,
				textColor: 0xffffff,
				minWidth: 100,
				maxWidth: 880,
				paddingTop: 25,
				paddingLeft: 35,
				paddingRight: 35,
				height: 78,
				registrationPoint: Alignment.BOTTOM_LEFT				
			});
		
			opinion = new BlockText({
				textFont: Assets.FONT_REGULAR,
				textSizePixels: 30,
				textColor: 0xffffff,
				minWidth: 100,
				maxWidth: 880,
				paddingTop: 25,
				paddingLeft: 35,
				paddingRight: 35,
				paddingBottom: 25,
				maxHeight: 1000,
				registrationPoint: Alignment.BOTTOM_LEFT 
			});
			
			
			addChild(nameTag);
			
			opinion.y = nameTag.height;
			
			addChild(opinion);
			
			
			
			showRegistrationPoint = true;		
			
			
	
			CivilDebateWall.state.addEventListener(State.ACTIVE_DEBATE_CHANGE, onActiveDebateChange);
		}
		
		
		private function onActiveDebateChange(e:Event):void {
			
			nameTag.backgroundColor = CivilDebateWall.state.activeThread.firstPost.stanceColorDark;
			nameTag.text = (CivilDebateWall.state.activeThread.firstPost.user.username + " SAYS : " + CivilDebateWall.state.activeThread.firstPost.stance + "!").toUpperCase();
			
			opinion.backgroundColor = CivilDebateWall.state.activeThread.firstPost.stanceColorLight;
			opinion.text = Char.LEFT_QUOTE + CivilDebateWall.state.activeThread.firstPost.text + Char.RIGHT_QUOTE;
			
			opinion.y = 0;
			nameTag.y = opinion.y - opinion.height;
			
		}
		
		
	}
}
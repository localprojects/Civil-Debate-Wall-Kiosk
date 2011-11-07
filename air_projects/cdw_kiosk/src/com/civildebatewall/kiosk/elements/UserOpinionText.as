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
	
	
	public class UserOpinionText extends BlockBase	{
		
		private var opinion:BlockText;
		private var nameTag:BlockText;
		
		public function UserOpinionText()	{
			super();
			
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
				registrationPoint: Alignment.BOTTOM_LEFT,
				visible: true
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
				registrationPoint: Alignment.BOTTOM_LEFT,
				visible: true
			});
			
			
			addChild(nameTag);
			opinion.y = nameTag.height;
			
			addChild(opinion);
		}
		
		override protected function beforeTweenIn():void {
			super.beforeTweenIn();
			
			trace("Setting name: " + CivilDebateWall.state.userName);
			trace("Setting opinion: " + CivilDebateWall.state.userOpinion);
			
			nameTag.backgroundColor = CivilDebateWall.state.userStanceColorDark;
			nameTag.text = (CivilDebateWall.state.userName + " SAYS : " + CivilDebateWall.state.userStance + "!").toUpperCase();
			
			opinion.backgroundColor = CivilDebateWall.state.userStanceColorLight;
			opinion.text = Char.LEFT_QUOTE + CivilDebateWall.state.userOpinion + Char.RIGHT_QUOTE;
			
			opinion.y = 0;
			nameTag.y = opinion.y - opinion.height;			
		}
		
		
		
		
	}
}
/*--------------------------------------------------------------------
Civil Debate Wall Kiosk
Copyright (c) 2012 Local Projects. All rights reserved.

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU Affero General Public License as
published by the Free Software Foundation, either version 3 of the
License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU Affero General Public License for more details.

You should have received a copy of the GNU Affero General Public
License along with this program. 

If not, see <http://www.gnu.org/licenses/>.
--------------------------------------------------------------------*/

package com.civildebatewall.kiosk.elements.opinion_text {
	
	import com.civildebatewall.Assets;
	import com.civildebatewall.CivilDebateWall;
	import com.kitschpatrol.futil.blocks.BlockText;
	import com.kitschpatrol.futil.constants.Alignment;
	import com.kitschpatrol.futil.constants.Char;
	
	public class UserOpinionText extends BlockTextOpinion	{
		
		private var opinion:BlockText;
		private var nameTag:BlockText;
		
		public function UserOpinionText()	{
			super({
				registrationPoint: Alignment.BOTTOM_LEFT, // Note registration point!
				width: 880,
				maxHeight: 1000,
				backgroundAlpha: 0
			});
			
			nameTag = new BlockText({
				textFont: Assets.FONT_BOLD,
				textBold: true,
				textSize: 30,
				textColor: 0xffffff,
				minWidth: 100,
				maxWidth: 880,
				paddingTop: 25,
				paddingLeft: 35,
				paddingRight: 35,
				height: 78,
				visible: true
			});
			
			opinion = new BlockText({
				textFont: Assets.FONT_REGULAR,
				textSize: 30,
				textColor: 0xffffff,
				minWidth: 100,
				maxWidth: 880,
				paddingTop: 25,
				paddingLeft: 35,
				paddingRight: 35,
				paddingBottom: 25,
				maxHeight: 1000,
				visible: true
			});
			
			addChild(nameTag);
			opinion.y = nameTag.height;
			
			addChild(opinion);
		}
		
		override protected function beforeTweenIn():void {
			super.beforeTweenIn();

			nameTag.backgroundColor = CivilDebateWall.state.userStanceColorDark;
			nameTag.text = (CivilDebateWall.state.userName + " SAYS : " + CivilDebateWall.state.userStance + "!").toUpperCase();
			
			opinion.backgroundColor = CivilDebateWall.state.userStanceColorLight;
			opinion.text = Char.LEFT_QUOTE + CivilDebateWall.state.userOpinion + Char.RIGHT_QUOTE;
			
			opinion.y = opinion.height;
			nameTag.y = opinion.top - nameTag.height;
		}

	}
}

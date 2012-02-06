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

package com.civildebatewall.wallsaver.elements {

	import com.civildebatewall.Assets;
	import com.civildebatewall.CivilDebateWall;
	import com.greensock.TweenMax;
	import com.kitschpatrol.futil.blocks.BlockText;
	import com.kitschpatrol.futil.constants.Alignment;
	
	import flash.events.MouseEvent;
	import flash.text.TextFormatAlign;

	public class JoinButton extends BlockText {
		
		private var downBackgroundColor:uint; // alternates based on scree
		
		public function JoinButton(params:Object = null) {
			super({
				text: "JOIN THE DEBATE. TOUCH TO BEGIN.",
				backgroundColor: Assets.COLOR_GRAY_85,
				textFont: Assets.FONT_BOLD,
				textSize: 17,
				textColor: 0xffffff,
				backgroundRadius: 11,																		
				width: 590,
				height: 63,
				textAlignmentMode: TextFormatAlign.CENTER,
				registrationPoint: Alignment.BOTTOM_RIGHT,
				alignmentPoint: Alignment.CENTER,
				visible: true,
				buttonMode: true				
			});
			
			downBackgroundColor = ((CivilDebateWall.flashSpan.settings.thisScreen.id % 2) == 0) ? Assets.COLOR_YES_DARK : Assets.COLOR_NO_DARK;
			
			onButtonDown.push(onDown);
			onStageUp.push(onUp);
		}
		
		private function onDown(e:MouseEvent):void {
			TweenMax.to(this, 0, {backgroundColor: downBackgroundColor});
		}
		
		private function onUp(e:MouseEvent):void {
			TweenMax.to(this, 0.5, {backgroundColor: Assets.COLOR_GRAY_85});
			CivilDebateWall.flashSpan.stop(); // fades everything out
		}

	}
}

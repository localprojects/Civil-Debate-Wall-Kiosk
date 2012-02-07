/*--------------------------------------------------------------------
Civil Debate Wall Kiosk
Copyright (c) 2012 Local Projects. All rights reserved.

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as
published by the Free Software Foundation, either version 2 of the
License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public
License along with this program. 

If not, see <http://www.gnu.org/licenses/>.
--------------------------------------------------------------------*/

package com.civildebatewall.kiosk.buttons {
	import com.civildebatewall.Assets;
	import com.civildebatewall.CivilDebateWall;
	import com.greensock.TweenMax;
	import com.kitschpatrol.futil.blocks.BlockText;
	import com.kitschpatrol.futil.constants.Alignment;
	import com.kitschpatrol.futil.utilitites.ColorUtil;
	
	import flash.events.MouseEvent;
	
	public class DebateButton extends BlockText {
		
		public function DebateButton(params:Object = null) {
			super({
				buttonMode: true,
				textFont: Assets.FONT_BOLD,
				textBold: true,
				textSize: 18,
				leading: 11,
				letterSpacing: -1,
				textColor: ColorUtil.gray(77),
				backgroundColor: 0xffffff,
				textAlignmentMode: Alignment.TEXT_CENTER,
				width: 397,
				height: 143,
				backgroundRadius: 20,
				alignmentPoint: Alignment.CENTER
			});
			
			onButtonDown.push(onDown);
			onStageUp.push(onUp);

		}
		
		override protected function beforeTweenIn():void {
			text = "DEBATE\n" + CivilDebateWall.state.userRespondingTo.user.usernameFormatted.toUpperCase() + " !";
			super.beforeTweenIn();
		}
				
		private function onDown(e:MouseEvent):void {
			drawDown();
		}
		
		private function onUp(e:MouseEvent):void {
			drawUp();
			
			CivilDebateWall.state.userIsDebating = true;
			CivilDebateWall.state.setUserStance(CivilDebateWall.state.userRespondingTo.opposingStance);
			CivilDebateWall.state.setView(CivilDebateWall.kiosk.opinionEntryView);
		}
		
		private function drawUp():void {
			TweenMax.to(this, 0.5, {backgroundColor: 0xffffff, textColor: ColorUtil.gray(77)});			
		}
		
		private function drawDown():void {
			TweenMax.to(this, 0, {backgroundColor: ColorUtil.gray(77), textColor: 0xffffff});			
		}
		
	}
}

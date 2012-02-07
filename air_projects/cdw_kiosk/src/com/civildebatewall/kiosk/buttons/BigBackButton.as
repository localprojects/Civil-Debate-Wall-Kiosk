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
	
	import flash.events.MouseEvent;
	
	public class BigBackButton extends BlockText	{
		
		public function BigBackButton() {
			super({
				buttonMode: true,
				text: "BACK TO HOME SCREEN",
				textFont: Assets.FONT_BOLD,
				textBold: true,
				textSize: 25,
				textColor: 0xffffff,
				textAlignmentMode: Alignment.TEXT_CENTER,
				width: 1024,
				height: 65,
				backgroundRadius: 12,
				alignmentPoint: Alignment.CENTER
			});
			
			onButtonDown.push(onDown);
			onStageUp.push(onUp);
		}
		
		override protected function beforeTweenIn():void {
			backgroundColor = CivilDebateWall.state.activeThread.firstPost.stanceColorMedium;
			super.beforeTweenIn();
		}
		
		private function onDown(e:MouseEvent):void {
			backgroundColor = CivilDebateWall.state.activeThread.firstPost.stanceColorDark;
		}
		
		private function onUp(e:MouseEvent):void {
			TweenMax.to(this, 0.5, {backgroundColor: CivilDebateWall.state.activeThread.firstPost.stanceColorMedium});
			CivilDebateWall.state.setView(CivilDebateWall.kiosk.homeView); // TODO dynamically go back to stats as well?
		}
		
	}
}

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

package com.civildebatewall.kiosk.buttons {

	import com.civildebatewall.Assets;
	import com.civildebatewall.CivilDebateWall;
	import com.greensock.TweenMax;
	import com.greensock.easing.Quart;
	import com.kitschpatrol.futil.blocks.BlockText;
	import com.kitschpatrol.futil.constants.Alignment;
	
	import flash.display.Bitmap;
	import flash.display.Shape;
	import flash.events.MouseEvent;
	
	public class LowerMenuButton extends BlockText	{
	
		private var icon:Bitmap;
		public var lowered:Boolean;
		
		private var line:Shape;
		
		public function LowerMenuButton() {
			super({
				buttonMode: true,
				text: "Lower Menu",
				textFont: Assets.FONT_BOLD,
				textBold: true,
				textSize: 18,
				textColor: 0xffffff,
				textAlignmentMode: Alignment.TEXT_LEFT,
				width: 238,
				height: 65,
				letterSpacing: -1,
				backgroundRadius: 12,
				paddingLeft: 27, //compensate for icon
				alignmentY: 0.5
			});
			
			onButtonDown.push(onDown);
			onStageUp.push(onUp);
			
			icon = Assets.getLowerMenuCarat();
			icon.x = 183;
			icon.y = 25;	
			background.addChild(icon);
			
			lowered = false;
		}
		
		override protected function beforeTweenIn():void {
			backgroundColor = CivilDebateWall.state.activeThread.firstPost.stanceColorMedium;
			super.beforeTweenIn();
		}
		
		private function onDown(e:MouseEvent):void {
			TweenMax.to(this, 0, {backgroundColor: CivilDebateWall.state.activeThread.firstPost.stanceColorLight});			
		}
		
		private function onUp(e:MouseEvent, instant:Boolean = false):void {
			TweenMax.to(this, 0.5, {backgroundColor: CivilDebateWall.state.activeThread.firstPost.stanceColorMedium});
			//CivilDebateWall.state.setView(CivilDebateWall.kiosk.view.homeView); // TODO dynamically go back to stats as well?
			
			if (!lowered) {
				lowered = true;
				TweenMax.to(this, instant ? 0 : 0.5, {text: "Raise Menu"})
				TweenMax.to(icon, instant ? 0 : 0.50, {transformAroundCenter:{scaleY: -1}, ease: Quart.easeInOut});								
				CivilDebateWall.kiosk.statsOverlay.lowerMenu(instant);
			}
			else {
				lowered = false;
				TweenMax.to(this, instant ? 0 : 0.5, {text: "Lower Menu"})
				TweenMax.to(icon, instant ? 0 : 0.50, {transformAroundCenter:{scaleY: 1}, ease: Quart.easeInOut});													
				CivilDebateWall.kiosk.statsOverlay.raiseMenu(instant);					
			}
			
		}
		
		public function toggle(instant:Boolean = false):void {
			onUp(new MouseEvent(MouseEvent.MOUSE_UP), instant);
		}
		
	}
}

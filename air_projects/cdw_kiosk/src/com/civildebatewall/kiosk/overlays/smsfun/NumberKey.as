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

package com.civildebatewall.kiosk.overlays.smsfun {

	import com.civildebatewall.Assets;
	import com.civildebatewall.CivilDebateWall;
	import com.greensock.TweenMax;
	import com.kitschpatrol.futil.blocks.BlockText;
	import com.kitschpatrol.futil.constants.Alignment;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class NumberKey extends BlockText {
		
		public static const KEY_PRESSED_EVENT:String = "keyPressedEvent";
		
		public function NumberKey(number:String)	{
			
			super({
				width: 149,
				height: 81,
				textFont: Assets.FONT_BOLD,
				textBold: true,
				textSize: 35, // TODO  auto				
				borderThickness: 3,
				backgroundRadius: 0,
				showBorder: true,	
				borderColor: CivilDebateWall.state.userStanceColorLight,
				backgroundColor: CivilDebateWall.state.userStanceColorLight,	
				backgroundAlpha: 0.12,
				textColor: CivilDebateWall.state.userStanceColorDark,
				alignmentPoint: Alignment.CENTER,
				textAlignmentMode: Alignment.TEXT_CENTER,
				text: number,
				buttonMode: true,
				visible: true
			});
			
			onButtonUp.push(onUp);
			onButtonDown.push(onDown);
			onButtonOver.push(onOver);
			onButtonOut.push(onOut);	
		}

		// mouse handling
		private function onDown(e:MouseEvent):void {
			drawDown();
		}
		
		private function onUp(e:MouseEvent):void {
			drawUp();
			this.dispatchEvent(new Event(KEY_PRESSED_EVENT, true)); // send event
		}		
		
		private function onOver(e:MouseEvent):void {
			if (e.buttonDown) drawDown();
		}
		
		private function onOut(e:MouseEvent):void {
			drawUp();
		}
		
		// drawing
		private function drawUp():void {
			TweenMax.to(this, 0.2, {backgroundAlpha: 0.12, textColor: CivilDebateWall.state.userStanceColorDark});			
		}
		
		private function drawDown():void {
			TweenMax.to(this, 0, {backgroundAlpha: 1, textColor: 0xffffff});
		}
		
	}
}

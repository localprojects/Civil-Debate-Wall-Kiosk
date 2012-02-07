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
	import com.kitschpatrol.futil.blocks.BlockText;
	
	import flash.display.Shape;
	import flash.events.MouseEvent;
	
	public class TermsAndConditionsButton extends BlockText {
	
		private var underline:Shape;
		
		public function TermsAndConditionsButton() {
			super({
				text: "Terms and Conditions",
				textFont: Assets.FONT_REGULAR,
				backgroundAlpha: 0,
				textSize: 14,
				buttonMode: true,
				textColor: 0xffffff,
				visible: false
			});
			
			underline = new Shape();
			underline.graphics.beginFill(0xffffff);
			underline.graphics.drawRect(0, 0, this.width - 2, 2);
			underline.graphics.endFill();
			underline.y = this.height + 5;
			underline.x = 3;
			addChild(underline);			
			
			onButtonUp.push(onUp);
		}
		
		private function onUp(e:MouseEvent):void {
			CivilDebateWall.state.setView(CivilDebateWall.kiosk.termsAndConditionsView);
		}
		
	}
}

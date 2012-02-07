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
	
	import flash.display.Sprite;
	
	public class Keypad extends Sprite	{
		
		public function Keypad() {
			super();

			for (var i:int = 0; i < 12; i++) {
				var tempKey:NumberKey = new NumberKey((i + 1).toString());
				tempKey.x = (i % 3) * (tempKey.width - tempKey.borderThickness);
				tempKey.y = Math.floor(i / 3) * (tempKey.height - tempKey.borderThickness); 

				// exceptional keys
				if (i == 11 || i == 9) {      
					tempKey.textSize = 17;
					if (i == 9) tempKey.text = "BACK";
					if (i == 11) tempKey.text = "SUBMIT";	
				}
				if (i == 10) tempKey.text = "0";
				
				addChild(tempKey);
			}
		}

	}
}

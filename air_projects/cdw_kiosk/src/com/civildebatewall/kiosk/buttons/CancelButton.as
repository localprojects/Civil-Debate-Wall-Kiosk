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
	
	import com.civildebatewall.CivilDebateWall;
	
	import flash.events.MouseEvent;
	
	public class CancelButton extends WhiteButton	{
		
		public function CancelButton(params:Object = null) {
			super({
				text: "CANCEL",
				width: 180,
				height: 64
			});
			
			onButtonUp.push(onUp);
		}
		
		private function onUp(e:MouseEvent):void {
			CivilDebateWall.state.clearUser();
			
			if (CivilDebateWall.data.threads.length == 0) {
				CivilDebateWall.state.setView(CivilDebateWall.kiosk.noOpinionView);				
			}
			else {
				CivilDebateWall.state.setView(CivilDebateWall.kiosk.homeView);
			}
		}
		
	}
}

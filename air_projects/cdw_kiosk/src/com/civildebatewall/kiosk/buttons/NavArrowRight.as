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
	import com.kitschpatrol.futil.constants.Alignment;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class NavArrowRight extends NavArrowBase {
		
		public function NavArrowRight() {
			super({bitmap: Assets.getRightCaratBig()});
		}
		
		override protected function onActiveDebateChange(e:Event):void {
			super.onActiveDebateChange(e);
			// move the arrow off screen if we need to
			if (CivilDebateWall.state.getRightThread() == null) {
				TweenMax.to(this, 0.5, {alpha: 0});
			}
			else {
				TweenMax.to(this, 0.5, {alpha: 1});								
			}
		}
		
		override protected function up(e:MouseEvent):void {
			super.up(e);
			if (CivilDebateWall.state.getRightThread() != null) {
				CivilDebateWall.state.setActiveThread(CivilDebateWall.state.getRightThread());
			}
		}		
		
	}
}

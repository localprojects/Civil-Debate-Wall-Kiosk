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
	import com.civildebatewall.State;
	import com.greensock.TweenMax;
	import com.kitschpatrol.futil.blocks.BlockBitmap;
	import com.kitschpatrol.futil.constants.Alignment;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class NavArrowBase extends BlockBitmap {
		
		public function NavArrowBase(params:Object = null) {
			super(params);
			buttonMode = true;
			
			onButtonDown.push(down);
			onButtonUp.push(up);
			
			width = 100;
			height = 152;
			alignmentPoint = Alignment.CENTER;
			backgroundAlpha = 0;
		
			CivilDebateWall.state.addEventListener(State.ACTIVE_THREAD_CHANGE, onActiveDebateChange);
			CivilDebateWall.state.addEventListener(State.SORT_CHANGE, onActiveDebateChange);
		}
		
		override protected function beforeTweenIn():void {
			TweenMax.to(this, 0, {colorMatrixFilter:{colorize: CivilDebateWall.state.activeThread.firstPost.stanceColorLight, amount: 1}});
			super.beforeTweenIn();
		}
		
		protected function onActiveDebateChange(e:Event):void {
			if (CivilDebateWall.state.activeThread != null) {
				TweenMax.to(this, 1, {colorMatrixFilter:{colorize: CivilDebateWall.state.activeThread.firstPost.stanceColorLight, amount: 1}});
			}
		}
		
		private function down(e:MouseEvent):void {
			TweenMax.to(this, 0, {colorMatrixFilter:{colorize: CivilDebateWall.state.activeThread.firstPost.stanceColorDark, amount: 1}});
		}
				
		protected function up(e:MouseEvent):void {
			TweenMax.to(this, 0.5, {colorMatrixFilter:{colorize: CivilDebateWall.state.activeThread.firstPost.stanceColorLight, amount: 1}});			
		}

	}
}

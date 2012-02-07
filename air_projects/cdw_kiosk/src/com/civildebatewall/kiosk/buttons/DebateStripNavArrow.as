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
	import com.civildebatewall.State;
	import com.greensock.TweenMax;
	import com.kitschpatrol.futil.blocks.BlockBitmap;
	import com.kitschpatrol.futil.constants.Alignment;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class DebateStripNavArrow extends BlockBitmap {
		
		public function DebateStripNavArrow(params:Object = null) {
			super(params);
			buttonMode = true;
			
			onButtonDown.push(onDown);
			onStageUp.push(onUp);
			
			width = 50;
			height = 141;
			alignmentPoint = Alignment.CENTER;
			backgroundAlpha = 0;
			backgroundColor = Assets.COLOR_GRAY_15;
			
			CivilDebateWall.state.addEventListener(State.ACTIVE_THREAD_CHANGE, onActiveDebateChange);
		}
		
		private function onActiveDebateChange(e:Event):void {
			// gray out?
			//TweenMax.to(this, 1, {colorMatrixFilter:{colorize: CivilDebateWall.state.activeThread.firstPost.stanceColorLight, amount: 1}});			
		}
		
		private function onDown(e:MouseEvent):void {
			TweenMax.to(this, 0, {backgroundAlpha: 1});
		}
		
		private function onUp(e:MouseEvent):void {
			TweenMax.to(this, 0.25, {backgroundAlpha: 0});
			//TweenMax.to(this, 0.5, {colorMatrixFilter:{colorize: CivilDebateWall.state.activeThread.firstPost.stanceColorLight, amount: 1}});			
		}
		
	}
}

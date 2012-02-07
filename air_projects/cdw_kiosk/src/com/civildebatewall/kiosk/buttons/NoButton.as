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
	import com.civildebatewall.data.containers.Post;
	import com.greensock.TweenMax;
	import com.kitschpatrol.futil.blocks.BlockBase;
	import com.kitschpatrol.futil.constants.Alignment;
	
	import flash.events.MouseEvent;
	
	public class NoButton extends BlockBase {
		
		public function NoButton() 	{
			super({
				buttonMode: true,
				width: 260, 
				height: 143,
				backgroundRadius: 20,				
				backgroundColor: Assets.COLOR_NO_LIGHT,
				alignmentPoint: Alignment.CENTER
			});
			
			addChild(Assets.getNoButtonLabelText());
			
			onButtonDown.push(onDown);
			onStageUp.push(onUp);
		}
		
		private function onDown(e:MouseEvent):void {
			TweenMax.to(this, 0, {backgroundColor: Assets.COLOR_NO_DARK});
		}
		
		private function onUp(e:MouseEvent):void {
			CivilDebateWall.state.setUserStance(Post.STANCE_NO);
			CivilDebateWall.state.setView(CivilDebateWall.kiosk.opinionEntryView);			
			
			TweenMax.to(this, 0.5, {backgroundColor: Assets.COLOR_NO_LIGHT});
		}
		
	}
}

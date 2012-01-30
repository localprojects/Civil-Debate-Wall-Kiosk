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

package com.civildebatewall.kiosk.elements
{
	import com.civildebatewall.Assets;
	import com.civildebatewall.CivilDebateWall;
	import com.civildebatewall.State;
	import com.civildebatewall.data.Data;
	import com.civildebatewall.kiosk.buttons.CaratButton;
	import com.greensock.TweenMax;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.getLogger;
	
	public class StatsTitleBarSelector extends StatsTitleBar	{
		
		private static const logger:ILogger = getLogger(StatsTitleBar);
		
		private var leftButton:CaratButton;
		private var rightButton:CaratButton;
		
		public function StatsTitleBarSelector(params:Object = null)		{
			super(params);
			leftButton = new CaratButton({bitmap: Assets.getLeftCaratWhite()});
			leftButton.x = 220;
			leftButton.y = 0;
			background.addChild(leftButton);
			
			rightButton = new CaratButton({bitmap: Assets.getRightCaratWhite()});
			rightButton.x = 738;
			rightButton.y = 0;		
			background.addChild(rightButton);
			
			visible = true;
			
			background.removeChild(leftDot);
			background.removeChild(rightDot);	
			
			// TODO
			// updates state
			CivilDebateWall.data.addEventListener(Data.DATA_UPDATE_EVENT, onViewChange); // only needs to happen at start?			
			CivilDebateWall.state.addEventListener(State.ON_STATS_VIEW_CHANGE, onViewChange);
			
			leftButton.onButtonUp.push(onLeftButton);
			rightButton.onButtonUp.push(onRightButton);	
			
		}
		
		private function onLeftButton(e:MouseEvent):void {
			CivilDebateWall.state.setStatsView(State.VIEW_MOST_DEBATED);
		}
		
		private function onRightButton(e:MouseEvent):void {
			CivilDebateWall.state.setStatsView(State.VIEW_MOST_LIKED);			
		}
		
		private function onViewChange(e:Event):void {	
			switch (CivilDebateWall.state.statsView) {
				case State.VIEW_MOST_DEBATED:
					TweenMax.to(this, 0.5, {text: "Most Debated Opinions"});
					leftButton.disable();
					rightButton.enable();
					break;
				case State.VIEW_MOST_LIKED:
					TweenMax.to(this, 0.5, {text: "Most Liked Opinions"});
					rightButton.disable();
					leftButton.enable();
					break;
				default:
					logger.error("Invalid stats view");
			}						
		}
		
	}
}

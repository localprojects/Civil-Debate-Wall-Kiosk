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

package com.civildebatewall {
	
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.getLogger;
	
	// Runs wallsaver automatically during inactivity
	public class DataUpdateTimer extends Timer	{
		
		private static const logger:ILogger = getLogger(DataUpdateTimer);
		
		public function DataUpdateTimer() {
			super(CivilDebateWall.settings.dataUpdateInterval * 1000);
			stop();
			this.addEventListener(TimerEvent.TIMER, onTimer);
		}
		
		private function onTimer(e:TimerEvent):void {
			// Show a random debate
			logger.info("Pulling update");
			CivilDebateWall.data.update();		
		}
		
		override public function start():void {
			// Always reset before starting
			this.reset();
			super.start();
		}
		
	}
}

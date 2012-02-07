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

package com.civildebatewall.wallsaver.core {
	import com.civildebatewall.CivilDebateWall;
	
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.getLogger;

	// Runs wallsaver automatically during inactivity
	public class WallSaverTimer extends Timer	{
		
		private static const logger:ILogger = getLogger(WallSaverTimer);
		
		public function WallSaverTimer() {
			super(CivilDebateWall.settings.wallsaverInterval * 1000, 1);
			stop();
			this.addEventListener(TimerEvent.TIMER_COMPLETE, onTimerComplete);
		}
		
		private function onTimerComplete(e:TimerEvent):void {
			// start one of the wall savers
			logger.info("Starting wallsaver via WallsaverTimer");
			if (Math.random() > 0.5) {
				CivilDebateWall.self.playSequenceA();
			}
			else {
				CivilDebateWall.self.playSequenceB();				
			}
		}
		
		override public function start():void {
			// Always reset before starting
			this.reset();
			super.start();
		}
		
	}
}

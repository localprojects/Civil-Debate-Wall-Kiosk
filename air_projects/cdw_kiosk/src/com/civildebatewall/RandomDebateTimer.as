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
	
	import com.civildebatewall.CivilDebateWall;
	import com.civildebatewall.data.Data;
	import com.kitschpatrol.flashspan.Random;
	import com.kitschpatrol.futil.utilitites.ArrayUtil;
	
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.getLogger;
	
	// Runs wallsaver automatically during inactivity
	public class RandomDebateTimer extends Timer	{
		
		private static const logger:ILogger = getLogger(RandomDebateTimer);
		
		public function RandomDebateTimer() {
			super(CivilDebateWall.settings.randomDebateInterval * 1000);
			stop();
			this.addEventListener(TimerEvent.TIMER, onTimer);
		}
		
		private function onTimer(e:TimerEvent):void {
			// Show a random debate
			logger.info("Going to a random debate due to inactivity");
			CivilDebateWall.state.setActiveThread(ArrayUtil.randomElement(CivilDebateWall.data.threads));		
		}
		
//		private function onTimer(e:TimerEvent):void {
//			// update from server, then change debates
//			logger.info("Starting update due to inactivity...");			
//			
//			CivilDebateWall.data.addEventListener(Data.DATA_UPDATE_EVENT, onDataUpdate);
//			CivilDebateWall.data.update();			
//		}
//		
//		private function onDataUpdate(event:Event):void {
//			logger.info("...finished update due to inactivity...");
//			CivilDebateWall.data.removeEventListener(Data.DATA_UPDATE_EVENT, onDataUpdate);
//			
//			// Show a random debate
//			logger.info("Going to a random debate due to inactivity");
//			CivilDebateWall.state.setActiveThread(ArrayUtil.randomElement(CivilDebateWall.data.threads));
//		}
		
		override public function start():void {
			// Always reset before starting
			this.reset();
			super.start();
		}
		
	}
}

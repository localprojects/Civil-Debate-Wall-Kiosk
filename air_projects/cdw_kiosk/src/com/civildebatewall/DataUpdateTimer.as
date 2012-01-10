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
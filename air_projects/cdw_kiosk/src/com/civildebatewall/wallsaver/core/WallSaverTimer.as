package com.civildebatewall.wallsaver.core {
	import com.kitschpatrol.flashspan.Random;
	
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.getLogger;
	import com.civildebatewall.CivilDebateWall;

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
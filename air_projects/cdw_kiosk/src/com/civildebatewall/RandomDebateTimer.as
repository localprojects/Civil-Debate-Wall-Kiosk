package com.civildebatewall {
	
	import com.civildebatewall.CivilDebateWall;
	import com.kitschpatrol.flashspan.Random;
	import com.kitschpatrol.futil.utilitites.ArrayUtil;
	
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
			// start one of the wall savers
			logger.info("Going to a random debate due to inactivity");
			CivilDebateWall.state.setActiveThread(ArrayUtil.randomElement(CivilDebateWall.data.threads));
		}
		
		override public function start():void {
			// Always reset before starting
			this.reset();
			super.start();
		}
		
	}
}
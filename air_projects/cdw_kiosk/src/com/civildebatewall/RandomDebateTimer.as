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
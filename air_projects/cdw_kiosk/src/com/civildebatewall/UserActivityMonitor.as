package com.civildebatewall {
	
	import com.greensock.TweenMax;
	import com.kitschpatrol.flashspan.FlashSpan;
	
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.getLogger;
	
	public class UserActivityMonitor extends EventDispatcher {
		
		private static const logger:ILogger = getLogger(UserActivityMonitor);
		
		private var timer:Timer;
		
		
		public function UserActivityMonitor(stageRef:Stage) {
			// Listen for these interruptions
			// List based on Aaron Clinger and Mike Creighton's Inactivity.as from CASA Lib
			stageRef.addEventListener(Event.RESIZE, onActivity, false, 0, true);
			stageRef.addEventListener(KeyboardEvent.KEY_DOWN, onActivity, false, 0, true);
			stageRef.addEventListener(KeyboardEvent.KEY_UP, onActivity, false, 0, true);
			stageRef.addEventListener(MouseEvent.MOUSE_DOWN, onActivity, false, 0, true);
			stageRef.addEventListener(MouseEvent.MOUSE_MOVE, onActivity, false, 0, true);
			stageRef.addEventListener(MouseEvent.MOUSE_WHEEL, onActivity, false, 0, true);
			stageRef.addEventListener(MouseEvent.MOUSE_UP, onActivity, false, 0, true);			

			
			// Set the timer
			timer = new Timer(1000);
			timer.addEventListener(TimerEvent.TIMER, onTick);
			timer.start();
		}
		
		

		// keep track of which other screens are active or inactive
		public var activeScreens:Array = [null, null, null, null, null];
		
		
		private function onTick(e:TimerEvent):void {
			CivilDebateWall.state.secondsInactive = timer.currentCount;
			//logger.info("Tick: " + timer.currentCount);

			if (timer.currentCount == CivilDebateWall.settings.inactivityTimeout) {

				// show the overlay
				if (CivilDebateWall.state.inactivityOverlayArmed) {
					logger.info("Tripping inactivity overlay...");
					CivilDebateWall.state.setView(CivilDebateWall.kiosk.inactivityOverlayView);
				}
			}
			else if (timer.currentCount == (CivilDebateWall.settings.inactivityTimeout + CivilDebateWall.settings.presenceCountdownTime)) {
				logger.info("User has gone inactive");		
				onInactive();
			}
		}
		
		public function onActivity(e:Event):void {
			// Send out an activity event if we're breaking inactivity
			if (timer.currentCount > (CivilDebateWall.settings.inactivityTimeout + CivilDebateWall.settings.presenceCountdownTime)) {
				logger.info("User has gone active");
				onActive();
			}
			
			if (CivilDebateWall.state.activeView != CivilDebateWall.kiosk.inactivityOverlayView) {
				timer.reset();
				timer.start();
			}
		}
		
		public function onActive():void {
			CivilDebateWall.state.userActive = true;
			CivilDebateWall.randomDebateTimer.stop();
			CivilDebateWall.dataUpdateTimer.stop();
			CivilDebateWall.self.broadcastActivity();
		} 
				
		private function onInactive():void {
			CivilDebateWall.state.userActive = false;
			CivilDebateWall.randomDebateTimer.start();
			CivilDebateWall.dataUpdateTimer.start();			
			
			// update
			logger.info("Pulling update due to inactivity");
			CivilDebateWall.data.update();
			
			// tell everyone else a bit later
			//TweenMax.delayedCall(5, CivilDebateWall.self.broadcastInactivity);
			CivilDebateWall.self.broadcastInactivity();			
		}
		
	}
}
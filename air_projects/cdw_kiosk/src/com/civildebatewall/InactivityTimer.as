package com.civildebatewall {
	
	import flash.display.Stage;
	import flash.events.Event;
	import flash.events.EventDispatcher;
	import flash.events.KeyboardEvent;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	
	public class InactivityTimer extends EventDispatcher {
		
		private var timer:Timer;
		
		public function InactivityTimer(stageRef:Stage, seconds:int) {
			super(null);

			// Listen for these interruptions
			// List based on Aaron Clinger and Mike Creighton's Inactivity.as from CASA Lib
			stageRef.addEventListener(Event.RESIZE, onActivity, false, 0, true);
			stageRef.addEventListener(KeyboardEvent.KEY_DOWN, onActivity, false, 0, true);
			stageRef.addEventListener(KeyboardEvent.KEY_UP, onActivity, false, 0, true);
			stageRef.addEventListener(MouseEvent.MOUSE_DOWN, onActivity, false, 0, true);
			stageRef.addEventListener(MouseEvent.MOUSE_MOVE, onActivity, false, 0, true);
			stageRef.addEventListener(MouseEvent.MOUSE_WHEEL, onActivity, false, 0, true);
			stageRef.addEventListener(MouseEvent.MOUSE_UP, onActivity, false, 0, true);
			//stageRef.addEventListener(TouchEvent.TOUCH_BEGIN, onActivity, false, 0, true);			

			// Set the timer
			timer = new Timer(1000, seconds);
		}
		
		private function onInactivity(e:TimerEvent):void {
			timer.stop();
			this.dispatchEvent(new InactivityEvent(InactivityEvent.INACTIVE));
		}
		
		private function onActivity(e:Event):void {
			timer.reset();
			timer.start();
		}

		public function arm():void {
			timer.reset();
			timer.start();
			timer.addEventListener(TimerEvent.TIMER_COMPLETE, onInactivity);
		}		
		
		public function disarm():void {
			timer.removeEventListener(TimerEvent.TIMER_COMPLETE, onInactivity);
		}
		
		public function get secondsInactive():int {
			return timer.currentCount;
		}
		
		public function get armed():Boolean {
			return timer.hasEventListener(TimerEvent.TIMER_COMPLETE);
		}
		
	}
}
package net.localprojects.utilities {
	import flash.events.*;
	import flash.utils.Timer;
	import net.localprojects.events.InactivityEvent;
	
	public class InactivityTimer extends EventDispatcher {
		
		private var timer:Timer;
		
		public function InactivityTimer(seconds:int) {
			super(null);

			// Listen for these interruptions
			// List based on Aaron Clinger and Mike Creighton's Inactivity.as from CASA Lib			
			Main.stageRef.addEventListener(Event.RESIZE, onActivity, false, 0, true);
			Main.stageRef.addEventListener(KeyboardEvent.KEY_DOWN, onActivity, false, 0, true);
			Main.stageRef.addEventListener(KeyboardEvent.KEY_UP, onActivity, false, 0, true);
			Main.stageRef.addEventListener(MouseEvent.MOUSE_DOWN, onActivity, false, 0, true);
			Main.stageRef.addEventListener(MouseEvent.MOUSE_MOVE, onActivity, false, 0, true);
			Main.stageRef.addEventListener(MouseEvent.MOUSE_WHEEL, onActivity, false, 0, true);
			Main.stageRef.addEventListener(MouseEvent.MOUSE_DOWN, onActivity, false, 0, true);
			Main.stageRef.addEventListener(MouseEvent.MOUSE_UP, onActivity, false, 0, true);

			// Set the timer
			timer = new Timer(seconds * 1000);
			timer.addEventListener(TimerEvent.TIMER, onInactivity);
			timer.start();
		}
		
		private function onInactivity(e:TimerEvent):void {
			timer.stop();
			this.dispatchEvent(new InactivityEvent(InactivityEvent.INACTIVE));
		}
		
		private function onActivity(e:Event):void {
			timer.reset();
			timer.start();
		}
		
	}
}
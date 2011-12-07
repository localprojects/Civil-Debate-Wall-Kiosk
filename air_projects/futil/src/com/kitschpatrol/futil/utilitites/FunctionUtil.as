package com.kitschpatrol.futil.utilitites {
	import flash.events.TimerEvent;
	import flash.utils.Timer;

	public class FunctionUtil	{

		public static function doAfterDelay(f:Function, d:Number):void {
			var timer:Timer = new Timer(d);
			
			var callback:Function = function(t:TimerEvent):void {
				t.target.stop();
				t.target.removeEventListener(TimerEvent.TIMER, callback);
				// call the function
				f();
			}
			
			timer.addEventListener(TimerEvent.TIMER, callback);
			
			timer.start();
		}
		
	}
}
package com.kitschpatrol.flashspan.events {
	import flash.events.Event;
	
	public class TimeSyncEvent extends Event {
		public static const SYNC:String = "timeSync";
		
		public var time:int;
				
		public function TimeSyncEvent(type:String, time:int, bubbles:Boolean=false, cancelable:Boolean=false)	{
			this.time = time;
			super(type, bubbles, cancelable);
		}
	}
}
package com.kitschpatrol.flashspan.events {
	import flash.events.Event;
	
	public class FlashSpanEvent extends Event {
		public static const START:String = "start";
		public static const STOP:String = "stop";		
		
		public function FlashSpanEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) {
			super(type, bubbles, cancelable);
		}
	}
}
package com.civildebatewall {
	import flash.events.Event;
	
	public class InactivityEvent extends Event {
		public static const INACTIVE:String  = "inactive";		
		
		public function InactivityEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)	{
			super(type, bubbles, cancelable);
		}
	}
}
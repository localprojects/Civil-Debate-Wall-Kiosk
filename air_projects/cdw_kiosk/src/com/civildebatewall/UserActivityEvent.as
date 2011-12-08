package com.civildebatewall {
	
	import flash.events.Event;
	
	public class UserActivityEvent extends Event {
		
		public static const ACTIVE:String  = "active";
		public static const INACTIVE:String  = "inactive";		
		
		public function UserActivityEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false)	{
			super(type, bubbles, cancelable);
		}
		
	}
}
package com.kitschpatrol.flashspan.events {
	import flash.events.Event;
	
	public class CustomMessageEvent extends Event {
		public static const MESSAGE_RECEIVED:String = "messageReceived";
		
		public var header:String;
		public var message:String;
		
		public function CustomMessageEvent(type:String, header:String, message:String, bubbles:Boolean=false, cancelable:Boolean=false) {
			this.header = header;
			this.message = message;
			super(type, bubbles, cancelable);
		}
	}
}
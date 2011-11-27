package com.kitschpatrol.flashspan.events {
	import flash.events.Event;
	
	public class FrameSyncEvent extends Event {
		public static const SYNC:String = "frameSync";
		
		public var frameCount:uint;
		
		public function FrameSyncEvent(type:String,  frameCount:uint, bubbles:Boolean=false, cancelable:Boolean=false)	{
			this.frameCount = frameCount;
			super(type, bubbles, cancelable);
		}
	}
}
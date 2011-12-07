package com.civildebatewall.kiosk.camera {
	
	import flash.events.Event;
	
	public class CameraFeedEvent extends Event {
		
		public static const NEW_FRAME_EVENT:String = "newFrameEvent";
		public static const CAMERA_TIMEOUT_EVENT:String = "cameraTimeoutEvent";
		
		public function CameraFeedEvent(type:String, bubbles:Boolean=false, cancelable:Boolean=false) {
			super(type, bubbles, cancelable);
		}
	}
}
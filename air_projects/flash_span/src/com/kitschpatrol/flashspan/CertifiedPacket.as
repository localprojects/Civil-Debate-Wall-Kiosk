package com.kitschpatrol.flashspan {
	
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	
	public class CertifiedPacket extends Object	{
		
		private static var certifiedPacketCount:uint = 0;

		public var message:String;
		public var timeout:int;
		public var timeSent:int;
		public var packetID:int;		
		private var timeoutTimer:Timer;
		private var timeoutCallback:Function;
		public var destination:NetworkedScreen;
		
		public function CertifiedPacket(_message:String, _destination:NetworkedScreen, _timeout:int, _timeoutCallback:Function) {
			message = _message;
			timeout = _timeout;
			timeSent = getTimer();
			packetID = CertifiedPacket.certifiedPacketCount++;
			timeoutCallback = _timeoutCallback;
			destination = _destination;
			
			timeoutTimer = new Timer(timeout);
			timeoutTimer.addEventListener(TimerEvent.TIMER, onTimeout);
			timeoutTimer.start();			
		}
		
		public function toMessage():String {
			return FlashSpan.CERTIFIED_HEADER + message + "," + packetID;
		}
		
		private function onTimeout(e:TimerEvent):void {
			disarmTimeout();
			timeoutCallback(this);
		}
		
		public function disarmTimeout():void {
			timeoutTimer.stop();
			timeoutTimer.removeEventListener(TimerEvent.TIMER, onTimeout);			
		}
		
	}
}
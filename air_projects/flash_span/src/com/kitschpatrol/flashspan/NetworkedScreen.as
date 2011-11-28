package com.kitschpatrol.flashspan
{
	import flash.geom.Rectangle;

	public class NetworkedScreen extends Rectangle {
		public var id:int;
		public var ip:String;
		public var port:int;	
		public var latency:int;
		public var connected:Boolean;
		
		// Simple structure for remote computer info
		public function NetworkedScreen(screenNode:XML) {
			super();
			
			for each (var screenSettings:XML in screenNode.children()) {				
				var key:String = screenSettings.localName();
				var value:Object = screenSettings.valueOf();				
				
				if (this.hasOwnProperty(key)) {
					this[key] = value;
				}
			}
			
			connected = false;
		}
		
	}
}
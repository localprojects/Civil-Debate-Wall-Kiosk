package com.kitschpatrol.flashspan
{
	public class NetworkedScreen extends Object {
		public var id:int;
		public var ip:String;
		public var port:int;
		public var screenWidth:int;
		public var screenHeight:int;
		public var xOffset:int;
		public var yOffset:int;	
		public var latency:int;
		
		public var connected:Boolean;
		
		
		// Simple structure for remote computer info.
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
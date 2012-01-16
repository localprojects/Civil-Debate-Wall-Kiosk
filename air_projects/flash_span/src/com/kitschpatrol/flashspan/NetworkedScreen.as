/* Copyright 2011, Eric Mika

This file is part of FlashSpan.

FlashSpan is free software: you can redistribute it and/or modify
it under the terms of the GNU Lesser General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

FlashSpan is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public License
along with FlashSpan.  If not, see <http://www.gnu.org/licenses/>. */

package com.kitschpatrol.flashspan {
	
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
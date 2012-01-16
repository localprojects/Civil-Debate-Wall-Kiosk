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
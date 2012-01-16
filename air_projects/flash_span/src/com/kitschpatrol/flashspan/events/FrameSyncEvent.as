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
	
	public class FrameSyncEvent extends Event {
		
		public static const SYNC:String = "frameSync";
		
		public var frameCount:uint;
		
		public function FrameSyncEvent(type:String,  frameCount:uint, bubbles:Boolean=false, cancelable:Boolean=false)	{
			this.frameCount = frameCount;
			super(type, bubbles, cancelable);
		}
	}
}
/**
 * KeyButton Event types
 */
package org.velluminous.keyboard
{
	import flash.events.Event;

	public class KeyButtonEvent extends Event
	{
		/**
		 * KeyButton press 
		 */
		public static var PRESS:String = "keyButtonPress";

		/**
		 * KeyButton release
		 */
		public static var RELEASE:String = "keyButtonRelease";

		/**
		 * data
		 */
		public var data:String;
		
		/**
		 * Constructor
		 */
		public function KeyButtonEvent(type:String, data:String, bubbles:Boolean=false, cancelable:Boolean=false)
		{
			super(type, bubbles, cancelable);
			this.data = data;
		}
		
	}
}
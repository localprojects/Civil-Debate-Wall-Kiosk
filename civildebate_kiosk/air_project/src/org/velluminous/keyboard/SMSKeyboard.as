/**
 * SMS keyboard
 */
package org.velluminous.keyboard
{
	import flash.geom.Point;
	
	public class SMSKeyboard extends KeyButtonCollection
	{
		/**
		 * Constructor 
		 */
		public function SMSKeyboard()
		{
			super();
		}
		
		/**
		 * Set up labels
		 */
		protected override function initLabels():void
		{
			keylabels = new Array(
				new Array( "1", "2", "3" ),
				new Array( "4", "5", "6" ),
				new Array( "7", "8", "9" ),
				new Array( "+", "0", "DEL" )
			);
			
			keysizeperrow = new Array(
				new Point( KEY_SIZE, KEY_SIZE ),
				new Point( KEY_SIZE*1, KEY_SIZE ),
				new Point( KEY_SIZE*1, KEY_SIZE ),
				new Point( KEY_SIZE*1, KEY_SIZE )
			);
		}

		
	}
}


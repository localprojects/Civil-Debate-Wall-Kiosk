/**
 * Numeric keyboard
 */
package org.velluminous.keyboard
{
	import flash.geom.Point;

	public class NumericKeyboard extends KeyButtonCollection
	{
		/**
		 * constructor 
		 */
		public function NumericKeyboard()
		{
			super();
		}
		
		/**
		 * setup labels
		 */
		protected override function initLabels():void
		{

			keylabels = new Array(
				new Array( "1", "2", "3", "4", "5", "6", "7", "8", "9", "0" ),
				new Array( "$", "!", "~", "&", "=", "\"" ),
				new Array( "#", "_", "-", "+" ),
				new Array( "ABC", "space", "@", ".", ".com", "DEL" )
			);
			
			keysizeperrow = new Array(
				new Point( KEY_SIZE, KEY_SIZE ),
				new Point( KEY_SIZE*1.5, KEY_SIZE ),
				new Point( KEY_SIZE*1.5, KEY_SIZE ),
				new Point( KEY_SIZE*1.25, KEY_SIZE )
			);
		}
	}
}
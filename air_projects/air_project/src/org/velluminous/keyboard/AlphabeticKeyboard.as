/**
 * Basic qwerty keyboard
 */
package org.velluminous.keyboard
{
	import flash.geom.Point;
	public class AlphabeticKeyboard extends KeyButtonCollection
	{
		/**
		 * Constructor 
		 */
		public function AlphabeticKeyboard()
		{
			super();
		}
		
		/**
		 * Set up labels
		 */
		protected override function initLabels():void
		{
			keylabels = new Array(
				new Array( "Q", "W", "E", "R", "T", "Y", "U", "I", "O", "P" ),
				new Array( "A", "S", "D", "F", "G", "H", "J", "K", "L" ),
				new Array( "Z", "X", "C", "V", "B", "N", "M" ),
				new Array( ".?123", "@", ".", ".com", "DEL" )
				);
				
			keysizeperrow = new Array(
				new Point( KEY_SIZE, KEY_SIZE ),
				new Point( KEY_SIZE, KEY_SIZE ),
				new Point( KEY_SIZE, KEY_SIZE ),
				new Point( KEY_SIZE*1.25, KEY_SIZE )
			);
		}
		
		/*
		protected override function handleRelease( e:KeyButtonEvent ):void
		{
			var data:String = e.data;
			switch ( data )
			{
				case ".?123":
				break;
				
				case "space":
				break;
				
				case "DEL":
				break;
				
				default:
				
			}
			trace( data );
		}
		*/	
		
	}
}
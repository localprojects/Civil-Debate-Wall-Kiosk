/**
 * Basic qwerty keyboard 
 */
package org.velluminous.keyboard
{
	import flash.display.Sprite;
	import flash.geom.Point;
	
	public class KeyButtonCollection extends Sprite
	{
		/**
		 * arrays of characters for each key 
		 */
		protected var keylabels:Array;
		
		/**
		 * arrays of key sizes
		 */
		protected var keysizeperrow:Array;
		
		/**
		 * standard key size for touch input
		 */
		public static var KEY_SIZE:Number = 60;
		
		/**
		 * space between keys
		 */
		public static var KEY_PADDING:Number = 20;
		
		/**
		 * constructor 
		 */
		public function KeyButtonCollection()
		{
			super();
			initLabels();
			createChildren();
		}

		/**
		 * init arrays
		 */
		protected function initLabels():void
		{
			keylabels = new Array(
				new Array( "Q", "W", "E", "R", "T", "Y", "U", "I", "O", "P" ),
				new Array( "A", "S", "D", "F", "G", "H", "J", "K", "L" ),
				new Array( "Z", "X", "C", "V", "B", "N", "M", "DEL" ),
				new Array( ".?123", "space", "@", "." )
				);
				
			keysizeperrow = new Array(
				new Point( KEY_SIZE, KEY_SIZE ),
				new Point( KEY_SIZE, KEY_SIZE ),
				new Point( KEY_SIZE, KEY_SIZE ),
				new Point( KEY_SIZE*1.25, KEY_SIZE )
			);
		}
		
		/**
		 * create children
		 */
		private function createChildren():void
		{
			var keysize:Number = KEY_SIZE;
			var keypadding:Number = KEY_PADDING;
			var keyboardwidth:Number = keylabels[0].length * ( keysize + keypadding );
			
			var xpos:Number = 0;
			var ypos:Number = 0;
			for ( var i:Number = 0; i < keylabels.length; i++ )
			{
				var keywidth:Number = (this.keysizeperrow[ i ] as Point).x;
				var keyheight:Number = ( this.keysizeperrow[i] as Point).y;
				xpos = ( keyboardwidth - keylabels[ i ].length * ( keywidth + keypadding ) ) / 2; 
				for ( var j:Number = 0; j < keylabels[ i ].length; j++ )
				{
					var btn:KeyButton = new KeyButton( keylabels[ i ][ j ], keywidth, keyheight );
					btn.addEventListener( KeyButtonEvent.PRESS, handlePress );
					btn.addEventListener( KeyButtonEvent.RELEASE, handleRelease );
					btn.x = xpos;
					btn.y = ypos;
					xpos += keywidth + keypadding;
					addChild( btn );
				}
				ypos += keyheight + keypadding;
			}
		}		
		
		/**
		 * handle key press
		 */
		protected function handlePress( e:KeyButtonEvent ):void
		{
			this.dispatchEvent( new KeyButtonEvent( KeyButtonEvent.PRESS, e.data ) );
		}
		
		/**
		 * handle key release
		 */
		protected function handleRelease( e:KeyButtonEvent ):void
		{
			this.dispatchEvent( new KeyButtonEvent( KeyButtonEvent.RELEASE, e.data ) );
		}
	}
}
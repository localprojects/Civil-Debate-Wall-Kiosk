package com.civildebatewall.kiosk.overlays.smsfun {
	
	import flash.display.Sprite;
	
	public class Keypad extends Sprite	{
		
		public function Keypad() {
			super();

			for (var i:int = 0; i < 12; i++) {
				var tempKey:NumberKey = new NumberKey((i + 1).toString());
				tempKey.x = (i % 3) * (tempKey.width - tempKey.borderThickness);
				tempKey.y = Math.floor(i / 3) * (tempKey.height - tempKey.borderThickness); 

				// exceptional keys
				if (i == 11 || i == 9) {      
					tempKey.textSize = 17;
					if (i == 9) tempKey.text = "BACK";
					if (i == 11) tempKey.text = "SUBMIT";	
				}
				if (i == 10) tempKey.text = "0";
				
				addChild(tempKey);
			}
		}

	}
}
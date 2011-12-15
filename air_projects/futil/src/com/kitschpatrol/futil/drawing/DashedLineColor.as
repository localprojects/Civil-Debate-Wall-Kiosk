package com.kitschpatrol.futil.drawing {
	
	// container for logging color changes
	internal class DashedLineColor {
		
		public var colorA:uint;
		public var colorB:uint;
		public var length:Number;
		
		public function DashedLineColor(colorA:uint, colorB:uint, length:Number)	{
			this.colorA = colorA;
			this.colorB = colorB;
			this.length = length;
		}
	}
}
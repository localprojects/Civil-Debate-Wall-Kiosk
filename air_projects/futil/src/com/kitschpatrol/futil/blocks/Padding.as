package com.kitschpatrol.futil.blocks {

	public class Padding {
		
		public var top:Number;
		public var right:Number;
		public var bottom:Number;
		public var left:Number;
		
		public function Padding(top:Number = 0, right:Number = 0, bottom:Number = 0, left:Number = 0)	{
			this.top = top;
			this.right = right;
			this.bottom = bottom;
			this.left = left;
		}
		
		public function get horizontal():Number {	return left + right; }
		public function set horizontal(amount:Number):void {
			left = amount;
			right = amount;
		}
		
		public function get vertical():Number { return top + bottom; }
		public function set vertical(amount:Number):void {
			top = amount;
			bottom = amount;
		}
		
		public function toInteger():int {
			return 1;
		}
		
	}
}
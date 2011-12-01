package com.kitschpatrol.futil.utilitites
{
	import flash.display.DisplayObject;

	public class DepthUtil
	{

		public static function bringToFront(d:DisplayObject):void {
			d.parent.setChildIndex(d, d.parent.numChildren - 1);
		}
		
		public static function sendToBack(d:DisplayObject):void {
			d.parent.setChildIndex(d, 0);
		}		
		
	}
}
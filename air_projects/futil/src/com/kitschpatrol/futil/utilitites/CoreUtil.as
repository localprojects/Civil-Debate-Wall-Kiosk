package com.kitschpatrol.futil.utilitites {
	import flash.utils.getTimer;
	
	
	public class CoreUtil	{
		
		public static function sleep(millis:Number):void {
			var startSleep:int = getTimer(); 
			
			while((getTimer() - startSleep) < millis) {
				// twiddle thumbs
			}
		}
		
	}
}
package com.kitschpatrol.futil {
	
	public class Utilities {
		
		
		// Useful generic toString override?
		//public static fieldsToString
		
		
		
		
		
		
		// via http://www.actionscript.org/forums/showthread.php3?t=158117
		// TODO only works for dynamic objects, need to split for reflection
		public static function traceObject(obj:*, level:int = 0):void {
			var tabs:String = "";
			
			for (var i:int = 0; i < level; i++)	tabs += "\t";
			
			for (var prop:String in obj) {
				trace(tabs + "[" + prop + "] -> " + obj[ prop ]);
				traceObject(obj[ prop ], level + 1);
			}
		}
		
		
	}
}
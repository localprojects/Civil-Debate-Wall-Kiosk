package com.kitschpatrol.futil.utilitites {
	import flash.system.Capabilities;
	
	public class PlatformUtil	{
	
			public static function isMac():Boolean {
				return StringUtil.contains(Capabilities.os, "Mac");				
			}
			
			public static function isWindows():Boolean {
				return StringUtil.contains(Capabilities.os, "Windows");				
			}			
		
	}
}
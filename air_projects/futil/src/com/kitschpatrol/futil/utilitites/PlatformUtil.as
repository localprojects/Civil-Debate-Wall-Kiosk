package com.kitschpatrol.futil.utilitites {
	import flash.system.Capabilities;
	
	public class PlatformUtil	{
	
			public static function get isMac():Boolean {
				return StringUtil.contains(Capabilities.os, "Mac");				
			}
			
			public static function get isWindows():Boolean {
				return StringUtil.contains(Capabilities.os, "Windows");				
			}
			
			
		
	}
}
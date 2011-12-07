package com.civildebatewall {
	
	import com.adobe.serialization.json.JSON;
	import com.kitschpatrol.futil.utilitites.FileUtil;
	import com.kitschpatrol.futil.utilitites.ObjectUtil;
	import com.kitschpatrol.futil.utilitites.PlatformUtil;
	
	import flash.filesystem.File;	
	
	public dynamic class Settings extends Object {
		
		// Loads settings from a JSON file
		public static function load():Object {
			
			var settingsPath:String;
			
			if (PlatformUtil.isWindows) {
				settingsPath = "//NAS-C0-AF-40/cdwmedia/conf/kiosk_settings.json"; // use the NAS!
			}
			else if (PlatformUtil.isMac) {
				settingsPath  = File.applicationDirectory.resolvePath("settings.json").url;
			}
			else {
				throw new Error("Error detecting system type when loading settings.");
			}
			
			var settingsString:String = FileUtil.loadString(settingsPath);
			var settings:Object = {}; // Holds final settings
			var rawSettings:Object = JSON.decode(settingsString); // Raw settings from file
			settings = rawSettings.common; // Always use the common settings
			
			// Use the "Mac" or "Windows" settings depending on detected platform
			if (PlatformUtil.isWindows) {
				settings = ObjectUtil.mergeObjects(settings , rawSettings.windows);
			}
			else if (PlatformUtil.isMac) {
				settings  = ObjectUtil.mergeObjects(settings , rawSettings.mac);				
			}
			else {
				throw new Error("Error detecting system type when loading settings.");
			}
			
			settings.settingsPath = settingsPath;
			return settings;
		}
		
	}
}
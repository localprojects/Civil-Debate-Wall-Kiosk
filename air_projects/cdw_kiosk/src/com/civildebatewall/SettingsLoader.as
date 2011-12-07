package com.civildebatewall {
	
	import com.adobe.serialization.json.JSON;
	import com.kitschpatrol.futil.utilitites.FileUtil;
	import com.kitschpatrol.futil.utilitites.ObjectUtil;
	import com.kitschpatrol.futil.utilitites.PlatformUtil;
	
	import flash.filesystem.File;	
	
	public class SettingsLoader extends Object {
		
		// Loads settings from a JSON file
		public static function load():Settings {
			
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
			var rawSettings:Object = JSON.decode(settingsString); // Raw settings from file
			
			var settings:Settings = new Settings(); // Holds final settings
			
			// Apply common settings
			ObjectUtil.setParams(settings, rawSettings.common);
			
			// Use the "Mac" or "Windows" settings depending on detected platform
			if (PlatformUtil.isWindows) {
				ObjectUtil.setParams(settings, rawSettings.windows);
			}
			else if (PlatformUtil.isMac) {
				ObjectUtil.setParams(settings, rawSettings.mac);				
			}
			else {
				throw new Error("Error detecting system type when loading settings.");
			}
			
			return settings;
		}
		
	}
}
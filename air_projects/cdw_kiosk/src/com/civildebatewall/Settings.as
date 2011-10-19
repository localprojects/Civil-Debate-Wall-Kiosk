package com.civildebatewall {
	import com.adobe.serialization.json.JSON;
	import com.kitschpatrol.futil.utilitites.ObjectUtil;
	import com.kitschpatrol.futil.utilitites.PlatformUtil;
	import com.kitschpatrol.futil.utilitites.StringUtil;
	
	import flash.filesystem.*;
	import flash.system.Capabilities;
	
	public dynamic class Settings extends Object {
		
		// Loads settings from a JSON file
		public static function load():Object {
			var file:File = File.applicationDirectory.resolvePath("settings.json");
			var stream:FileStream = new FileStream();
			stream.open(file, FileMode.READ);
			var settingsString:String = stream.readUTFBytes(stream.bytesAvailable);
			stream.close();

			var settings:Object = {}; // Holds final settings
			var rawSettings:Object = JSON.decode(settingsString); // Raw settings from file
			
			settings = rawSettings.common; // Always use the common settings
			
			// Use the "Mac" or "Windows" settings depending on detected platform
			if (PlatformUtil.isWindows()) {
				trace("Loading Windows Settings");
				settings = ObjectUtil.mergeObjects(settings , rawSettings.windows);
			}
			else if (PlatformUtil.isMac()) {
				trace("Loading Mac Settings");
				settings  = ObjectUtil.mergeObjects(settings , rawSettings.mac);				
			}
			else {
				throw new Error("Error detecting system type when loading settings.");
			}
				
			return settings;
		}
		
		
		
		
	}
}
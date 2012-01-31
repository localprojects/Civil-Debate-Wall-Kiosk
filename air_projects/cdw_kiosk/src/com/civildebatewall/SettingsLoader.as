/*--------------------------------------------------------------------
Civil Debate Wall Kiosk
Copyright (c) 2012 Local Projects. All rights reserved.

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU Affero General Public License as
published by the Free Software Foundation, either version 3 of the
License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU Affero General Public License for more details.

You should have received a copy of the GNU Affero General Public
License along with this program. 

If not, see <http://www.gnu.org/licenses/>.
--------------------------------------------------------------------*/

package com.civildebatewall {
	

	import com.kitschpatrol.futil.utilitites.FileUtil;
	import com.kitschpatrol.futil.utilitites.ObjectUtil;
	import com.kitschpatrol.futil.utilitites.PlatformUtil;
	
	import flash.filesystem.File;	
	
	public class SettingsLoader extends Object {
		
		// Loads settings from a JSON file
		public static function load():Settings {
			
			var settingsPath:String;
			
			if (PlatformUtil.isWindows) {
				settingsPath = File.applicationDirectory.resolvePath("settings.json").url; // use the NAS!
			}
			else if (PlatformUtil.isMac) {
				settingsPath  = File.applicationDirectory.resolvePath("settings.json").url;
			}
			else {
				throw new Error("Error detecting system type when loading settings.");
			}
			
			var settingsString:String = FileUtil.loadString(settingsPath);
			var rawSettings:Object = JSON.parse(settingsString); // Raw settings from file
			
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

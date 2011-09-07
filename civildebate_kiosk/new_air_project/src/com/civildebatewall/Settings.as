package com.civildebatewall {
	import com.adobe.serialization.json.*;
	import flash.system.Capabilities;
	
	import flash.filesystem.*;
	
	public class Settings extends Object {
		
		public static function load():Object {
			var settingsName:String = '';

			
			if((Capabilities.os.indexOf("Windows") >= 0)) {
				settingsName = 'settingsWindows.json';
			}
			else if((Capabilities.os.indexOf("Mac") >= 0)) {
				settingsName = 'settingsMac.json';
			} 
			
			var file:File = File.applicationDirectory.resolvePath(settingsName);
			var stream:FileStream = new FileStream();
			stream.open(file, FileMode.READ);
			var settingsString:String = stream.readUTFBytes(stream.bytesAvailable);
			stream.close();
			return JSON.decode(settingsString);
		}
		
		
	}
}
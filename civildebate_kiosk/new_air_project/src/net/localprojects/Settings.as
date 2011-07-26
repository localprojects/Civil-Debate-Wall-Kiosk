package net.localprojects {
	import com.adobe.serialization.json.*;
	
	import flash.filesystem.*;
	
	public class Settings extends Object {
		
		public static function load():Object {
			var file:File = File.applicationDirectory.resolvePath('settings.json');
			var stream:FileStream = new FileStream();
			stream.open(file, FileMode.READ);
			var settingsString:String = stream.readUTFBytes(stream.bytesAvailable);
			stream.close();
			
			return JSON.decode(settingsString);
		}
		
		
	}
}
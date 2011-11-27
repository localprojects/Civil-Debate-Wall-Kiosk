package com.kitschpatrol.flashspan {
	
	import com.demonsters.debugger.MonsterDebugger;
	
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.xml.XMLDocument;
	import flash.xml.XMLNode;
	
	public class Settings extends Object {
		// A collection of settings. These can be set manually or are loaded from an XML file
		public static const SERVER_AUTO:String = "auto";
		public static const SYNC_FRAMES:String = "frame";
		public static const SYNC_TIME:String = "time";
		
		public var totalWidth:int;
		public var totalHeight:int;
		public var scaleFactor:Number;
		public var server:String;
		public var syncMode:String;
		
		public var thisScreen:NetworkedScreen; // reference...
		public var networkMap:Vector.<NetworkedScreen>;
		
		public function Settings() {
			// Constructor
		}
		
		public function load(filePath:String):void {
			// load text file
			var file:File = File(filePath);
			var fileStream:FileStream = new FileStream();
			fileStream.open(file, FileMode.READ);
			
			var fileContents:String = fileStream.readUTFBytes(fileStream.bytesAvailable); // Read the contens of the 
			fileStream.close(); // Clean up and close the file stream			
			
			// parse the xml
			var xml:XML = new XML(fileContents);	
			
			// Global Settings
			for each (var setting:XML in xml.children()) {
				var key:String = setting.localName();
				var value:Object = setting.valueOf();
				
				if ((key != "networkMap") && this.hasOwnProperty(key)) {
					this[key] = value;
				}
			}
			
			// Network Map
			networkMap = new Vector.<NetworkedScreen>(xml.networkMap.children().length);			
			for each (var screenSettings:XML in xml.networkMap.children()) {
				// NetworkedScreen constructor parses xml
				networkMap[screenSettings.id] = new NetworkedScreen(screenSettings);
			}		
			
			MonsterDebugger.trace(this, this);
		}
		
		public function setMyID(id:int):void {
			thisScreen = networkMap[id];
		}
		
		// find a networked screen that matches certain network values
		public function getScreenByIP(ip:String, port:int):NetworkedScreen {
			for (var i:int = 0; i < networkMap.length; i++) {
				if ((networkMap[i].ip == ip) && (networkMap[i].port == port)) {
					return networkMap[i];
				}
			}
			return null;			
		}
	}
}
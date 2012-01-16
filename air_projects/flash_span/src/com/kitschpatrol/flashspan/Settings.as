/* Copyright 2011, Eric Mika

This file is part of FlashSpan.

FlashSpan is free software: you can redistribute it and/or modify
it under the terms of the GNU Lesser General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

FlashSpan is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU Lesser General Public License for more details.

You should have received a copy of the GNU Lesser General Public License
along with FlashSpan.  If not, see <http://www.gnu.org/licenses/>.	*/

package com.kitschpatrol.flashspan {

	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.geom.Rectangle;
	
	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.getLogger;
	
	public class Settings extends Object {
		
		private static const logger:ILogger = getLogger(Settings);
		
		// A collection of settings. These can be set manually or are loaded from an XML file
		public static const SERVER_AUTO:String = "auto";
		public static const SYNC_FRAMES:String = "frame";
		public static const SYNC_TIME:String = "time";
		
		public var totalWidth:int;
		public var totalHeight:int;
		public var server:String;
		public var syncMode:String;
		public var physicalScreenWidth:int;
		
		public var screenWidth:int; // from xml
		public var screenHeight:int; // from xml
		public var screenCount:int; // from xml
		public var bezelWidth:int; // from xml
		
		public var screens:Vector.<NetworkedScreen>;
		public var bezels:Vector.<Rectangle>;
		
		public var thisScreen:NetworkedScreen; // reference...		
		
		public var frameRate:int = 60;
		public var frameSyncInterval:int = 1; // how many frames between syncs
		
		public function Settings() {
			// Constructor
		}
		
		private function sortById(a:NetworkedScreen, b:NetworkedScreen):Number {
			return a.id - b.id;
		}
		
		public function load(filePath:String):void {
			// load text file
			logger.info("Settings File Path: " + filePath);
			var file:File = new File(filePath);
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
			
			screenCount = xml.networkMap.children().length();
			
			screens = new Vector.<NetworkedScreen>;			
			for each (var screenSettings:XML in xml.networkMap.children()) {
				// NetworkedScreen constructor parses xml
				screens.push(new NetworkedScreen(screenSettings));
			}
			screens = screens.sort(sortById);
			
			// fill in other variables
			totalWidth = (screenWidth * screenCount) + (bezelWidth * 2 * (screenCount - 1));
			totalHeight = screenHeight;
			physicalScreenWidth = screenWidth + (bezelWidth * 2);			

			// then populate with calculated variables
			for (var i:int = 0; i < screenCount; i++) {
				screens[i].x = (i * screenWidth) + (i * 2 * bezelWidth);
				screens[i].y = 0;
				screens[i].width = screenWidth;
				screens[i].height = screenHeight;			
			}			
			
			// generate bezels			
			bezels = new Vector.<Rectangle>;
			
			for (var j:int = 0; j < screenCount; j++) {
				if (j > 0) {
					bezels.push(new Rectangle(screens[j].x - bezelWidth, 0, bezelWidth, screenHeight)); // Left bezel
				}
				
				if (j < (screens.length - 1)) {
					bezels.push(new Rectangle(screens[j].x + screens[j].width, 0, bezelWidth, screenHeight)); // Right bezel
				}
			}			
		}
		
		public function setMyID(id:int):void {
			thisScreen = screens[id];
		}
		
		// find a networked screen that matches certain network values
		public function getScreenByIP(ip:String, port:int):NetworkedScreen {
			for (var i:int = 0; i < screens.length; i++) {
				if ((screens[i].ip == ip) && (screens[i].port == port)) {
					return screens[i];
				}
			}
			return null;			
		}
		
	}
}
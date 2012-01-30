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
	import flash.geom.Rectangle;
	
	public class Settings	{
		
		// Container for strict type checking of settings
		// These are fileld in at startup with values from a JSON file via SettingsLoader.as
		
		// Basic
		public var characterLimit:int;
		public var inactivityTimeout:int;
		public var randomDebateInterval:int; // If inactive, portrait cycles every X seconds
		public var wallsaverInterval:int; // Seconds to show the random thread between wallsaver runs 
		public var presenceCountdownTime:int;
		public var dataUpdateInterval:int; 
		
		// Network
		public var secretKey:String;
		public var serverPath:String;
		
		// Cameras
		public var useWebcam:Boolean;	
		public var useSLR:Boolean;
		public var webCamFocalLength:Number;
		public var webCamUndersampleFactor:Number;
		public var slrWaitTime:Number;
		public var slrTimeout:Number;
		public var flipWebcamVertical:Boolean;
		public var tempImagePath:String;		
		public var imagePath:String;
		
		// Screen Sync (Flash Span)
		public var flashSpanConfigPath:String;

		// Logging and Debug
		public var logToTrace:Boolean;
		public var logToMonster:Boolean;
		public var logToFile:Boolean;
		public var logFilePath:String;
		public var localMultiScreenTest:Boolean;
		public var halfSize:Boolean;
		public var startFullScreen:Boolean;
		public var logFullHTTP:Boolean; // Log full responses from server
		
		// Generated Settings
		public var kioskNumber:int;
		public var settingsPath:String;
		public var secretKeyHash:String;
		public var computerName:String;
		
		// Local FlashSpan Testing
		public var testWidth:int;
		public var testHeight:int;					
		
		// Fixed settings (Not passed in from file)
		public var targetFaceRectangle:Rectangle = new Rectangle(294, 352, 494, 576);
		

		public function Settings() {
			
		}
	}
}

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
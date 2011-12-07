package com.civildebatewall {
	import flash.geom.Rectangle;
	
	public class Settings	{
		
		// Container for strict type checking of settings
		
		// Basic
		public var characterLimit:int;
		public var inactivityTimeout:Number;
		public var wallsaverTimein:Number;
		
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
		public var halfSize:Number;
		public var startFullScreen:Boolean;
		public var logFullHTTP:Boolean = true; // Log full responses from server
		
		// Generated Settings
		public var kioskNumber:int;
		public var settingsPath:String;
		public var secretKeyHash:String;
		public var computerName:String;
		
		// Fixed settings (Not passed in from file)
		public var targetFaceRectangle:Rectangle = new Rectangle(294, 352, 494, 576);
		

		public function Settings() {
			
		}
	}
}
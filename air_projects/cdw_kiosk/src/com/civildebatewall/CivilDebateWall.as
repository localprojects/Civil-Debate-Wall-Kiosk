package com.civildebatewall {
	import com.bit101.components.FPSMeter;
	import com.civildebatewall.data.Data;
	import com.civildebatewall.kiosk.buttons.*;
	import com.civildebatewall.kiosk.camera.*;
	import com.civildebatewall.kiosk.core.Kiosk;
	import com.civildebatewall.kiosk.elements.*;
	import com.civildebatewall.kiosk.keyboard.*;
	import com.civildebatewall.wallsaver.core.WallSaver;
	import com.demonsters.debugger.MonsterDebugger;
	import com.greensock.*;
	import com.greensock.easing.*;
	import com.greensock.plugins.*;
	import com.kitschpatrol.flashspan.FlashSpan;
	import com.kitschpatrol.flashspan.events.CustomMessageEvent;
	import com.kitschpatrol.flashspan.events.FlashSpanEvent;
	import com.kitschpatrol.flashspan.events.FrameSyncEvent;
	import com.kitschpatrol.futil.tweenPlugins.FutilBlockPlugin;
	import com.kitschpatrol.futil.utilitites.PlatformUtil;
	
	import flash.display.*;
	import flash.events.*;
	import flash.filesystem.File;
	import flash.net.*;
	import flash.ui.Mouse;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	
	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.LOGGER_FACTORY;
	import org.as3commons.logging.api.getLogger;
	import org.as3commons.logging.setup.SimpleTargetSetup;
	import org.as3commons.logging.setup.target.AirFileTarget;
	import org.as3commons.logging.setup.target.MonsterDebugger3TraceTarget;
	import org.as3commons.logging.setup.target.TraceTarget;
	import org.as3commons.logging.setup.target.mergeTargets;
	import org.as3commons.logging.util.captureUncaughtErrors;
	
	// Main entry point for the app.
	// Manages display of Interactive Kiosk and Wallsaver modes.
	public class CivilDebateWall extends Sprite	{
		
		private static const logger:ILogger = getLogger(CivilDebateWall);
		
		public static var flashSpan:FlashSpan;		
		public static var data:Data;
		public static var state:State;
		public static var settings:Object;
		public static var self:CivilDebateWall;
		
		public static var wallSaver:WallSaver;
		public static var kiosk:Kiosk;
		public static var dashboard:Dashboard;
		
		public static var inactivityTimer:InactivityTimer;		

		private var commandLineArgs:Array;
		public var fpsMeter:FPSMeter;
		
		
		public function CivilDebateWall(commandLineArgs:Array = null)	{
			self = this;
			this.commandLineArgs = commandLineArgs;
			
			// TweenMax Greensock plugins
			TweenPlugin.activate([ThrowPropsPlugin, CacheAsBitmapPlugin, TransformAroundCenterPlugin, TransformAroundPointPlugin]);				

			// TweenMax Futil plugins
			TweenPlugin.activate([FutilBlockPlugin]);
			
			// Work around for lack of mouse-down events (Still need this?)
			// http://forums.adobe.com/message/2794098?tstart=0
			Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;			
			
			fpsMeter = new FPSMeter(this);
			fpsMeter.visible = false;
			fpsMeter.start();
			
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(event:Event):void {
			removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);			
			
			// load settings from a local JSON file			
			settings = Settings.load();
			
			// In local multi-screen debug mode, kiosk number is set via command line args instead of IP-based introspection
			// TODO genereic command line settings override system?
			if (commandLineArgs.length > 0) {
				settings.kioskNumber = commandLineArgs[0];
				settings.localMultiScreenTest = true;
				settings.useSLR = false;
				settings.useWebcam = false;
				settings.halfSize= false;
			}
			
			// Pick computer name for logging folder prefix
			var computerName:String;
			if (PlatformUtil.isMac) {
				settings.computerName = (settings.localMultiScreenTest) ? "LocalMac" + settings.kioskNumber : "LocalMacSingle";
				init(); // Keep setting up
			}
			else if (PlatformUtil.isWindows) {
				// Windows uses the conmputer's host name to prefix the log folder
				PlatformUtil.getHostName(onHostName);
			}
		}
		
		private function onHostName(name:String):void {
			settings.computerName = name;
			init(); // Keep setting up
		}
		
		private function init():void {
			// Set up logging via AS3 Commons Logging
			// More info: http://as3commons.org/as3-commons-logging/
			
			if (settings.logToMonster) MonsterDebugger.initialize(this);
			var monsterTarget:MonsterDebugger3TraceTarget = (settings.logToMonster) ? new MonsterDebugger3TraceTarget() : null; 
			var traceTarget:TraceTarget = (settings.logToTrace) ? new TraceTarget() : null;			
			var fileTarget:AirFileTarget = (settings.logToFile) ? new AirFileTarget(settings.logFilePath + "/" + settings.computerName + "/TheWallKiosk.{date}.log") : null; 			
			
			LOGGER_FACTORY.setup = new SimpleTargetSetup(mergeTargets(traceTarget, fileTarget, monsterTarget));			

			captureUncaughtErrors(loaderInfo); // log errors, does this always work?			

			logger.info("Starting The Wall Kiosk");
			logger.info("Logging to: " + (settings.logToMonster ? "MonsterDebugger " : "") + "|" + (settings.logToTrace ? " Trace " : "") + "|" + (settings.logToFile ? " File" : ""));
			logger.info("Server: " + settings.serverPath);			
			
			if (commandLineArgs.length > 0) {
				logger.info("Command line args: " + commandLineArgs);
			}
			else {
				logger.info("No command line args passed at startup");				
			}			

			// set up the stage
			stage.quality = StageQuality.BEST;
	
			// three possible window modes
			if (settings.localMultiScreenTest) {			
				// dimensions come from app.xml
				stage.scaleMode = StageScaleMode.EXACT_FIT;				
			}
			else if (settings.halfSize) {
				// temporarily squish screen for laptop development (half size)				
				stage.scaleMode = StageScaleMode.EXACT_FIT;
				stage.nativeWindow.width = 540;
				stage.nativeWindow.height = 960;
			}
			else {
				// window dimensions are defined in app.xml, don't bother scaling
				stage.scaleMode = StageScaleMode.NO_SCALE;
			}
			
			// make sure image folders exist
			if (PlatformUtil.isWindows) {
				Utilities.createFolderIfNecessary(settings.imagePath);
				Utilities.createFolderIfNecessary(settings.tempImagePath);				
			}
			else if (PlatformUtil.isMac) {
				Utilities.createFolderIfNecessary(settings.imagePath);
				// NO SLR, so no temp folder
			}
			
			// fill the background
			graphics.beginFill(0x000000);
			graphics.drawRect(0, 0, 1080, 1920);
			graphics.endFill();
			
			// set up gui overlay
			dashboard = new Dashboard();
			dashboard.visible = false;
			
			// scale the dashboard according to
			if (settings.halfSize) {
				dashboard.scaleX = 1080 / stage.width;
				dashboard.scaleY = 1920 / stage.height;
			}
			
			// Set the custom context menu
			contextMenu = Menu.getMenu();
			
			if (settings.startFullScreen)	toggleFullScreen();
			
			// inactivity timer
			inactivityTimer = new InactivityTimer(stage, settings.inactivityTimeout);
			inactivityTimer.addEventListener(InactivityEvent.INACTIVE, onInactive);			
			
			// Set up the wall data stores
			data = new Data();
			state = new State();
			
			// Interactive kiosk
			kiosk = new Kiosk();
			addChild(kiosk);

			
			if (PlatformUtil.isWindows) {
				logger.info("Getting Kiosk Number from IP");		
				flashSpan = new FlashSpan(-1, settings.flashSpanConfigPath);
			}
			else {
				flashSpan = new FlashSpan(settings.kioskNumber, File.applicationDirectory.nativePath + "/flash_span_settings.xml");
			}
			
			// Set up flash span
			// TODO move this to its own class
			flashSpan.addEventListener(FlashSpanEvent.START, onSyncStart);
			flashSpan.addEventListener(FlashSpanEvent.STOP, onSyncStop);
			flashSpan.addEventListener(CustomMessageEvent.MESSAGE_RECEIVED, onCustomMessageReceived);
			flashSpan.addEventListener(FrameSyncEvent.SYNC, onFrameSync);
			
			settings.kioskNumber = flashSpan.settings.thisScreen.id;
			
			logger.info("Kiosk Number: " + settings.kioskNumber);
			
			wallSaver = new WallSaver();
			wallSaver.x = -flashSpan.settings.thisScreen.x; // shift content left
			addChild(wallSaver);
			
			
			
			
			
			
//		// temp disable wall saver mouse
//		wallSaver.mouseEnabled = false;
//		wallSaver.mouseChildren = false;
			
			// Load the data, which fills up everything through binding callbacks
			CivilDebateWall.state.firstLoad = true;
			data.load();
			

			// dashboard goes on top... or add when active? 
			addChild(dashboard);			
		}
		

	
		
		
		
		
		 
		
		
		private function onInactive(e:InactivityEvent):void {
			logger.info("Inactivity Event Fired");
			CivilDebateWall.state.clearUser();			
			CivilDebateWall.state.setView(CivilDebateWall.kiosk.view.inactivityOverlayView);
		}		
		
		
		public function toggleFullScreen():void {		
			if (stage.displayState == StageDisplayState.NORMAL) {
				stage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;
				Mouse.hide();
			}
			else {
				stage.displayState = StageDisplayState.NORMAL;
				Mouse.show();
			}		
		}
		
		
		
		
		
		
		
		// Wallsaver control abstraction... these get broadcast to everyone through flashspan
		
		// message headers
		private const PLAY_SEQUENCE_A:String = "a";
		private const PLAY_SEQUENCE_B:String = "b";
		
		
		private function onSyncStart(e:FlashSpanEvent):void {
			//wallSaver.timeline.play();
		}
		
		private function onSyncStop(e:FlashSpanEvent):void {
			if (wallSaver.timeline.active) wallSaver.endSequence();
		}		
		
		public function PlaySequenceA():void {
			flashSpan.stop();
			flashSpan.broadcastCustomMessage(PLAY_SEQUENCE_A);
			TweenMax.delayedCall(1, flashSpan.start);  // wait for messages to land before starting
		}
		
		public function PlaySequenceB():void {
			flashSpan.stop();
			flashSpan.broadcastCustomMessage(PLAY_SEQUENCE_B);
			TweenMax.delayedCall(1, flashSpan.start); // wait for messages to land before starting
		}
		

		private function onCustomMessageReceived(e:CustomMessageEvent):void {
			if (e.header == PLAY_SEQUENCE_A) {
				trace("Playing Sequence A");
				wallSaver.cueSequenceA();
				flashSpan.frameCount = 0;
			}
			else if (e.header == PLAY_SEQUENCE_B) {
				trace("Playing Sequence B");
				wallSaver.cueSequenceB();
				flashSpan.frameCount = 0;
			}
		}

		
		private function onFrameSync(e:FrameSyncEvent):void {
			wallSaver.timeline.gotoAndPlay(e.frameCount);
		}
		
		
	}
}
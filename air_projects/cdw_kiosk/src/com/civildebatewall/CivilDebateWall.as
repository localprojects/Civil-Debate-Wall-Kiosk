package com.civildebatewall {
	import com.adobe.crypto.SHA1;
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
	import com.kitschpatrol.futil.tweenPlugins.BackgroundColorPlugin;
	import com.kitschpatrol.futil.tweenPlugins.FutilBlockPlugin;
	import com.kitschpatrol.futil.tweenPlugins.NamedXPlugin;
	import com.kitschpatrol.futil.tweenPlugins.NamedYPlugin;
	import com.kitschpatrol.futil.tweenPlugins.TextColorPlugin;
	import com.kitschpatrol.futil.utilitites.PlatformUtil;
	
	import flash.display.*;
	import flash.events.*;
	import flash.filesystem.File;
	import flash.net.*;
	import flash.ui.Mouse;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	
	// Main entry point for the app.
	// Manages display of Interactive Kiosk and Wallsaver modes.
	public class CivilDebateWall extends Sprite	{
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
		
		// For flashspan		
		
		public function CivilDebateWall(commandLineArgs:Array = null)	{
			self = this;
			this.commandLineArgs = commandLineArgs;
			
			// Greensock plugins
			TweenPlugin.activate([ThrowPropsPlugin]);			
			TweenPlugin.activate([CacheAsBitmapPlugin]);	
			TweenPlugin.activate([TransformAroundCenterPlugin]);
			TweenPlugin.activate([TransformAroundPointPlugin]);	

			// Futil plugins
			TweenPlugin.activate([FutilBlockPlugin]);
			
			// Work around for lack of mouse-down events
			// http://forums.adobe.com/message/2794098?tstart=0
			Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;			
			
			fpsMeter = new FPSMeter(this);
			fpsMeter.visible = false;
			fpsMeter.start();
			
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(event:Event):void {
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);			
			
			// load settings from a local JSON file			
			settings = Settings.load();
			
			// if we're running in local multi-screen debug mode, we will receive certain command line args
			// these can ovveride settings
			// TODO genereic command line settings override system?
			if (commandLineArgs.length > 0) {
				MonsterDebugger.trace(this, "Args: " + commandLineArgs);
				settings.kioskNumber = commandLineArgs[0];
				settings.localMultiScreenTest = true;
				settings.useSLR = false;
				settings.useWebcam = false;
				settings.halfSize= false;
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
				// window dimensions are defined in app.xml,
				// but don't bother scaling
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
			
			// set up gui overlay TODO move to window
			dashboard = new Dashboard();
			dashboard.visible = true;
			
			
			if (settings.halfSize) {
				dashboard.scaleX = 2;
				dashboard.scaleY = 2;
			}
			
			// Set the custom context menu
			contextMenu = Menu.getMenu();
			
			if (settings.startFullScreen)	toggleFullScreen();
			
			// inactivity timer
			inactivityTimer = new InactivityTimer(stage, settings.inactivityTimeout);
			inactivityTimer.addEventListener(InactivityEvent.INACTIVE, onInactive);			
			

			
			// load the wall data
			data = new Data();
			
			// create local state
			state = new State();
			
			kiosk = new Kiosk();
			addChild(kiosk);
			
			// TODO create wallsaver here
			
			// Add the Wallsaver

			
			

			// set up Flash Span
			
			// TODO put IP based screen ID in settings here
			if (PlatformUtil.isWindows) {
				// get ID from IP
				MonsterDebugger.trace(this, "Getting kiosk ID from IP.");				
				flashSpan = new FlashSpan(-1, settings.flashSpanConfigPath);
			}
			else {
				flashSpan = new FlashSpan(settings.kioskNumber, File.applicationDirectory.nativePath + "/flash_span_settings.xml");
			}
			
			
			flashSpan.addEventListener(FlashSpanEvent.START, onSyncStart);
			flashSpan.addEventListener(FlashSpanEvent.STOP, onSyncStop);
			flashSpan.addEventListener(CustomMessageEvent.MESSAGE_RECEIVED, onCustomMessageReceived);
			flashSpan.addEventListener(FrameSyncEvent.SYNC, onFrameSync);
			
			settings.kioskNumber = flashSpan.settings.thisScreen.id;
			
			
			wallSaver = new WallSaver();
			wallSaver.x = -flashSpan.settings.thisScreen.x; // shift content left
			addChild(wallSaver);
			
			
			
			
			
			
//		// temp disable wall saver mouse
//		wallSaver.mouseEnabled = false;
//		wallSaver.mouseChildren = false;
			
			// Load the data, which fills up everything through binding callbacks
			data.load();			

			// dashboard goes on top... or add when active? 
			addChild(dashboard);
		}
		

	
		
		
		
		
		
		
		
		private function onInactive(e:InactivityEvent):void {
			MonsterDebugger.trace(this, "inactive!");
			//view.inactivityOverlayView();
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
		private const PLAY_SEQUENCE_A:String = 'a';
		private const PLAY_SEQUENCE_B:String = 'b';
		
		
		private function onSyncStart(e:FlashSpanEvent):void {
			//wallSaver.timeline.play();
		}
		
		private function onSyncStop(e:FlashSpanEvent):void {
			if (wallSaver.timeline.active) wallSaver.endSequence();
		}		
		
		public function PlaySequenceA():void {
			flashSpan.stop();
			flashSpan.broadcastCustomMessage(PLAY_SEQUENCE_A);
			flashSpan.start();
		}
		
		public function PlaySequenceB():void {
			flashSpan.stop();
			flashSpan.broadcastCustomMessage(PLAY_SEQUENCE_B);
			flashSpan.start();
		}
		

		private function onCustomMessageReceived(e:CustomMessageEvent):void {
			if (e.header == PLAY_SEQUENCE_A) {
				MonsterDebugger.trace(this, "Playing Sequence A");
				wallSaver.cueSequenceA();
				flashSpan.frameCount = 0;
			}
			else if (e.header == PLAY_SEQUENCE_B) {
				MonsterDebugger.trace(this, "Playing Sequence B");
				wallSaver.cueSequenceB();
				flashSpan.frameCount = 0;
			}
		}

		
		private function onFrameSync(e:FrameSyncEvent):void {
			wallSaver.timeline.gotoAndPlay(e.frameCount);
		}
		
		
	}
}
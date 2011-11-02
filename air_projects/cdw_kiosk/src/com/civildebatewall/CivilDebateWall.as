package com.civildebatewall {
	import com.adobe.crypto.SHA1;
	import com.civildebatewall.data.Data;
	import com.civildebatewall.kiosk.Kiosk;
	import com.civildebatewall.kiosk.blocks.*;
	import com.civildebatewall.kiosk.camera.*;
	import com.civildebatewall.kiosk.elements.*;
	import com.civildebatewall.kiosk.keyboard.*;
	import com.civildebatewall.kiosk.ui.*;
	import com.greensock.*;
	import com.greensock.easing.*;
	import com.greensock.plugins.*;
	import com.kitschpatrol.futil.tweenPlugins.BackgroundColorPlugin;
	import com.kitschpatrol.futil.tweenPlugins.FutilBlockPlugin;
	import com.kitschpatrol.futil.tweenPlugins.NamedXPlugin;
	import com.kitschpatrol.futil.tweenPlugins.NamedYPlugin;
	import com.kitschpatrol.futil.tweenPlugins.TextColorPlugin;
	import com.kitschpatrol.futil.utilitites.PlatformUtil;
	
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	import flash.ui.Mouse;
	
	// Main entry point for the app.
	// Manages display of Interactive Kiosk and Wallsaver modes.
	public class CivilDebateWall extends Sprite	{

		
		public static var data:Data;
		public static var state:State;
		public static var settings:Object;
		public static var self:CivilDebateWall;
		
		public static var kiosk:Kiosk;
		public static var dashboard:Dashboard;
		
		public static var inactivityTimer:InactivityTimer;		
		
		public function CivilDebateWall()	{
			self = this;
			
			// Greensock plugins
			TweenPlugin.activate([ThrowPropsPlugin]);			
			TweenPlugin.activate([CacheAsBitmapPlugin]);	
			TweenPlugin.activate([TransformAroundCenterPlugin]);

			// Futil plugins
			TweenPlugin.activate([FutilBlockPlugin]);
			
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(event:Event):void {
			this.removeEventListener(Event.ADDED_TO_STAGE, onAddedToStage);			
			
			// load settings from a local JSON file			
			settings = Settings.load();
			

			
			// set up the stage
			stage.quality = StageQuality.BEST;
			
			// temporarily squish screen for laptop development (half size)
			if (settings.halfSize) {
				stage.scaleMode = StageScaleMode.EXACT_FIT;
				stage.nativeWindow.width = 540;
				stage.nativeWindow.height = 960;
			}
			else {
				stage.scaleMode = StageScaleMode.NO_SCALE;
				stage.align = StageAlign.TOP;
				stage.nativeWindow.width = 1080;
				stage.nativeWindow.height = 1920;
			}
			
			// make sure image folders exist
			if (PlatformUtil.isWindows) {
				Utilities.createFolderIfNecessary(settings.imagePath);
				Utilities.createFolderIfNecessary(settings.tempImagePath);				
			}
			else if (PlatformUtil.isMac) {
				Utilities.createFolderIfNecessary(settings.imagePath);
			}
			
			// fill the background
			graphics.beginFill(0x000000);
			graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
			graphics.endFill();
			
			// set up gui overlay TODO move to window
			dashboard = new Dashboard(this.stage, 5, 5);
			dashboard.visible = false;
			
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
			
			// TODO create wallsaver
			
			// Load the data, which fills up everything through binding callbacks
			data.load();			
			
		}
		

	
		
		
		private function onInactive(e:InactivityEvent):void {
			trace("inactive!");
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
		
		
		
	}
}
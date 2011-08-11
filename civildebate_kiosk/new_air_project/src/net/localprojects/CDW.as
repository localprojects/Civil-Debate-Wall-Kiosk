package net.localprojects {

	import com.bit101.components.FPSMeter;
	import com.greensock.*;
	import com.greensock.easing.*;
	import com.greensock.events.LoaderEvent;
	
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	
	
	
	import net.localprojects.blocks.*;
	import net.localprojects.camera.*;
	import net.localprojects.elements.*;
	import net.localprojects.keyboard.*;
	import net.localprojects.ui.*;
	
	public class CDW extends Sprite {
		
		public static var ref:CDW;
		public static var database:Database;
		public static var dashboard:Dashboard;
		public static var state:State;
		public static var settings:Object;
		public static var view:View;
		public static var testOverlay:Bitmap;
		
		
		public function CDW() {
			ref = this;
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}

		private function onAddedToStage(event:Event):void {
			// load settings from a local JSON file
			settings = Settings.load();
			
			// set up the stage
			stage.quality = StageQuality.BEST;
			stage.scaleMode = StageScaleMode.EXACT_FIT;
			
			// temporarily squish screen for laptop development (half size)
			if (settings.halfSize) {
				stage.nativeWindow.width = 540;
				stage.nativeWindow.height = 960;
			}
			else {
				stage.nativeWindow.width = 1080;
				stage.nativeWindow.height = 1920;				
			}
			
			// create local state
			state = new State();
			
			// load the wall state
			database = new Database();
			database.addEventListener(LoaderEvent.COMPLETE, onDatabaseLoaded);			
			database.load();
			
			// background
			graphics.beginFill(0xffffff);
			graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
			graphics.endFill();
			

			
			// set up gui overlay
			dashboard = new Dashboard(this.stage, 5, 5);
			
			if (settings.halfSize) {			
				dashboard.scaleX = 2;
				dashboard.scaleY = 2;
			}
			
			// set up a full screen option in the context menu
			var myContextMenu:ContextMenu = new ContextMenu();
			var item:ContextMenuItem = new ContextMenuItem("Toggle Full Screen");
			myContextMenu.customItems.push(item);
			item.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, onFullScreenContextMenuSelect);
			contextMenu = myContextMenu;
			
			if (settings.startFullScreen) {
				toggleFullScreen();
			}
		}
		
		
		private function onDatabaseLoaded(e:LoaderEvent):void {
			trace("database loaded");
			
			// create the view, this is where
			// all of the visuals come from
			view = new View();
			addChild(view);
							
			// set the starting view
			view.homeView();

			// FPS meter
			var fps:FPSMeter = new FPSMeter(this, stage.stageWidth - 50, 0);		
			
			if (settings.halfSize) {
				fps.scaleX = 2;
				fps.scaleY = 2;			
				fps.x = stage.stageWidth - 100;
				fps.y = -5;	
			}
			
			// set up test overlay
			testOverlay = new Bitmap(new BitmapData(1080, 1920));
			testOverlay.visible = false;
			testOverlay.alpha = 0.5;
			addChild(testOverlay);
		}

		private function onFullScreenContextMenuSelect(e:Event):void {
			toggleFullScreen();
		}
		
		private function toggleFullScreen():void {
			if (stage.displayState == StageDisplayState.NORMAL) {
				stage.displayState = StageDisplayState.FULL_SCREEN;
			}
			else {
				stage.displayState = StageDisplayState.NORMAL;
			}
		}
		
		
		
	}
}
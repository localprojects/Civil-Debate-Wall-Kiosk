package net.localprojects {

	import com.bit101.components.FPSMeter;
	import com.greensock.*;
	import com.greensock.easing.*;
	
	
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	import flash.ui.Mouse;
	import flash.ui.MouseCursor;
	import flash.ui.MouseCursorData;
	
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
		public static var inactivityTimer:InactivityTimer;
		
		
		public function CDW() {
			ref = this;
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}

		private function onAddedToStage(event:Event):void {
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
			
			// create local state
			state = new State();
			
			// load the wall state
			database = new Database();
			database.addEventListener(Event.COMPLETE, onDatabaseLoaded);			
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
			var fullScreenItem:ContextMenuItem = new ContextMenuItem("Toggle Full Screen");
			myContextMenu.customItems.push(fullScreenItem);
			fullScreenItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, onFullScreenContextMenuSelect);

			// stage alignment for navigating an overdrawn window
			var alignTopItem:ContextMenuItem = new ContextMenuItem("Align to Top");
			myContextMenu.customItems.push(alignTopItem);
			alignTopItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, onAlignTop);	

			var alignCenterItem:ContextMenuItem = new ContextMenuItem("Align to Center");
			myContextMenu.customItems.push(alignCenterItem);
			alignCenterItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, onAlignCenter);	
			
			var alignBottomItem:ContextMenuItem = new ContextMenuItem("Align to Bottom");
			myContextMenu.customItems.push(alignBottomItem);
			alignBottomItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, onAlignBottom);				
			
			contextMenu = myContextMenu;
			
			if (settings.startFullScreen) {
				toggleFullScreen();
			}
			
			// inactivity timer
			inactivityTimer = new InactivityTimer(stage, settings.inactivityTimeout);
			inactivityTimer.addEventListener(InactivityEvent.INACTIVE, onInactive);
			
			// Mouse Hiding
			// This is ridiculous
			var cursorData:MouseCursorData = new MouseCursorData();
			var cursorBitmaps:Vector.<BitmapData> = new Vector.<BitmapData>(1, true);
			cursorBitmaps[0] = new BitmapData(1, 1, true, 0x000000ff);
			cursorData.data = cursorBitmaps;
			Mouse.registerCursor('hidden', cursorData);
		}
		
		private function onInactive(e:InactivityEvent):void {
			trace("inactive!");
			view.inactivityOverlayView();
		}
		
		private var firstTime:Boolean = true;
		private function onDatabaseLoaded(e:Event):void {
			
			if (firstTime) {
				firstTime = false;
				
				// set active debate to first in list
				// set the active debate to the first one
				
				
				
				for (var debateID:String in CDW.database.debates) {			
					CDW.state.setActiveDebate(debateID);
					break;
				}
				
				trace("database loaded");
				
				// set up test overlay
				testOverlay = new Bitmap(new BitmapData(1080, 1920));
				testOverlay.visible = false;
				testOverlay.alpha = 0.5;			
				
				// create the view, this is where
				// all of the visuals come from
				view = new View();
				addChild(view);
				
				// set the starting view
				if(database.getDebateCount() > 0) {
					view.homeView();
				}
				else {
					view.noOpinionView();
				}
				
				// FPS meter
				var fps:FPSMeter = new FPSMeter(this, stage.stageWidth - 50, 0);		
				
				if (settings.halfSize) {
					fps.scaleX = 2;
					fps.scaleY = 2;			
					fps.x = stage.stageWidth - 100;
					fps.y = -5;	
				}
				
				// Add test overlay
				addChild(testOverlay);				
							
			}
			else {
				trace('updated db')
				// set the starting view
				CDW.state.setActiveDebate(CDW.state.activeDebate);
				view.debateStrip.update();
				
				if(database.getDebateCount() > 0) {
					view.homeView();
				}
				else {
					view.noOpinionView();
				}
			}
			

		}
		
		
		private function onAlignTop(e:Event):void {
			stage.align = StageAlign.TOP;	
		}
		
		private function onAlignCenter(e:Event):void {
			stage.align = StageAlign.LEFT;			
		}
		
		private function onAlignBottom(e:Event):void {
			stage.align = StageAlign.BOTTOM;			
		}		

		private function onFullScreenContextMenuSelect(e:Event):void {
			toggleFullScreen();
		}
		
		private function toggleFullScreen():void {
			if (stage.displayState == StageDisplayState.NORMAL) {
				stage.displayState = StageDisplayState.FULL_SCREEN;
				Mouse.cursor = "hidden";
				Mouse.hide();
			}
			else {
				stage.displayState = StageDisplayState.NORMAL;
				Mouse.cursor = MouseCursor.ARROW;
				Mouse.show();
			}
		}
		
		
		
	}
}
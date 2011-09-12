package com.civildebatewall {

	import com.bit101.components.FPSMeter;
	import com.civildebatewall.blocks.*;
	import com.civildebatewall.camera.*;
	import com.civildebatewall.data.Database;
	import com.civildebatewall.elements.*;
	import com.civildebatewall.keyboard.*;
	import com.civildebatewall.ui.*;
	import com.greensock.*;
	import com.greensock.easing.*;
	import com.greensock.plugins.*;
	
	import flash.desktop.NativeApplication;
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	import flash.ui.Mouse;
	
	// Greensock plugins
	TweenPlugin.activate([ThrowPropsPlugin]);
	TweenPlugin.activate([MotionBlurPlugin]);			
	TweenPlugin.activate([CacheAsBitmapPlugin]);	
	TweenPlugin.activate([TransformAroundCenterPlugin]);
	FastEase.activate([Linear, Quad, Cubic, Quart, Quint, Strong]);
	
	public class CDW extends Sprite {
		
		public static var ref:CDW;
		public static var database:Database;
		public static var dashboard:Dashboard;
		public static var state:State;
		public static var settings:Object;
		public static var view:View;
		public static var testOverlay:Bitmap;
		public static var inactivityTimer:InactivityTimer;
		
		private var fps:FPSMeter;
		
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
			dashboard.visible = false;
			
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
			
			var toggleDashboardItem:ContextMenuItem = new ContextMenuItem("Toggle Dashboard");
			myContextMenu.customItems.push(toggleDashboardItem);
			toggleDashboardItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, onToggleDashboard);
			
			var toggleSMSButtonItem:ContextMenuItem = new ContextMenuItem("Toggle SMS Button");
			myContextMenu.customItems.push(toggleSMSButtonItem);
			toggleSMSButtonItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, onToggleSMSButton);						
			
			var toggleFPSItem:ContextMenuItem = new ContextMenuItem("Toggle FPS");
			myContextMenu.customItems.push(toggleFPSItem);
			toggleFPSItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, onToggleFPS);			
			
			var quitItem:ContextMenuItem = new ContextMenuItem("Quit");
			myContextMenu.customItems.push(quitItem);
			quitItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, onQuitSelect);				
						
			
			contextMenu = myContextMenu;
			
			if (settings.startFullScreen)	toggleFullScreen();
			
			// inactivity timer
			inactivityTimer = new InactivityTimer(stage, settings.inactivityTimeout);
			inactivityTimer.addEventListener(InactivityEvent.INACTIVE, onInactive);
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
				CDW.state.setActiveDebate(CDW.database.threads[0]);
				CDW.state.activeThreadID = CDW.state.activeThread.id; 
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
				if (database.threads.length >  0) {
					view.homeView();
				}
				else {
					view.noOpinionView();					
				}
				
				
				// FPS meter
				fps = new FPSMeter(this, stage.stageWidth - 50, 0);		
				fps.visible = false;
				
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
				
				if (CDW.state.userIsResponding) {
					// go to post to which you responded
					CDW.state.setActiveDebate(CDW.database.getThreadByID(CDW.state.activeThreadID));
				}
				else {
					// go to latest post
					CDW.state.setActiveDebate(CDW.database.threads[0]);
					CDW.state.activeThreadID = CDW.state.activeThread.id;					
				}
				
				view.debateStrip.update();
				view.statsOverlay.update();
				view.debateOverlay.update();
				
				
				if (CDW.state.userIsResponding) {
					// jump to debate overlay
					view.debateOverlayView(); // TODO put scroll-to functionality in debate overlay (checks for active post)
				}
				else {
					// jump to home view					
			  	database.threads.length > 0 ? view.homeView() : view.noOpinionView();
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
				stage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;
				Mouse.hide();
			}
			else {
				stage.displayState = StageDisplayState.NORMAL;
				Mouse.show();
			}
		}
		
		private function onToggleSMSButton(e:Event):void {
			if(CDW.view.skipTextButton.alpha == 1) {
				CDW.view.skipTextButton.alpha = 0;
				CDW.view.skipTextButton.setOnClick(null);								
			}
			else {
				CDW.view.skipTextButton.alpha = 1;
				CDW.view.skipTextButton.setOnClick(CDW.view.simulateSMS);				
			}
		}
		
		private function onToggleDashboard(e:Event):void {
			dashboard.visible = !dashboard.visible;
		}
		
		private function onToggleFPS(e:Event):void {
			fps.visible = !fps.visible;
		}		
		
		private function onQuitSelect(e:Event):void {
			NativeApplication.nativeApplication.exit();
		}

	}
}
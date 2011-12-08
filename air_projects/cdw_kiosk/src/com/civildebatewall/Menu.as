package com.civildebatewall {

	import com.kitschpatrol.futil.utilitites.PlatformUtil;
	
	import flash.desktop.NativeApplication;
	import flash.display.StageAlign;
	import flash.events.ContextMenuEvent;
	import flash.ui.ContextMenu;
	import flash.ui.ContextMenuItem;
	
	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.getLogger;

	// Custom context menu controls for on-site Kiosk administration.
	public class Menu	{
		
		private static const logger:ILogger = getLogger(Menu);
		
		public static function getMenu():ContextMenu {
			
			// set up a full screen option in the context menu
			var myContextMenu:ContextMenu = new ContextMenu();

			var demoSequenceAItem:ContextMenuItem = new ContextMenuItem("Demo Sequence A");
			myContextMenu.customItems.push(demoSequenceAItem);
			demoSequenceAItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, onDemoSequenceAContextMenuSelect);
			
			var demoSequenceBItem:ContextMenuItem = new ContextMenuItem("Demo Sequence B");
			myContextMenu.customItems.push(demoSequenceBItem);
			demoSequenceBItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, onDemoSequenceBContextMenuSelect);			
			
			var fullScreenItem:ContextMenuItem = new ContextMenuItem("Toggle Full Screen");
			myContextMenu.customItems.push(fullScreenItem);
			fullScreenItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, onFullScreenContextMenuSelect);
			
			var toggleDashboardItem:ContextMenuItem = new ContextMenuItem("Toggle Dashboard");
			myContextMenu.customItems.push(toggleDashboardItem);
			toggleDashboardItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, onToggleDashboard);			
			
			// stage alignment for navigating an overdrawn window
			// only use this when testing on a mac with a screen that's too small to show the whole thing
			if (!CivilDebateWall.settings.halfSize && PlatformUtil.isMac) {
				var alignTopItem:ContextMenuItem = new ContextMenuItem("Align to Top");
				myContextMenu.customItems.push(alignTopItem);
				alignTopItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, onAlignTop);	
				
				var alignCenterItem:ContextMenuItem = new ContextMenuItem("Align to Center");
				myContextMenu.customItems.push(alignCenterItem);
				alignCenterItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, onAlignCenter);	
				
				var alignBottomItem:ContextMenuItem = new ContextMenuItem("Align to Bottom");
				myContextMenu.customItems.push(alignBottomItem);
				alignBottomItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, onAlignBottom);				
			}
			
			var quitItem:ContextMenuItem = new ContextMenuItem("Quit");
			myContextMenu.customItems.push(quitItem);
			quitItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, onQuitSelect);
			
			var quitAllItem:ContextMenuItem = new ContextMenuItem("Quit All");
			myContextMenu.customItems.push(quitAllItem);
			quitAllItem.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, onQuitAllSelect);	
			
			return myContextMenu;
		}
		
		private static function onDemoSequenceAContextMenuSelect(e:ContextMenuEvent):void {
			CivilDebateWall.self.playSequenceA();
		}
		
		private static function onDemoSequenceBContextMenuSelect(e:ContextMenuEvent):void {
			CivilDebateWall.self.playSequenceB();			
		}		
		
		private static function onAlignTop(e:ContextMenuEvent):void {
			CivilDebateWall.self.stage.align = StageAlign.TOP;	
		}
		
		private static function onAlignCenter(e:ContextMenuEvent):void {
			CivilDebateWall.self.stage.align = StageAlign.LEFT;			
		}
		
		private static function onAlignBottom(e:ContextMenuEvent):void {
			CivilDebateWall.self.stage.align = StageAlign.BOTTOM;			
		}		
		
		private static function onFullScreenContextMenuSelect(e:ContextMenuEvent):void {
			toggleFullScreen();
		}
		
		private static function toggleFullScreen():void {
			CivilDebateWall.self.toggleFullScreen();
		}
		
		private static function onToggleDashboard(e:ContextMenuEvent):void {
			CivilDebateWall.dashboard.visible = !CivilDebateWall.dashboard.visible;
		}
		
		private static function onQuitSelect(e:ContextMenuEvent):void {
			logger.info("Qutting this screen intentionally");
			NativeApplication.nativeApplication.exit();
		}		
		
		private static function onQuitAllSelect(e:ContextMenuEvent):void {
			logger.info("Qutting all screens intentionally");
			CivilDebateWall.flashSpan.quitAll();
		}
		
	}
}
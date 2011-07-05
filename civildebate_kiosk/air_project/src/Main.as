package  {
	import com.bit101.components.FPSMeter;
	
	import flash.desktop.*;
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.text.engine.*;
	import flash.ui.*;
	
	import flashx.textLayout.formats.*;
	
	import net.localprojects.*;
	import net.localprojects.blocks.*;
	import net.localprojects.pages.*;
	
	import org.velluminous.keyboard.AlphabeticKeyboard;
	import org.velluminous.keyboard.KeyButtonEvent;

	[SWF(width="1080", height="1920", frameRate="60")]
	public class Main extends Sprite {		
		// some globals
		public static var mainRef:Main;
		public static var stageRef:Stage;
		public static var stageWidth:Number;
		public static var stageHeight:Number;
		public static var mouseX:int;
		public static var mouseY:int;
		
		// pages (move to view class)
		public static var homePage:Page;
		public static var portraitPage:Page;
		public static var reviewOpinionPage:Page;
		public static var resultsPage:Page;		
		
		// blocks (move to view class)
		public static var header:Header = new Header();
		public static var debatePicker:DebatePicker = new DebatePicker();
		public static var question:Question = new Question();
		public static var faceOff:FaceOff = new FaceOff();
		
		// kiosk state
		public static var state:State;
		
		// page management
		public var pages:Array = new Array();
		public var activePage:String;
		
		public function Main() {
			init();
		}
		
		private function init():void {
			mainRef = this;
			
			// set up stage
			this.stage.quality = StageQuality.BEST;
			this.stage.scaleMode = StageScaleMode.EXACT_FIT;			
			
			// set the globals
			stageWidth= this.stage.stageWidth;
			stageHeight = this.stage.stageHeight;
			stageRef = this.stage;
			
			// background fill
			graphics.beginFill(0x000000);
			graphics.drawRect(0, 0, 1080, 1920);
			graphics.endFill();
			

			homePage = new HomePage();
			portraitPage  = new PhotoBooth();
			reviewOpinionPage = new ReviewOpinionPage();
			resultsPage = new ResultsPage;
			
			// set initial view
			state = new State();	
			state.addEventListener(State.VIEW_CHANGE, onViewChange);			
			state.setView(new PhotoBooth());
			
			// temporarily squish screen for laptop development (half size)
			//stage.nativeWindow.width = 540;
			//stage.nativeWindow.height = 960;
		//	stage.nativeWindow.width = 1080;
		//	stage.nativeWindow.height = 1920;			
			
			
			// Set up some placeholder menus
			//			var mainMenu:NativeMenuItem = new NativeMenuItem("CDB");
			//			var menu:NativeMenu = new NativeMenu();
			//			menu.addItem(mainMenu);
			//			
			//			if (NativeApplication.supportsMenu)	{
			//				NativeApplication.nativeApplication.menu = menu;
			//			} 
			//			else if (NativeWindow.supportsMenu) {
			//				// TODO TEST ON WINDOWS
			//				stage.nativeWindow.menu = menu;
			//			}
			
			
			addEventListener(Event.ENTER_FRAME, update);		

			//			var keyboard:AlphabeticKeyboard = new AlphabeticKeyboard();
			//			keyboard.addEventListener(KeyButtonEvent.RELEASE, onKeyUp);
			//			keyboard.scaleX = .5;
			//			keyboard.scaleY = .5;			
			//			addChild(keyboard);			
			
			
			
			
			// Show FPS
			var fpsBackground:Shape = new Shape();
			fpsBackground.graphics.beginFill(0);
			fpsBackground.graphics.drawRect(stage.stageWidth - 100, stage.stageHeight - 50, 100, 50);
			fpsBackground.graphics.endFill();
			addChild(fpsBackground);
			
			var fps:FPSMeter = new FPSMeter(this, (stage.stageWidth - 100) + 5, (stage.stageHeight - 50) + 5);
			fps.scaleX = 2;
			fps.scaleY = 2;
			
			
			// set up a full screen option in the context menu
			var myContextMenu:ContextMenu = new ContextMenu();
			var item:ContextMenuItem = new ContextMenuItem("Toggle Full Screen");
			myContextMenu.customItems.push(item);
			item.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, onFullScreenContextMenuSelect);
			contextMenu = myContextMenu;
			
			
//			this.rotation = -90;
//			this.y = 1920;
//			this.width = 1080;
			
		}
		
		private function onKeyUp(e:KeyButtonEvent):void {
			trace("up!");
			trace(e.data);
		}
		
		// create views class!!!
		private function onViewChange(e:Event):void {
			trace("view changed");
			
			// clear everything
			if ((state.getLastView() != null) && contains(state.getLastView())) {
				removeChild(state.getLastView());
			}
			
			addChild(state.getView());
		}


		public function update(e:Event):void {
			Main.mouseX = this.mouseX;
			Main.mouseY = this.mouseY;
			//trace(Main.mouseX);			
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
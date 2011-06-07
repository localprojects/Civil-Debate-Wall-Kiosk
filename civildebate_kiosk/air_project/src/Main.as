package  {
	import flash.desktop.NativeApplication;
	import flash.display.NativeMenu;
	import flash.display.NativeMenuItem;
	import flash.display.NativeWindow;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.Event;
	import flash.display.StageScaleMode;
	import flash.display.StageQuality;
	import flash.display.Shape;
	
	import net.localprojects.PortraitCamera;
	import net.localprojects.Assets;
	
	import com.bit101.components.PushButton;
	
	[SWF(width="540", height="960", backgroundColor="0x2f3439", frameRate="60")]
	public class Main extends Sprite {
		
		private var photoBooth:PortraitCamera;
		
		// some globals
		public static var stageRef:Stage;
		public static var stageWidth:Number;
		public static var stageHeight:Number;		
		
		public function Main() {

			// set up stage
			this.stage.quality = StageQuality.BEST;
			this.stage.scaleMode = StageScaleMode.NO_SCALE;			
			
			// set the globals
			stageWidth= this.stage.stageWidth;
			stageHeight = this.stage.stageHeight;
			stageRef = this.stage;			

			// 
			photoBooth = new PortraitCamera();
			photoBooth.x = (stageWidth - photoBooth.width) / 2;
			photoBooth.y = 150;
			addChild(photoBooth);
			
			
			// header
			var header:Shape = new Shape();
			header.graphics.beginFill(0x97999b);
			header.graphics.drawRect(0, 0, Main.stageWidth, 60);
			header.graphics.endFill();
			addChild(header);
			
			
			
			// footer
			var footer:Shape = new Shape();
			header.graphics.beginFill(0x97999b);
			header.graphics.drawRect(0, Main.stageHeight - 60, Main.stageWidth, 60);
			header.graphics.endFill();
			addChild(header);			
			
			
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
			
			
			addEventListener(Event.ENTER_FRAME, firstFrame);
		}
		
		public function firstFrame(e:Event):void {
//			removeEventListener(Event.ENTER_FRAME, firstFrame);			
//			trace("first frame");
//

//			
//			// fill out the stage
//			this.graphics.beginFill(0xff0000);
//			this.graphics.drawRect(0, 0, appWidth, appHeight);
//			this.graphics.endFill();			
//			
			
			addEventListener(Event.ENTER_FRAME, update);			
		}		
		
		public function update(e:Event):void {
	
		}
		
	}
}
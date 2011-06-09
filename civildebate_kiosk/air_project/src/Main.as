package  {
	import flash.desktop.NativeApplication;
	import flash.display.DisplayObject;
	import flash.display.NativeMenu;
	import flash.display.NativeMenuItem;
	import flash.display.NativeWindow;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.display.StageQuality;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.engine.FontWeight;
	
	import flashx.textLayout.formats.TextAlign;
	
	import net.localprojects.Assets;
	import net.localprojects.FixedLabel;
	import net.localprojects.PortraitCamera;
	import net.localprojects.TextBoxLayoutFormat;
	import net.localprojects.pages.AttractLoop;
	import net.localprojects.pages.HomePage;
	import net.localprojects.pages.Page;
	
	import org.hamcrest.mxml.object.Null;

	
	
	[SWF(width="540", height="960", backgroundColor="0x2f3439", frameRate="60")]
	public class Main extends Sprite {
		
		private var photoBooth:PortraitCamera;
		
		// some globals
		public static var mainRef:Main;
		public static var stageRef:Stage;
		public static var stageWidth:Number;
		public static var stageHeight:Number;
		public static var mouseX:int;
		public static var mouseY:int;		
		
		
		
		// page management
		private var pages:Array = new Array();
		public var activePage:String;
		
		
		public function Main() {

			mainRef = this;
			
			// set up stage
			this.stage.quality = StageQuality.BEST;
			this.stage.scaleMode = StageScaleMode.NO_SCALE;			
			
			// set the globals
			stageWidth= this.stage.stageWidth;
			stageHeight = this.stage.stageHeight;
			stageRef = this.stage;			

			// background fill
			graphics.beginFill(0xffffff);
			graphics.drawRect(0, 0, stageWidth, stageHeight);
			graphics.endFill();
			

			// header
			var header:Sprite = new Sprite();
			header.graphics.beginFill(0x97999b);
			header.graphics.drawRect(0, 0, Main.stageWidth, 50);
			header.graphics.endFill();
			addChild(header);

			// header title text
			var format:TextBoxLayoutFormat = new TextBoxLayoutFormat();
			format.boundingWidth = 250;
			format.boundingHeight = 20;
			format.fontFamily = "Helvetica";
			format.fontSize = 14;
			format.color = 0xffffff;
			format.fontWeight = FontWeight.BOLD;
			format.showSpriteBackground = false;			
			
			var title:FixedLabel = new FixedLabel("GREAT CIVIL DEBATE WALL", format);
			title.x = 15;
			title.y = 18;
			header.addChild(title);			
			
			// header vote counter
			format.fontSize = 10;
			format.boundingWidth = 50;
			format.boundingHeight = 25;			
			
			var counterLabel:FixedLabel = new FixedLabel("TOTAL\nVOTES", format);
			counterLabel.x = stageWidth - 50;
			counterLabel.y = 14;
			header.addChild(counterLabel);
			
			format.fontSize = 25;
			format.boundingWidth = 200;
			format.boundingHeight = 25;
			format.textAlign = TextAlign.RIGHT;
			
			var counter:FixedLabel = new FixedLabel("#,###", format);
			counter.x = stageWidth - 258;
			counter.y = 14;
			header.addChild(counter);			
			
			// footer
			var footer:Shape = new Shape();
			footer.graphics.beginFill(0x97999b);
			footer.graphics.drawRect(0, Main.stageHeight - 60, Main.stageWidth, 60);
			footer.graphics.endFill();
			addChild(footer);
			
			// views
			pages = [
				new AttractLoop(),
				new HomePage()
			];
			
			// start on attract page
			goToPage("attract");
			
			
			
			
//			photoBooth = new PortraitCamera();
//			photoBooth.x = (stageWidth - photoBooth.width) / 2;
//			photoBooth.y = 150;
//			addChild(photoBooth);
						
			

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
			
			
		}
		
		

		
		
		public function goToPage(targetName:String):void {
			// todo tweening and other nice things
			
			for (var i:int = 0; i < pages.length; i++) {
				
				// remove any existing pages (better to show / hide)
				
				// not the one, remove it
				
				if (this.contains(pages[i]) && (pages[i].name !== targetName)) {
					this.removeChild(pages[i]);
				}
				
				
				if (pages[i].name == targetName) {
					this.addChild(pages[i]);
				}
				
			}
			
			// add the one we want
			
			
			
			
			// hide everything
			
		}


		
		public function update(e:Event):void {
			
			Main.mouseX = this.mouseX;
			Main.mouseY = this.mouseY;
			trace(Main.mouseX);			
		}
		
	}
}
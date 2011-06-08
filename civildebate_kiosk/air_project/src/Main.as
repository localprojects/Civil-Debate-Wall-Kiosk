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
	import flash.geom.Rectangle;
	
	import net.localprojects.Assets;
	import net.localprojects.FixedLabel;
	import net.localprojects.PortraitCamera;
	import net.localprojects.TextBoxLayoutFormat;
	
	import flash.text.engine.FontWeight;
	import flashx.textLayout.formats.TextAlign;
	
	
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

			// background fill
			graphics.beginFill(0xffffff);
			graphics.drawRect(0, 0, stageWidth, stageHeight);
			graphics.endFill();
			
			
			photoBooth = new PortraitCamera();
			photoBooth.x = (stageWidth - photoBooth.width) / 2;
			photoBooth.y = 150;
			addChild(photoBooth);
			
			
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
			counter.y = 12;
			header.addChild(counter);			
			

			// footer
			var footer:Shape = new Shape();
			footer.graphics.beginFill(0x97999b);
			footer.graphics.drawRect(0, Main.stageHeight - 60, Main.stageWidth, 60);
			footer.graphics.endFill();
			addChild(footer);
			

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
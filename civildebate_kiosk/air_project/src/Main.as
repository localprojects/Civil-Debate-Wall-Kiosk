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
			var header:Shape = new Shape();
			header.graphics.beginFill(0x97999b);
			header.graphics.drawRect(0, 0, Main.stageWidth, 60);
			header.graphics.endFill();
			addChild(header);
			

			// footer
			var footer:Shape = new Shape();
			footer.graphics.beginFill(0x97999b);
			footer.graphics.drawRect(0, Main.stageHeight - 60, Main.stageWidth, 60);
			footer.graphics.endFill();
			addChild(footer);
			
			
			
			var label:FixedLabel = new FixedLabel("testing");
			label.x = 0;
			label.y = 0;
			addChild(label);
			
			graphics.beginFill(0xff0000);
			graphics.drawRect(0, 0, 20, 20);
			graphics.endFill();					
			
			
			// using the new FTE (Flash Text Engine) API
			// http://help.adobe.com/en_US/ActionScript/3.0_ProgrammingAS3/WS6C0BB8ED-2805-467a-9C71-F9D757F33FB6.html			
//			var factory:StringTextLineFactory = new StringTextLineFactory();
//			factory.compositionBounds = new Rectangle( 100, 100, 200, 130 );
//			var format2:TextLayoutFormat = new TextLayoutFormat();
//			format2.fontFamily = "Helvetica, Arial, _sans";
//			format2.fontSize = 20;
//			format2.color = 0xff0000;
//			format2.textAlpha = 1;
//			
//			factory.spanFormat = format2;
//			factory.text = "The quick brown fox jumped over the lazy dog.";
//			factory.createTextLines(useTextLines);
//			factory.compositionBounds = new Rectangle( 0, 0, stageWidth, 130 );			
//			
//			factory.createTextLines(useTextLines);
			
			
			
//				var bounds:Rectangle = new Rectangle(10, 10, this.width, this.height);
//				
//				var paragraphFormat:ParagraphFormat = new ParagraphFormat();
//				paragraphFormat.direction = Direction.LTR;
//				
//				var characterFormat:CharacterFormat = new CharacterFormat();
//				characterFormat.fontSize = 18;
//				
//				// for embedding
//				//characterFormat.fontFamily = AFont.NAME;
//				//characterFormat.fontLookup = flash.text.engine.FontLookup.EMBEDDED_CFF;
//				//characterFormat.renderingMode = flash.text.engine.RenderingMode.CFF;
//				
//				
//				StringTextLineFactory.createTextLinesFromString(addTextLineToContainer, "copy goes here", bounds, characterFormat, paragraphFormat);
//			
//			

			
			
			
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
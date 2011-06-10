package  {
	import flash.desktop.*;
	import flash.display.*;
	import flash.events.*;
	import flash.geom.*;
	import flash.text.engine.*;
	
	import flashx.textLayout.formats.*;
	
	import net.localprojects.*;
	import net.localprojects.pages.*;	

	[SWF(width="540", height="960", backgroundColor="0x2f3439", frameRate="60")]
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
		
		// kiosk state
		public static var state:State;
		
		// page management
		public var pages:Array = new Array();
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
			
			
			homePage = new HomePage();
			portraitPage  = new PortraitPage();
			reviewOpinionPage = new ReviewOpinionPage();
			resultsPage = new ResultsPage;
			
			
			// set initial view
			state = new State();	
			state.addEventListener(State.VIEW_CHANGE, onViewChange);			
			state.setView(new HomePage());
			

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
		
	}
}
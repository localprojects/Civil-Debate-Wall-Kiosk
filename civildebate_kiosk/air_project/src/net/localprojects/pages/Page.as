package net.localprojects.pages {
	import flash.display.Sprite;
	import flash.text.engine.FontWeight;
	
	import net.localprojects.FixedLabel;
	import net.localprojects.TextBoxLayoutFormat;

	// basic class for views
	
	
	public class Page extends Sprite {
		
		private var titleText:FixedLabel;
		private var placeholderText:FixedLabel;
		public var blocks:Array;
		
		
		import flashx.textLayout.formats.TextAlign;		
		
		
		
		public function Page() {
			super();
			blocks = new Array();
			titleText = null;	
		}
		
		public function setTitle(text:String):void {
		
			var format:TextBoxLayoutFormat = new TextBoxLayoutFormat();
			format.boundingWidth = Main.stageWidth;
			format.boundingHeight = 35;
			format.fontFamily = "Helvetica";
			format.fontSize = 16;
			format.color = 0x97999b;
			format.fontWeight = FontWeight.BOLD;
			format.textAlign = TextAlign.CENTER;
			format.showSpriteBackground = false;
			
			
			if (titleText == null) {
				titleText = new FixedLabel(text, format);
				addChild(titleText);
				
			}
			else {
				titleText.setText(text);
				titleText.update();
			}
			
			titleText.y = 75;
		}
		
		public function setPlaceholderText(text:String):void {
			var format:TextBoxLayoutFormat = new TextBoxLayoutFormat();
			format.boundingWidth = Main.stageWidth;
			format.boundingHeight = 100;
			format.fontFamily = "Helvetica";
			format.fontSize = 40;
			format.color = 0xcc0000;
			format.fontWeight = FontWeight.BOLD;
			format.textAlign = TextAlign.CENTER;
			format.showSpriteBackground = false;
			
			
			if (placeholderText == null) {
				placeholderText = new FixedLabel(text, format);
				addChild(placeholderText);
				
			}
			else {
				placeholderText.setText(text);
				placeholderText.update();
			}
			
			placeholderText.y = Main.stageHeight * 0.7;			
		}
		
		
	}
}
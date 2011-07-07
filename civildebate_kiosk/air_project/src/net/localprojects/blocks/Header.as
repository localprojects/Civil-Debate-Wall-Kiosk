package net.localprojects.blocks {
	import flash.display.Sprite;
	import flash.text.*;
	
	import net.localprojects.Assets;
	
	public class Header	extends Sprite {
		
		// blocks are chunks of a view shared across pages, put blocks together to make a page
		
		// TODO create block interface or base class (singletons?)
		public function Header() {
			init();
		}
		
		private function init():void {
			// background			
			addChild(Assets.headerBackground);
			Assets.headerBackground.x = 30;
			Assets.headerBackground.y = 30;			
			
			// text
			var textFormat:TextFormat = new TextFormat();
			textFormat.bold = true;			
			textFormat.font =  Assets.FONT_REGULAR;
			textFormat.align = TextFormatAlign.CENTER;
			textFormat.size = 36;
			
			
			// button label
			var title:TextField = new TextField();
			title.defaultTextFormat = textFormat;
			title.embedFonts = true;
			title.selectable = false;
			title.multiline = false;
			title.cacheAsBitmap = false;
			title.mouseEnabled = false;			
			title.autoSize = TextFieldAutoSize.CENTER;
			title.gridFitType = GridFitType.NONE;
			title.antiAliasType = AntiAliasType.NORMAL;
			title.textColor = 0xffffff;
			title.text = "The Great Civil Debate Wall".toUpperCase();
			title.x = Assets.headerBackground.x + (width - title.width) / 2;
			title.y = Assets.headerBackground.y + ((height - title.height) / 2) + 2;
			
			addChild(title);
		}
	}
}
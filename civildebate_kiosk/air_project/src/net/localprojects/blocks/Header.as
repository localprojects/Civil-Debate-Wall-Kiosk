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
			graphics.beginBitmapFill(Assets.headerBackground.bitmapData);
			graphics.drawRect(0, 0, 1080, 115);
			graphics.endFill();
			
			// text
			var textFormat:TextFormat = new TextFormat();
			textFormat.font =  Assets.BUTTON_FONT;
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
			title.x = (width - title.width) / 2;
			title.y = ((height - title.height) / 2) + 6;
			
			addChild(title);
		}
	}
}
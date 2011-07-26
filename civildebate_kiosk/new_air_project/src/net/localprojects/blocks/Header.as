package net.localprojects.blocks
{
	import flash.display.*;
	import net.localprojects.*;
	import flash.text.*;
	
	public class Header extends BlockBase	{
		
		public function Header()	{
			super();
			init();
		}
		
		public function init():void {
			// background			
			var background:Bitmap = Assets.getHeaderBackground();
			addChild(background);			
			
			// text
			var textFormat:TextFormat = new TextFormat();
			textFormat.bold = true;			
			textFormat.font = Assets.FONT_REGULAR;
			textFormat.align = TextFormatAlign.CENTER;
			textFormat.size = 36;
			
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
			title.x = background.x + (width - title.width) / 2;
			title.y = background.y + ((height - title.height) / 2) + 2;
			
			addChild(title);
		}
			
	}
}
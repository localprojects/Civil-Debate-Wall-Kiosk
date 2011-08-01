package net.localprojects.blocks
{
	import flash.display.*;
	import net.localprojects.*;
	import flash.text.*;
	
	public class DebateOverlay extends BlockBase	{
		
		public function DebateOverlay()	{
			super();
			init();
		}
		
		public function init():void {
			this.graphics.beginFill(0xff0000);
			this.graphics.drawRect(0, 0, 1022, 807);
			this.graphics.endFill();
			
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
			title.text = "Debate overlay";
			addChild(title);			
			Utilities.centerWithin(title, this);
		}
		
	}
}
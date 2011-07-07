package net.localprojects.elements {
	import flash.display.*;
	import flash.text.*;
	import net.localprojects.*;
	
	public class BlockLabel extends Sprite {
		
		private var backgroundColor:uint;
		
		public function BlockLabel() {
			super();
			
			
			backgroundColor = 0xff0000;
			
		
			var textFormat:TextFormat = new TextFormat();
			textFormat.bold = true;
			textFormat.font =  Assets.FONT_REGULAR;
			textFormat.align = TextFormatAlign.LEFT;
			textFormat.size = 36;
			textFormat.leftMargin = 30;
			textFormat.rightMargin = 30;			
			
			var labelText:TextField = new TextField();
			labelText.defaultTextFormat = textFormat;
			labelText.embedFonts = true;
			labelText.selectable = false;
			labelText.multiline = true;
			labelText.cacheAsBitmap = false;
			labelText.mouseEnabled = false;
			labelText.backgroundColor = backgroundColor;
			labelText.background = true;
			labelText.gridFitType = GridFitType.NONE;
			labelText.antiAliasType = AntiAliasType.NORMAL;
			labelText.textColor = 0;
			labelText.width = 300;
			labelText.autoSize = TextFieldAutoSize.LEFT;
			labelText.wordWrap = true;
			labelText.text = "LOREM IPSUM DOLOR SIT AMET PLURBIS UNUM";
			
						
			
			addChild(labelText);				
			
		}
	}
}
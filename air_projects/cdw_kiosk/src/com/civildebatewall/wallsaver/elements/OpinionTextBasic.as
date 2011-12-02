package com.civildebatewall.wallsaver.elements {
	import com.civildebatewall.Assets;
	
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextInteractionMode;
	
	// work around for windows disappearing text glitches (showing up on some screens, not on others)
	// replaces nicer block text approach, see OpinionRow.as in commit 95987b83129902d1c3eb009556649df484f2fbd5 for example
	public class OpinionTextBasic extends TextField	{
		
		public function OpinionTextBasic(text:String) {
			super();
			
			var textFormat:TextFormat = new TextFormat();
			textFormat.font = Assets.FONT_REGULAR;
			textFormat.size = 50.5;
			textFormat.color = 0xffffff;			
			textFormat.rightMargin = 110 / 4;
			textFormat.leftMargin = 110 / 4;
			
			
			
			multiline = false;
			selectable = false;
			embedFonts = true;
			multiline = true;
			antiAliasType = AntiAliasType.NORMAL;
			embedFonts = true;
			defaultTextFormat = textFormat;			
			autoSize = TextFieldAutoSize.LEFT;
			
			text = text;

			scaleX = 4;
			scaleY = 4;			
		}
	}
}
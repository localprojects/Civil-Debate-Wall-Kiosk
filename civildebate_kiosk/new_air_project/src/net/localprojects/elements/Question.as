package net.localprojects.elements {
	import flash.display.*;
	import flash.text.*;
	
	import net.localprojects.Assets;
	import net.localprojects.blocks.BlockBase;
	
	public class Question extends BlockBase {
		
		private var questionText:TextField;
		
		public function Question() {
			super();
			init();
		}
		
		public function init():void {
			
			// text
			// TODO get this from the state and move to update function
			var textFormat:TextFormat = new TextFormat();
			textFormat.font =  Assets.FONT_HEAVY;
			textFormat.align = TextFormatAlign.CENTER;
			textFormat.size = 37;
			textFormat.letterSpacing = -0.25;
			textFormat.leading = 4;
			
			questionText = new TextField();
			questionText.defaultTextFormat = textFormat;
			questionText.embedFonts = true;
			questionText.selectable = false;
			questionText.multiline = true;
			questionText.cacheAsBitmap = false;
			questionText.mouseEnabled = false;			
			questionText.gridFitType = GridFitType.NONE;
			questionText.antiAliasType = AntiAliasType.NORMAL;
			questionText.textColor = 0x414042;
			questionText.width = 1022;
			questionText.wordWrap = true;			
			setText('Question goes here');
			
			addChild(questionText);	
		}
		
		override public function setText(s:String, instant:Boolean = false):void {
			questionText.text = s;
		}
		
	}
}
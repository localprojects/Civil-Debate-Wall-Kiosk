package net.localprojects.blocks {
	import flash.display.*;
	import flash.text.*;
	
	import net.localprojects.Assets;
	
	public class Question extends Block {
		
		private var questionText:TextField;
		
		public function Question() {
			super();
			init();
		}
		
		public function init():void {
			
			// text
			// TODO get this from the state and move to update function
			var textFormat:TextFormat = new TextFormat();
			textFormat.bold = true;
			textFormat.font =  Assets.FONT_REGULAR;
			textFormat.align = TextFormatAlign.CENTER;
			textFormat.size = 36;
			
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
			//questionText.y = ((height - questionText.height) / 2) + 6;			
			setText('Question goes here');
			
			addChild(questionText);	
		}
		
		public function setText(s:String):void {
			questionText.text = s;
		}
		

		
	}
}
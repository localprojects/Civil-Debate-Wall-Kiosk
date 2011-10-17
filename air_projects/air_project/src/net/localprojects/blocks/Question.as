package net.localprojects.blocks {
	import flash.display.Sprite;
	import flash.text.*;	
	import net.localprojects.Assets;
	
	public class Question extends Block {
		public function Question() {
			super();
			init();
		}
		
		private function init():void {
			
			// text
			// TODO get this from the state and move to update function
			var textFormat:TextFormat = new TextFormat();
			textFormat.bold = true;
			textFormat.font =  Assets.FONT_REGULAR;
			textFormat.align = TextFormatAlign.CENTER;
			textFormat.size = 36;
			
			var questionText:TextField = new TextField();
			questionText.defaultTextFormat = textFormat;
			questionText.embedFonts = true;
			questionText.selectable = false;
			questionText.multiline = true;
			questionText.cacheAsBitmap = false;
			questionText.mouseEnabled = false;			
			questionText.gridFitType = GridFitType.NONE;
			questionText.antiAliasType = AntiAliasType.NORMAL;
			questionText.textColor = 0x414042;
			questionText.width = 1080;
			questionText.wordWrap = true;
			questionText.text = "\u201C Do you feel our public education provides our children with a very thorough education? \u201D";
			//questionText.y = ((height - questionText.height) / 2) + 6;			
			
			addChild(questionText);	
			
			this.x = 0;
			this.y = 140;
		}
	}
}
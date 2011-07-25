package net.localprojects.elements {
	import com.bit101.components.Text;
	
	import flash.display.*;
	import flash.text.*;
	
	import net.localprojects.*;
	
	// multi-line block text
	public class BlockParagraph extends Sprite {
		
		private var _textWidth:Number;
		private var _text:String;
		private var _textSize:Number;
		private var _backgroundColor:uint;
		private var _bold:Boolean;
		
		private var textField:TextField;
		private var vPadding:Number;
		private var hPadding:Number;		
		private var leading:Number;
		private var background:Shape;
		
		public function BlockParagraph(textWidth:Number, text:String, textSize:Number, backgroundColor:uint, bold:Boolean = false) {
			vPadding = 28;
			hPadding = 40;
			leading = 5;			
			
			_textWidth = textWidth - hPadding;
			_text = text;
			_textSize = textSize;
			_bold = bold;
			_backgroundColor = backgroundColor;

			init();
		}
		
		private function init():void {
			// set up the text format
			var textFormat:TextFormat = new TextFormat();			
			textFormat.bold = _bold;
			textFormat.font =  Assets.FONT_REGULAR;
			textFormat.align = TextFormatAlign.LEFT;
			textFormat.size = _textSize;
			textFormat.leading = leading;
			
			// this is just to make sure line breaks are calculated reasonably
			// since Flash doesn't have line height control (just leading), there's no way
			// to center text vertically on its background. To get around this, we place the text on manually
			// drawn background shapes
			
      textField = new TextField();
			textField.defaultTextFormat = textFormat;
			textField.embedFonts = true;
			textField.selectable = false;
			textField.multiline = true;
			textField.cacheAsBitmap = false;
			textField.mouseEnabled = false;
			textField.gridFitType = GridFitType.NONE;
			textField.antiAliasType = AntiAliasType.ADVANCED;
			textField.textColor = 0xffffff;
			textField.width = _textWidth;
			textField.autoSize = TextFieldAutoSize.LEFT;
			textField.wordWrap = true;
			textField.text = _text;
			
			//draw the background
			background = new Shape();
			
			drawBackground();
			
			// compensate for negative origin
			background.x = hPadding;
			background.y = vPadding;
			addChild(background);
			
			textField.x = hPadding / 2;
			textField.y = vPadding / 2;			
			addChild(textField);			
			
//			this.graphics.beginFill(0xff0000);
//			this.graphics.drawRect(0, 0, width, height);
//			this.graphics.endFill();
			
			this.cacheAsBitmap = true;
		}
		
		private function drawBackground():void {
			background.graphics.clear();
			
			var yPos:Number = 0;			
			for (var i:int = 0; i < textField.numLines; i++) {
				var metrics:TextLineMetrics = textField.getLineMetrics(i);				
				
				background.graphics.beginFill(_backgroundColor);								
				background.graphics.drawRect(0 - hPadding, yPos - vPadding, metrics.width + hPadding, metrics.height + vPadding);
				background.graphics.endFill();				
				
				yPos += metrics.height;				
			}	
		}
		
		public function setText(s:String):void {
			textField.text = s;
			drawBackground();
		}		
	
		// TODO getters and setters
		
		
		
		
	}
}
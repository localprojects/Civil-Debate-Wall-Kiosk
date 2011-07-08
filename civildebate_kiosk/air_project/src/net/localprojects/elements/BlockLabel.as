package net.localprojects.elements {
	import com.bit101.components.Text;
	
	import flash.display.*;
	import flash.text.*;
	
	import net.localprojects.*;
	
	// multi-line block text
	public class BlockLabel extends Sprite {
		
		private var _text:String;
		private var _textSize:Number;
		private var _textColor:uint;		
		private var _backgroundColor:uint;
		private var _showBackground:Boolean;		
		
		private var textField:TextField;
		private var vPadding:Number;
		private var hPadding:Number;		
		private var leading:Number;
		
		public function BlockLabel(text:String, textSize:Number, textColor:uint, backgroundColor:uint, showBackground:Boolean = true) {
			vPadding = 28;
			hPadding = 40;
			
			_text = text;
			_textSize = textSize;
			_textColor = textColor;
			_backgroundColor = backgroundColor;
			_showBackground = showBackground;
			
			init();
		}
		
		private function init():void {
			// set up the text format
			var textFormat:TextFormat = new TextFormat();			
			textFormat.bold = true;
			textFormat.font =  Assets.FONT_REGULAR;
			textFormat.align = TextFormatAlign.LEFT;
			textFormat.size = _textSize;
			textFormat.leading = leading;
			
			textField = new TextField();
			textField.defaultTextFormat = textFormat;
			textField.embedFonts = true;
			textField.selectable = false;
			textField.cacheAsBitmap = false;
			textField.mouseEnabled = false;
			textField.gridFitType = GridFitType.NONE;
			textField.antiAliasType = AntiAliasType.ADVANCED;
			textField.textColor = _textColor;
			//textField.width = 1080;
			textField.autoSize = TextFieldAutoSize.LEFT;
			
			textField.text = _text;
			
			//draw the background
			if (_showBackground) {
				var background:Shape = new Shape();
				
				background.graphics.beginFill(_backgroundColor);								
				background.graphics.drawRect(0 - hPadding, 0 - vPadding, textField.width + hPadding, textField.height + vPadding);
				background.graphics.endFill();				
				
				// compensate for negative origin
				background.x = hPadding;
				background.y = vPadding;
				addChild(background);
				
				textField.x = hPadding / 2;
				textField.y = vPadding / 2;
			}
			
			addChild(textField);			
			
			//			this.graphics.beginFill(0xff0000);
			//			this.graphics.drawRect(0, 0, width, height);
			//			this.graphics.endFill();
			
			this.cacheAsBitmap = true;
			
			
			
		}
		
		// TODO getters and setters
		
		
		
		
	}
}
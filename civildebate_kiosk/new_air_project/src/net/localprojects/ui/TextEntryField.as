package net.localprojects.ui {
	import flash.display.Sprite;
	import flash.text.*;
	import net.localprojects.Assets;
	import net.localprojects.blocks.BlockBase;
	
	
	public class TextEntryField extends BlockBase	{
		
		protected var _fieldWidth:Number;
		protected var _fieldHeight:Number;
		protected var _defaultText:String;
		protected var _textSize:Number;
		protected var _backgroundColor:uint;
		
		// TODO arrow...
		public function BlockButton(fieldWidth:Number, fieldHeight:Number, defaultText:String, textSize:Number, backgroundColor:uint) {
			super();
			
			_fieldWidth = fieldWidth;
			_fieldHeight = fieldHeight;
			_defaultText = defaultText;
			_textSize = textSize;
			_backgroundColor = backgroundColor;
			
			init();
			draw();
		}
		
		private function init():void {
			// label
			// set up the text format
			var textFormat:TextFormat = new TextFormat();			
			textFormat.bold = true;
			textFormat.font =  Assets.FONT_REGULAR;
			textFormat.align = TextFormatAlign.CENTER;
			textFormat.size = _labelSize;
			
			var labelField:TextField = new TextField();
			labelField.defaultTextFormat = textFormat;
			labelField.embedFonts = true;
			labelField.selectable = false;
			labelField.mouseEnabled = false;
			labelField.gridFitType = GridFitType.NONE;
			labelField.antiAliasType = AntiAliasType.ADVANCED;
			labelField.textColor = 0xffffff;
			labelField.width = _buttonWidth;
			labelField.autoSize = TextFieldAutoSize.CENTER;
			labelField.text = _labelText;
			labelField.x = (_buttonWidth / 2) - (labelField.width / 2);
			labelField.y = (_buttonHeight / 2) - (labelField.height / 2);			
			
			addChild(labelField);			
		}
		
		private function draw():void {
			this.graphics.beginFill(_backgroundColor);
			this.graphics.lineStyle(4, 0xffffff);
			this.graphics.drawRect(0, 0, _buttonWidth, _buttonHeight);
			this.graphics.endFill();
		}
		
		
		
		// TODO getters and setters
	}
}

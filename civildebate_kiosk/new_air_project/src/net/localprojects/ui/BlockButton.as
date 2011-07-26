package net.localprojects.ui {
	import flash.display.Sprite;
	import flash.text.*;
	import net.localprojects.Assets;
	import net.localprojects.blocks.Block;
	
	public class BlockButton extends Block	{

		protected var _buttonWidth:Number;
		protected var _buttonHeight:Number;
		protected var _labelText:String;
		protected var _labelSize:Number;
		protected var _backgroundColor:uint;
		protected var _arrow:Boolean;		
		
		// TODO arrow...
		public function BlockButton(buttonWidth:Number, buttonHeight:Number, labelText:String, labelSize:Number, backgroundColor:uint, arrow:Boolean) {
			_buttonWidth = buttonWidth;
			_buttonHeight = buttonHeight;
			_labelText = labelText;
			_labelSize = labelSize;
			_backgroundColor = backgroundColor;
			_arrow = arrow;

						
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

package net.localprojects.ui {
	import com.greensock.TweenMax;
	import com.greensock.easing.*;
	
	import flash.display.Sprite;
	import flash.text.*;
	
	import net.localprojects.Assets;	
	
	public class BlockButton extends ButtonBase	{

		protected var _buttonWidth:Number;
		protected var _buttonHeight:Number;
		protected var _labelText:String;
		protected var _labelSize:Number;
		protected var _arrow:Boolean;
		protected var _bold:Boolean;
		
		// TODO arrow...
		public function BlockButton(buttonWidth:Number, buttonHeight:Number, labelText:String, labelSize:Number, backgroundColor:uint, arrow:Boolean, bold:Boolean = false) {
			super();
			
			_buttonWidth = buttonWidth;
			_buttonHeight = buttonHeight;
			_labelText = labelText;
			_labelSize = labelSize;
			_backgroundColor = backgroundColor;
			_arrow = arrow;
			_bold = bold;
						
			init();
			draw();
		}
		
		private function init():void {
			// label
			// set up the text format
			var textFormat:TextFormat = new TextFormat();
			textFormat.bold = _bold;
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
			
			addChild(background);
			addChild(labelField);
			
			
		}
		
		override protected function draw():void {

			// draw the background
			background.graphics.clear();
			background.graphics.beginFill(0xffffff);
			background.graphics.drawRect(0, 0, _buttonWidth, _buttonHeight);
			background.graphics.endFill();
			TweenMax.to(background, 0, {ease: Quart.easeOut, colorTransform: {tint: _backgroundColor, tintAmount: 1}});
			
			// draw the outline
			this.graphics.clear();
			this.graphics.lineStyle(6, 0xffffff);
			this.graphics.drawRect(0, 0, _buttonWidth, _buttonHeight);
			this.graphics.endFill();
		}
		
		public function setBackgroundColor(c:uint):void {
			_backgroundColor = c;
			TweenMax.to(background, 0.5, {ease: Quart.easeOut, colorTransform: {tint: _backgroundColor, tintAmount: 1}});			
		}
		
		
		
		
		// TODO getters and setters
	}
}

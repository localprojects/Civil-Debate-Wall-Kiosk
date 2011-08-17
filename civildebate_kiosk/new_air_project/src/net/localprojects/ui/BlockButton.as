package net.localprojects.ui {
	import com.greensock.TweenMax;
	import com.greensock.easing.*;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.*;
	
	import net.localprojects.Assets;
	
	public class BlockButton extends ButtonBase	{

		protected var labelFieldA:TextField;
		protected var labelFieldB:TextField;
		protected var _buttonWidth:Number;
		protected var _buttonHeight:Number;
		protected var _labelText:String;
		protected var _labelSize:Number;
		protected var _arrow:Boolean;
		protected var _bold:Boolean;
		protected var outline:Shape;
		
		
		protected var strokeWeight:Number;
		
		// TODO arrow...
		public function BlockButton(buttonWidth:Number, buttonHeight:Number, labelText:String, labelSize:Number, backgroundColor:uint, arrow:Boolean, bold:Boolean = false) {
			super();
			outline = new Shape();
			
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
		
		
		private function generateLabel(text:String):TextField {
			// label
			// set up the text format
			var textFormat:TextFormat = new TextFormat();
			textFormat.bold = _bold;
			textFormat.font =  Assets.FONT_REGULAR;
			textFormat.align = TextFormatAlign.CENTER;
			textFormat.size = _labelSize;
			textFormat.leading = 5;
			
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
			labelField.text = text;
			labelField.x = (_buttonWidth / 2) - (labelField.width / 2);
			labelField.y = (_buttonHeight / 2) - (labelField.height / 2);			
			
			return labelField;
		}
		
		private var newLabel:TextField;
		override public function setLabel(text:String):void {
			_labelText = text;
			newLabel = generateLabel(_labelText);
			newLabel.alpha = 0;
			addChild(newLabel);
			
			TweenMax.to(labelFieldA, 0.2, {alpha: 0, ease: Quart.easeIn});
			TweenMax.to(newLabel, 0.2, {alpha: 1, ease: Quart.easeOut, onComplete: onSetLabelComplete});
		}
		
		private function onSetLabelComplete():void {
			labelFieldA = newLabel;
		}
		
		
		private function init():void {
			strokeWeight = 4;
			
			labelFieldA = generateLabel(_labelText);

			
			addChild(background);
			addChild(outline);
			addChild(labelFieldA);
		}
		
		override protected function draw():void {

			// draw the background
			background.graphics.clear();
			background.graphics.beginFill(0xffffff);
			background.graphics.drawRect(0, 0, _buttonWidth, _buttonHeight);
			background.graphics.endFill();
			TweenMax.to(background, 0, {ease: Quart.easeOut, colorTransform: {tint: _backgroundColor, tintAmount: 1}});
			
			// draw the outline
			outline.graphics.clear();
			outline.graphics.lineStyle(strokeWeight, 0xffffff);
			outline.graphics.drawRect(0, 0, _buttonWidth, _buttonHeight);
			outline.graphics.endFill();
		}
		
		override public function setBackgroundColor(c:uint, instant:Boolean = false):void {
			_backgroundColor = c;
			TweenMax.to(background, 0.5, {ease: Quart.easeOut, colorTransform: {tint: _backgroundColor, tintAmount: 1}});			
		}
		
		
		
		
		// TODO getters and setters
	}
}

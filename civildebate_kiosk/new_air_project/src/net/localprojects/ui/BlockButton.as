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
		protected var _letterSpacing:Number;
		protected var _font:String;
		protected var _labelColor:uint;		
		protected var outline:Shape;
		
		protected var strokeWeight:Number;
		
		// TODO arrow...
		public function BlockButton(buttonWidth:Number, buttonHeight:Number, backgroundColor:uint, labelText:String, labelSize:Number, labelColor:uint = 0xffffff, labelFont:String = null) {
			super();
			outline = new Shape();
			
			if (labelFont == null) {
				_font = Assets.FONT_REGULAR;
			}
			else {
				_font = labelFont;
			}
			
			_buttonWidth = buttonWidth;
			_buttonHeight = buttonHeight;
			_labelText = labelText;
			_labelSize = labelSize;
			_labelColor = labelColor;
			
			_backgroundColor = backgroundColor;
				
			init();
			draw();
		}
		
		private function init():void {
			strokeWeight = 4;
			_letterSpacing = -1;
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
		
		
		private var textFormat:TextFormat;
		private var labelField:TextField;
		
		private function generateLabel(text:String):TextField {
			// label
			textFormat = new TextFormat();
			textFormat.font =  _font;
			textFormat.align = TextFormatAlign.CENTER;
			textFormat.size = _labelSize;
			textFormat.letterSpacing = _letterSpacing;
			
			labelField = new TextField();
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
		
		public function setLetterSpacing(amount:Number):void {
			_letterSpacing = amount;
			removeChild(labelFieldA);
			labelFieldA = generateLabel(_labelText);
			addChild(labelFieldA);
		}
	
		
		override public function setLabel(text:String):void {
			_labelText = text;
			
			labelFieldB = labelFieldA;
			labelFieldA = generateLabel(_labelText);
			labelFieldA.alpha = 0;
			addChild(labelFieldA);
			
			TweenMax.to(labelFieldB, 0.2, {alpha: 0, ease: Quart.easeIn});
			TweenMax.to(labelFieldA, 0.2, {alpha: 1, ease: Quart.easeOut});
		}
		
		
		override public function setBackgroundColor(c:uint, instant:Boolean = false):void {
			_backgroundColor = c;
			TweenMax.to(background, 0.5, {ease: Quart.easeOut, colorTransform: {tint: _backgroundColor, tintAmount: 1}});			
		}
	}
}

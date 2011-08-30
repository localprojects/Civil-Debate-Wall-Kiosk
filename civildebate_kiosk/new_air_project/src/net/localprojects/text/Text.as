package net.localprojects.text {
	import com.greensock.TweenMax;
	import com.greensock.easing.*;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.text.*;
	
	import net.localprojects.*;
	
	public class Text extends Sprite {
		
		// Constants
		public static const BOUNDS_FIXED:String = 'boundsFixed';
		public static const BOUNDS_GROW:String = 'boundsGrow'; // in which case width and height specify truncation...		
		public static const CENTER:String = TextFormatAlign.CENTER;
		public static const LEFT:String = TextFormatAlign.LEFT;
		public static const RIGHT:String = TextFormatAlign.RIGHT;		
		
		
		// Text Properties, with defaults
		protected var _text:String = ''; // set to tween (e.g. setText(text, duration = 0, params = {}); (maybe no params...)
		protected var _textColor:uint = 0xCCCCCC; // tweens
		protected var _textSize:Number = 12; // tweens
		protected var _textFont:String = Assets.FONT_REGULAR; // set to tween
		protected var _textLetterSpacing:Number = 0; // tweens
		protected var _textAlign:String = LEFT; // set to tween
		
		// Metrics
		protected var _bounds:String = BOUNDS_GROW; // set to tween
		protected var _boundsWidth:Number = Number.MAX_VALUE; // tweens
		protected var _boundsHeight:Number = Number.MAX_VALUE; // tweens
		
		// Border
		
		
		// Background
		protected var backgroundShow:Boolean = false;
		protected var backgroundColor:uint = 0x000000;		
		
		
		
		// Implementation
		protected var textField:TextField;
		protected var textFormat:TextFormat;
		
		
		public function Text(text:String) {
			_text = text;
			textField = generateTextField(_text);
			addChild(textField);
			trace("text created: " + _text);
		}
		
		
		protected function generateTextField(t:String):TextField {
			// format persists (for adjustment after the fact)
			textFormat = new TextFormat();
			textFormat.font =  _textFont;
			textFormat.align = _textAlign;
			textFormat.size = _textSize;
			textFormat.letterSpacing = _textLetterSpacing;
			
			
			// field is overwritte
			var tempTextField:TextField = new TextField();
			tempTextField.defaultTextFormat = textFormat;
			tempTextField.embedFonts = true;
			tempTextField.selectable = false;
			tempTextField.mouseEnabled = false;
			tempTextField.multiline = false;
			//tempTextField.gridFitType = GridFitType;
			tempTextField.antiAliasType = AntiAliasType.ADVANCED;
			tempTextField.autoSize = TextFieldAutoSize.LEFT;

			
			
			tempTextField.textColor = _textColor;			
			tempTextField.text = _text;
			
//			tempTextField.x = (_buttonWidth / 2) - (labelField.width / 2) - (strokeWeight / 2);
//			tempTextField.y = (_buttonHeight / 2) - (labelField.height / 2) - (strokeWeight / 2);			
			
			return tempTextField;
		}		
		
		
		
		// Getters and Setters
		
		
		// Settables
		public function setText(s:String, duration:Number = 0):void {
			if (_text != s) {
				_text = s;
				if (duration == 0 ) {
					textField.text 
				}
				else {
					// TODO TWEEN		
				}
			}
		}
		
		
		// Tweenables
		public function get textColor():uint	{	return _textColor;	}
		public function set textColor(c:uint):void  {
			_textColor = c;
			textField.textColor = _textColor;
			trace(_textColor);			
		}
		
		public function get textSize():Number	{	return _textSize;	}		
		public function set textSize(s:Number):void  {
			_textSize = s;
			textFormat.size = _textSize;
			textField.setTextFormat(textFormat);
		}
		
		public function get textLetterSpacing():Number	{	return _textLetterSpacing;	}		
		public function set textLetterSpacing(n:Number):void  {
			_textLetterSpacing = n;
			textFormat.letterSpacing = _textLetterSpacing;
			textField.setTextFormat(textFormat);
		}
		
		
		

		
				
	}
}
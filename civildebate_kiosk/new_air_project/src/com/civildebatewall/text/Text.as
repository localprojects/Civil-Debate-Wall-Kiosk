package com.civildebatewall.text {
	import com.civildebatewall.*;
	import com.greensock.easing.*;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.text.*;
	import flash.text.engine.TextBlock;
	
	public class Text extends Sprite {
		
		
		// background colors
		
		// background padding
		
		// rounded background border
		
		// line spacing
		
		// anchor left, center, right
		
		// 
		
		// string hiliting (multiline)
		
		// states (defined with object style set...), e.g. setOverState(duration, {background:Color, red}); // AND tweenable
		
		// EVERYTHING tweenable. Set transitions between states, duration, easing.
		
		// minimal html support (bold, italic)... no worry about size yet?
		
		// ignore baseline
		
		// built in tweening, or create tweenMax plugin.
		
		// pixel perfect height, padding, etc, based on _pixels_ from entire character set... might cost some initialization
		
		// NO tween font...
		
		//var textBlock:TextBlock = new TextBlock(string, settings);
		
		
		// Static
		// Buttons
		// Input
		// Icons?
		
		// alternate "selection" representation
		
		
		// Background MODES
		// RAGGED_HUG (ragged), CONTAINMENT_RECT ( rectangle that includes everything)
		// has to be define
		
		
		
		
		// also nice
		// truncation
		// smarty pants
		
		
		
		// background is its own class just something that draws a rectangle around, so we can use it to build custom icon buttons, etc.
		// same for border
		
		
		
		/* 
		// TEXT DEVELOPMENT ZONE
		
		trace("doing text dev");			
		
		///TweenPlugin.activate([BlurFilterPlugin]); //activation is permanent in the SWF, so this line only needs to be run once.
		stage.scaleMode = StageScaleMode.NO_SCALE;
		stage.align = StageAlign.TOP;
		stage.nativeWindow.width = 1080;
		stage.nativeWindow.height = 1920;
		
		var text:Text = new Text("Hello world");
		addChild(text);
		text.x = 400;
		text.y = 400;
		
		
		// Tween Sliders
		var sizeSlider:HSlider = new HSlider(this, 0, 0, function():void{ text.textSize = sizeSlider.value });
		sizeSlider.minimum = 0;
		sizeSlider.maximum = 200;
		var colorChooser:ColorChooser = new ColorChooser(this, 0, 0, 0, function():void { text.textColor = colorChooser.value });
		var spacingSlider:HSlider = new HSlider(this, 0, 0, function():void{ text.textLetterSpacing = spacingSlider.value });
		spacingSlider.minimum = -50;
		spacingSlider.maximum = 50;
		
		var randomText:PushButton = new PushButton(this, 0, 0, "Change Text", function():void { text.setText(Utilities.dummyText(50)) });
		var left:PushButton = new PushButton(this, 0, 0, "Align Left", function():void { text.setTextAlign(Text.LEFT) });
		var center:PushButton = new PushButton(this, 0, 0, "Align Center", function():void { text.setTextAlign(Text.CENTER) });
		var right:PushButton = new PushButton(this, 0, 0, "Align Right", function():void { text.setTextAlign(Text.RIGHT) });						
		
		// Position controls automatically
		var controls:Array = [sizeSlider, colorChooser, spacingSlider, randomText, left, center, right];
		var yAccumulator:Number = 5;
		
		for (var i:int = 0; i < controls.length; i++) {
		controls[i].x = 5;
		controls[i].y = yAccumulator;
		yAccumulator = controls[i].y + controls[i].height + 5; 
		}
		
		*/
				
		
		
		
		
		
			
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
		

		// Debugging
		protected var _showOrigin:Boolean = true;		
		
		
		// Implementation
		protected var textField:TextField;
		protected var textFormat:TextFormat;
		protected var background:Shape;
		
		// Debug Implementation
		protected var originDot:Shape;

		
		
		public function Text(text:String) {
			_text = text;
			
			background = new Shape();
			addChild(background);
			
			textField = generateTextField(_text);
			addChild(textField);
			
			trace("text created: " + _text);
			
			// Debug Stuff (todo comment out)
			originDot = new Shape();
			originDot.graphics.beginFill(0xff0000);
			originDot.graphics.drawCircle(0, 0, 20);
			originDot.graphics.endFill();
			showOrigin = _showOrigin;
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
		public function getText():String { return _text; }
		public function setText(s:String, duration:Number = 0):void {
			if (s != _text) {
				_text = s;
				if (duration == 0 ) {
					textField.text = _text;
					trace("setting ", s);						
				}
				else {
					// TODO TWEEN		
				}
			}
		}
		
		public function getTextAlign():String { return _textAlign; }
		public function setTextAlign(s:String, duration:Number = 0):void {
			if (s != _textAlign) {
				_textAlign = s;
				if (duration == 0) {
					// jump to it
					textField.autoSize = _textAlign;
					
					// TODO if bounds are not fixed, then move the label relative to origin
					// if bounds ARE fixed, then move the label relative to the bounds
					
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
		}
		
		public function get textSize():Number	{	return _textSize;	}		
		public function set textSize(s:Number):void  {
			_textSize = s;
			textFormat.size = _textSize;
			textField.defaultTextFormat = textFormat;
			textField.setTextFormat(textFormat);
		}
		
		public function get textLetterSpacing():Number	{	return _textLetterSpacing;	}		
		public function set textLetterSpacing(n:Number):void  {
			_textLetterSpacing = n;
			textFormat.letterSpacing = _textLetterSpacing;
			textField.defaultTextFormat = textFormat;			
			textField.setTextFormat(textFormat);
		}
		
		
		// Debug
		public function get showOrigin():Boolean	{	return _showOrigin;	}
		public function set showOrigin(b:Boolean):void  {
			_showOrigin = b;
			if (_showOrigin) {
				if (!contains(originDot)) addChild(originDot);
			}
			else {
				if (contains(originDot)) removeChild(originDot);
			}
		}		
		
		
		

		
				
	}
}
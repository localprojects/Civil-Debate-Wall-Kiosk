package net.localprojects.blocks {
	import com.bit101.components.Text;
	import com.greensock.TweenMax;
	import com.greensock.easing.*;
	
	import flash.display.*;
	import flash.geom.Rectangle;
	import flash.text.*;
	
	import net.localprojects.*;
	import net.localprojects.Assets;
	
	// multi-line block text
	public class BlockLabel extends BlockBase {
		
		protected var _text:String;
		protected var _textSize:Number;
		protected var _textColor:uint;		
		protected var _backgroundColor:uint;
		protected var _showBackground:Boolean;		
		protected var _italic:Boolean;
		protected var _font:String;
		protected var _letterSpacing:Number;		
		
		protected var textField:TextField;
		protected var textFormat:TextFormat;		
		protected var paddingTop:int;
		protected var paddingBottom:int;		
		protected var paddingLeft:int;
		protected var paddingRight:int;		
		public var background:Bitmap;
		
		
		
		public function BlockLabel(text:String, textSize:Number, textColor:uint = 0xffffff, backgroundColor:uint = 0x000000, font:String = null, showBackground:Boolean = true) {
			_italic = false;
			_letterSpacing = -1;			
			
			// Work around for intermittent 1047 error
			if (font == null) {
				font = Assets.FONT_REGULAR				
			}
			
			// kludge to get italic fonts working without additional intervention
			if (font.indexOf('Italic') > 0) {
				_italic = true;
				font = font.replace(' Italic', '');
				trace('new font: ' + font);
			}
			
			paddingTop = 28;
			paddingBottom = 28;
			paddingLeft = 40;
			paddingRight = 40;
			
			_text = text;
			_font = font;
			_textSize = textSize;
			_textColor = textColor;
			_backgroundColor = backgroundColor;
			_showBackground = showBackground;
			
			init();
		}
		
		
				
		private function init():void {
			considerDescenders = true;
			
			
			// set up the text format
			textFormat = new TextFormat();
			textFormat.font =  _font;
			textFormat.align = TextFormatAlign.LEFT;
			textFormat.size = _textSize;
			textFormat.letterSpacing = _letterSpacing;
			textFormat.italic = _italic;
			//textFormat.leading = -0.25;
			
			textField = new TextField();
			textField.defaultTextFormat = textFormat;
			textField.embedFonts = true;
			textField.selectable = false;
			textField.cacheAsBitmap = false;
			textField.mouseEnabled = false;
			textField.gridFitType = GridFitType.NONE;
			textField.antiAliasType = AntiAliasType.ADVANCED;
			textField.textColor = _textColor;
			textField.autoSize = TextFieldAutoSize.LEFT;
			

			//textField.backgroundColor = 0xff0000cc;
			//textField.background = true;
			
			textField.text = _text;
			
			background = new Bitmap();
			background.pixelSnapping = PixelSnapping.ALWAYS;
			
			
			
			addChild(background);			
			drawBackground();
			
			addChild(textField);
			

			
			
			this.cacheAsBitmap = true;
		}

		public function setLetterSpacing(amount:Number):void {
			_letterSpacing = amount;
			textFormat.letterSpacing = _letterSpacing;			
			textField.defaultTextFormat = textFormat;
			textField.text = _text;
			drawBackground();
		}
		
		
		

		public function setPadding(top:Number, right:Number, bottom:Number, left:Number):void {
			paddingTop = top;
			paddingRight = right;
			paddingBottom = bottom;
			paddingLeft = left;
			drawBackground();
		}		
		
		
		
		
		private function textWidth():int {
			return Math.max(Math.floor(textField.width - (_textSize * 0.112244898)), 1);
		}
		
		private function textHeight():int {
			var metrics:TextLineMetrics = textField.getLineMetrics(0);
			
			//metrics.
			
			if (considerDescenders) {
				return Math.round(metrics.ascent);				
			}
			else {
				return Math.round(metrics.ascent - (_textSize * 0.2040816327));
			}
		}
		
		public var considerDescenders:Boolean
		
		protected function drawBackground():void {

			//draw the background
			if (_showBackground) {
				background.bitmapData = new BitmapData(textWidth() + paddingLeft + paddingRight, textHeight() + paddingTop + paddingBottom, false, 0xffffff);
				background.pixelSnapping = PixelSnapping.ALWAYS;

				textField.x = paddingLeft - 3;
				textField.y = paddingTop - Math.round(_textSize * 0.2448979592);
				
				// actual color is set by tweenmax
				TweenMax.to(background, 0, {ease: Quart.easeInOut, colorTransform: {tint: _backgroundColor, tintAmount: 1}});
			}			
		}
		
		
		protected function getBackgroundWidth(s:String):Number {
			var oldString:String = textField.text;
			textField.text = s; // temporarily measure with new string
			var newWidth:Number = textField.width + paddingLeft + paddingRight;
			textField.text = oldString; // reset string
			return newWidth;
		}
		
		
		protected function getBackgroundDimensions(s:String):Rectangle {
			var oldString:String = textField.text;
			textField.text = s; // temporarily measure with new string
			var newDimensions:Rectangle = new Rectangle(0, 0, textWidth() + paddingLeft + paddingRight, textHeight() + paddingTop + paddingBottom);  
			textField.text = oldString; // reset string
			return newDimensions;
		}

		
		protected var newText:String;
		protected var instantTween:Boolean;
		
		override public function setText(s:String, instant:Boolean = false):void {
			// make sure it's a change
			if (textField.text != s) {		
				_text = s;
			
				instantTween = instant;			
				var textOutDuration:Number = instant ? 0 : 0.1;
				var backgroundDuration:Number = instant ? 0 : 0.2;			
				newText = s;			
			
				if (instant) {
					textField.text = newText;		
					drawBackground();
//					background.width = getBackgroundDimensions(newText).width;
//					background.height = getBackgroundDimensions(newText).height;
				}
				else {
					// crossfade text
					TweenMax.to(textField, textOutDuration, {alpha: 0, ease: Quart.easeOut, onComplete: afterFade});
					TweenMax.to(background, backgroundDuration, {width: getBackgroundDimensions(newText).width, height: getBackgroundDimensions(newText).height, ease: Quart.easeIn});					
				}
			
			// resize the background
			
			}
		}
			
		
		public function afterFade():void {
			textField.text = newText;				
			//drawBackground();				
			var textInDuration:Number = instantTween ? 0 : 0.1;
			TweenMax.to(textField, textInDuration, {alpha: 1, ease: Quart.easeIn});
		}
		
		
		// tweens to a new color
		override public function setBackgroundColor(c:uint, instant:Boolean = false):void {
			_backgroundColor = c;
			
			var duation:Number = instant ? 0 : 0.5;
			
			TweenMax.to(background, duation, {ease: Quart.easeInOut, colorTransform: {tint: _backgroundColor, tintAmount: 1}});			
		}
			
		
		
		// TODO getters and setters		
	}
}
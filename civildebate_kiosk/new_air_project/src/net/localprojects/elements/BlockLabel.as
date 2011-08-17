package net.localprojects.elements {
	import com.bit101.components.Text;
	import com.greensock.TweenMax;
	import com.greensock.easing.*;
	
	import flash.display.*;
	import flash.geom.Rectangle;
	import flash.text.*;
	
	import net.localprojects.*;
	import net.localprojects.blocks.*;
	
	// multi-line block text
	public class BlockLabel extends BlockBase {
		
		protected var _text:String;
		protected var _textSize:Number;
		protected var _textColor:uint;		
		protected var _backgroundColor:uint;
		protected var _showBackground:Boolean;		
		protected var _bold:Boolean;
		
		protected var textField:TextField;
		protected var paddingTop:Number;
		protected var paddingBottom:Number;		
		protected var paddingLeft:Number;
		protected var paddingRight:Number;		
		protected var background:Shape;
		
		
		
		public function BlockLabel(text:String, textSize:Number, textColor:uint, backgroundColor:uint, bold:Boolean = false, showBackground:Boolean = true) {
			paddingTop = 28;
			paddingBottom = 28;
			paddingLeft = 40;
			paddingRight = 40;
			
			_text = text;
			_bold = bold;
			_textSize = textSize;
			_textColor = textColor;
			_backgroundColor = backgroundColor;
			_showBackground = showBackground;
			
			init();
		}
		
		private function init():void {
			// set up the text format
			var textFormat:TextFormat = new TextFormat();			
			textFormat.bold = _bold;
			textFormat.font =  Assets.FONT_REGULAR;
			textFormat.align = TextFormatAlign.LEFT;
			textFormat.size = _textSize;
			textFormat.leading = -0.25;
			
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
			
			background = new Shape();
			addChild(background);			
			drawBackground();
			
			addChild(textField);			
			
			// this.graphics.beginFill(0xff0000);
			// this.graphics.drawRect(0, 0, width, height);
			// this.graphics.endFill();
			
			this.cacheAsBitmap = true;
		}
		
		

		
		public function setPadding(top:Number, right:Number, bottom:Number, left:Number):void {
			paddingTop = top;
			paddingRight = right;
			paddingBottom = bottom;
			paddingLeft = left;
			drawBackground();
		}		
		
		
		
		protected function drawBackground():void {
			background.graphics.clear();
			
			//draw the background
			if (_showBackground) {
				background.graphics.beginFill(0xffffff); // white fill for manipulation by tweenmax				
				background.graphics.drawRect(0, 0, textField.width + paddingLeft + paddingRight, textField.height + paddingTop + paddingBottom);
				background.graphics.endFill();				
				
				textField.x = paddingLeft;
				textField.y = paddingTop;
				
				// actual color is set by tweenmax
				TweenMax.to(background, 0, {ease: Quart.easeInOut, colorTransform: {tint: _backgroundColor, tintAmount: 1}});
			}			
		}
		
		private function getBackgroundWidth(s:String):Number {
			var oldString:String = textField.text;
			textField.text = s; // temporarily measure with new string
			var newWidth:Number = textField.width + paddingLeft + paddingRight;
			textField.text = oldString; // reset string
			return newWidth;
		}
		
		private function getBackgroundDimensions(s:String):Rectangle {
			var oldString:String = textField.text;
			textField.text = s; // temporarily measure with new string
			var newDimensions:Rectangle = new Rectangle(0, 0, textField.width + paddingLeft + paddingRight, textField.height + paddingTop + paddingBottom);  
			textField.text = oldString; // reset string
			return newDimensions;
		}

		
		private var newText:String;
		private var instantTween:Boolean;
		override public function setText(s:String, instant:Boolean = false):void {
			instantTween = instant;			
			var textOutDuration:Number = instant ? 0 : 0.1;
			var backgroundDuration:Number = instant ? 0 : 0.2;			
			newText = s;			
			
			if (instant) {
				textField.text = newText;							
				
				
			}
			
			else {
			
				// TODO crossfade text


				TweenMax.to(textField, textOutDuration, {alpha: 0, ease: Quart.easeOut, onComplete: afterFade});
			}
			
			TweenMax.to(background, backgroundDuration, {width: getBackgroundDimensions(newText).width, height: getBackgroundDimensions(newText).height, ease: Quart.easeIn});			
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
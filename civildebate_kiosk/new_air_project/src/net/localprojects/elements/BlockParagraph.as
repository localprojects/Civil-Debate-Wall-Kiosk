package net.localprojects.elements {
	import com.bit101.components.Text;
	
	import flash.display.*;
	import flash.text.*;
	
	import net.localprojects.*;
	import net.localprojects.blocks.BlockBase;
	import com.greensock.*;
	import com.greensock.easing.*;
	
	// multi-line block text
	public class BlockParagraph extends BlockBase {
		
		protected var _textWidth:Number;
		protected var _text:String;
		protected var _textSize:Number;
		protected var _backgroundColor:uint;
		protected var _bold:Boolean;
		
		protected var textField:TextField;
		protected var paddingTop:Number;
		protected var paddingRight:Number;
		protected var paddingBottom:Number;
		protected var paddingLeft:Number;	
		

		protected var leading:Number;
		protected var background:Shape;
		
		public function BlockParagraph(textWidth:Number, text:String, textSize:Number, backgroundColor:uint, bold:Boolean = false) {
			leading = 5;			
			paddingTop = 17;
			paddingRight = 30;
			paddingBottom = 25;
			paddingLeft = 30;			
			
			_textWidth = textWidth - (paddingLeft + paddingRight);
			_text = text;
			_textSize = textSize;
			_bold = bold;
			_backgroundColor = backgroundColor;

			init();
		}
		
		private function init():void {
			// set up the text format
			var textFormat:TextFormat = new TextFormat();			
			textFormat.bold = _bold;
			textFormat.font =  Assets.FONT_REGULAR;
			textFormat.align = TextFormatAlign.LEFT;
			textFormat.size = _textSize;
			textFormat.leading = leading;
			
			// this is just to make sure line breaks are calculated reasonably
			// since Flash doesn't have line height control (just leading), there's no way
			// to center text vertically on its background. To get around this, we place the text on manually
			// drawn background shapes
			
      textField = new TextField();
			textField.defaultTextFormat = textFormat;
			textField.embedFonts = true;
			textField.selectable = false;
			textField.multiline = true;
			textField.cacheAsBitmap = false;
			textField.mouseEnabled = false;
			textField.gridFitType = GridFitType.NONE;
			textField.antiAliasType = AntiAliasType.ADVANCED;
			textField.textColor = 0xffffff;
			textField.width = _textWidth;
			textField.autoSize = TextFieldAutoSize.LEFT;
			textField.wordWrap = true;
			textField.text = _text;
			
			//draw the background
			background = new Shape();
			
			drawBackground();
			
			addChild(background);
			addChild(textField);			
			

			this.cacheAsBitmap = true;
		}
		
		protected function drawBackground():void {
			background.graphics.clear();
			
			var yPos:Number = 0;			
			for (var i:int = 0; i < textField.numLines; i++) {
				var metrics:TextLineMetrics = textField.getLineMetrics(i);				
				
				background.graphics.beginFill(0xffffff); // white fill for manipulation by tweenmax												
				background.graphics.drawRect(0 - paddingLeft, yPos - paddingTop, metrics.width + paddingLeft + paddingRight, metrics.height + paddingTop + paddingBottom);
				background.graphics.endFill();
				
				// actual color is set by tweenmax
				TweenMax.to(background, 0, {ease: Quart.easeInOut, colorTransform: {tint: _backgroundColor, tintAmount: 1}});
				
				yPos += metrics.height;				
			}	
			
			
			//background
			background.x = paddingLeft;
			background.y = paddingTop;
			
			textField.x =  paddingLeft;
			textField.y =  paddingTop;			
		}
		
		public function setText(s:String):void {
			textField.text = s;
			drawBackground();
		}
		
		public function setBackgroundColor(c:uint):void {
			_backgroundColor = c;
			TweenMax.to(background, 0, {ease: Quart.easeInOut, colorTransform: {tint: _backgroundColor, tintAmount: 1}});			
		}
	
		// TODO getters and setters

	}
}
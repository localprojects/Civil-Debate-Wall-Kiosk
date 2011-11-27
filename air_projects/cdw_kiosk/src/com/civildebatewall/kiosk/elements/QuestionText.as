package com.civildebatewall.kiosk.elements {
	import com.greensock.TweenMax;
	import com.greensock.easing.*;
	
	import flash.display.*;
	import flash.text.*;
	
	import com.civildebatewall.Assets;
	import com.civildebatewall.kiosk.legacyBlocks.OldBlockBase;
	
	public class QuestionText extends OldBlockBase {
		
		private var questionText:TextField;
		private var questionTextColor:uint;
		
		public function QuestionText() {
			super();
			init();
		}
		
		public function init():void {
			
			// text
			// TODO get this from the state and move to update function
			var textFormat:TextFormat = new TextFormat();
			textFormat.font =  Assets.FONT_HEAVY;
			textFormat.align = TextFormatAlign.CENTER;
			textFormat.size = 37;
			textFormat.letterSpacing = -0.25;
			textFormat.leading = 4;
			
			questionText = new TextField();
			questionText.defaultTextFormat = textFormat;
			questionText.embedFonts = true;
			questionText.selectable = false;
			questionText.multiline = true;
			questionText.cacheAsBitmap = false;
			questionText.mouseEnabled = false;			
			questionText.gridFitType = GridFitType.NONE;
			questionText.antiAliasType = AntiAliasType.NORMAL;
			questionText.textColor = 0xffffff;
			questionText.width = 1022;
			questionText.wordWrap = true;			
			setText('Question goes here');
			
			addChild(questionText);	
		}
		
		override public function setText(s:String, instant:Boolean = false):void {
			questionText.text = s;
		}
		
		public function setTextColor(c:uint):void {
			if (c != questionTextColor) {
				questionTextColor = c;
				TweenMax.to(questionText, 0.3, {ease: Quart.easeInOut, colorTransform: {tint: questionTextColor, tintAmount: 1}});
			}
		}
		
	}
}
package com.civildebatewall.ui {
	import flash.events.Event;
	import flash.text.*;
	
	import com.civildebatewall.kiosk.blocks.BlockParagraph;
	
	
	public class BlockInputParagraph extends BlockParagraph {
		
		private var minWidth:Number = 0; // how wide should the feel be if there's nothing in it?
		private var minHeight:Number = 0;
		private var lastText:String = '';
		private var atLimit:Boolean = false;		
		private var onLimitReached:Function;
		private var onLimitUnreached:Function;
		private var onNumLinesChange:Function;
		private var onNotEmpty:Function;				
		private var lastLineCount:int;
		
		public function BlockInputParagraph(textWidth:Number, backgroundColor:uint, text:String, textSize:Number, textColor:uint = 0xffffff, textFont:String = null, leading:Number = 3) {		
			super(textWidth, backgroundColor, text, textSize, textColor, textFont, leading);
			postInit();
		}
		
		private function postInit():void {
			minWidth = 200;
			textField.type = TextFieldType.INPUT;
			
			textField.focusRect = false;
			textField.selectable = true;
			textField.cacheAsBitmap = false;
			textField.mouseEnabled = true;
			textField.maxChars = 140;
			
			// find minimum dimensions
			textField.text =  'Height Test'; // test character
			minHeight = textField.height + paddingTop + paddingBottom;
			
			textField.text = _text;
			textField.setSelection(_text.length - 1, _text.length - 1);
			minWidth = 103;
			
			lastText = textField.text;
			
			drawBackground();			
		}
		
		
		private function onEnterFrame(e:Event):void {
			if (textField.text != lastText) {
				
				if (textField.length >= textField.maxChars) {
					if (onLimitReached != null) onLimitReached(e);
					atLimit = true;
				}
				else if (atLimit) {
					atLimit = false;
					if (onLimitUnreached != null) onLimitUnreached(e);				
				}
				
				lastText = textField.text ;
				drawBackground();				
			}
			
			
			if(textField.numLines != lastLineCount) {
				if (onNumLinesChange != null) onNumLinesChange(e);
				lastLineCount = textField.numLines;
			}
			
			if (textField.length > 0) {
				if (onNotEmpty != null) onNotEmpty(e);
			}			
			
		}
		
		public function setOnNotEmpty(f:Function):void {
			onNotEmpty = f;
		}			
				
		
		
		public function setOnLimitReached(f:Function):void {
			onLimitReached = f;
		}
		
		public function setOnLimitUnreached(f:Function):void {
			onLimitUnreached = f;
		}
		
		public function setOnNumLinesChange(f:Function):void {
			onNumLinesChange = f;
		}		
		
		
		override protected function beforeTweenIn():void {
			super.beforeTweenIn();
			lastText = '';
			lastLineCount = textField.numLines;
			this.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		override protected function afterTweenIn():void {
			super.afterTweenIn();
			stage.focus = textField;
		}		
		
		override protected function afterTweenOut():void {
			super.afterTweenOut();
			this.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		
		
		
		override protected function drawBackground():void {
			background.graphics.clear();
			
			var yPos:Number = 0;			
			for (var i:int = 0; i < textField.numLines; i++) {
				var metrics:TextLineMetrics = textField.getLineMetrics(i);				
				
				background.graphics.beginFill(_backgroundColor);								
				background.graphics.drawRect(0 - paddingLeft, yPos - paddingTop, metrics.width + paddingLeft + paddingRight, metrics.height + paddingTop + paddingBottom);
				background.graphics.endFill();	
				
				yPos += metrics.height;				
			}	
			
			
			//background
			background.x = paddingLeft;
			background.y = paddingTop;
			
			textField.x =  paddingLeft;
			textField.y =  paddingTop;			
		}
		
		public function getTextField():TextField {
			return textField;
		}		
		
	}
}
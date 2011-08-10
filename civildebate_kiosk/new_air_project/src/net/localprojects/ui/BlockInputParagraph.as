package net.localprojects.ui {
	import net.localprojects.elements.BlockParagraph;
	import flash.text.*;
	import flash.events.Event;
	
	
	public class BlockInputParagraph extends BlockParagraph {
		
		private var minWidth:Number = 0; // how wide should the feel be if there's nothing in it?
		private var minHeight:Number = 0;
		private var lastText:String = '';		
		
		public function BlockInputParagraph(textWidth:Number, text:String, textSize:Number, backgroundColor:uint, bold:Boolean=false)	{
			super(textWidth, text, textSize, backgroundColor, bold);
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
			if(textField.text != lastText) {
				// changed, redraw background
				drawBackground();
			}
			
			lastText = textField.text;
		}
		
		override protected function afterTweenIn():void {
			super.afterTweenIn();
			stage.focus = textField;
			this.addEventListener(Event.ENTER_FRAME, onEnterFrame);
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
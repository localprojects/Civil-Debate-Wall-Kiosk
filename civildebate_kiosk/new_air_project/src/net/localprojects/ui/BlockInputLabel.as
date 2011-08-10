package net.localprojects.ui {
	import com.bit101.components.Text;
	
	import flash.display.*;
	import flash.events.Event;
	import flash.events.TextEvent;
	import flash.text.*;
	
	import net.localprojects.*;
	import net.localprojects.blocks.*;
	import net.localprojects.elements.*;
	
	
	
	public class BlockInputLabel extends BlockLabel {
		
		private var minWidth:Number = 0; // how wide should the field be if there's nothing in it?
		private var minHeight:Number = 0;
		private var lastText:String = '';
		
		public function BlockInputLabel(text:String, textSize:Number, textColor:uint, backgroundColor:uint, bold:Boolean = false, showBackground:Boolean = true) {
			super(text, textSize, textColor, backgroundColor, bold, showBackground);
			postInit();
		}
		
		private function postInit():void {
			minWidth = 200;
			textField.type = TextFieldType.INPUT;
			textField.setSelection(0,0);
			textField.focusRect = false;
			textField.selectable = true;
			textField.cacheAsBitmap = false;
			textField.mouseEnabled = true;
			textField.maxChars = 20;
			
			// find minimum dimensions
			textField.text =  'Height Test'; // test character
			minHeight = textField.height + paddingTop + paddingBottom;

			textField.text = _text;
			
			minWidth = 103;
			
			lastText = textField.text;
			
			// only easy way to watch for text changes...
			
			
			
			drawBackground();
		}
		
		private function onEnterFrame(e:Event):void {
			if (textField.text != lastText) {
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
		
		// TODO prevent drag selections without clobbering the cursor?
		
		
		override protected function drawBackground():void {
			background.graphics.clear();
			
			//draw the background
			if (_showBackground) {
				var backgroundWidth:Number = Math.max(minWidth, textField.width + paddingLeft + paddingRight);
				var backgroundHeight:Number = Math.max(minHeight, textField.height + paddingTop + paddingBottom);
				
				
				background.graphics.beginFill(_backgroundColor);								
				background.graphics.drawRect(0, 0, backgroundWidth, backgroundHeight);
				background.graphics.endFill();				
				
				textField.x = paddingLeft;
				textField.y = paddingTop;
			}			
		}		
		

		

		
		// TODO getters and setters
		
		public function getTextField():TextField {
			return textField;
		}
		
		
	}
}
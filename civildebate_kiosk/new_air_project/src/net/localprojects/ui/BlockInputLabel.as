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
		
		public function BlockInputLabel(text:String, textSize:Number, textColor:uint, backgroundColor:uint, font:String = Assets.FONT_REGULAR, showBackground:Boolean = true) {
			super(text, textSize, textColor, backgroundColor, font, showBackground);
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
		
		

		

		
		// TODO getters and setters
		
		public function getTextField():TextField {
			return textField;
		}
		
		
	}
}
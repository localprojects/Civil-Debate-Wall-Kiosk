package com.civildebatewall.ui {
	import com.bit101.components.Text;
	
	import flash.display.*;
	import flash.events.Event;
	import flash.events.TextEvent;
	import flash.text.*;
	
	import com.civildebatewall.*;
	import com.civildebatewall.blocks.*;
	import com.civildebatewall.elements.*;
	
	
	
	public class BlockInputLabel extends BlockLabel {
		
		private var minWidth:Number = 0; // how wide should the field be if there's nothing in it?
		private var minHeight:Number = 0;
		private var onLimitReached:Function;
		private var onLimitUnreached:Function;
		private var onNotEmpty:Function;		
		private var atLimit:Boolean = false;
		private var lastText:String;
		
		public function BlockInputLabel(text:String, textSize:Number, textColor:uint, backgroundColor:uint, font:String = null, showBackground:Boolean = true) {			
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
			textField.maxChars = 18;
			
			// find minimum dimensions
			textField.text =  'Height Test'; // test character
			minHeight = textField.height + paddingTop + paddingBottom;

			textField.text = _text;
			
			minWidth = 103;
			

			
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
				
				if (textField.length > 0) {
					if (onNotEmpty != null) onNotEmpty(e);
				}
				
			}
			
			
		}
		
		public function setOnLimitReached(f:Function):void {
			onLimitReached = f;
		}
		
		public function setOnLimitUnreached(f:Function):void {
			onLimitUnreached = f;
		}	
		
		public function setOnNotEmpty(f:Function):void {
			onNotEmpty = f;
		}			
			

		
		override protected function beforeTweenIn():void {
			super.beforeTweenIn();
			lastText = '';
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
		


		

		
		// TODO getters and setters
		
		public function getTextField():TextField {
			return textField;
		}
		
		
	}
}
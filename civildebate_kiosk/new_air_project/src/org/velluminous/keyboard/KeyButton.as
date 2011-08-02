package org.velluminous.keyboard {	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	
	public class KeyButton extends Sprite {
		private var letter:String;
		private var label:TextField;
		private var surface:Sprite;
		private var w:Number;
		private var h:Number;
		
		public function KeyButton(letter:String, w:Number, h:Number) {
			super();
			letter = letter;
			w = w;
			h = h;
			init();
		}
		
		private function init():void {
			surface = new Sprite();
			
			
			addChild(surface);
			surface.addEventListener(MouseEvent.MOUSE_UP, handleMouseUp);
			surface.addEventListener(MouseEvent.MOUSE_DOWN, handleMouseDown);
			surface.addEventListener(MouseEvent.MOUSE_OUT, handleMouseUpOutside);
			surface.addEventListener(MouseEvent.MOUSE_OVER, handleMouseDragOver);
			drawText();
			
			render(false);
		}
		
		// draw the key surface
		public function render(on:Boolean):void	{
			surface.graphics.clear();
			if (on)	{
				surface.graphics.lineStyle(2, 0xffffff);
				surface.graphics.beginFill(0xffffff, 0.8);
			}
			else {
				surface.graphics.lineStyle(2, 0xffffff);
				surface.graphics.beginFill(0x000000, 0.25);
			}
			
			surface.graphics.drawRect(0, 0, w, h);
			surface.graphics.endFill(); 
		}
		
		/**
		 * draw the text
		 */
		private function drawText():void
		{
		
			 var format2:TextFormat	      = new TextFormat();
          	//format2.font		      = Constants.FONT_FAMILY;
          	format2.color                = 0x000000;
          	format2.size                 = 18;//w * 0.275;
			format2.align = TextFormatAlign.CENTER;
	//		format2.letterSpacing = Constants.FONT_LETTERSPACING; 
          	label  = new TextField();
			label.embedFonts = true;
			label.wordWrap = true;
			label.antiAliasType         = AntiAliasType.ADVANCED;
          	label.width = w
          	label.autoSize = TextFieldAutoSize.CENTER;
          	label.defaultTextFormat     = format2;
			label.text = letter;  
		    label.selectable = false;
			label.textColor = 0xffffff;
			surface.addChild(label);
			label.x = (w-label.width)/2;
			label.y = (h - label.height)/2;	
		}
		
		/**
		 * handle touch input
		 */
		private function handleMouseDown(e:MouseEvent):void
		{
			//SoundManager.getInstance().playsound(SoundManager.KEYBOARD_PRESS);
			render(true);
			dispatchEvent(new KeyButtonEvent(KeyButtonEvent.PRESS, letter));
		}

		/**
		 * handle touch input
		 */
		private function handleMouseUp(e:MouseEvent):void
		{
			render(false);
			dispatchEvent(new KeyButtonEvent(KeyButtonEvent.RELEASE, letter));
		}
		
		/**
		 * handle touch input
		 */
		private function handleMouseUpOutside(e:MouseEvent):void
		{
			render(false);
		}
		
		/**
		 * 
		 */
		private function handleMouseDragOver(e:MouseEvent):void
		{
			if (e.buttonDown)
				render(true);
		}
	}
}
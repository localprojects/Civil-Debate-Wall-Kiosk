package net.localprojects.keyboard {
	import com.adobe.utils.StringUtil;
	import com.greensock.TweenMax;
	import com.greensock.easing.*;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.*;
	
	import net.localprojects.Assets;
	import net.localprojects.Utilities;
		
	
	public class Key extends Sprite {
		private var keyWidth:Number;
		private var keyHeight:Number;
		public var letter:String;
		private var padding:Number;
		private var keyCap:Shape;
		private var textField:TextField;
		public var active:Boolean; // for toggles, like shift
		
		public function Key(_letter:String, w:Number, h:Number)	{
			super();
			letter = StringUtil.trim(_letter);
			active = false; 
			
			
			keyWidth = w;
			keyHeight = h;
			
			init();
		}
		
		private function init():void {
			padding = 8;
			
			// draw backboard / hit area
			this.graphics.beginFill(Utilities.randRange(0, int.MAX_VALUE), 0);
			this.graphics.drawRect(0, 0, keyWidth, keyHeight);
			this.graphics.endFill();

			this.graphics.lineStyle(2, Assets.COLOR_YES_LIGHT);
			this.graphics.drawRoundRect(padding, padding, keyWidth - padding * 2, keyHeight - padding * 2, 15, 15);			
			
			
			// activity overlay
			keyCap = new Shape();
			keyCap.graphics.beginFill(Assets.COLOR_YES_LIGHT);
			keyCap.graphics.lineStyle(2, Assets.COLOR_YES_LIGHT);
			keyCap.graphics.drawRoundRect(padding, padding, keyWidth - padding * 2, keyHeight - padding * 2, 15, 15);			
			keyCap.graphics.endFill();
			keyCap.alpha = 0;
			addChild(keyCap);
			
			// text label
			var textFormat:TextFormat = new TextFormat();			
			textFormat.bold = false;
			textFormat.font =  Assets.FONT_REGULAR;
			textFormat.align = TextFormatAlign.CENTER;
			textFormat.size = 20;
			
			textField = new TextField();
			textField.defaultTextFormat = textFormat;
			textField.embedFonts = true;
			textField.selectable = false;
			textField.cacheAsBitmap = true;
			textField.mouseEnabled = false;
			textField.gridFitType = GridFitType.NONE;
			textField.antiAliasType = AntiAliasType.ADVANCED;
			textField.textColor = Assets.COLOR_YES_LIGHT;
			textField.width = width;
			//textField.autoSize = TextFieldAutoSize.LEFT;
			textField.text = letter;
			textField.y = height / 2 - 10;
			addChild(textField);					
			
			
		}
		
		public function setLetter(s:String):void {
			letter = s;
			textField.text = letter;
		}

		
		public function onMouseDown(e:MouseEvent):void {
			
			
			TweenMax.to(keyCap, 0, {alpha: 1});
			TweenMax.to(textField, 0, {textColor: 0xffffff});
		}
		
		public function onMouseUp(e:MouseEvent):void {
			
			if(!active && letter == 'SHIFT') {
				active = true;
			}
			else {
				active = false;
				TweenMax.to(keyCap, 0.2, {alpha: 0, ease: Quart.easeOut});
				TweenMax.to(textField, 0, {textColor: Assets.COLOR_YES_LIGHT});
			}

			
			
		}
		
		
		
		
		public function onMouseOver(e:MouseEvent):void {
			// are we dragging over?
			if (e.buttonDown) {
				TweenMax.to(keyCap, 0, {alpha: 1});
				TweenMax.to(textField, 0, {textColor: 0xffffff});				
			}
		}		
		
		public function onMouseOut(e:MouseEvent):void {
			if (e.buttonDown) {
				TweenMax.to(keyCap, 0, {alpha: 0});
				TweenMax.to(textField, 0, {textColor: Assets.COLOR_YES_LIGHT});
			}
		}
		
		
		
	}
}
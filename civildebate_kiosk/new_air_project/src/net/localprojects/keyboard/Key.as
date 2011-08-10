package net.localprojects.keyboard {
	import com.adobe.utils.StringUtil;
	import com.greensock.TweenMax;
	import com.greensock.easing.*;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.text.*;
	import flash.utils.Timer;
	
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
		public var repeats:Boolean;
		
		// how long until we start repeating
		private var repeatDelay:int;
		private var repeatDelayTimer:Timer;
		
		// how long between repeats
		private var repeatInterval:int;
		private var repeatIntervalTimer:Timer;		
		
		public function Key(_letter:String, w:Number, h:Number)	{
			super();
			letter = StringUtil.trim(_letter);
			active = false; 
			
			
			keyWidth = w;
			keyHeight = h;
			
			init();
		}
		
		private function init():void {
			repeats = false;
			repeatDelay = 500;
			repeatInterval = 100;
			
			// repeat delay timer
			repeatDelayTimer = new Timer(repeatDelay, 1);
			repeatDelayTimer.addEventListener(TimerEvent.TIMER, onRepeatTimer);
			
			repeatIntervalTimer = new Timer(repeatInterval);
			repeatIntervalTimer.addEventListener(TimerEvent.TIMER, onRepeatIntervalTimer);			
			
			padding = 8;
			
			if (letter == 'SPACE') letter = ' ';
			
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
			textField.autoSize = TextFieldAutoSize.CENTER;
			textField.text = letter;
			textField.height = height;
//			textField.backgroundColor = 0xff0000;
//			textField.background = true;
			textField.y = height / 2 - 10;
			addChild(textField);					
			
			
		}
		
		private function onRepeatTimer(e:TimerEvent):void {
			repeatIntervalTimer.reset();			
			repeatIntervalTimer.start();
		}
		
		private function onRepeatIntervalTimer(e:TimerEvent):void {
			if (repeats) {
				this.dispatchEvent(new MouseEvent(MouseEvent.MOUSE_UP, true, false, 0, 0, null, false, false, false, true, 0, true));
			}
		}		
		
		public function setLetter(s:String):void {
			letter = s;
			textField.text = letter;
		}
		
		public function onMouseDown(e:MouseEvent):void {
			// start repeat timer
			repeatDelayTimer.reset();
			repeatDelayTimer.start();
			
			TweenMax.to(keyCap, 0, {alpha: 1});
			TweenMax.to(textField, 0, {textColor: 0xffffff});
		}
		
		public function onMouseUp(e:MouseEvent):void {
			// using the command key to tag repeat keystrokes
			// sloppy
			if (!e.commandKey) {
				repeatDelayTimer.stop();
				repeatIntervalTimer.stop();
				
				if (!active && letter == 'SHIFT') {
					active = true;
				}
				else {
					active = false;
					TweenMax.to(keyCap, 0.2, {alpha: 0, ease: Quart.easeOut});
					TweenMax.to(textField, 0, {textColor: Assets.COLOR_YES_LIGHT});
				}
			}
		}
		
		
		
		
		public function onMouseOver(e:MouseEvent):void {
			// are we dragging over?
			if (e.buttonDown) {
				repeatDelayTimer.reset();
				repeatDelayTimer.start();				
				TweenMax.to(keyCap, 0, {alpha: 1});
				TweenMax.to(textField, 0, {textColor: 0xffffff});				
			}
		}		
		
		public function onMouseOut(e:MouseEvent):void {
			if (e.buttonDown) {
				repeatDelayTimer.stop();
				repeatIntervalTimer.stop();				
				TweenMax.to(keyCap, 0, {alpha: 0});
				TweenMax.to(textField, 0, {textColor: Assets.COLOR_YES_LIGHT});
			}
		}
		
		
		
	}
}
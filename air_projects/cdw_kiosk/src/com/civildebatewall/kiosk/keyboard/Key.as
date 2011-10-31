package com.civildebatewall.kiosk.keyboard {
	import com.adobe.utils.StringUtil;
	import com.civildebatewall.Assets;
	import com.civildebatewall.Utilities;
	import com.greensock.TweenMax;
	import com.greensock.easing.*;
	import com.kitschpatrol.futil.Math2;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.text.*;
	import flash.utils.Timer;
	
	
	public class Key extends Sprite {
		private var keyWidth:Number;
		private var keyHeight:Number;
		public var letter:String;
		private var padding:Number;
		private var keyCap:Shape;
		private var textField:TextField;
		public var active:Boolean; // for toggles, like shift
		public var repeats:Boolean;
		public var color:uint;
		
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
						
			// prep activity overlay
			keyCap = new Shape();
			keyCap.alpha = 0;
			addChild(keyCap);
			
			draw();			
			
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
			textField.textColor = color;
			textField.width = width;
			textField.autoSize = TextFieldAutoSize.CENTER;
			textField.text = letter;
			textField.height = height;
			textField.y = (height / 2) - 13;
			addChild(textField);
		}
		
		private function draw():void {
			// draw backboard / hit area
			this.graphics.clear();
			this.graphics.beginFill(Math2.randRange(0, int.MAX_VALUE), 0);
			this.graphics.drawRect(0, 0, keyWidth, keyHeight);
			this.graphics.endFill();
			
			this.graphics.lineStyle(2, color);
			this.graphics.drawRoundRect(padding, padding, keyWidth - padding * 2, keyHeight - padding * 2, 15, 15);
			
			keyCap.graphics.clear();
			keyCap.graphics.beginFill(color);
			keyCap.graphics.lineStyle(2, color);
			keyCap.graphics.drawRoundRect(padding, padding, keyWidth - padding * 2, keyHeight - padding * 2, 15, 15);			
			keyCap.graphics.endFill();
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
					TweenMax.to(textField, 0, {textColor: color});
				}
			}
		}
		
		public function setColor(c:uint):void {
			color = c;
			textField.textColor = color;
			draw(); // redraw
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
				TweenMax.to(textField, 0, {textColor: color});
			}
		}
		
		
		
	}
}
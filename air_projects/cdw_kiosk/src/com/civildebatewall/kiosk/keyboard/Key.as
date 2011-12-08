package com.civildebatewall.kiosk.keyboard {
	
	import com.adobe.utils.StringUtil;
	import com.civildebatewall.Assets;
	import com.greensock.TweenMax;
	import com.greensock.easing.Quart;
	import com.kitschpatrol.futil.Random;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.text.AntiAliasType;
	import flash.text.GridFitType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	import flash.text.TextFormatAlign;
	import flash.utils.Timer;
	
	public class Key extends Sprite {
		
		public var activeLetter:String;
		public var letter:String;
		public var shiftLetter:String;		
		
		private var keyWidth:Number;
		private var keyHeight:Number;
		private var paddingVertical:Number;
		private var paddingHorizontal:Number;
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
		
		public function Key(width:Number, height:Number, paddingVertical:Number, paddingHorizontal:Number, letter:String, shiftLetter:String = null)	{
			super();
			keyWidth = width;
			keyHeight = height;
			this.paddingVertical = 10;
			this.paddingHorizontal = paddingHorizontal;
			this.letter = StringUtil.trim(letter);
			this.shiftLetter = (shiftLetter == null) ? this.letter.toUpperCase() : StringUtil.trim(shiftLetter);
			active = false;
			activeLetter = this.letter; // default to lowercase
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
			
			
			if ((activeLetter == "SHIFT1") || (activeLetter == "SHIFT2")) {
				activeLetter = "SHIFT";
				shiftLetter = "SHIFT";
				letter = "SHIFT";				
			}
			
			if (activeLetter == "SPACE") {
				activeLetter = " ";
				shiftLetter = " ";
				letter = " ";
			}
						
			// prep activity overlay
			keyCap = new Shape();
			keyCap.alpha = 0;
			addChild(keyCap);
			
			draw();			
			
			// text label
			var textFormat:TextFormat = new TextFormat();			
			textFormat.bold = true;
			textFormat.font = Assets.FONT_BOLD;
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
			textField.text = activeLetter;
			textField.height = height;
			textField.y = (height / 2) - 10;
			addChild(textField);
		}
		
		private function draw():void {
			// draw backboard / hit area	
			this.graphics.clear();
			this.graphics.beginFill(int(Random.range(0, int.MAX_VALUE)), 0);
			this.graphics.drawRect(0, 0, keyWidth + (paddingHorizontal * 2), keyHeight + (paddingVertical * 2));
			this.graphics.endFill();
			
			this.graphics.lineStyle(2, color, 1, true);
			this.graphics.drawRoundRect(paddingHorizontal, paddingVertical, keyWidth, keyHeight, 15, 15);

			keyCap.graphics.clear();
			keyCap.graphics.beginFill(color);
			keyCap.graphics.lineStyle(2, color, 1, true);
			keyCap.graphics.drawRoundRect(paddingHorizontal, paddingVertical, keyWidth, keyHeight, 15, 15);			
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
			activeLetter = s;
			textField.text = activeLetter;
		}
		
		public function onMouseDown(e:MouseEvent):void {
			// start repeat timer
			repeatDelayTimer.reset();
			repeatDelayTimer.start();
			
			drawDown();
		}
		
		public function onMouseUp(e:MouseEvent):void {
			// using the command key to tag repeat keystrokes
			// sloppy
			if (!e.commandKey) {
				repeatDelayTimer.stop();
				repeatIntervalTimer.stop();
				
				if (!active && letter == "SHIFT") {
					active = true;
				}
				else {
					active = false;
					drawUp();
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
			trace("over");
			if (e.buttonDown) drawOver();
		}
		
		
		public function onMouseOut(e:MouseEvent):void {
			if (e.buttonDown) drawOut();
		}
		
		public function drawDown():void {
			TweenMax.to(keyCap, 0, {alpha: 1});
			TweenMax.to(textField, 0, {textColor: 0xffffff});			
		}
		
		public function drawUp():void {
			TweenMax.to(keyCap, 0.2, {alpha: 0, ease: Quart.easeOut});
			TweenMax.to(textField, 0, {textColor: color});			
		}
		
		public function drawOver():void {
			repeatDelayTimer.reset();
			repeatDelayTimer.start();				
			TweenMax.to(keyCap, 0, {alpha: 1});
			TweenMax.to(textField, 0, {textColor: 0xffffff});			
		}
		
		public function drawOut():void {
			repeatDelayTimer.stop();
			repeatIntervalTimer.stop();				
			TweenMax.to(keyCap, 0, {alpha: 0});
			TweenMax.to(textField, 0, {textColor: color});			
		}
		
		
	}
}
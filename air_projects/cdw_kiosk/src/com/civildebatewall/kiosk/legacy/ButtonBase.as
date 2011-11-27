package com.civildebatewall.kiosk.legacy {
	import com.greensock.TweenMax;
	import com.greensock.easing.*;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.*;
	import flash.utils.Timer;
	
	import com.civildebatewall.Assets;
	import com.civildebatewall.kiosk.core.Kiosk;
	
	public class ButtonBase extends OldBlockBase {
		
		public static const ACTIVE:String = 'active';
		public static const INACTIVE:String = 'active';
		public static const UP:String = 'active';
		public static const DOWN:String = 'active';		
		private var mode:String;
		protected var onClick:Function;
		protected var onDown:Function;		
		protected var outline:Shape;
		protected var background:Sprite;
		protected var _backgroundColor:uint;
		protected var _backgroundDownColor:uint;
		protected var _disabledColor:uint = 0;		
		
		protected var timeout:Number; // time between presses
		protected var timer:Timer;
		public var locked:Boolean;
	
		public function ButtonBase() {
			super();
			init();
		}
		
		
		public function setTimeout(time:Number):void {
			timeout = time;
			timer.delay = timeout;
			timer.reset();
			timer.stop();
		}
			
		private function init():void {
			background = new Sprite();
			onClick = defaultOnClick;
			this.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			//this.addEventListener(TouchEvent.TOUCH_BEGIN, onMouseDown);			
			//this.addEventListener(MouseEvent.CLICK, onClick);
			
			locked = false;
			timeout = 0;
			timer = new Timer(timeout );
			timer.addEventListener(TimerEvent.TIMER, onTimeout);
		}
		
		private function onTimeout(e:TimerEvent):void {
			trace('button back!');
			unlock();
		}
		
		public function unlock():void {
			locked = false;
			timer.stop();
			TweenMax.to(background, 1, {ease: Quart.easeOut, colorTransform: {tint: _backgroundColor, tintAmount: 1}});
			TweenMax.to(outline, 1, {ease: Quart.easeOut, alpha: 1});			
		}
		
		protected function onMouseDown(e:MouseEvent):void {
			if (!locked) {
				if (onDown != null) onDown(e);
				Kiosk.self.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
				TweenMax.to(background, 0, {colorTransform: {tint: _backgroundDownColor, tintAmount: 1}});
			}
		}
		
		
		
		protected function onMouseUp(e:MouseEvent):void {
			
			if (timeout > 0) {
				locked = true;
				timer.reset();
				timer.start();
				TweenMax.to(background, 0.3, {ease: Quart.easeOut, colorTransform: {tint: _disabledColor, tintAmount: 1}});
				TweenMax.to(outline, 0.3, {ease: Quart.easeOut, alpha: 0});				
			}
			else {
				TweenMax.to(background, 0.3, {ease: Quart.easeOut, colorTransform: {tint: _backgroundColor, tintAmount: 1}});
			}
			
			Kiosk.self.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);			
			
			onClick(e);
		}		
		
		
		protected function defaultOnClick(e:MouseEvent):void {
			trace("default button click, nothing to do");
		}
		
		public function setDisabledColor(c:uint):void {
			_disabledColor = c;			
		}
		
		
		public function setOnClick(f:Function):void {
			if (f == null) {
				disable();
			}
			else {
				onClick = f;
				enable();
			}
		}
		
		public function setOnDown(f:Function):void {
			if (f == null) {
				//disable();
			}
			else {
				onDown = f;
				//enable();
			}
		}		
		
		
		public function setLabel(text:String, instant:Boolean = false):void {
			// override me
		}
		
		
		public function enable():void {
			this.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			
			//this.addEventListener(TouchEvent.TOUCH_BEGIN, onMouseDown);			
		}
		
		
		public function disable():void {
			trace('disabled');
			this.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
						
			//this.removeEventListener(TouchEvent.TOUCH_BEGIN, onMouseDown);			
		}
		
		
		protected function draw():void {
			// override me
		}
		
		public function setDownColor(c:uint):void {
			_backgroundDownColor = c;
		}
		
	}
}
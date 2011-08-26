package net.localprojects.ui {
	import com.greensock.TweenMax;
	import com.greensock.easing.*;
	
	import flash.display.Sprite;
	import flash.events.*;
	import flash.utils.Timer;
	
	import net.localprojects.CDW;
	import net.localprojects.blocks.BlockBase;
	
	public class ButtonBase extends BlockBase {
		
		public static const ACTIVE:String = 'active';
		public static const INACTIVE:String = 'active';
		public static const UP:String = 'active';
		public static const DOWN:String = 'active';		
		private var mode:String;
		protected var onClick:Function;
		protected var background:Sprite;
		protected var _backgroundColor:uint;
		protected var _backgroundDownColor:uint;
		
		protected var timeout:Number; // time between presses
		private var timer:Timer;
		private var locked:Boolean;
	
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
			locked = false;
		}
		
		protected function onMouseDown(e:MouseEvent):void {
			if (!locked) {
				CDW.ref.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
				TweenMax.to(background, 0, {colorTransform: {tint: _backgroundDownColor, tintAmount: 1}});
			}
		}
		
		protected function onMouseUp(e:MouseEvent):void {
			
			if (timeout > 0) {
				locked = true;
				timer.reset();
				timer.start();
			}
			
			CDW.ref.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);			
			TweenMax.to(background, 0.3, {ease: Quart.easeOut, colorTransform: {tint: _backgroundColor, tintAmount: 1}});
			onClick(e);
		}		
		
		
		protected function defaultOnClick(e:MouseEvent):void {
			trace("default button click, nothing to do");
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
		
		
		public function setLabel(text:String):void {
			// override me
		}
		
		
		public function enable():void {
			this.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			//this.addEventListener(TouchEvent.TOUCH_BEGIN, onMouseDown);			
		}
		
		
		public function disable():void {
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
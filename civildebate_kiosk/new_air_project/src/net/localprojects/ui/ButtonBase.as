package net.localprojects.ui {
	import com.greensock.TweenMax;
	import com.greensock.easing.*;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
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
	
		public function ButtonBase() {
			super();
			init();
		}
			
		private function init():void {
			background = new Sprite();
			onClick = defaultOnClick;
			this.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			//this.addEventListener(MouseEvent.CLICK, onClick);
		}
		
		protected function onMouseDown(e:MouseEvent):void {
			CDW.ref.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			TweenMax.to(background, 0, {colorTransform: {tint: _backgroundColor, tintAmount: 0.2}});
		}
		
		protected function onMouseUp(e:MouseEvent):void {
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
		}
		
		public function disable():void {
			this.removeEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		}
		
		public function setMode(buttonMode:String):void {
			mode = buttonMode;
			// redraw
			
			switch (mode) {
				case ACTIVE:
					trace ('active');
					break;
				case INACTIVE:
					trace ('inactive');
					break;
				case UP:
					trace ('up');
					break;
				case DOWN:
					trace ('down');
					break;				
				default:
					trace('button set mode error')
			}
			
			draw();
		}
		
		protected function draw():void {
			
		}
		
		
		
		
		
	}
}
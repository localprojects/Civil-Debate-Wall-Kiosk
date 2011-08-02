package net.localprojects.ui {
	import flash.events.MouseEvent;
	
	import net.localprojects.blocks.BlockBase;
	
	public class ButtonBase extends BlockBase {
		
		public static const ACTIVE:String = 'active';
		public static const INACTIVE:String = 'active';
		public static const UP:String = 'active';
		public static const DOWN:String = 'active';		
		private var mode:String;
		protected var onClick:Function;
	
		public function ButtonBase() {
			onClick = defaultOnClick;
			this.addEventListener(MouseEvent.CLICK, onClick);
		}
		
		protected function defaultOnClick(e:MouseEvent):void {
			trace("default button click, nothing to do");
		}		
		
		public function setOnClick(f:Function):void {
			this.removeEventListener(MouseEvent.CLICK, onClick);
			onClick = f;
			this.addEventListener(MouseEvent.CLICK, onClick);			
		}
		
		public function setLabel(text:String):void {
			// override me
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
package net.localprojects.ui {
	import flash.events.MouseEvent;
	
	import net.localprojects.blocks.BlockBase;
	
	public class ButtonBase extends BlockBase {
		
		protected var onClick:Function;
		
		// enable / disable?
		
		
		protected function defaultOnClick(e:MouseEvent):void {
			trace("default button click, nothing to do");
		}
		
		public function ButtonBase() {
			onClick = defaultOnClick;
			this.addEventListener(MouseEvent.CLICK, onClick);
		}
		
		public function setOnClick(f:Function):void {
			this.removeEventListener(MouseEvent.CLICK, onClick);
			onClick = f;
			this.addEventListener(MouseEvent.CLICK, onClick);			
		}
		
		
		
		
		
	}
}
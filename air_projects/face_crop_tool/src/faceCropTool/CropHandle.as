package faceCropTool
{
	import com.kitschpatrol.futil.utilitites.ColorUtil;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.ui.Mouse;
	
	public class CropHandle extends Sprite
	{
		
		public var active:Boolean;
		
		public function CropHandle() {

			super();
			
			buttonMode = true;
			active = false;
			drawUp();
			
			this.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			this.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		}
		
		private function onMouseDown(e:MouseEvent):void {
			drawDown();
			active = true;
			this.startDrag();
			this.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
		}
		
		private function onMouseUp(e:MouseEvent):void {
			drawUp();
			active = false;
			this.stopDrag();
			this.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
		}		
		
		private function onMouseMove(e:MouseEvent):void {
			this.dispatchEvent(new Event(Event.CHANGE, true));
		}
		
		
		private function drawUp():void {
			this.graphics.clear();
			this.graphics.lineStyle(6, ColorUtil.grayPercent(50));
			this.graphics.beginFill(ColorUtil.grayPercent(20));
			this.graphics.drawCircle(0, 0, 20);
			this.graphics.endFill();			
		}
		
		private function drawDown():void {
			this.graphics.clear();
			this.graphics.lineStyle(6, ColorUtil.grayPercent(50));
			this.graphics.beginFill(ColorUtil.grayPercent(40));
			this.graphics.drawCircle(0, 0, 20);
			this.graphics.endFill();			
		}		
	}
}
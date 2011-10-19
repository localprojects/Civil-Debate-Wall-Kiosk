package faceCropTool
{
	import com.kitschpatrol.futil.utilitites.ColorUtil;
	import com.kitschpatrol.futil.utilitites.GeomUtil;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Rectangle;
	

	public class CropRect extends Sprite
	{
		// Use rect!
		
		
		
		
		private var topLeftHandle:CropHandle;
		private var topRightHandle:CropHandle;
		private var bottomRightHandle:CropHandle;
		private var bottomLeftHandle:CropHandle;
		
		public function CropRect()	{
			super();
			
			// Quick hack to compensate for scaling
			// TODO adapt for different window sizes
			this.scaleX = 0.5;
			this.scaleY = 0.5;
			
			
  
			
			topLeftHandle = new CropHandle();
			addChild(topLeftHandle);

			topRightHandle = new CropHandle();
			addChild(topRightHandle);			
			
			bottomRightHandle = new CropHandle();	
			addChild(bottomRightHandle);
			
			bottomLeftHandle = new CropHandle();
			addChild(bottomLeftHandle);
			
			draw();
			
			// TODO watch for change instead
	//		this.addEventListener(Event.CHANGE, onChange);	
			this.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function draw():void {
			

			if (topLeftHandle.active) {
				State.faceCropRect.left = topLeftHandle.x;
				State.faceCropRect.top = topLeftHandle.y;				
			}
			else {
				topLeftHandle.x = State.faceCropRect.left;
				topLeftHandle.y = State.faceCropRect.top;
			}
			
			if (topRightHandle.active) {
				State.faceCropRect.right = topRightHandle.x;
				State.faceCropRect.top = topRightHandle.y;				
			}
			else {
				topRightHandle.x = State.faceCropRect.right;
				topRightHandle.y = State.faceCropRect.top;
			}			
			
			if (bottomLeftHandle.active) {
				State.faceCropRect.left = bottomLeftHandle.x;
				State.faceCropRect.bottom = bottomLeftHandle.y;				
			}
			else {
				bottomLeftHandle.x = State.faceCropRect.left;
				bottomLeftHandle.y = State.faceCropRect.bottom;
			}
			
			if (bottomRightHandle.active) {
				State.faceCropRect.right = bottomRightHandle.x;
				State.faceCropRect.bottom = bottomRightHandle.y;				
			}
			else {
				bottomRightHandle.x = State.faceCropRect.right;
				bottomRightHandle.y = State.faceCropRect.bottom;
			}
			
			
			this.graphics.clear();
			this.graphics.lineStyle(10, ColorUtil.gray(70));
			this.graphics.drawRect(State.faceCropRect.x, State.faceCropRect.y, State.faceCropRect.width, State.faceCropRect.height);
			this.graphics.endFill();
			
		}
		
		
		
		private function onEnterFrame(e:Event):void {
			draw();
		}
		
		
		
		// draw lines between
	}
}
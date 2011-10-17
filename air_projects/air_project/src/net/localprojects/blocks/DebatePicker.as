package net.localprojects.blocks {
	import flash.display.Sprite;
	import flash.events.*;
	import flash.geom.*;
	import flash.utils.*;
	
	import net.localprojects.Assets;
	import net.localprojects.ui.ThumbnailButton;
	
	public class DebatePicker extends Block {
		
		private var debateHolder:Sprite = new Sprite();
		private	var padding:int = 0;
		private var lastMouseX:int;		
		
		public function DebatePicker() {
			init();
		}
		
		private function init():void {
			
			// strip (catches mouse events.. TODO make it bigger?)
			graphics.beginFill(0xffffff);
			graphics.drawRect(0, 0, 1080, 141);
			
			// fill it with debate thumbnails			
			// TODO build this from the state and move to update function
			for(var i:int = 0; i < 50; i++) {
				var tempDebateThumbnail:ThumbnailButton = new ThumbnailButton();
				tempDebateThumbnail.x = padding + ((tempDebateThumbnail.width + padding) * i);
				tempDebateThumbnail.y = 0;			
				tempDebateThumbnail.active = false;
				debateHolder.addChild(tempDebateThumbnail);
				
				
			}
			
			// center the debate holder
			debateHolder.y = 0;
			debateHolder.x = (1080 - debateHolder.width) / 2;
			
			
			addChild(debateHolder);
			
			this.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			this.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			
			this.x = 0;
			this.y = 1748;	
		}
		
		// scroll physics
		private var vx:Number = 0;
		private var friction:Number = 0.9;
		private var vxThreshold:Number = 0;
		private var mouseDown:Boolean = false;
		
		private function onMouseDown(e:MouseEvent):void {
			Main.stageRef.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			Main.stageRef.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			
			mouseDown = true;
			
			lastMouseX = Main.mouseX;
			vx = 0;
		}
		
		private function onMouseMove(e:MouseEvent):void {
			// scroll the strip
			// TODO add limit bounding
			debateHolder.x += Main.mouseX - lastMouseX;
			vx = Main.mouseX - lastMouseX; // TODO average multiple recent velocities instead of the latest? Depends on touch screen. 
			lastMouseX = Main.mouseX;	
		}
		
		private function onEnterFrame(e:Event):void {
			// check bounds
			if (debateHolder.x > 0) {
				debateHolder.x = 0;
				vx = 0;
				trace("left limit");				
			}
			else if (debateHolder.x < ((debateHolder.width - Main.stageWidth) * -1)) {
				debateHolder.x = (debateHolder.width - Main.stageWidth) * -1;
				vx = 0;
				trace("right limit");				
			}
			
			// inertia
			if (!mouseDown && (Math.abs(vx) > vxThreshold)) {
				debateHolder.x += vx;
				vx *= friction;
			}
		}
		
		private function onMouseUp(e:MouseEvent):void {
			Main.stageRef.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			Main.stageRef.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			
			mouseDown = false;
			

			// are we clicking on a thumbnail? or just scrolling?
			var objects:Array = this.getObjectsUnderPoint(new Point(Main.mouseX, Main.mouseY));
			for (var i:int = 0; i < objects.length; i++) {
				//trace(objects[i].toString());	
				
				
				// kind of gross, use introspection to find out what's under the mouse instead of adding listeners to the thumbnails, need to block event bubbling instead?
				if (objects[i] is ThumbnailButton) {
					trace("clicked thumbnail!");
					// TODO figure out if we should interpret a click or a scroll (does the touchscreen do this for us?)					
				}
				
			}
			
			
			
		}
		
	}
}
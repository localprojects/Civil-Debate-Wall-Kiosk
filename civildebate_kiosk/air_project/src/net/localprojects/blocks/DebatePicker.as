package net.localprojects.blocks {
	import flash.display.Sprite;
	import flash.events.*;
	
	import net.localprojects.Assets;
	import net.localprojects.ui.DebateThumbnail;
	
	public class DebatePicker extends Sprite {
		
		private var debateHolder:Sprite = new Sprite();
		private	var padding:int = 84;
		private var lastMouseX:int;		
		
		public function DebatePicker() {
			init();
		}
		
		private function init():void {
			
			// background
			graphics.beginFill(0x000000);
			graphics.drawRect(0, 0, 1080, 200);
			graphics.endFill();
			
			// strip
			graphics.beginFill(0x292829);
			graphics.drawRect(0, 30, 1080, 140);
			
			// fill it with debate thumbnails			
			// TODO build this from the state and move to update function
			for(var i:int = 0; i < 50; i++) {
				var tempDebateThumbnail:DebateThumbnail = new DebateThumbnail();
				tempDebateThumbnail.x = padding + ((tempDebateThumbnail.width + padding) * i);
				trace(tempDebateThumbnail.x);
				debateHolder.addChild(tempDebateThumbnail);
			}
			
			// center the debate holder
			debateHolder.y = 54;
			debateHolder.x = (1080 - debateHolder.width) / 2;
			
			
			addChild(debateHolder);
			
			this.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			
			this.x = 0;
			this.y = 1720;	
		}
		
		private function onMouseDown(e:MouseEvent):void {
			Main.stageRef.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			Main.stageRef.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			
			lastMouseX = Main.stageRef.mouseX;
		}
		
		private function onMouseMove(e:MouseEvent):void {
			// scroll the strip
			// TODO add inertia and limit bounding
			debateHolder.x += Main.stageRef.mouseX - lastMouseX;
			lastMouseX = Main.stageRef.mouseX;
		}
		
		private function onMouseUp(e:MouseEvent):void {
			Main.stageRef.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			Main.stageRef.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);			
		}
		
	}
}
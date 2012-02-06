/*------------------------------------------------------------------------------
Copyright (c) 2012 Local Projects. All rights reserved.

This file is part of The Civil Debate Wall.

The Civil Debate Wall is free software: you can redistribute it and/or modify
it under the terms of the GNU Affero General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

The Civil Debate Wall is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU Affero General Public License for more details.

You should have received a copy of the GNU Affero General Public License
along with The Civil Debate Wall.  If not, see <http://www.gnu.org/licenses/>.
------------------------------------------------------------------------------*/

package faceCropTool.utilities {
	import com.kitschpatrol.futil.utilitites.ColorUtil;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class CropHandle extends Sprite {
		
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
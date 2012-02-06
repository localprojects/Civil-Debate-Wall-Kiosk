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
	
	import faceCropTool.core.State;
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	public class CropRect extends Sprite {
		
		// Extend rect instead?
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
			// this.addEventListener(Event.CHANGE, onChange);	
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
		
	}
}
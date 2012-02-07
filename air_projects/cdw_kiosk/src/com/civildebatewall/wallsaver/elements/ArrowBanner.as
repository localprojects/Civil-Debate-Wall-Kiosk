/*--------------------------------------------------------------------
Civil Debate Wall Kiosk
Copyright (c) 2012 Local Projects. All rights reserved.

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as
published by the Free Software Foundation, either version 2 of the
License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public
License along with this program. 

If not, see <http://www.gnu.org/licenses/>.
--------------------------------------------------------------------*/

package com.civildebatewall.wallsaver.elements {
	
	import flash.display.Sprite;
	
	public class ArrowBanner extends Sprite	{
		
		public static const RIGHT:String = "right";
		public static const LEFT:String = "left";		
		
		private var direction:String;
		private var size:int;
		private var color:uint;
		private var arrowWidth:int;
		private var arrowHeight:int;
		
		public function ArrowBanner(size:int, arrowWidth:int, arrowHeight:int, color:uint, direction:String) {
			super();
			this.size = size;
			this.arrowWidth = arrowWidth;
			this.arrowHeight = arrowHeight;
			this.color = color;
			this.direction = direction;
			
			draw();
		}

		private function draw():void {
			graphics.clear();
			graphics.beginFill(color);			
			
			if (direction == RIGHT) { 			
				graphics.moveTo(0, 0); // top left
				graphics.lineTo(size + arrowWidth, 0); // top right
				graphics.lineTo(size + arrowWidth + arrowWidth, arrowHeight / 2); // arrow point
				graphics.lineTo(size + arrowWidth, arrowHeight) // bottom right
				graphics.lineTo(0, arrowHeight); // bottom left
				graphics.lineTo(arrowWidth, arrowHeight / 2); // arrow indent
				graphics.lineTo(0, 0); // back to top left
			}
			else if (direction == LEFT) {
				graphics.moveTo(0, arrowHeight / 2); // arrow point
				graphics.lineTo(arrowWidth, 0); // top left
				graphics.lineTo(size + arrowWidth + arrowWidth, 0); // top right
				graphics.lineTo(size + arrowWidth, arrowHeight / 2); // arrow indent
				graphics.lineTo(size + arrowWidth + arrowWidth, arrowHeight); // bottom right
				graphics.lineTo(arrowWidth, arrowHeight); // bottom left
				graphics.lineTo(0, arrowHeight / 2); // arrow point
			}
			else {
				throw new Error("Invalid arrow direction \"" + direction + "\""); 
			}
			
			graphics.endFill();			
		}
		
	}
}

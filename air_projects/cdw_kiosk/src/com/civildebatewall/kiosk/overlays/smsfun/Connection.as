/*--------------------------------------------------------------------
Civil Debate Wall Kiosk
Copyright (c) 2012 Local Projects. All rights reserved.

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU Affero General Public License as
published by the Free Software Foundation, either version 3 of the
License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU Affero General Public License for more details.

You should have received a copy of the GNU Affero General Public
License along with this program. 

If not, see <http://www.gnu.org/licenses/>.
--------------------------------------------------------------------*/

package com.civildebatewall.kiosk.overlays.smsfun {
	
	import com.civildebatewall.Assets;
	import com.civildebatewall.data.containers.Post;
	import com.kitschpatrol.futil.drawing.DashedLine;
	
	import flash.display.CapsStyle;
	import flash.display.LineScaleMode;
	import flash.display.Shape;
	import flash.geom.Point;
	
	public class Connection extends DashedLine {
		
		private var dot:Shape;
		
		public function Connection() {
			super(20 / 4, 25 / 4, 20 / 4, 0xff0000, 0x00ff00, CapsStyle.NONE, LineScaleMode.NORMAL);
			
			// disabled per Katie (and multi-color complexities)
//			// create the line point dot
//			dot = new Shape();
//			dot.graphics.beginFill(colorA);
//			dot.graphics.drawCircle(0, 0, 8);
//			dot.graphics.endFill();
//			addChild(dot);
		}
		
		public function get penPosition():Point {
			return path.pointAt(step);
		}
		
		override protected function draw():void {
			// make the pen dot follow the line
//			var penHead:Point = path.pointAt(step);
//			dot.x = penHead.x;
//			dot.y = penHead.y;	
			
			super.draw();
		}	
		
	}
}

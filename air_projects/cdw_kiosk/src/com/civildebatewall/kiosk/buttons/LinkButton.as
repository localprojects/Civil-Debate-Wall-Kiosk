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

package com.civildebatewall.kiosk.buttons {
	
	import com.civildebatewall.Assets;
	import com.greensock.TweenMax;
	import com.kitschpatrol.futil.blocks.BlockText;
	import com.kitschpatrol.futil.utilitites.ObjectUtil;
	
	import flash.display.Shape;
	
	public class LinkButton extends BlockText {

		private var underline:Shape;
		public var value:int;
		
		public function LinkButton(params:Object = null) {
			
			super(
				ObjectUtil.mergeObjects(
					params, 		
					{textFont: Assets.FONT_REGULAR,
					backgroundColor: Assets.COLOR_GRAY_5,
					textColor: Assets.COLOR_GRAY_25,
					textSize: 14,
					buttonMode: true,
					visible: true
				})
			);
			
			underline = new Shape();
			underline.graphics.beginFill(Assets.COLOR_GRAY_85);
			underline.graphics.drawRect(0, 0, this.width - 2, 2);
			underline.graphics.endFill();
			underline.y = this.height + 5;
			underline.x = 3;
			underline.alpha = 0;
			addChild(underline);
		}
		
		public function drawMouseDown():void {
			textColor = Assets.COLOR_GRAY_85;
			underlineAlpha = 1;
		}
		
		public function drawMouseUp():void {
			TweenMax.to(this, 0.5, {textColor: Assets.COLOR_GRAY_25, underlineAlpha: 0});			
		}

		public function get underlineAlpha():Number {	return underline.alpha;	}		
		public function set underlineAlpha(a:Number):void {
			underline.alpha = a;
		}
		
	}
}

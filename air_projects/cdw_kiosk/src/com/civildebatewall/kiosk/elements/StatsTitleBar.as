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

package com.civildebatewall.kiosk.elements {

	import com.civildebatewall.Assets;
	import com.kitschpatrol.futil.blocks.BlockText;
	import com.kitschpatrol.futil.constants.Alignment;
	
	import flash.display.Shape;
	
	public class StatsTitleBar extends BlockText {
		
		public var leftDot:Shape;
		public var rightDot:Shape;		
		
		public function StatsTitleBar(params:Object = null)	{
			
			super(params);			
			
			setParams({
				textFont: Assets.FONT_BOLD,
				textBold: true,
				textSize: 18,
				textColor: 0xffffff,
				letterSpacing: -1,
				textAlignmentMode: Alignment.TEXT_CENTER,
				alignmentPoint: Alignment.CENTER,
				width: 1022,
				height: 64,
				backgroundColor: 0x000000				
			});
			
			content.mouseChildren = false;
			content.mouseEnabled = false;
			
			leftDot = new Shape();
			leftDot.graphics.beginFill(Assets.COLOR_YES_LIGHT);
			leftDot.graphics.drawCircle(252, 32, 4);
			leftDot.graphics.endFill();
			background.addChild(leftDot);
			
			rightDot = new Shape();
			rightDot.graphics.beginFill(Assets.COLOR_NO_LIGHT);
			rightDot.graphics.drawCircle(770, 32, 4);
			rightDot.graphics.endFill();			
			background.addChild(rightDot);
		}
		
	}
}

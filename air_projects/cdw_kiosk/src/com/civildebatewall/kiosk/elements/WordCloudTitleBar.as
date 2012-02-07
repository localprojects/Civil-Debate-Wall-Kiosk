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

package com.civildebatewall.kiosk.elements {

	import com.kitschpatrol.futil.blocks.BlockBase;
	
	public class WordCloudTitleBar extends StatsTitleBar {
		
		public var clearTagButton:ClearTagButton;
		
		public function WordCloudTitleBar(params:Object = null) {
			super(params);
			
			maxSizeBehavior = BlockBase.MAX_SIZE_CLIPS;

			clearTagButton = new ClearTagButton();
			clearTagButton.x = width;
			clearTagButton.setDefaultTweenIn(0.5, {x: width - clearTagButton.width});
			clearTagButton.setDefaultTweenOut(1, {x: width});
			background.addChild(clearTagButton);
			
			clearTagButton.mask = clippingMask;			
		}
	
	}
}

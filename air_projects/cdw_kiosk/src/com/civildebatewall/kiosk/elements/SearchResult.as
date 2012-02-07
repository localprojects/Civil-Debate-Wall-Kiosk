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
	
	import com.civildebatewall.Assets;
	import com.civildebatewall.data.containers.Post;
	import com.civildebatewall.kiosk.buttons.GoToDebateButton;
	
	public class SearchResult extends Comment {

		private var goToDebateButton:GoToDebateButton;		
		
		public function SearchResult(post:Post, postNumber:int = -1) {		
			super(post, postNumber);
			
			setParams({
				backgroundAlpha: 1,
				backgroundColor: Assets.COLOR_GRAY_5
			})
			
			flagButton.x = 672;
			
			goToDebateButton = new GoToDebateButton();
			goToDebateButton.y = -1;			
			goToDebateButton.x = 709;
			goToDebateButton.visible = true;
			goToDebateButton.targetPost = post;
			addChild(goToDebateButton);
		}
		
	}
}

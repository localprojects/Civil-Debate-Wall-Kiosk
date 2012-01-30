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

package com.civildebatewall.kiosk.elements.opinion_text {
	import com.civildebatewall.CivilDebateWall;
	import com.civildebatewall.State;
	
	import flash.events.Event;
	
	public class OpinionTextSuperlative extends OpinionTextBase	{
		
		public function OpinionTextSuperlative() {
			super();
			width = 444;
			maxHeight = 600; // TODO ?
			
			// size changes
			nameTag.maxWidth = width;			
			nameTag.height = 39;
			nameTag.paddingLeft = 18;
			nameTag.paddingRight = 18;
			nameTag.textSize = 15;
			nameTag.leading = nameTag.height;
			
			opinion.maxWidth = width;
			opinion.paddingTop = 13;
			opinion.paddingBottom = 17;	
			opinion.paddingLeft = 18;
			opinion.paddingRight = 18;			
			opinion.leading = 10;
			opinion.textSize = 15;
		}		
	}
}

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

package com.civildebatewall.kiosk.elements.question_text {
	
	public class QuestionHeaderThread extends QuestionHeaderBase {
		
		public function QuestionHeaderThread() {
			super();
			
			// Above the comment thread
			setParams({
				width: 1024,
				height: 250,
				textSize: 28,
				leading: 22,
				paddingRight: 71,
				paddingLeft: 71,
				lineWidth: 964,
				backgroundAlpha: 0.85			
			});
			
			drawLines();			
		}
		
	}
}

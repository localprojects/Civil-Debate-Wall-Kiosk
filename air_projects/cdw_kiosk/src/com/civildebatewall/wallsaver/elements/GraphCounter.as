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

	import com.civildebatewall.Assets;
	import com.kitschpatrol.futil.blocks.BlockText;
	import com.kitschpatrol.futil.constants.Alignment;
	import com.kitschpatrol.futil.constants.Char;
	
	public class GraphCounter extends BlockText {
		
		public function GraphCounter() {
			super({
				text: "0",
				textColor: 0xffffff,
				textFont: Assets.FONT_BOLD,
				sizeFactorGlyphs: Char.SET_OF_NUMBERS,															 
				textSize: 225,
				alignmentPoint: Alignment.CENTER,																 
				showBackground: false,
				textAlignmentMode: Alignment.TEXT_CENTER,
				width: 702,
				visible: true
			});
		}
		
		public function get count():Number {
			return parseInt(text);
		}
		
		public function set count(value:Number):void {
			text = Math.round(value).toString();
		}
		
	}
}

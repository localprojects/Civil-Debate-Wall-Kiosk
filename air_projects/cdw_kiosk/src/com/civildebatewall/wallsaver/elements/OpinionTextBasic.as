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

package com.civildebatewall.wallsaver.elements {
	
	import com.civildebatewall.Assets;
	
	import flash.text.AntiAliasType;
	import flash.text.TextField;
	import flash.text.TextFieldAutoSize;
	import flash.text.TextFormat;
	
	// work around for windows disappearing text glitches (showing up on some screens, not on others)
	// replaces nicer block text approach, see OpinionRow.as in commit 95987b83129902d1c3eb009556649df484f2fbd5 for example
	public class OpinionTextBasic extends TextField	{
		
		public function OpinionTextBasic(text:String) {
			super();
			
			var textFormat:TextFormat = new TextFormat();
			textFormat.font = Assets.FONT_REGULAR;
			textFormat.size = 50.5;
			textFormat.color = 0xffffff;			
			textFormat.rightMargin = 110 / 4;
			textFormat.leftMargin = 110 / 4;

			multiline = false;
			selectable = false;
			embedFonts = true;
			multiline = true;
			antiAliasType = AntiAliasType.NORMAL;
			embedFonts = true;
			defaultTextFormat = textFormat;			
			autoSize = TextFieldAutoSize.LEFT;
			
			this.text = text;

			scaleX = 4;
			scaleY = 4;			
		}
		
	}
}

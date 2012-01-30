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

package com.civildebatewall.kiosk.buttons {

	import com.civildebatewall.Assets;
	import com.civildebatewall.data.Word;
	import com.kitschpatrol.futil.blocks.BlockText;
	import com.kitschpatrol.futil.constants.Alignment;
	import com.kitschpatrol.futil.utilitites.BitmapUtil;
	import com.kitschpatrol.futil.utilitites.StringUtil;
	
	public class WordButton extends BlockText {
		
		public var difference:Number;		
		public var normalDifference:Number;
		private var _posts:Array;
		public var word:Word; // keep the word reference
		public var yesCases:Number;
		public var noCases:Number;		
		
		public function WordButton(_word:Word)	{
			super();

			word = _word;
			normalDifference = word.normalDifference;
			_posts = word.posts;
			yesCases = word.yesCases;			
			noCases = word.noCases;			

			// set up the word button
			height = 57;
			backgroundRadius = 4;
			text = StringUtil.capitalize(word.theWord);
			textFont = Assets.FONT_BOLD;
			letterSpacing = -1;	
			textColor = 0xffffff;
			textSize = 25;
			textAlignmentMode = Alignment.TEXT_CENTER,
			paddingTop = 0;
			paddingRight = 13;
			paddingBottom = 0;
			paddingLeft = 13;
			leading = 25; // make sure we don't wrap
			backgroundColor = 0x000000;
			alignmentPoint = Alignment.CENTER;
			buttonMode = true;
			
			visible = true;
			updateColor();
		}
		
		// todo normal difference setter?
		public function updateColor():void {
			backgroundColor =	BitmapUtil.getPixelAtNormal(Assets.wordCloudGradient, normalDifference, 0);			
		}
		
	}
}

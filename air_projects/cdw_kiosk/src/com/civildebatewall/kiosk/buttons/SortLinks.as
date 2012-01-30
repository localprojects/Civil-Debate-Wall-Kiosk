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
	import com.civildebatewall.CivilDebateWall;
	import com.civildebatewall.State;
	import com.kitschpatrol.futil.blocks.BlockBase;
	import com.kitschpatrol.futil.blocks.BlockText;
	
	import flash.display.Bitmap;
	import flash.events.MouseEvent;
	
	public class SortLinks extends BlockBase	{
		
		private var sortedText:Bitmap;
		private var recentText:LinkButton;
		private var dividerA:BlockText;		
		private var yesText:LinkButton;
		private var dividerB:BlockText;
		private var noText:LinkButton;		
		private var dividerC:BlockText;
		private var mostDebatedText:LinkButton;
		private var selectedLink:LinkButton;
		private var clickedLink:LinkButton;	
		
		public function SortLinks() {
			super({
				backgroundColor: Assets.COLOR_GRAY_5,
				width: 1080,
				height: 78
			});
			
			sortedText = Assets.getSortedByText();
			
			recentText = new LinkButton({
				text: "Recent",
				value: State.SORT_BY_RECENT
				
			});
			
			dividerA = new BlockText({
				textFont: Assets.FONT_REGULAR,
				backgroundColor: Assets.COLOR_GRAY_5,
				textColor: Assets.COLOR_GRAY_25,
				textSize: 14,
				text: "/"				
			});
			
			yesText = new LinkButton({
				text: "Yes",
				value: State.SORT_BY_YES
			});
			
			dividerB = new BlockText({
				textFont: Assets.FONT_REGULAR,
				backgroundColor: Assets.COLOR_GRAY_5,
				textColor: Assets.COLOR_GRAY_25,
				textSize: 14,
				text: "/"				
			});			
			
			noText = new LinkButton({
				text: "No",
				value: State.SORT_BY_NO				
			});
			
			dividerC = new BlockText({
				textFont: Assets.FONT_REGULAR,
				backgroundColor: Assets.COLOR_GRAY_5,
				textColor: Assets.COLOR_GRAY_25,
				textSize: 14,
				text: "/"				
			});			
			
			mostDebatedText = new LinkButton({
				text: "Most Debated",
				value: State.SORT_BY_MOST_DEBATED				
			});
			

			var xOffset:Number = 321;
			var yOffset:Number = 32;
			var spacing:Number = 5;
			
			sortedText.x = xOffset;
			sortedText.y = yOffset;
			addChild(sortedText);
			
			recentText.x = sortedText.x + sortedText.width + (spacing * 2);
			recentText.y = yOffset;
			addChild(recentText);
			
			dividerA.x = recentText.x + recentText.width + spacing;
			dividerA.y = yOffset;
			addChild(dividerA);
			
			yesText.x = dividerA.x + dividerA.width + spacing;
			yesText.y = yOffset;
			addChild(yesText);
			
			dividerB.x = yesText.x + yesText.width + spacing;
			dividerB.y = yOffset;
			addChild(dividerB);
			
			noText.x = dividerB.x + dividerB.width + spacing;
			noText.y = yOffset;
			addChild(noText);
			
			dividerC.x = noText.x + noText.width + spacing;
			dividerC.y = yOffset;			
			addChild(dividerC);	
			
			mostDebatedText.x = dividerC.x + dividerC.width + spacing;
			mostDebatedText.y = yOffset;
			
			addChild(mostDebatedText);

			recentText.drawMouseDown();
			selectedLink = recentText;
			
			// Events, TODO drop these into block
			recentText.onButtonDown.push(down);
			yesText.onButtonDown.push(down);
			noText.onButtonDown.push(down);
			mostDebatedText.onButtonDown.push(down);
		
			recentText.onButtonUp.push(up);
			yesText.onButtonUp.push(up);
			noText.onButtonUp.push(up);
			mostDebatedText.onButtonUp.push(up);			
		}

		private function down(e:MouseEvent):void {
			clickedLink = e.currentTarget as LinkButton;
			clickedLink.drawMouseDown();
		}
		
		private function up(e:MouseEvent):void {
			if (selectedLink != clickedLink) {
				selectedLink.drawMouseUp();
				clickedLink.drawMouseDown();
				selectedLink = clickedLink;
				
				CivilDebateWall.state.setSort(selectedLink.value)
			}
		}
		
	}
}

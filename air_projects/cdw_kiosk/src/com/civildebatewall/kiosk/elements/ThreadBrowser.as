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
	import com.civildebatewall.CivilDebateWall;
	import com.civildebatewall.data.Data;
	import com.civildebatewall.kiosk.BlockInertialScroll;
	import com.kitschpatrol.futil.utilitites.GraphicsUtil;
	
	import flash.display.Shape;
	import flash.events.Event;
	
	public class ThreadBrowser extends BlockInertialScroll	{
		
		public function ThreadBrowser()	{
			super({
				backgroundColor: 0xffffff,
				backgroundAlpha: 0.85,
				width: 1024,
				maxHeight: 986,
				maxSizeBehavior: MAX_SIZE_CLIPS,
				scrollAxis: SCROLL_Y
			});
			
			CivilDebateWall.data.addEventListener(Data.DATA_UPDATE_EVENT, onDataUpdate);
		}
		
		private function onDataUpdate(e:Event):void {
			refreshContent();
		}
		
		override protected function beforeTweenIn():void {
			refreshContent();
			super.beforeTweenIn();
		}		
			
		public function refreshContent():void {
			var yOffset:int = 0;
		
			// clean up, note it's awkward to call content instead of "this"... compromises of Futil
			GraphicsUtil.removeChildren(content);			

			// sort
			CivilDebateWall.state.activeThread.posts.sortOn("created", Array.DESCENDING | Array.NUMERIC);						

			// skip the last one since it's the original post
			for (var i:uint = 0; i < CivilDebateWall.state.activeThread.posts.length - 1; i++) {
				
				// create rows
				var commentRow:Comment = new Comment(CivilDebateWall.state.activeThread.posts[i], i + 1);
				commentRow.x = 0;
				commentRow.y = yOffset;
				commentRow.visible = true;
				addChild(commentRow);
				
				yOffset += commentRow.height;
				
				// add the lines between the comments				
				if (i < CivilDebateWall.state.activeThread.postCount - 2) {
					var line:Shape = new Shape();
					line.graphics.lineStyle(1, Assets.COLOR_GRAY_25, 1.0, true);
					line.graphics.moveTo(0, 0);
					line.graphics.lineTo(commentRow.width - 60, 0);
					line.x = 30;
					line.y = yOffset;
					addChild(line);
				}
				
				yOffset += 1; // compensate for the line
			}
			
			// do we need to scroll?
			//scrollField.scrollAllowed = (scrollField.scrollSheet.height > _maxHeight - 30);
			//minScrollY = 0;
			//maxScrollY = content.height - height;			
		}
		
	}
}

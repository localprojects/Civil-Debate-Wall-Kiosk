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
	import com.civildebatewall.data.Data;
	import com.greensock.TweenMax;
	import com.kitschpatrol.futil.blocks.BlockText;
	import com.kitschpatrol.futil.constants.Alignment;
	import com.kitschpatrol.futil.constants.Char;
	import com.kitschpatrol.futil.utilitites.StringUtil;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class ViewCommentsButton extends BlockText	{
		public function ViewCommentsButton(params:Object = null) {
			super({
				textFont: Assets.FONT_REGULAR,
				textSize: 18,
				backgroundRadius: 8,
				textAlignmentMode: Alignment.TEXT_CENTER,
				textColor: 0xffffff,
				paddingLeft: 24,
				buttonMode: true,
				paddingRight: 24,
				width: 614,
				height: 64,
				alignmentPoint: Alignment.CENTER
			});
			
			CivilDebateWall.state.addEventListener(State.ACTIVE_THREAD_CHANGE, onActiveThreadChange);
			CivilDebateWall.state.addEventListener(Data.DATA_UPDATE_EVENT, onDataUpdate);
			
			onButtonDown.push(onDown);
			onStageUp.push(onUp);
		}
		
		private function onDown(e:MouseEvent):void {
			TweenMax.to(this, 0, {backgroundColor: CivilDebateWall.state.activeThread.firstPost.stanceColorLight});
		}
		
		private function onUp(e:MouseEvent):void {
			TweenMax.to(this, 0.3, {backgroundColor: CivilDebateWall.state.activeThread.firstPost.stanceColorDark});
			CivilDebateWall.state.setView(CivilDebateWall.kiosk.threadView);
		}
		
		private function onDataUpdate(e:Event):void {
			updateButton();
		}
		
		private function onActiveThreadChange(e:Event):void {
			updateButton();
		}	
		
		private function updateButton():void {
			if (CivilDebateWall.state.activeThread != null) {
				if (CivilDebateWall.state.activeThread.postCount > 1) {
					backgroundColor = CivilDebateWall.state.activeThread.firstPost.stanceColorDark;				
					// Iteratively truncate the text of the first post to fit in the button
					var firstCommentText:String = CivilDebateWall.state.activeThread.posts[0].text;
					var commentLength:int = firstCommentText.length;
					
					text = wrapText(firstCommentText);
					
					while (textField.numLines > 1) {
						commentLength--;
						text = wrapText(StringUtil.truncate(firstCommentText, commentLength, Char.ELLIPSES));
					}
					
					unlock();
				}
				else {
					lock();
					backgroundColor = CivilDebateWall.state.activeThread.firstPost.stanceColorDisabled;				
					text = "No responses yet. Be the first!";				
				}
			}
		}
		
		private function wrapText(s:String):String {
			return Char.LEFT_QUOTE + s + Char.RIGHT_QUOTE + " + " + (CivilDebateWall.state.activeThread.postCount - 1) + " responses";
		}
		
	}
}

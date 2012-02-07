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

package com.civildebatewall.kiosk.buttons {

	import com.civildebatewall.Assets;
	import com.civildebatewall.CivilDebateWall;
	import com.civildebatewall.data.containers.Post;
	import com.greensock.TweenMax;
	import com.kitschpatrol.futil.blocks.BlockBitmap;
	import com.kitschpatrol.futil.constants.Alignment;
	
	import flash.events.MouseEvent;
	
	public class GoToDebateButton extends BlockBitmap	{
		
		private var _targetPost:Post;
		
		public function GoToDebateButton() {
			super({
				height: 30,
				paddingLeft: 12,
				paddingRight: 12,	
				alignmentPoint: Alignment.CENTER,
				bitmap: Assets.getGoToDebateText(),
				backgroundRadius: 4,
				buttonMode: true
			});
			
			onButtonDown.push(onDown);
			onStageUp.push(onUp);			
		}
		
		public function get targetPost():Post {
			return _targetPost;
		}
		public function set targetPost(post:Post):void {
			_targetPost = post;
			TweenMax.to(this, 0.3, {backgroundColor: _targetPost.stanceColorDark});
		}
		
		private function onDown(e:MouseEvent):void {
			if (_targetPost != null) {
				backgroundColor = _targetPost.stanceColorLight;
			}			
		}
		
		private function onLock(e:MouseEvent):void {
			backgroundColor = _targetPost.stanceColorDisabled;
		}
		
		private function onUnlock(e:MouseEvent):void {
			backgroundColor = _targetPost.stanceColorMedium;			
		}
		
		private function onUp(e:MouseEvent):void {
			if (_targetPost != null) {
				TweenMax.to(this, 0.3, {backgroundColor: _targetPost.stanceColorDark});
			}			

			CivilDebateWall.state.setActiveThread(_targetPost.thread);
			CivilDebateWall.state.setActivePost(_targetPost);
			
			if (_targetPost.thread.postCount == 1) {
				// It's a single post
				CivilDebateWall.state.setView(CivilDebateWall.kiosk.homeView);
			}
			else {
				// It's a comment thread
				CivilDebateWall.state.setView(CivilDebateWall.kiosk.threadView);				
			}
		}
		
	}
}

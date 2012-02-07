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
	import com.kitschpatrol.futil.blocks.BlockBase;
	
	import flash.display.Bitmap;
	import flash.events.MouseEvent;
	
	public class DebateThisButton extends BlockBase {
		
		private var underlay:Bitmap;
		private var label:Bitmap;
		private var _targetPost:Post;
		
		public function DebateThisButton(params:Object = null)	{
			super({width: 101, height: 109, backgroundAlpha: 0, buttonMode: true});
			
			underlay = Assets.getBalloonButtonBackground();
			addChild(underlay);
			
			label = Assets.getBalloonButtonText();
			label.x = 21;
			label.y = 32;
			addChild(label);
			
			setParams(params);
			
			onButtonDown.push(onDown);
			onStageUp.push(onUp);
			onButtonCancel.push(onCancel);			
		}
		
		public function get targetPost():Post {
			return _targetPost;
		}
		
		public function set targetPost(post:Post):void {
			_targetPost = post;
			TweenMax.to(underlay, 0, {colorMatrixFilter:{colorize: _targetPost.stanceColorDark, amount: 1}});
		}
		
		public function onDown(e:MouseEvent):void {
			TweenMax.to(underlay, 0, {colorMatrixFilter:{colorize: _targetPost.stanceColorLight, amount: 1}});
		}
		
		public function onUp(e:MouseEvent):void {
			TweenMax.to(underlay, 0.5, {colorMatrixFilter:{colorize: _targetPost.stanceColorDark, amount: 1}});
			
			CivilDebateWall.state.userRespondingTo = _targetPost;
			CivilDebateWall.state.userIsDebating = true;
			CivilDebateWall.state.setUserStance(CivilDebateWall.state.userRespondingTo.opposingStance);
			CivilDebateWall.state.setView(CivilDebateWall.kiosk.opinionEntryView);
		}
		
		public function onCancel(e:MouseEvent):void {
			removeStageUpListener();
			if (_targetPost != null) {
				TweenMax.to(underlay, 0.5, {colorMatrixFilter:{colorize: _targetPost.stanceColorDark, amount: 1}});
			}
		}

	}
}

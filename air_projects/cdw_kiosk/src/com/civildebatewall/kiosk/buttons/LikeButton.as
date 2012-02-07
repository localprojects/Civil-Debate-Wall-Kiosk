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
	import com.civildebatewall.data.Data;
	import com.civildebatewall.data.containers.Post;
	import com.greensock.TweenMax;
	import com.greensock.easing.Back;
	import com.kitschpatrol.futil.blocks.BlockBase;
	import com.kitschpatrol.futil.blocks.BlockText;
	import com.kitschpatrol.futil.constants.Alignment;
	import com.kitschpatrol.futil.utilitites.StringUtil;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class LikeButton extends BlockBase {
		
		private var _targetPost:Post;		
		
		private var counter:BlockText;
		private var icon:Sprite;		
		private var pipe:Shape;
		private var label:BlockText;
		
		public function LikeButton() {
			super({
				width: 174,
				height: 64,
				backgroundRadius: 8,
				buttonMode: true
			});

			// Numeric counter
			counter = new BlockText({
				text: "0",
				textFont: Assets.FONT_BOLD,
				textBold: true,
				textSize: 18,
				textAlignmentMode: Alignment.TEXT_RIGHT,
				textColor: 0xffffff,
				backgroundAlpha: 0,
				width: 50,
				height: 20,
				registrationPoint: Alignment.TOP_RIGHT,
				visible: true
			});
			
			counter.x = 50;
			counter.y = 23;
			counter.mouseEnabled = false;
			addChild(counter);
			
			// E> Icon
			icon = Assets.getHeart();
			icon.x = 54;
			icon.y = 24;
			addChild(icon);			
			
			// Small divider pipe
			pipe = new Shape();
			pipe.graphics.beginFill(0xffffff);
			pipe.graphics.drawRect(0, 0, 1, 35);
			pipe.graphics.endFill();
			pipe.x = 86;
			pipe.y = 15;
			addChild(pipe);
			
			// "Like" label
			label = new BlockText({
				text: "Like",
				textFont: Assets.FONT_REGULAR,
				textSize: 18,
				textColor: 0xffffff,
				backgroundAlpha: 0,
				width: 73,
				height: 20,
				visible: true
			});
			
			label.x = 100;
			label.y = 23;
			label.mouseEnabled = false;
			addChild(label);
			
			CivilDebateWall.data.addEventListener(Data.LIKE_UPDATE_LOCAL, onLike);
			CivilDebateWall.data.addEventListener(Data.LIKE_UPDATE_SERVER, onLike);
			CivilDebateWall.data.addEventListener(Data.DATA_UPDATE_EVENT, onLike);
			
			buttonTimeout = 5000;
			onButtonDown.push(onDown);
			onStageUp.push(onUp);
			onButtonLock.push(onLock);
			onButtonUnlock.push(onUnlock);
		}
		
		private function onLike(e:Event):void {
			counter.text = _targetPost.likes.toString();
			label.text = StringUtil.plural("Like", _targetPost.likes);
		}
		
		public function get targetPost():Post {
			return _targetPost;
		}
		
		public function set targetPost(post:Post):void {
			_targetPost = post;
			counter.text =_targetPost.likes.toString();
			label.text = StringUtil.plural("Like", _targetPost.likes);
			unlock(); // Fires onUnlock() below.			
		}		
		
		private function onDown(e:MouseEvent):void {
			backgroundColor = _targetPost.stanceColorLight;
		}
		
		private function onLock(e:MouseEvent):void {
			backgroundColor = _targetPost.stanceColorDisabled;
		}
		
		private function onUnlock(e:MouseEvent):void {
			backgroundColor = _targetPost.stanceColorDark;
		}
		
		private function onUp(e:MouseEvent):void {
			CivilDebateWall.data.like(_targetPost);
			
			backgroundColor = _targetPost.stanceColorDark;			
			
			// Thump
			TweenMax.to(icon, 0.25, {transformAroundCenter:{scaleX: 1.5, scaleY: 1.5}, alpha: 0.75, ease: Back.easeOut, yoyo: true, repeat: 1});
		}	
		
	}
}

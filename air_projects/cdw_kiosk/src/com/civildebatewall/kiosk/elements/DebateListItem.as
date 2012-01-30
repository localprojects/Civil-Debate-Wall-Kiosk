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

package com.civildebatewall.kiosk.elements {

	import com.civildebatewall.Assets;
	import com.civildebatewall.data.containers.Post;
	import com.greensock.TweenMax;
	import com.kitschpatrol.futil.blocks.BlockBase;
	import com.kitschpatrol.futil.blocks.BlockText;
	import com.kitschpatrol.futil.constants.Alignment;
	import com.kitschpatrol.futil.utilitites.DateUtil;
	import com.kitschpatrol.futil.utilitites.NumberUtil;
	import com.kitschpatrol.futil.utilitites.StringUtil;
	
	public class DebateListItem extends BlockBase {
		
		private var _post:Post;
		private var _itemIndex:int;		
		public var toggledOn:Boolean;
		
		private var numberLabel:BlockText;		
		private var author:BlockText;	
		private var horizontalRule:BlockBase;
		public var callout:BlockText;
		
		public function DebateListItem(post:Post, itemIndex:int = 0) {
			super({
				width: 505,
				height: 157,
				backgroundRadius: 8				
			});			
			
			_post = post;
			_itemIndex = itemIndex;
			toggledOn = false;
			
			// rule
			horizontalRule = new BlockBase({
				width: width,
				height: 1,
				y: 62,
				visible: true
			});
			addChild(horizontalRule);
			
			// number
			numberLabel = new BlockText({
				textFont: Assets.FONT_HEAVY,
				textSize: 12,
				textAlignmentMode: Alignment.TEXT_RIGHT,
				width: 51,
				height: 12,
				text: _itemIndex +  ".",
				y: 26,
				visible: true,
				backgroundAlpha: 0			
			});
			addChild(numberLabel);
			
			// author and date
			var nameString:String = StringUtil.capitalize(_post.user.usernameFormatted, true);
			var dateString:String =  NumberUtil.zeroPad(_post.created.month + 1, 2) + "/" + NumberUtil.zeroPad(_post.created.date, 2) + "/" + DateUtil.getShortYear(_post.created); 
			var timeString:String = DateUtil.getShortHour(_post.created) + ":" + NumberUtil.zeroPad(_post.created.minutes, 2) + DateUtil.getAMPM(_post.created).toLowerCase();
			
			
			author = new BlockText({
				textFont: Assets.FONT_BOLD,
				textSize: 12,
				width: 418,
				height: 12,			
				x: 86,
				y: 26,
				text: nameString + " : " + dateString + ", " + timeString,
				visible: true,
				backgroundAlpha: 0			
			});
			addChild(author);
			
			callout = new BlockText({
				textFont: Assets.FONT_BOLD,
				textSize: 34,
				width: 418,
				height: 34,			
				x: 86,
				y: 93,	
				visible: true,
				backgroundAlpha: 0
			});
			addChild(callout);
			
			buttonMode = true;
			
			onStageUp.push(onUp);
			onUp();
		}
		
		
		private var backTween:TweenMax = null;
		
		private function onDown(...args):void {
			backgroundColor = _post.stanceColorMedium;
			horizontalRule.backgroundColor = 0xffffff;
			numberLabel.textColor = 0xffffff;
			author.textColor = 0xffffff;			
			callout.textColor = 0xffffff;				
		}
		
		private function onUp(...args):void {
			if (!toggledOn) {
				backTween = TweenMax.to(this, 0.3, {backgroundColor: Assets.COLOR_GRAY_5});
				TweenMax.to(horizontalRule, 0.3, {backgroundColor: Assets.COLOR_GRAY_15});
				TweenMax.to(numberLabel, 0.3, {textColor: Assets.COLOR_GRAY_15});
				TweenMax.to(author, 0.3, {textColor: Assets.COLOR_GRAY_15});
				TweenMax.to(callout, 0.3, {textColor: Assets.COLOR_GRAY_15});
			}
		}	

		public function activate():void {
			toggledOn = true;;
			TweenMax.killChildTweensOf(this, true);
			if (backTween != null) backTween.kill();
			onDown();
		}
		
		public function deactivate():void {
			toggledOn = false;
			onUp();
		}
		
		public function get post():Post { return _post; }
		
	}
}

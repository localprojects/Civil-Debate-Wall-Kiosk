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
	import com.civildebatewall.data.containers.Post;
	import com.greensock.TweenMax;
	import com.kitschpatrol.futil.blocks.BlockBase;
	import com.kitschpatrol.futil.utilitites.GeomUtil;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class StanceToggle extends BlockBase	{
			
		private var yesText:Bitmap;
		private var noText:Bitmap;		
		
		private var yesTarget:Number;
		private var noTarget:Number;
		
		public function StanceToggle() {
			super({
				buttonMode: true,
				width: 260, 
				height: 143,
				backgroundRadius: 20,
				maxSizeBehavior: MAX_SIZE_CLIPS
			});
			
			yesText = Assets.getYesButtonLabelText();
			noText = Assets.getNoButtonLabelText();

			addChild(yesText);
			addChild(noText);
			
			GeomUtil.centerWithin(yesText, this);
			GeomUtil.centerWithin(noText, this);			
			
			yesTarget = yesText.y;
			noTarget = noText.y;

			onButtonCancel.push(onCancel);
			onButtonDown.push(onDown);
			onStageUp.push(onUp);
			CivilDebateWall.state.addEventListener(State.USER_STANCE_CHANGE_EVENT, onUserStanceChange);
		}
		
		private function onDown(e:MouseEvent):void {
			if (!TweenMax.isTweening(this)) {
				TweenMax.to(this, 0, {backgroundColor: CivilDebateWall.state.userStanceColorDark});
			}
		}
		
		private function onUp(e:MouseEvent):void {
			if (!TweenMax.isTweening(this)) {
				if (CivilDebateWall.state.userStance == Post.STANCE_YES) {
					CivilDebateWall.state.setUserStance(Post.STANCE_NO);	
				}
				else {
					CivilDebateWall.state.setUserStance(Post.STANCE_YES);				
				}
			}
		}
		
		private function onCancel(e:MouseEvent):void {
			removeStageUpListener();
			TweenMax.to(this, .35, {backgroundColor: CivilDebateWall.state.userStanceColorLight});
		}
		
		private function onUserStanceChange(e:Event):void {
			// Only animate if we are on our own page
			var duration:Number = 0;
			if (CivilDebateWall.state.activeView == CivilDebateWall.kiosk.opinionEntryView) {
				duration = .35;
			}
			
			if (CivilDebateWall.state.userStance == Post.STANCE_YES) {
				TweenMax.to(yesText, duration, {alpha: 1, transformAroundCenter: {scaleX: 1, scaleY: 1, rotation:getRotationChange(yesText, 0, true) }});
				TweenMax.to(noText, duration, {alpha: 0, transformAroundCenter: {scaleX: 0, scaleY: 0, rotation:getRotationChange(noText, 180, true) }});		
			}
			else {
				TweenMax.to(noText, duration, {alpha: 1, transformAroundCenter: {scaleX: 1, scaleY: 1, rotation:getRotationChange(noText, 0, true) }});
				TweenMax.to(yesText, duration, {alpha: 0, transformAroundCenter: {scaleX: 0, scaleY: 0, rotation:getRotationChange(yesText, 180, true) }});				
			}
			
			TweenMax.to(this, duration, {backgroundColor: CivilDebateWall.state.userStanceColorLight});
		}		
		
		// helper for directional rotation via http://forums.greensock.com/viewtopic.php?f=1&t=3176
		private function getRotationChange(mc:DisplayObject, newRotation:Number, clockwise:Boolean):String {
			var dif:Number = newRotation - mc.rotation;
			if (Boolean(dif > 0) != clockwise) {
				dif += (clockwise) ? 360 : -360;
			}
			return String(dif);
		}				

	}
}

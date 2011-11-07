package com.civildebatewall {
	import com.civildebatewall.data.Post;
	import com.greensock.TweenMax;
	import com.kitschpatrol.futil.blocks.BlockBase;
	import com.kitschpatrol.futil.constants.Alignment;
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
		
		public function StanceToggle(params:Object=null) {
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
			
//			yesText.y = height;
//			noText.y = height;
			
			onButtonDown.push(onDown);
			onButtonUp.push(onUp);
			CivilDebateWall.state.addEventListener(State.USER_STANCE_CHANGE, onUserStanceChange);
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
		
		private function onUserStanceChange(e:Event):void {
			// Only animate if we are on our own page
			var duration:Number = 0;
			if (CivilDebateWall.state.activeView == CivilDebateWall.kiosk.view.opinionEntryView) {
				duration = .35;
			}
			
			if (CivilDebateWall.state.userStance == Post.STANCE_YES) {
				
				TweenMax.to(yesText, duration, {alpha: 1, transformAroundCenter: {scaleX: 1, scaleY: 1, rotation:getRotationChange(yesText, 0, true) }});
				TweenMax.to(noText, duration, {alpha: 0, transformAroundCenter: {scaleX: 0, scaleY: 0, rotation:getRotationChange(yesText, 180, true) }});
								
				//TweenMax.to(noText, duration, {alpha: 0, y: height});				
				
				
								
			}
			else {
//				TweenMax.to(noText, duration, {alpha: 1, y: noTarget});				
//				TweenMax.to(yesText, duration, {alpha: 0, y: height});
				//noText.rotation = -180;
				TweenMax.to(noText, duration, {alpha: 1, transformAroundCenter: {scaleX: 1, scaleY: 1, rotation:getRotationChange(yesText, 0, true) }});
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
		
		
		// listens to user stance changes
		
	}
}
package com.civildebatewall {
	import com.civildebatewall.data.Post;
	import com.greensock.TweenMax;
	import com.kitschpatrol.futil.blocks.BlockBase;
	import com.kitschpatrol.futil.constants.Alignment;
	import com.kitschpatrol.futil.utilitites.GeomUtil;
	
	import flash.display.Bitmap;
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
			
			yesText.y = height;
			noText.y = height;
			
			onButtonDown.push(onDown);
			onButtonUp.push(onUp);
			CivilDebateWall.state.addEventListener(State.USER_STANCE_CHANGE, onUserStanceChange);
		}
		
		private function onDown(e:MouseEvent):void {
			TweenMax.to(this, 0, {backgroundColor: CivilDebateWall.state.userStanceColorDark});
		}
		
		private function onUp(e:MouseEvent):void {
			if (CivilDebateWall.state.userStance == Post.STANCE_YES) {
				CivilDebateWall.state.setUserStance(Post.STANCE_NO);	
			}
			else {
				CivilDebateWall.state.setUserStance(Post.STANCE_YES);				
			}
		}
		
		private function onUserStanceChange(e:Event):void {
			// Only animate if we are on our own page
			var duration:Number = 0;
			if (CivilDebateWall.state.activeView == CivilDebateWall.kiosk.view.opinionEntryView) {
				duration = .35;
			}
			
			if (CivilDebateWall.state.userStance == Post.STANCE_YES) {
				TweenMax.to(yesText, duration, {alpha: 1, y: yesTarget});
				TweenMax.to(noText, duration, {alpha: 0, y: height});				
			}
			else {
				TweenMax.to(noText, duration, {alpha: 1, y: noTarget});				
				TweenMax.to(yesText, duration, {alpha: 0, y: height});
			}
			
			TweenMax.to(this, duration, {backgroundColor: CivilDebateWall.state.userStanceColorLight});
		}
		
		
		
		
		
		// listens to user stance changes
		
	}
}
package com.civildebatewall.kiosk.buttons {

	import com.civildebatewall.Assets;
	import com.civildebatewall.CivilDebateWall;
	import com.civildebatewall.State;
	import com.civildebatewall.data.containers.Post;
	import com.greensock.TweenMax;
	import com.greensock.easing.Quart;
	import com.kitschpatrol.futil.blocks.BlockBase;
	import com.kitschpatrol.futil.constants.Alignment;
	
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	public class FlagButton extends BlockBase {
		
		private var _targetPost:Post;		
		public var icon:Sprite;
		
		public function FlagButton() {
			super({
				buttonMode: true,
				width: 30,
				height: 30,
				backgroundRadius: 4,
				alignmentPoint: Alignment.CENTER
			});
			
			icon = Assets.getFlag();
			icon.width = 10;
			icon.height = 10;
			icon.x = -5;
			icon.y = -5;
			addChild(icon);			

			backgroundColor = 0xffffff;
			
			buttonTimeout = 5000;
			onButtonDown.push(onDown);
			onStageUp.push(onUp);
			onButtonLock.push(onLock);
			onButtonUnlock.push(onUnlock);
			onButtonCancel.push(onCancel);
		}
		
		public function get targetPost():Post {
			return _targetPost;
		}
		
		public function set targetPost(post:Post):void {
			_targetPost = post;
			unlock(); // Fires onUnlock() below.			
		}
		
		private function onDown(e:MouseEvent):void {
			backgroundColor = _targetPost.stanceColorLight;
			
			// glitch fix...
			icon.x = 0;
			icon.y = 0;							
		}
		
		private function onLock(e:MouseEvent):void {
			backgroundColor = _targetPost.stanceColorDisabled;
		}
		
		private function onUnlock(e:MouseEvent):void {
			backgroundColor = _targetPost.stanceColorDark;			
		}
		
		private function onUp(e:MouseEvent):void {
			if (mouseEnabled) {
				// confimation overlay...
				CivilDebateWall.kiosk.flagOverlay.targetPost = _targetPost;
				CivilDebateWall.state.setView(CivilDebateWall.kiosk.flagOverlayView);
			
			
				
				// Spin animation
				TweenMax.to(icon, 0.8, {transformAroundCenter:{rotation: 360}, ease: Quart.easeInOut});				
				TweenMax.to(icon, 0.4, {transformAroundCenter:{scaleX: 2, scaleY: 2}, alpha: 0.75, ease: Quart.easeIn});
				TweenMax.to(icon, 0.4, {transformAroundCenter:{scaleX: 1, scaleY: 1}, alpha: 1, ease: Quart.easeOut, delay: .4});
			}
		}
		
		private function onCancel(e:MouseEvent):void {
			if (_targetPost != null) {
				backgroundColor = _targetPost.stanceColorDark;
			}
		}
		
	}
}
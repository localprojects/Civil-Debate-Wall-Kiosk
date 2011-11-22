package com.civildebatewall.kiosk.elements {
	import com.civildebatewall.Assets;
	import com.civildebatewall.CivilDebateWall;
	import com.civildebatewall.State;
	import com.civildebatewall.data.Post;
	import com.greensock.TweenMax;
	import com.greensock.easing.Back;
	import com.kitschpatrol.futil.blocks.BlockBase;
	import com.kitschpatrol.futil.constants.Alignment;
	
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	
	public class FlagButton extends BlockBase {
		
		private var _targetPost:Post;		
		
		public var icon:Bitmap;
		
		public function FlagButton() {
			super({
				buttonMode: true,
				width: 30,
				height: 30,
				backgroundRadius: 4,
				alignmentPoint: Alignment.CENTER,
				icon: Assets.getFlagIconSmall()
			});
			
			addChild(icon);
			
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
				CivilDebateWall.kiosk.view.flagOverlayView();
				
				
				
				//CivilDebateWall.data.flag(_targetPost);
			
				// Thump animation
				TweenMax.to(icon, 0.25, {transformAroundCenter:{scaleX: 1.5, scaleY: 1.5}, alpha: 0.75, ease: Back.easeOut, yoyo: true, repeat: 1});
			}
		}
		
		private function onCancel(e:MouseEvent):void {
			if (_targetPost != null) {
				backgroundColor = _targetPost.stanceColorDark;
			}
		}		
		
		
	}
}
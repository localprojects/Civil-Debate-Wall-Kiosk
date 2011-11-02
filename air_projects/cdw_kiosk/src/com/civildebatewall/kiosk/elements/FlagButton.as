package com.civildebatewall.kiosk.elements {
	import com.civildebatewall.Assets;
	import com.civildebatewall.CivilDebateWall;
	import com.civildebatewall.State;
	import com.greensock.TweenMax;
	import com.greensock.easing.Back;
	import com.kitschpatrol.futil.blocks.BlockBase;
	import com.kitschpatrol.futil.constants.Alignment;
	
	import flash.display.Bitmap;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	
	public class FlagButton extends BlockBase {
		
		private var icon:Bitmap;
		
		public function FlagButton() {
			super({
				buttonMode: true,
				width: 64,
				height: 64,
				backgroundRadius: 8,
				alignmentPoint: Alignment.CENTER
			});
			
			icon = Assets.getFlagIcon();
			addChild(icon);
			
			CivilDebateWall.state.addEventListener(State.ACTIVE_DEBATE_CHANGE, onActiveDebateChange);
			
			buttonTimeout = 5000;
			onButtonDown.push(onDown);
			onStageUp.push(onUp);
			onButtonLock.push(onLock);
			onButtonUnlock.push(onUnlock);
		}
		
		private function onActiveDebateChange(e:Event):void {
			unlock(); // Fires onUnlock() below.			
		}
		
		private function onDown(e:MouseEvent):void {
			backgroundColor = CivilDebateWall.state.activeThread.firstPost.stanceColorDark;
		}
		
		private function onLock(e:MouseEvent):void {
			backgroundColor = CivilDebateWall.state.activeThread.firstPost.stanceColorDisabled;
		}
		
		private function onUnlock(e:MouseEvent):void {
			backgroundColor = CivilDebateWall.state.activeThread.firstPost.stanceColorMedium;			
		}
		
		private function onUp(e:MouseEvent):void {
			CivilDebateWall.data.flag(CivilDebateWall.state.activeThread.firstPost);
			
			// Thump animation
			TweenMax.to(icon, 0.25, {transformAroundCenter:{scaleX: 1.5, scaleY: 1.5}, alpha: 0.75, ease: Back.easeOut, yoyo: true, repeat: 1});
		}			
		
		
	}
}
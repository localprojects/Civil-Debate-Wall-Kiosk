package com.civildebatewall.kiosk.buttons {
	
	import com.civildebatewall.Assets;
	import com.civildebatewall.CivilDebateWall;
	import com.civildebatewall.State;
	import com.civildebatewall.data.Data;
	import com.greensock.TweenMax;
	import com.kitschpatrol.futil.blocks.BlockBitmap;
	import com.kitschpatrol.futil.constants.Alignment;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class DebateStripNavArrow extends BlockBitmap {
		
		public function DebateStripNavArrow(params:Object=null) {
			super(params);
			buttonMode = true;
			
			onButtonDown.push(onDown);
			onStageUp.push(onUp);
			
			width = 50;
			height = 141;
			alignmentPoint = Alignment.CENTER;
			backgroundAlpha = 0;
			backgroundColor = Assets.COLOR_GRAY_15;
			
			CivilDebateWall.state.addEventListener(State.ACTIVE_THREAD_CHANGE, onActiveDebateChange);
		}
		
		private function onActiveDebateChange(e:Event):void {
			// gray out?
			//TweenMax.to(this, 1, {colorMatrixFilter:{colorize: CivilDebateWall.state.activeThread.firstPost.stanceColorLight, amount: 1}});			
		}
		
		private function onDown(e:MouseEvent):void {
			TweenMax.to(this, 0, {backgroundAlpha: 1});
		}
		
		private function onUp(e:MouseEvent):void {
			TweenMax.to(this, 0.25, {backgroundAlpha: 0});
			//TweenMax.to(this, 0.5, {colorMatrixFilter:{colorize: CivilDebateWall.state.activeThread.firstPost.stanceColorLight, amount: 1}});			
		}
		
	}
}
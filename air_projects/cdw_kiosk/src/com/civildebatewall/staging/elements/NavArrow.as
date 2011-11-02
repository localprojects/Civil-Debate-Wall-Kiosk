package com.civildebatewall.staging.elements {
	
	import com.civildebatewall.CivilDebateWall;
	import com.civildebatewall.State;
	import com.civildebatewall.data.Data;
	import com.greensock.TweenMax;
	import com.kitschpatrol.futil.blocks.BlockBitmap;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class NavArrow extends BlockBitmap {
		
		
		public function NavArrow(params:Object=null) {
			super(params);
			buttonMode = true;
			
			onButtonDown.push(down);
			onButtonUp.push(up);

			CivilDebateWall.state.addEventListener(State.ACTIVE_DEBATE_CHANGE, onActiveDebateChange);
		}
		
		override protected function beforeTweenIn():void {
			TweenMax.to(this, 0, {colorMatrixFilter:{colorize: CivilDebateWall.state.activeThread.firstPost.stanceColorLight, amount: 1}});
			super.beforeTweenIn();
		}
		
		private function onActiveDebateChange(e:Event):void {
			TweenMax.to(this, 1, {colorMatrixFilter:{colorize: CivilDebateWall.state.activeThread.firstPost.stanceColorLight, amount: 1}});			
		}
		
		private function down(e:MouseEvent):void {
			TweenMax.to(this, 0, {colorMatrixFilter:{colorize: CivilDebateWall.state.activeThread.firstPost.stanceColorDark, amount: 1}});
		}
				
		private function up(e:MouseEvent):void {
			TweenMax.to(this, 0.5, {colorMatrixFilter:{colorize: CivilDebateWall.state.activeThread.firstPost.stanceColorLight, amount: 1}});			
		}

	}
}
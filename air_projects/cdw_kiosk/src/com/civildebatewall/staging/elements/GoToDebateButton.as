package com.civildebatewall.staging.elements {
	import com.civildebatewall.Assets;
	import com.civildebatewall.CivilDebateWall;
	import com.civildebatewall.data.Post;
	import com.greensock.TweenMax;
	import com.kitschpatrol.futil.blocks.BlockText;
	import com.kitschpatrol.futil.constants.Alignment;
	
	import flash.events.MouseEvent;
	
	public class GoToDebateButton extends BlockText	{
		
		private var _targetPost:Post;
		
		public function GoToDebateButton() {
			super({
				height: 33,
				paddingLeft: 12,
				paddingRight: 12,	
				textFont: Assets.FONT_BOLD,
				textBold: true,
				textSize: 10,
				alignmentPoint: Alignment.CENTER,
				text: "GO TO DEBATE",
				textColor: 0xffffff,
				leading: 33,
				letterSpacing: -1,
				backgroundRadius: 4,
				buttonMode: true
			});
			
			onButtonDown.push(onDown);
			onStageUp.push(onUp);			
		}
		
		public function get targetPost():Post {
			return _targetPost;
		}
		public function set targetPost(post:Post):void {
			_targetPost = post;
			
			
			TweenMax.to(this, 0.3, {backgroundColor: _targetPost.stanceColorDark});
			
		}
		
		private function onDown(e:MouseEvent):void {
			
			
			if (_targetPost != null) {
				backgroundColor = _targetPost.stanceColorLight;
			}			
		}
		
		private function onLock(e:MouseEvent):void {
			backgroundColor = _targetPost.stanceColorDisabled;
		}
		
		private function onUnlock(e:MouseEvent):void {
			backgroundColor = _targetPost.stanceColorMedium;			
		}
		
		private function onUp(e:MouseEvent):void {
			if (_targetPost != null) {
				TweenMax.to(this, 0.3, {backgroundColor: _targetPost.stanceColorDark});
			}			
			 
			
			CivilDebateWall.state.setActiveThread(_targetPost.thread);
			CivilDebateWall.state.setActivePost(_targetPost);
			CivilDebateWall.state.setView(CivilDebateWall.kiosk.view.threadView);
		}
		
	
		
		
		
	}
}
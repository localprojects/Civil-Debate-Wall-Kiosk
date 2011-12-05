package com.civildebatewall.kiosk.elements {
	
	import com.civildebatewall.Assets;
	import com.civildebatewall.data.Post;
	import com.civildebatewall.kiosk.buttons.GoToDebateButton;
	
	public class SearchResult extends Comment {

		private var goToDebateButton:GoToDebateButton;		
		
		public function SearchResult(post:Post, postNumber:int = -1) {		
			super(post, postNumber);
			
			backgroundAlpha = 1;
			backgroundColor = Assets.COLOR_GRAY_5;
			
			flagButton.x = 672;
			
			goToDebateButton = new GoToDebateButton();
			goToDebateButton.y = -1;			
			goToDebateButton.x = 709;
			goToDebateButton.visible = true;
			goToDebateButton.targetPost = post;
			addChild(goToDebateButton);
		}
		
	}
}
package net.localprojects.blocks {
	import net.localprojects.ui.BlockButton;
	import net.localprojects.Assets;
	
	public class Stats extends BlockBase {
		
		public var homeButton:BlockButton;
		
		public function Stats() {
			super();
			init();
		}
		
		private function init():void {
			this.graphics.beginFill(0xff0000);
			this.graphics.drawRect(0, 0, 1022, 1626);
			this.graphics.endFill();
			1827
			
			// no animation for this at the moment
			// TODO put it in the parent block instead?
			homeButton = new BlockButton(1022, 63, 'BACK TO DEBATE', 20, Assets.COLOR_YES_MEDIUM, false);
			homeButton.setDefaultTweenIn(0, {x:0, y: 1563});
			homeButton.setDefaultTweenOut(0, {x:0, y: 1563});
			
			addChild(homeButton);
			homeButton.tweenIn();
		}
		
		
	}
}
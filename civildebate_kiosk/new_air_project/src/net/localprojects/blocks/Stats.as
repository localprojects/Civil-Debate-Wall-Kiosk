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
			this.graphics.beginFill(0xffffff);
			this.graphics.drawRect(0, 0, 1022, 1626);
			this.graphics.endFill();
			
			this.addChild(Assets.statsPlaceholder);
			
			// no animation for this at the moment
			// TODO put it in the parent block instead?
			homeButton = new BlockButton(1022, 63, Assets.COLOR_YES_MEDIUM, 'BACK TO DEBATE', 20);
			homeButton.setDefaultTweenIn(0, {x:0, y: 1563});
			homeButton.setDefaultTweenOut(0, {x:0, y: 1563});
			
			addChild(homeButton);
			homeButton.tweenIn();
		}
		
		
	}
}
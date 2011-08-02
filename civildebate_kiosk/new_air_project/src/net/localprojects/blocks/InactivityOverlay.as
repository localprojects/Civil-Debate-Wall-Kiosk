package net.localprojects.blocks {
	
	public class InactivityOverlay extends BlockBase {
		
		public function InactivityOverlay() {
			super();
			init();
		}
		
		private function init():void {
			this.graphics.beginFill(0x000000, 0.85);
			this.graphics.drawRect(0, 0, 1080, 1920);
			this.graphics.endFill();
			this.cacheAsBitmap = true;
		}
		
		
	}
}
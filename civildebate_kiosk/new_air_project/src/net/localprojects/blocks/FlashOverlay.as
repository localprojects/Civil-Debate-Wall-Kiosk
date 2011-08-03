package net.localprojects.blocks {
	import net.localprojects.CDW;
	
	public class FlashOverlay extends BlockBase {
		public function FlashOverlay()	{
			super();
			init();
		}
		
		private function init():void {
			this.graphics.beginFill(0xffffff);
			this.graphics.drawRect(0, 0, CDW.ref.stage.stageWidth, CDW.ref.stage.stageHeight);
			this.graphics.endFill();
		}
	}
}
package net.localprojects.blocks
{
	public class BlackOverlay extends BlockBase
	{
		public function BlackOverlay()
		{
			super();
			init();
		}
		
		private function init():void {
			this.graphics.beginFill(0x000000);
			this.graphics.drawRect(0, 0, stageWidth, stageHeight);
			this.graphics.endFill();
		}		
	}
}

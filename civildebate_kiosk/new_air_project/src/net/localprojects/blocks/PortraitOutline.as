package net.localprojects.blocks {
	
	import net.localprojects.Assets;
	
	public class PortraitOutline extends BlockBase {
		
		public function PortraitOutline()	{
			super();
			init();
		}
		
		private function init():void {
			addChild(Assets.portraitOutline);
		}
	}
}
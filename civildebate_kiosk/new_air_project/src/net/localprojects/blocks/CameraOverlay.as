package net.localprojects.blocks {
	
	import net.localprojects.Assets;
	
	public class CameraOverlay extends BlockBase {
		
		public function CameraOverlay()	{
			super();
			init();
		}
		
		
		// TODo stance switch
		private function init():void {
			addChild(Assets.yesPortraitOverlay);
		}
	}
}
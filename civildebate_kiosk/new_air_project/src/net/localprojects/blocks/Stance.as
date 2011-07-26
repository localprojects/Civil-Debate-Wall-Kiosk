package net.localprojects.blocks {
	import flash.display.Sprite;
	
	import net.localprojects.Assets;
	import net.localprojects.elements.*;
	
	public class Stance extends Block {
		
		private var blockLabel:BlockLabel;
		
		public function Stance() {
			super();
			init();
		}
		
		public function init():void {
			blockLabel = new BlockLabel("", 85, 0xffffff, Assets.COLOR_YES_LIGHT);
			addChild(blockLabel);
		}
		
		
		public function setText(s:String):void {
			blockLabel.setText(s.toUpperCase() + "!");
		}		

	}
}
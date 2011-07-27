package net.localprojects.blocks {
	import flash.display.Sprite;
	
	import net.localprojects.Assets;
	import net.localprojects.elements.*;
	
	// TODO extends block label instead
	public class Nametag extends BlockBase {
		
		private var blockLabel:BlockLabel;
		
		public function Nametag() {
			super();
			init();
		}
		
		public function init():void {
			blockLabel = new BlockLabel("", 35, 0xffffff, Assets.COLOR_YES_MEDIUM, true);
			blockLabel.visible = true;
			addChild(blockLabel);
		}
		
		
		public function setText(s:String):void {
			blockLabel.setText(s + " Says:");
		}		
		
	}
}
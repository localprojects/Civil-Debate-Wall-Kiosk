package net.localprojects.blocks {
	import flash.display.Sprite;
	
	import net.localprojects.Assets;
	import net.localprojects.elements.*;
	
	public class Nametag extends Sprite implements IBlock {
		
		private var blockLabel:BlockLabel;
		
		public function Nametag() {
			super();
			init();
		}
		
		public function init():void {
			blockLabel = new BlockLabel("", 35, 0xffffff, Assets.COLOR_YES_MEDIUM, true);
			addChild(blockLabel);
		}
		
		
		public function setText(s:String):void {
			blockLabel.setText(s + " Says:");
		}		
		
	}
}
package net.localprojects.blocks {
	import flash.display.Sprite;
	
	import net.localprojects.Assets;
	import net.localprojects.elements.*;
	
	public class Opinion extends Block {
		
		private var blockParagraph:BlockParagraph;
		
		public function Opinion() {
			super();
			init();
		}
		
		public function init():void {
			blockParagraph = new BlockParagraph(915, 'Opinion goes here', 40, Assets.COLOR_YES_LIGHT, true); 
			addChild(blockParagraph);
		}
		
		
		public function setText(s:String):void {
			blockParagraph.setText(s);
		}		
		
	}
}
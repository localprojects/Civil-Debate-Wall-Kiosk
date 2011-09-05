package net.localprojects.elements {
	import net.localprojects.Assets;
	import net.localprojects.blocks.BlockBase;
	
	public class WordFrequencyList extends BlockBase {
		public var count:int = 3;
		
		public function WordFrequencyList()	{
			super();
			
			//this.addChild(Assets.wordFrequencyBlockPlaceholder);
		}
	}
}
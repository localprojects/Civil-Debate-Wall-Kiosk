package net.localprojects.elements {
	import net.localprojects.blocks.BlockBase;
	import net.localprojects.Assets;
	
	public class WordFrequencyList extends BlockBase {
		public function WordFrequencyList()	{
			super();
			
			this.addChild(Assets.wordFrequencyBlockPlaceholder);
		}
	}
}
package net.localprojects.elements {
	import net.localprojects.blocks.BlockBase;
	import net.localprojects.*;
	
	public class MostDebatedPanel extends BlockBase {
		public function MostDebatedPanel()
		{
			super();
			this.addChild(Assets.getMostDebatedPlaceholder());
		}
	}
}
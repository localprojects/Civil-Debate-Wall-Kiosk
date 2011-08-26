package net.localprojects.elements
{
	import flash.display.*;
	import net.localprojects.*;
	import flash.text.*;
	import net.localprojects.blocks.BlockBase;
	
	public class DebateOverlay extends BlockBase	{
		
		public function DebateOverlay()	{
			super();
			init();
		}
		
		public function init():void {
			this.addChild(Assets.commentsPlaceholder);
		}
		
	}
}
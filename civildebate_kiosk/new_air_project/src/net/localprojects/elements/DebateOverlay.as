package net.localprojects.elements
{
	import flash.display.*;
	import flash.text.*;
	
	import net.localprojects.*;
	import net.localprojects.blocks.BlockBase;
	
	public class DebateOverlay extends BlockBase	{
		
		// scrolling TBA....
		
		private var scrollSheet:Sprite;
		
		
		public function DebateOverlay()	{
			super();
			init();
		}
		
		public function init():void {
			this.addChild(Assets.commentsPlaceholder);
		}
		
		public function update():void {
			// rebuild the list
		
			for each (var comment:Object in CDW.database.debates[CDW.state.activeDebate]['comments']) {
				trace('comment!');
				trace(comment);
			}
			
			
		}
		
	}
}
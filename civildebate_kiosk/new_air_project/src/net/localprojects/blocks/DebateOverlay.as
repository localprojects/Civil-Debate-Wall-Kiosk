package net.localprojects.blocks
{
	import flash.display.*;
	import net.localprojects.*;
	import flash.text.*;
	
	public class DebateOverlay extends BlockBase	{
		
		public function DebateOverlay()	{
			super();
			init();
		}
		
		public function init():void {
//			this.graphics.beginFill(0xff0000);
//			this.graphics.drawRect(0, 0, 1022, 807);
//			this.graphics.endFill();
			
			this.addChild(Assets.commentsPlaceholder);

		}
		
	}
}
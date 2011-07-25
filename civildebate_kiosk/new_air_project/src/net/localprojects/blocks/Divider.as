package net.localprojects.blocks {
	
	import flash.display.*;
	
	import net.localprojects.*;
	
	public class Divider extends Sprite implements IBlock {
		
		public function Divider() {
			init();
		}
		
		public function init():void	{
			var divider:Bitmap = Assets.getDivider();
			addChild(divider);
		}
		
	}
}

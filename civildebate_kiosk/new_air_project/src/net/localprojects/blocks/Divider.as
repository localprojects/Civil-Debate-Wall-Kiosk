package net.localprojects.blocks {
	import flash.display.*;
	import flash.geom.Point;
	import net.localprojects.*;
	
	public class Divider extends Block {

		public function Divider() {
			super();
			init();
		}
		
		public function init():void	{
			var divider:Bitmap = Assets.getDivider();
			addChild(divider);
		}
		
	}
}

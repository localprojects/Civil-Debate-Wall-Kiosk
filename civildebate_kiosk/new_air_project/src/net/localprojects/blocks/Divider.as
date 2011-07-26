package net.localprojects.blocks {
	import flash.display.*;
	import flash.geom.Point;
	import net.localprojects.*;
	
	public class Divider extends BlockBase {

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

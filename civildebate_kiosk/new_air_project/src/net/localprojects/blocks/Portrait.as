package net.localprojects.blocks {
	import flash.display.*;
	import net.localprojects.*;
	
	public class Portrait extends BlockBase {
		
		private var image:Bitmap;
		
		public function Portrait() {
			super();
			init();
		}
		
		private function init():void {
			image = new Bitmap(Assets.portraitPlaceholder.bitmapData);
			addChild(image);
		}
		
		public function setImage(i:Bitmap):void {
			// todo: copy this instead?
			// why do we have to add and remove the child?
			removeChild(image);
			image = new Bitmap(i.bitmapData);
			addChild(image);
		}
	}
}
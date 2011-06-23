package net.localprojects.ui {
	import flash.display.Sprite;
	import net.localprojects.Assets;
	
	public class DebateThumbnail extends Sprite	{
		public function DebateThumbnail() {
			this.graphics.beginBitmapFill(Assets.debateThumbnail.bitmapData);
			this.graphics.drawRect(0, 0, Assets.debateThumbnail.width, Assets.debateThumbnail.height);
			this.graphics.endFill();
		}
	}
}
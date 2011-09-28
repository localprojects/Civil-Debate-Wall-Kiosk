package {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.PixelSnapping;
	
	public class ColorBlock extends Bitmap {
		public function ColorBlock(startX:int, startY:int, w:uint, h:uint, color:uint) {
			super(new BitmapData(w, h, false, color), PixelSnapping.ALWAYS, false);
			x = startX;
			y = startY;
		}
	}
}
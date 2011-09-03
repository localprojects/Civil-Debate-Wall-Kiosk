package net.localprojects {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import sekati.utils.ColorUtil;
	import flash.geom.Rectangle;
	
	
	public class MetaBitmap extends Bitmap {
		
		public var brightness:int = 0;
		
		public function MetaBitmap(bitmapData:BitmapData=null, pixelSnapping:String="auto", smoothing:Boolean=false) {
			super(bitmapData, pixelSnapping, smoothing);
	
			brightness = ColorUtil.averageLightness(this, 0.001, new Rectangle(29, 117, 1022, 117)); // indexed on bitmap reference
			trace("Brightness: " + brightness); 
		}
	}
}
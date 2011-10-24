package faceCropTool.core {
	import flash.display.Bitmap;
	import flash.geom.Rectangle;
	
	public final class Assets	{
		
		// Constants
		public static const KIOSK_WIDTH:int = 1080;
		public static const KIOSK_HEIGHT:int = 1920;
		public static const KIOSK_DEFAULT_FACE_TARGET:Rectangle = new Rectangle(294, 352, 494, 576);
		public static const WEB_WIDTH:int = 550;
		public static const WEB_HEIGHT:int = 608;
		public static const WEB_DEFAULT_FACE_TARGET:Rectangle = new Rectangle(188, 110, 175, 192);	
		
		// Bitmaps
		[Embed(source = '/assets/graphics/kioskOverlay.png')] private static const kioskOverlayClass:Class;
		public static function getKioskOverlay():Bitmap { return new kioskOverlayClass() as Bitmap; };
		public static const KIOSK_OVERLAY:Bitmap = getKioskOverlay();
		
		[Embed(source = '/assets/graphics/webOverlay.png')] private static const webOverlayClass:Class;
		public static function getWebOverlay():Bitmap { return new webOverlayClass() as Bitmap; };
		public static const WEB_OVERLAY:Bitmap = getWebOverlay();
			
	}
}
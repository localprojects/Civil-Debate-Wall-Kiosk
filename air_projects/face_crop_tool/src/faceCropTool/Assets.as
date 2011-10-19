package faceCropTool
{
	import flash.display.Bitmap;
	
	public final class Assets
	{
		[Embed(source = '/assets/graphics/kioskOverlay.png')] private static const kioskOverlayClass:Class;
		public static function getKioskOverlay():Bitmap { return new kioskOverlayClass() as Bitmap; };
		public static const kioskOverlay:Bitmap = getKioskOverlay();
	}
}
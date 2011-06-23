package net.localprojects {
	
	import flash.display.Bitmap;

	public final class Assets	{
		
		// or run "python embedgen.py "kitten.jpg" | pbcopy" from the desktop
		[Embed(source = "../assets/cameraSilhouette.png")] private static const cameraSilhouetteClass:Class;
		public static const cameraSilhouette:Bitmap = new cameraSilhouetteClass() as Bitmap;

		[Embed(source = "../assets/obama.jpg")] private static const obamaClass:Class;
		public static const obama:Bitmap = new obamaClass() as Bitmap;
		
		[Embed(source = "../assets/silhouette.jpg")] private static const silhouetteClass:Class;
		public static const silhouette:Bitmap = new silhouetteClass() as Bitmap;
		
		[Embed(source = "../assets/graphics/bigButton.png")] private static const bigButtonClass:Class;
		public static const bigButtonBackground:Bitmap = new bigButtonClass() as Bitmap;
		
		
		// fonts
//		[Embed(source='../assets/fonts/RockwBol.ps', fontName="Rockwell-Bold", mimeType='application/x-font')]
//		public static const buttonFont:Class;
//		public static const BUTTON_FONT:String = "Rockwell-Bold";
		
		[Embed(source="../assets/fonts/rockwell.swf", symbol="RockwellBold")]
		public static const buttonFont:Class;
		public static const BUTTON_FONT:String = "Rockwell";		
		
		//private var AssetClass:Class;

	}
}
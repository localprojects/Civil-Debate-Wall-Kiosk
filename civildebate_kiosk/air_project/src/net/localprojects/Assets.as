package net.localprojects {
	
	import flash.display.*;

	public final class Assets	{
		
		// To generate embed code, run "python embedgen.py "kitten.jpg" | pbcopy" from /meta/embed_generator
		[Embed(source = "../assets/cameraSilhouette.png")] private static const cameraSilhouetteClass:Class;
		public static const cameraSilhouette:Bitmap = new cameraSilhouetteClass() as Bitmap;

		[Embed(source = "../assets/graphics/obama.png")] private static const obamaClass:Class;
		public static const obama:Bitmap = new obamaClass() as Bitmap;
		
		[Embed(source = "../assets/silhouette.jpg")] private static const silhouetteClass:Class;
		public static const silhouette:Bitmap = new silhouetteClass() as Bitmap;
		
		[Embed(source = "../assets/graphics/bigButton.png")] private static const bigButtonClass:Class;
		public static const bigButtonBackground:Bitmap = new bigButtonClass() as Bitmap;
		
		[Embed(source = "../assets/graphics/headerBackground.png")] private static const headerBackgroundClass:Class;
		public static const headerBackground:Bitmap = new headerBackgroundClass() as Bitmap;

		[Embed(source = "../assets/graphics/debateThumbnail.png")] private static const debateThumbnailClass:Class;
		public static const debateThumbnail:Bitmap = new debateThumbnailClass() as Bitmap;
		
		[Embed(source = "../assets/graphics/triangleMask.svg")]
		public static const triangleMaskClass:Class;

		
		
		
		
		// fonts
//		[Embed(source='../assets/fonts/RockwBol.ps', fontName="Rockwell-Bold", mimeType='application/x-font')]
//		public static const buttonFont:Class;
//		public static const BUTTON_FONT:String = "Rockwell-Bold";
		
		// TODO put multiple fonts / weights in one swf?
		// See FLA project in /meta/font_embedding
		[Embed(source="../assets/assets.swf", symbol="RockwellBold")] public static const buttonFont:Class;
		public static const BUTTON_FONT:String = "Rockwell";
	}
}
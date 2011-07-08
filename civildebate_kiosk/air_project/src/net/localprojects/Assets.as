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

		[Embed(source = "../assets/graphics/portraitOverlay.png")] private static const portraitOverlayClass:Class;
		public static const portraitOverlay:Bitmap = new portraitOverlayClass() as Bitmap;
		
		[Embed(source="../assets/shaders/portraitBlur.pbj", mimeType="application/octet-stream")]
		public static const PortraitBlurFilter:Class;
		
		[Embed(source = "../assets/graphics/portraitBlurMask.png")] private static const portraitBlurMaskClass:Class;
		public static const portraitBlurMask:Bitmap = new portraitBlurMaskClass() as Bitmap;
		
		
		
		
		
		
		
		[Embed(source = "../assets/graphics/samplePortrait.png")] private static const samplePortraitClass:Class;
		public static const samplePortrait:Bitmap = new samplePortraitClass() as Bitmap;

		[Embed(source = "../assets/graphics/dashedDivider.png")] private static const dashedDividerClass:Class;
		public static function getDashedDivider():Bitmap { return new dashedDividerClass() as Bitmap; };
		
		[Embed(source = "../assets/graphics/buttonBackground.png")] private static const buttonBackgroundClass:Class;
		public static function buttonBackground():Bitmap { return new buttonBackgroundClass() as Bitmap; };
		
		[Embed(source = "../assets/graphics/statsIcon.png")] private static const statsIconClass:Class;
		public static function statsIcon():Bitmap { return new statsIconClass() as Bitmap; };

		[Embed(source = "../assets/graphics/likeIcon.png")] private static const likeIconClass:Class;
		public static function likeIcon():Bitmap { return new likeIconClass() as Bitmap; };
		
		[Embed(source = "../assets/graphics/quotation.svg")] private static const quotationClass:Class;
		public static function quotation():Sprite { return new quotationClass() as Sprite; };
		
		
		
		
		
		
		// fonts
		[Embed(source="../assets/fonts/rockwell.swf", symbol="RockwellRegular")] public static const Font:Class;
		[Embed(source="../assets/fonts/rockwell.swf", symbol="RockwellBold")] public static const FontBold:Class;
		public static const FONT_REGULAR:String = "Rockwell";
		
		[Embed(source="../assets/fonts/rockwell.swf", symbol="RockwellExtraBold")] public static const FontExtraBold:Class;		
		public static const FONT_EXTRA_BOLD:String = "Rockwell Extra Bold";
		
		[Embed(source="../assets/fonts/rockwell.swf", symbol="RockwellLight")] public static const FontLight:Class;		
		public static const FONT_LIGHT:String = "Rockwell Light";		
	}
}
package net.localprojects
{
	import flash.display.*;
	
	public final class Assets	{
		// Graphics
		[Embed(source = "/assets/graphics/bigButton.png")] private static const bigButtonClass:Class;
		public static function bigButton():Bitmap { return new bigButtonClass() as Bitmap; };

		[Embed(source = "/assets/graphics/buttonBackground.png")] private static const buttonBackgroundClass:Class;
		public static function buttonBackground():Bitmap { return new buttonBackgroundClass() as Bitmap; };

		[Embed(source = "/assets/graphics/dashedDivider.png")] private static const dashedDividerClass:Class;
		public static function dashedDivider():Bitmap { return new dashedDividerClass() as Bitmap; };
		
		[Embed(source = "/assets/graphics/headerBackground.png")] private static const headerBackgroundClass:Class;
		public static function headerBackground():Bitmap { return new headerBackgroundClass() as Bitmap; };
		
		[Embed(source = "/assets/graphics/likeIcon.png")] private static const likeIconClass:Class;
		public static function likeIcon():Bitmap { return new likeIconClass() as Bitmap; };
		
		[Embed(source = "/assets/graphics/quotation.svg")] private static const quotationClass:Class;
		public static function quotation():Sprite { return new quotationClass() as Sprite; };
		
		[Embed(source = "/assets/graphics/answerBackground.png")] private static const answerBackgroundClass:Class;
		public static function answerBackground():Bitmap { return new answerBackgroundClass() as Bitmap; };		
		
		[Embed(source = "/assets/graphics/statsIcon.png")] private static const statsIconClass:Class;
		public static function statsIcon():Bitmap { return new statsIconClass() as Bitmap; };
		
		
		
		
		
		// Fonts
		[Embed(source="/assets/fonts/rockwell.swf", symbol="RockwellRegular")] public static const Font:Class;
		[Embed(source="/assets/fonts/rockwell.swf", symbol="RockwellBold")] public static const FontBold:Class;
		public static const FONT_REGULAR:String = "Rockwell";
		
		[Embed(source="/assets/fonts/rockwell.swf", symbol="RockwellExtraBold")] public static const FontExtraBold:Class;		
		public static const FONT_EXTRA_BOLD:String = "Rockwell Extra Bold";
		
		[Embed(source="/assets/fonts/rockwell.swf", symbol="RockwellLight")] public static const FontLight:Class;		
		public static const FONT_LIGHT:String = "Rockwell Light";				
	}
}
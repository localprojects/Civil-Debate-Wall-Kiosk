package {
	import flash.display.*;
	
	public final class Assets	{
		
		// Test Images
		[Embed(source = '/assets/graphics/earth.png')] private static const earthClass:Class;
		public static function getEarth():Bitmap { return new earthClass() as Bitmap; };
		public static const earth:Bitmap = getEarth();
		
		[Embed(source = '/assets/graphics/moon.png')] private static const moonClass:Class;
		public static function getMoon():Bitmap { return new moonClass() as Bitmap; };
		public static const moon:Bitmap = getMoon();
		
		// Fonts
		[Embed(source='/assets/fonts/fonts.swf', symbol='RockwellLight')] public static const FontLight:Class;
		public static const FONT_LIGHT:String = 'Rockwell Std Light';		
		
		[Embed(source='/assets/fonts/fonts.swf', symbol='RockwellRegular')] public static const FontRegular:Class;
		public static const FONT_REGULAR:String = 'Rockwell Std';
		
		[Embed(source='/assets/fonts/fonts.swf', symbol='RockwellBold')] public static const FontBold:Class;
		public static const FONT_BOLD:String = 'Rockwell Std'; // Gets bolded through textfield		
		
		[Embed(source='/assets/fonts/fonts.swf', symbol='RockwellExtraBold')] public static const FontHeavy:Class;		
		public static const FONT_HEAVY:String = 'Rockwell Std Extra Bold';		
		
		[Embed(source='/assets/fonts/fonts.swf', symbol='RockwellLightItalic')] public static const FontLightItalic:Class;
		public static const FONT_LIGHT_ITALIC:String = 'Rockwell Std'; // gets italicized in textfield?	
		
		[Embed(source='/assets/fonts/fonts.swf', symbol='RockwellItalic')] public static const FontRegularItalic:Class;
		public static const FONT_REGULAR_ITALIC:String = 'Rockwell Std Italic';
		
		[Embed(source='/assets/fonts/fonts.swf', symbol='RockwellBoldItalic')] public static const FontBoldItalic:Class;
		public static const FONT_BOLD_ITALIC:String = 'Rockwell Std'; // gets bolded and italicized in textfield?		
	
	}
}
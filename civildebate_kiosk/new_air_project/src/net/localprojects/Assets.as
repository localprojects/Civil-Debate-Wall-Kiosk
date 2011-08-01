package net.localprojects
{
	import flash.display.*;
	
	public final class Assets	{
		// Graphics
		[Embed(source = '/assets/graphics/bigButton.png')] private static const bigButtonClass:Class;
		public static function bigButton():Bitmap { return new bigButtonClass() as Bitmap; };

		[Embed(source = '/assets/graphics/buttonBackground.png')] private static const buttonBackgroundClass:Class;
		public static function buttonBackground():Bitmap { return new buttonBackgroundClass() as Bitmap; };

		[Embed(source = '/assets/graphics/divider.png')] private static const dividerClass:Class;
		public static function getDivider():Bitmap { return new dividerClass() as Bitmap; };
		
		[Embed(source = '/assets/graphics/headerBackground.png')] private static const headerBackgroundClass:Class;
		public static function getHeaderBackground():Bitmap { return new headerBackgroundClass() as Bitmap; };
		
		[Embed(source = '/assets/graphics/likeIcon.png')] private static const likeIconClass:Class;
		public static function likeIcon():Bitmap { return new likeIconClass() as Bitmap; };
		
		[Embed(source = '/assets/graphics/quotation.svg')] private static const quotationClass:Class;
		public static function getQuotation():Sprite { return new quotationClass() as Sprite; };
		
		[Embed(source = '/assets/graphics/answerBackground.png')] private static const answerBackgroundClass:Class;
		public static function answerBackground():Bitmap { return new answerBackgroundClass() as Bitmap; };		
		
		[Embed(source = '/assets/graphics/statsIcon.png')] private static const statsIconClass:Class;
		public static function statsIcon():Bitmap { return new statsIconClass() as Bitmap; };
		
		[Embed(source = '/assets/graphics/portraitPlaceholder.png')] private static const portraitPlaceholderClass:Class;
		public static function getPortraitPlaceholder():Bitmap { return new portraitPlaceholderClass() as Bitmap; };		
		public static const portraitPlaceholder:Bitmap = getPortraitPlaceholder();
		
		[Embed(source = '/assets/graphics/portraitOutline.png')] private static const portraitOutlineClass:Class;
		public static function getPortraitOutline():Bitmap { return new portraitOutlineClass() as Bitmap; };
		public static const portraitOutline:Bitmap = getPortraitOutline();
		
		[Embed(source = '/assets/graphics/cameraIcon.png')] private static const cameraIconClass:Class;
		public static function getCameraIcon():Bitmap { return new cameraIconClass() as Bitmap; };
		public static const cameraIcon:Bitmap = getCameraIcon();
		
		[Embed(source = '/assets/graphics/portraitMask.png')] private static const portraitMaskClass:Class;
		public static function getPortraitMask():Bitmap { return new portraitMaskClass() as Bitmap; };
		public static const portraitMask:Bitmap = getPortraitMask();
		
		
		public static function getStatsUnderlay():Bitmap { return new Bitmap(new BitmapData(1080, 1920, false, 0xffffff)); };
		public static const statsUnderlay:Bitmap = getStatsUnderlay();
		
		// Fonts
		[Embed(source='/assets/fonts/rockwell.swf', symbol='RockwellRegular')] public static const Font:Class;
		[Embed(source='/assets/fonts/rockwell.swf', symbol='RockwellBold')] public static const FontBold:Class;
		public static const FONT_REGULAR:String = 'Rockwell';
		
		[Embed(source='/assets/fonts/rockwell.swf', symbol='RockwellExtraBold')] public static const FontExtraBold:Class;		
		public static const FONT_EXTRA_BOLD:String = 'Rockwell Extra Bold';
		
		[Embed(source='/assets/fonts/rockwell.swf', symbol='RockwellLight')] public static const FontLight:Class;		
		public static const FONT_LIGHT:String = 'Rockwell Light';				


		// Colors
		public static const COLOR_YES_LIGHT:uint = Utilities.color(0, 185, 255);
		public static const COLOR_YES_MEDIUM:uint = Utilities.color(0, 155, 255);
		public static const COLOR_YES_DARK:uint = Utilities.color(0, 115, 255);
		public static const COLOR_NO_LIGHT:uint = Utilities.color(255, 90, 0); // TODO medium and light are identical in the design template!
		public static const COLOR_NO_MEDIUM:uint = Utilities.color(255, 90, 0); // TODO medium and light are identical in the designtemplate!
		public static const COLOR_NO_DARK:uint = Utilities.color(255, 60, 0);
		public static const COLOR_INSTRUCTION_DARK:uint = Utilities.color(77, 77, 79);
		public static const COLOR_INSTRUCTION_MEDIUM:uint = Utilities.color(147, 149, 152); 
		
	}
}
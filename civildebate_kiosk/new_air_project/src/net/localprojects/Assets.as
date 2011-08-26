package net.localprojects
{
	import flash.display.*;
	import flash.media.Sound;
	
	public final class Assets	{
		
		// Embed code is generated dynamically by embedgen.py
		
		// Bitmaps
		[Embed(source = '/assets/graphics/bottomButtonTile.png')] private static const bottomButtonTileClass:Class;
		public static function getBottomButtonTile():Bitmap { return new bottomButtonTileClass() as Bitmap; };
		public static const bottomButtonTile:Bitmap = getBottomButtonTile();
		
		[Embed(source = '/assets/graphics/bottomEdgeMask.png')] private static const bottomEdgeMaskClass:Class;
		public static function getBottomEdgeMask():Bitmap { return new bottomEdgeMaskClass() as Bitmap; };
		public static const bottomEdgeMask:Bitmap = getBottomEdgeMask();
		
		[Embed(source = '/assets/graphics/buttonBackground.png')] private static const buttonBackgroundClass:Class;
		public static function getButtonBackground():Bitmap { return new buttonBackgroundClass() as Bitmap; };
		public static const buttonBackground:Bitmap = getButtonBackground();
		
		[Embed(source = '/assets/graphics/cameraIcon.png')] private static const cameraIconClass:Class;
		public static function getCameraIcon():Bitmap { return new cameraIconClass() as Bitmap; };
		public static const cameraIcon:Bitmap = getCameraIcon();
		
		[Embed(source = '/assets/graphics/commentsPlaceholder.png')] private static const commentsPlaceholderClass:Class;
		public static function getCommentsPlaceholder():Bitmap { return new commentsPlaceholderClass() as Bitmap; };
		public static const commentsPlaceholder:Bitmap = getCommentsPlaceholder();
		
		[Embed(source = '/assets/graphics/divider.png')] private static const dividerClass:Class;
		public static function getDivider():Bitmap { return new dividerClass() as Bitmap; };
		public static const divider:Bitmap = getDivider();
		
		[Embed(source = '/assets/graphics/flagIcon.png')] private static const flagIconClass:Class;
		public static function getFlagIcon():Bitmap { return new flagIconClass() as Bitmap; };
		public static const flagIcon:Bitmap = getFlagIcon();
		
		[Embed(source = '/assets/graphics/headerBackground.png')] private static const headerBackgroundClass:Class;
		public static function getHeaderBackground():Bitmap { return new headerBackgroundClass() as Bitmap; };
		public static const headerBackground:Bitmap = getHeaderBackground();
		
		[Embed(source = '/assets/graphics/leftButtonTile.png')] private static const leftButtonTileClass:Class;
		public static function getLeftButtonTile():Bitmap { return new leftButtonTileClass() as Bitmap; };
		public static const leftButtonTile:Bitmap = getLeftButtonTile();
		
		[Embed(source = '/assets/graphics/leftEdgeMask.png')] private static const leftEdgeMaskClass:Class;
		public static function getLeftEdgeMask():Bitmap { return new leftEdgeMaskClass() as Bitmap; };
		public static const leftEdgeMask:Bitmap = getLeftEdgeMask();
		
		[Embed(source = '/assets/graphics/likeIcon.png')] private static const likeIconClass:Class;
		public static function getLikeIcon():Bitmap { return new likeIconClass() as Bitmap; };
		public static const likeIcon:Bitmap = getLikeIcon();		
		
		[Embed(source = '/assets/graphics/portraitPlaceholder.png')] private static const portraitPlaceholderClass:Class;
		public static function getPortraitPlaceholder():Bitmap { return new portraitPlaceholderClass() as Bitmap; };
		public static const portraitPlaceholder:Bitmap = getPortraitPlaceholder();
		
		[Embed(source = '/assets/graphics/statsIcon.png')] private static const statsIconClass:Class;
		public static function getStatsIcon():Bitmap { return new statsIconClass() as Bitmap; };
		public static const statsIcon:Bitmap = getStatsIcon();
		
		[Embed(source = '/assets/graphics/statsPlaceholder.png')] private static const statsPlaceholderClass:Class;
		public static function getStatsPlaceholder():Bitmap { return new statsPlaceholderClass() as Bitmap; };
		public static const statsPlaceholder:Bitmap = getStatsPlaceholder();
				
		
		// Vectors
		[Embed(source = '/assets/graphics/quotation.svg')] private static const quotationClass:Class;
		public static function getQuotation():Sprite { return new quotationClass() as Sprite; };
		public static const quotation:Sprite = getQuotation();		

		
		// Generators
		public static function getStatsUnderlay():Bitmap { return new Bitmap(new BitmapData(1080, 1920, false, 0xffffff)); };
		public static const statsUnderlay:Bitmap = getStatsUnderlay();
		
		
		// Fonts
		[Embed(source='/assets/fonts/museo.swf', symbol='MuseoSlab300')] public static const FontLight:Class;
		public static const FONT_LIGHT:String = 'Museo Slab 300';		
		
		[Embed(source='/assets/fonts/museo.swf', symbol='MuseoSlab500')] public static const FontRegular:Class;
		public static const FONT_REGULAR:String = 'Museo Slab 500';
		
		[Embed(source='/assets/fonts/museo.swf', symbol='MuseoSlab700')] public static const FontBold:Class;
		public static const FONT_BOLD:String = 'Museo Slab 700';		
		
		[Embed(source='/assets/fonts/museo.swf', symbol='MuseoSlab900')] public static const FontHeavy:Class;		
		public static const FONT_HEAVY:String = 'Museo Slab 900';				

		
		// Colors
		public static const COLOR_YES_LIGHT:uint = Utilities.color(0, 185, 255);
		public static const COLOR_YES_MEDIUM:uint = Utilities.color(0, 155, 255);
		public static const COLOR_YES_DARK:uint = Utilities.color(0, 115, 255);
		public static const COLOR_YES_OVERLAY:uint = Utilities.color(53, 124, 146);		
		
		public static const COLOR_NO_LIGHT:uint = Utilities.color(255, 90, 0); // TODO medium and light are identical in the design template!
		public static const COLOR_NO_MEDIUM:uint = Utilities.color(255, 90, 0); // TODO medium and light are identical in the designtemplate!
		public static const COLOR_NO_DARK:uint = Utilities.color(255, 60, 0);
		public static const COLOR_NO_OVERLAY:uint = Utilities.color(255, 60, 0);		
		
		public static const COLOR_INSTRUCTION_DARK:uint = Utilities.color(77, 77, 79);
		public static const COLOR_INSTRUCTION_75:uint = Utilities.color(99, 100, 102); // 75% K
		public static const COLOR_INSTRUCTION_50:uint = Utilities.color(147, 149, 152); // 50% K
		
		
		
		
	}
}
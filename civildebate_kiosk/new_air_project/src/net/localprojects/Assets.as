package net.localprojects
{
	import flash.display.*;
	import flash.media.Sound;
	
	public final class Assets	{
		// Fonts
		[Embed(source='/assets/fonts/museo.swf', symbol='MuseoSlab300')] public static const FontLight:Class;
		public static const FONT_LIGHT:String = 'Museo Slab 300';		
		
		[Embed(source='/assets/fonts/museo.swf', symbol='MuseoSlab500')] public static const FontRegular:Class;
		public static const FONT_REGULAR:String = 'Museo Slab 500';
		
		[Embed(source='/assets/fonts/museo.swf', symbol='MuseoSlab700')] public static const FontBold:Class;
		public static const FONT_BOLD:String = 'Museo Slab 700';		
		
		[Embed(source='/assets/fonts/museo.swf', symbol='MuseoSlab900')] public static const FontHeavy:Class;		
		public static const FONT_HEAVY:String = 'Museo Slab 900';		
		
		
		// Graphics
		[Embed(source = '/assets/graphics/blankCursor.png')] private static const blankCursorClass:Class;
		public static function getBlankCursor():Bitmap { return new blankCursorClass() as Bitmap; };
		public static const blankCursor:Bitmap = getBlankCursor();		
		
		[Embed(source = '/assets/graphics/faceTarget.png')] private static const faceTargetClass:Class;
		public static function getFaceTarget():Bitmap { return new faceTargetClass() as Bitmap; };
		public static const faceTarget:Bitmap = getFaceTarget();		
		
		[Embed(source = '/assets/graphics/bigButton.png')] private static const bigButtonClass:Class;
		public static function getBigButton():Bitmap { return new bigButtonClass() as Bitmap; };
		public static const bigButton:Bitmap = getBigButton();		
		
		[Embed(source = '/assets/graphics/leftButtonEdge.png')] private static const leftButtonEdgeClass:Class;
		public static function getLeftButtonEdge():Bitmap { return new leftButtonEdgeClass() as Bitmap; };
		public static const leftButtonEdge:Bitmap = getLeftButtonEdge();		
		
		[Embed(source = '/assets/graphics/leftEdgeMask.png')] private static const leftEdgeMaskClass:Class;
		public static function getLeftEdgeMask():Bitmap { return new leftEdgeMaskClass() as Bitmap; };
		public static const leftEdgeMask:Bitmap = getLeftEdgeMask();

		[Embed(source = '/assets/graphics/bottomEdgeMask.png')] private static const bottomEdgeMaskClass:Class;
		public static function getBottomEdgeMask():Bitmap { return new bottomEdgeMaskClass() as Bitmap; };
		public static const bottomEdgeMask:Bitmap = getBottomEdgeMask();
		
		
		[Embed(source = '/assets/graphics/leftButtonTile.png')] private static const leftButtonTileClass:Class;
		public static function getLeftButtonTile():Bitmap { return new leftButtonTileClass() as Bitmap; };
		public static const leftButtonTile:Bitmap = getLeftButtonTile();
		
		[Embed(source = '/assets/graphics/bottomButtonTile.png')] private static const bottomButtonTileClass:Class;
		public static function getBottomButtonTile():Bitmap { return new bottomButtonTileClass() as Bitmap; };
		public static const bottomButtonTile:Bitmap = getBottomButtonTile();

		[Embed(source = '/assets/graphics/flagIcon.png')] private static const flagIconClass:Class;
		public static function getFlagIcon():Bitmap { return new flagIconClass() as Bitmap; };
		public static const flagIcon:Bitmap = getFlagIcon();		
		
		[Embed(source = '/assets/graphics/statsIcon.png')] private static const statsIconClass:Class;
		public static function getStatsIcon():Bitmap { return new statsIconClass() as Bitmap; };
		public static const statsIcon:Bitmap = getStatsIcon();		
		
		
		[Embed(source = '/assets/graphics/buttonBackground.png')] private static const buttonBackgroundClass:Class;
		public static function getButtonBackground():Bitmap { return new buttonBackgroundClass() as Bitmap; };
		public static const buttonBackground:Bitmap = getButtonBackground();		

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
		
		[Embed(source = '/assets/graphics/yesPortraitOverlay.png')] private static const yesPortraitOverlayClass:Class;
		public static function getYesPortraitOverlay():Bitmap { return new yesPortraitOverlayClass() as Bitmap; };
		public static const yesPortraitOverlay:Bitmap = getYesPortraitOverlay();
		
		[Embed(source = '/assets/graphics/cameraArrow.png')] private static const cameraArrowClass:Class;
		public static function getCameraArrow():Bitmap { return new cameraArrowClass() as Bitmap; };
		public static const cameraArrow:Bitmap = getCameraArrow();
		
		
		
		public static function getStatsUnderlay():Bitmap { return new Bitmap(new BitmapData(1080, 1920, false, 0xffffff)); };
		public static const statsUnderlay:Bitmap = getStatsUnderlay();
		

		

		// Colors
		public static const COLOR_YES_LIGHT:uint = Utilities.color(0, 185, 255);
		public static const COLOR_YES_MEDIUM:uint = Utilities.color(0, 155, 255);
		public static const COLOR_YES_DARK:uint = Utilities.color(0, 115, 255);
		public static const COLOR_NO_LIGHT:uint = Utilities.color(255, 90, 0); // TODO medium and light are identical in the design template!
		public static const COLOR_NO_MEDIUM:uint = Utilities.color(255, 90, 0); // TODO medium and light are identical in the designtemplate!
		public static const COLOR_NO_DARK:uint = Utilities.color(255, 60, 0);
		public static const COLOR_INSTRUCTION_DARK:uint = Utilities.color(77, 77, 79);
		public static const COLOR_INSTRUCTION_MEDIUM:uint = Utilities.color(99, 100, 102);		
		public static const COLOR_INSTRUCTION_LIGHT:uint = Utilities.color(147, 149, 152); 
		
		
		// Temp
		[Embed(source = '/assets/graphics/statsPlaceholder.png')] private static const statsPlaceholderClass:Class;
		public static function getStatsPlaceholder():Bitmap { return new statsPlaceholderClass() as Bitmap; };
		public static const statsPlaceholder:Bitmap = getStatsPlaceholder();
		
		[Embed(source = '/assets/graphics/commentsPlaceholder.png')] private static const commentsPlaceholderClass:Class;
		public static function getCommentsPlaceholder():Bitmap { return new commentsPlaceholderClass() as Bitmap; };
		public static const commentsPlaceholder:Bitmap = getCommentsPlaceholder();
		
		[Embed(source = '/assets/graphics/portraitBlurMask.png')] private static const portraitBlurMaskClass:Class;
		public static function getPortraitBlurMask():Bitmap { return new portraitBlurMaskClass() as Bitmap; };
		public static const portraitBlurMask:Bitmap = getPortraitBlurMask();
	}
}
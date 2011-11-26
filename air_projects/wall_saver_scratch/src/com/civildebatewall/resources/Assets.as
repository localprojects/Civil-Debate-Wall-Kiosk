package com.civildebatewall.resources {
	import com.kitschpatrol.futil.utilitites.ColorUtil;
	
	public class Assets {
		
		import flash.display.*;		
		import flash.utils.ByteArray;

		// New Title Sequence
		[Embed(source = '/assets/graphics/titleChevron.png')] private static const titleChevronClass:Class;
		public static function getTitleChevron():Bitmap { return new titleChevronClass() as Bitmap; };
		public static const titleChevron:Bitmap = getTitleChevron();
				
		[Embed(source = '/assets/graphics/wallText.png')] private static const wallTextClass:Class;
		public static function getWallText():Bitmap { return new wallTextClass() as Bitmap; };
		public static const wallText:Bitmap = getWallText();
		
		[Embed(source = '/assets/graphics/theText.png')] private static const theTextClass:Class;
		public static function getTheText():Bitmap { return new theTextClass() as Bitmap; };
		public static const theText:Bitmap = getTheText();
		
		[Embed(source = '/assets/graphics/taglineText.png')] private static const taglineTextClass:Class;
		public static function getTaglineText():Bitmap { return new taglineTextClass() as Bitmap; };
		public static const taglineText:Bitmap = getTaglineText();
		
		
		// Quotation Marks
		[Embed(source = '/assets/graphics/quoteNoClose.png')] private static const quoteNoCloseClass:Class;
		public static function getQuoteNoClose():Bitmap { return new quoteNoCloseClass() as Bitmap; };
		public static const quoteNoClose:Bitmap = getQuoteNoClose();
		
		[Embed(source = '/assets/graphics/quoteYesClose.png')] private static const quoteYesCloseClass:Class;
		public static function getQuoteYesClose():Bitmap { return new quoteYesCloseClass() as Bitmap; };
		public static const quoteYesClose:Bitmap = getQuoteYesClose();
		
		[Embed(source = '/assets/graphics/quoteYesOpen.png')] private static const quoteYesOpenClass:Class;
		public static function getQuoteYesOpen():Bitmap { return new quoteYesOpenClass() as Bitmap; };
		public static const quoteYesOpen:Bitmap = getQuoteYesOpen();
		
		[Embed(source = '/assets/graphics/quoteNoOpen.png')] private static const quoteNoOpenClass:Class;
		public static function getQuoteNoOpen():Bitmap { return new quoteNoOpenClass() as Bitmap; };
		public static const quoteNoOpen:Bitmap = getQuoteNoOpen();
		
		
		// Calls To Action
		[Embed(source = '/assets/graphics/touchToBeginText.png')] private static const touchToBeginTextClass:Class;
		public static function getTouchToBeginText():Bitmap { return new touchToBeginTextClass() as Bitmap; };
		public static const touchToBeginText:Bitmap = getTouchToBeginText();
		
		[Embed(source = '/assets/graphics/joinTheDebateText.png')] private static const joinTheDebateTextClass:Class;
		public static function getJoinTheDebateText():Bitmap { return new joinTheDebateTextClass() as Bitmap; };
		public static const joinTheDebateText:Bitmap = getJoinTheDebateText();

		// Graph Labels
		[Embed(source = '/assets/graphics/graphLabelNo.png')] private static const graphLabelNoClass:Class;
		public static function getGraphLabelNo():Bitmap { return new graphLabelNoClass() as Bitmap; };
		public static const graphLabelNo:Bitmap = getGraphLabelNo();
		
		[Embed(source = '/assets/graphics/graphLabelYes.png')] private static const graphLabelYesClass:Class;
		public static function getGraphLabelYes():Bitmap { return new graphLabelYesClass() as Bitmap; };
		public static const graphLabelYes:Bitmap = getGraphLabelYes();


		// Sample Kiosks		
		[Embed(source = '/assets/graphics/sampleKiosk1.jpg')] private static const sampleKiosk1Class:Class;
		public static function getSampleKiosk1():Bitmap { return new sampleKiosk1Class() as Bitmap; };
		public static const sampleKiosk1:Bitmap = getSampleKiosk1();
		
		[Embed(source = '/assets/graphics/sampleKiosk2.jpg')] private static const sampleKiosk2Class:Class;
		public static function getSampleKiosk2():Bitmap { return new sampleKiosk2Class() as Bitmap; };
		public static const sampleKiosk2:Bitmap = getSampleKiosk2();		
		
		
		// Sample Portraits
		[Embed(source = '/assets/graphics/samplePortrait1.jpg')] private static const samplePortrait1Class:Class;
		public static function getSamplePortrait1():Bitmap { return new samplePortrait1Class() as Bitmap; };
		public static const samplePortrait1:Bitmap = getSamplePortrait1();
		
		[Embed(source = '/assets/graphics/samplePortrait2.jpg')] private static const samplePortrait2Class:Class;
		public static function getSamplePortrait2():Bitmap { return new samplePortrait2Class() as Bitmap; };
		public static const samplePortrait2:Bitmap = getSamplePortrait2();
		
		[Embed(source = '/assets/graphics/samplePortrait3.jpg')] private static const samplePortrait3Class:Class;
		public static function getSamplePortrait3():Bitmap { return new samplePortrait3Class() as Bitmap; };
		public static const samplePortrait3:Bitmap = getSamplePortrait3();
		
		[Embed(source = '/assets/graphics/samplePortrait4.jpg')] private static const samplePortrait4Class:Class;
		public static function getSamplePortrait4():Bitmap { return new samplePortrait4Class() as Bitmap; };
		public static const samplePortrait4:Bitmap = getSamplePortrait4();
		

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
		
		
		// Colors
		public static const COLOR_YES_EXTRA_LIGHT:uint = ColorUtil.rgb(185, 229, 250); //ColorUtil.rgb(109, 207, 246);
		public static const COLOR_YES_LIGHT:uint = ColorUtil.rgb(0, 185, 255);
		public static const COLOR_YES_MEDIUM:uint = ColorUtil.rgb(0, 155, 255);
		public static const COLOR_YES_DARK:uint = ColorUtil.rgb(0, 115, 255);
		public static const COLOR_YES_OVERLAY:uint = ColorUtil.rgb(53, 124, 146);
		public static const COLOR_YES_WATERMARK:uint = ColorUtil.rgb(239, 249, 254);
		public static const COLOR_YES_DISABLED:uint = ColorUtil.rgb(34, 63, 110); 
		public static const COLOR_YES_HIGHLIGHT:uint = COLOR_YES_DISABLED; // TBD		
		
		public static const COLOR_NO_EXTRA_LIGHT:uint = ColorUtil.rgb(251, 200, 180); //ColorUtil.rgb(247, 150, 121);
		public static const COLOR_NO_LIGHT:uint = ColorUtil.rgb(255, 90, 0); // TODO medium and light are identical in the design template!
		public static const COLOR_NO_MEDIUM:uint = ColorUtil.rgb(255, 75, 0); // TODO medium and light are identical in the designtemplate!
		public static const COLOR_NO_DARK:uint = ColorUtil.rgb(255, 60, 0);
		public static const COLOR_NO_OVERLAY:uint = ColorUtil.rgb(255, 60, 0);
		public static const COLOR_NO_WATERMARK:uint = ColorUtil.rgb(255, 242, 235);
		public static const COLOR_NO_DISABLED	:uint = ColorUtil.rgb(140, 41, 4);		
		public static const COLOR_NO_HIGHLIGHT:uint = COLOR_NO_DISABLED; // TBD		
		
		public static const COLOR_GRAY_2:uint = ColorUtil.grayPercent(2.5);
		public static const COLOR_GRAY_5:uint = ColorUtil.grayPercent(5);
		public static const COLOR_GRAY_15:uint = ColorUtil.grayPercent(15);		
		public static const COLOR_GRAY_20:uint = ColorUtil.grayPercent(20);
		public static const COLOR_GRAY_25:uint = ColorUtil.grayPercent(25);
		public static const COLOR_GRAY_50:uint = ColorUtil.grayPercent(50);
		public static const COLOR_GRAY_75:uint = ColorUtil.grayPercent(75);
		public static const COLOR_GRAY_85:uint = ColorUtil.grayPercent(85);
		public static const COLOR_GRAY_90:uint = ColorUtil.grayPercent(90);
	}
}
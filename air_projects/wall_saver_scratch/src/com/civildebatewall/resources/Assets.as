package com.civildebatewall.resources {
	import com.kitschpatrol.futil.utilitites.ColorUtil;
	
	public class Assets {
		
		import flash.display.*;		
		import flash.utils.ByteArray;

		// Wallsaver Arrows
		[Embed(source = '/assets/graphics/questionArrowHead.png')] private static const questionArrowHeadClass:Class;
		public static function getQuestionArrowHead():Bitmap { return new questionArrowHeadClass() as Bitmap; };
		public static const questionArrowHead:Bitmap = getQuestionArrowHead();

		[Embed(source = '/assets/graphics/questionArrowTail.png')] private static const questionArrowTailClass:Class;
		public static function getQuestionArrowTail():Bitmap { return new questionArrowTailClass() as Bitmap; };
		public static const questionArrowTail:Bitmap = getQuestionArrowTail();
		
		[Embed(source = '/assets/graphics/touchToBeginText.png')] private static const touchToBeginTextClass:Class;
		public static function getTouchToBeginText():Bitmap { return new touchToBeginTextClass() as Bitmap; };
		public static const touchToBeginText:Bitmap = getTouchToBeginText();
		
		[Embed(source = '/assets/graphics/joinTheDebateText.png')] private static const joinTheDebateTextClass:Class;
		public static function getJoinTheDebateText():Bitmap { return new joinTheDebateTextClass() as Bitmap; };
		public static const joinTheDebateText:Bitmap = getJoinTheDebateText();

		[Embed(source = '/assets/graphics/blueArrowHead.png')] private static const blueArrowHeadClass:Class;
		public static function getBlueArrowHead():Bitmap { return new blueArrowHeadClass() as Bitmap; };
		public static const blueArrowHead:Bitmap = getBlueArrowHead();

		[Embed(source = '/assets/graphics/blueArrowTail.png')] private static const blueArrowTailClass:Class;
		public static function getBlueArrowTail():Bitmap { return new blueArrowTailClass() as Bitmap; };
		public static const blueArrowTail:Bitmap = getBlueArrowTail();
		
		[Embed(source = '/assets/graphics/orangeArrowHead.png')] private static const orangeArrowHeadClass:Class;
		public static function getOrangeArrowHead():Bitmap { return new orangeArrowHeadClass() as Bitmap; };
		public static const orangeArrowHead:Bitmap = getOrangeArrowHead();
		
		[Embed(source = '/assets/graphics/orangeArrowTail.png')] private static const orangeArrowTailClass:Class;
		public static function getOrangeArrowTail():Bitmap { return new orangeArrowTailClass() as Bitmap; };
		public static const orangeArrowTail:Bitmap = getOrangeArrowTail();
		

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
		
		
		// Sliced up title
		[Embed(source = '/assets/graphics/titleSlice_01.png')] private static const titleSlice_01Class:Class;
		public static function getTitleSlice_01():Bitmap { return new titleSlice_01Class() as Bitmap; };
		public static const titleSlice_01:Bitmap = getTitleSlice_01();
		
		[Embed(source = '/assets/graphics/titleSlice_02.png')] private static const titleSlice_02Class:Class;
		public static function getTitleSlice_02():Bitmap { return new titleSlice_02Class() as Bitmap; };
		public static const titleSlice_02:Bitmap = getTitleSlice_02();
		
		[Embed(source = '/assets/graphics/titleSlice_03.png')] private static const titleSlice_03Class:Class;
		public static function getTitleSlice_03():Bitmap { return new titleSlice_03Class() as Bitmap; };
		public static const titleSlice_03:Bitmap = getTitleSlice_03();
		
		[Embed(source = '/assets/graphics/titleSlice_04.png')] private static const titleSlice_04Class:Class;
		public static function getTitleSlice_04():Bitmap { return new titleSlice_04Class() as Bitmap; };
		public static const titleSlice_04:Bitmap = getTitleSlice_04();
		
		[Embed(source = '/assets/graphics/titleSlice_05.png')] private static const titleSlice_05Class:Class;
		public static function getTitleSlice_05():Bitmap { return new titleSlice_05Class() as Bitmap; };
		public static const titleSlice_05:Bitmap = getTitleSlice_05();
		
		[Embed(source = '/assets/graphics/titleSlice_06.png')] private static const titleSlice_06Class:Class;
		public static function getTitleSlice_06():Bitmap { return new titleSlice_06Class() as Bitmap; };
		public static const titleSlice_06:Bitmap = getTitleSlice_06();
		
		[Embed(source = '/assets/graphics/titleSlice_07.png')] private static const titleSlice_07Class:Class;
		public static function getTitleSlice_07():Bitmap { return new titleSlice_07Class() as Bitmap; };
		public static const titleSlice_07:Bitmap = getTitleSlice_07();
		

		// Shaders
		[Embed(source="/assets/shaders/maskBlend.pbj", mimeType="application/octet-stream")] public static const MaskBlendFilter:Class;
		public static function getMaskBlendFilter():Shader { return new Shader(new MaskBlendFilter() as ByteArray); };
		
		
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
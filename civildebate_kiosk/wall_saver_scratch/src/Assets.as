package {
	
	public final class Assets {
		
		import flash.display.*;		
		import flash.utils.ByteArray;
		
		[Embed(source = '/assets/graphics/title.png')] private static const titleClass:Class;
		public static function getTitle():Bitmap { return new titleClass() as Bitmap; };
		public static const title:Bitmap = getTitle();

		[Embed(source = '/assets/graphics/sampleKiosk2.png')] private static const sampleKiosk2Class:Class;
		public static function getSampleKiosk2():Bitmap { return new sampleKiosk2Class() as Bitmap; };
		public static const sampleKiosk2:Bitmap = getSampleKiosk2();
		
		[Embed(source = '/assets/graphics/sampleKiosk1.png')] private static const sampleKiosk1Class:Class;
		public static function getSampleKiosk1():Bitmap { return new sampleKiosk1Class() as Bitmap; };
		public static const sampleKiosk1:Bitmap = getSampleKiosk1();		
		
		[Embed(source = '/assets/graphics/joinDebateButton.png')] private static const joinDebateButtonClass:Class;
		public static function getJoinDebateButton():Bitmap { return new joinDebateButtonClass() as Bitmap; };
		public static const joinDebateButton:Bitmap = getJoinDebateButton();
		
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
		
		
		
		// Temp
		[Embed(source = '/assets/graphics/yesPlaceholderWhite.png')] private static const yesPlaceholderWhiteClass:Class;
		public static function getYesPlaceholderWhite():Bitmap { return new yesPlaceholderWhiteClass() as Bitmap; };
		public static const yesPlaceholderWhite:Bitmap = getYesPlaceholderWhite();


		[Embed(source = '/assets/graphics/noPlaceholderWhite.png')] private static const noPlaceholderWhiteClass:Class;
		public static function getNoPlaceholderWhite():Bitmap { return new noPlaceholderWhiteClass() as Bitmap; };
		public static const noPlaceholderWhite:Bitmap = getNoPlaceholderWhite();
		

		
		// Shaders
		[Embed(source="/assets/shaders/maskBlend.pbj", mimeType="application/octet-stream")] public static const MaskBlendFilter:Class;
		public static function getMaskBlendFilter():Shader { return new Shader(new MaskBlendFilter() as ByteArray); };
		
		
		
		// Colors
		public static const COLOR_YES_EXTRA_LIGHT:uint = color(185, 229, 250); //color(109, 207, 246);
		public static const COLOR_YES_LIGHT:uint = color(0, 185, 255);
		public static const COLOR_YES_MEDIUM:uint = color(0, 155, 255);
		public static const COLOR_YES_DARK:uint = color(0, 115, 255);
		public static const COLOR_YES_OVERLAY:uint = color(53, 124, 146);
		public static const COLOR_YES_WATERMARK:uint = color(239, 249, 254);
		public static const COLOR_YES_DISABLED:uint = color(34, 63, 110); 
		public static const COLOR_YES_HIGHLIGHT:uint = COLOR_YES_DISABLED; // TBD		
		
		public static const COLOR_NO_EXTRA_LIGHT:uint = color(251, 200, 180); //color(247, 150, 121);
		public static const COLOR_NO_LIGHT:uint = color(255, 90, 0); // TODO medium and light are identical in the design template!
		public static const COLOR_NO_MEDIUM:uint = color(255, 75, 0); // TODO medium and light are identical in the designtemplate!
		public static const COLOR_NO_DARK:uint = color(255, 60, 0);
		public static const COLOR_NO_OVERLAY:uint = color(255, 60, 0);
		public static const COLOR_NO_WATERMARK:uint = color(255, 242, 235);
		public static const COLOR_NO_DISABLED	:uint = color(140, 41, 4);		
		public static const COLOR_NO_HIGHLIGHT:uint = COLOR_NO_DISABLED; // TBD		
		
		public static const COLOR_GRAY_2:uint = color(248, 248, 248); // ?% K
		public static const COLOR_GRAY_5:uint = color(241, 242, 242); // 5% K
		public static const COLOR_GRAY_15:uint = color(220, 221, 222); // 15% K		
		public static const COLOR_GRAY_20:uint = color(230, 231, 232); // 20% K
		public static const COLOR_GRAY_25:uint = color(199, 200, 202); // 25% K
		public static const COLOR_GRAY_50:uint = color(147, 149, 152); // 50% K
		public static const COLOR_GRAY_75:uint = color(99, 100, 102); // 75% K
		public static const COLOR_GRAY_85:uint = color(77, 77, 79); // 85% K
		public static const COLOR_GRAY_90:uint = color(65, 66, 64); // 90% K
		
		public static function color(r:int, g:int, b:int):uint {
			return r << 16 | g << 8 | b;
		}
				
		
	}
}
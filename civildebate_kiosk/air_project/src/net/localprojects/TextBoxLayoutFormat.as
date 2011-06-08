package net.localprojects
{
	import flashx.textLayout.formats.ITextLayoutFormat;
	import flashx.textLayout.formats.TextLayoutFormat;
	
	// gives some extra fields for specifying label boxes
	
	public class TextBoxLayoutFormat extends TextLayoutFormat
	{
		
		public var boundingWidth:Number = 100;
		public var boundingHeight:Number = 100;
		public var backgroundSpriteColor:uint = 0x000000;
		public var showSpriteBackground:Boolean = false;
		
		public function TextBoxLayoutFormat(initialValues:ITextLayoutFormat=null)
		{
			super(initialValues);
			
			
			
		}
	}
}
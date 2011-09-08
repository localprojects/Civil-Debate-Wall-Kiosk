package com.civildebatewall.ui {
	import com.civildebatewall.*;
	import com.civildebatewall.blocks.BlockLabel;
	import com.civildebatewall.data.Word;
	
	import fl.motion.Color;
	
	
	public class WordButton extends BlockLabel {
		public var normalDifference:Number;
		private var _posts:Array;
		private var interpolatedColor:uint;
		public var word:Word; // keep the word reference
		
		public function WordButton(_word:Word, textSize:Number = 34, textColor:uint=0xffffff, backgroundColor:uint=0x000000, font:String=null, showBackground:Boolean=true)	{
			word = _word;
			normalDifference = word.normalDifference;
			_posts = word.posts;
			font = Assets.FONT_REGULAR;

			super(StringUtils.capitalize(word.word), textSize, textColor, backgroundColor, font, showBackground);
			
			// set background color
			interpolatedColor = Utilities.getPixelGradient(Assets.wordCloudGradient, normalDifference);
			this.setBackgroundColor(interpolatedColor, true);
			
			this.setPadding(14, 15, 10, 15);
		}
		
	}
}
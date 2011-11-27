package com.civildebatewall.kiosk.buttons {
	import com.civildebatewall.*;
	import com.civildebatewall.data.Word;
	import com.kitschpatrol.futil.blocks.BlockText;
	import com.kitschpatrol.futil.constants.Alignment;
	import com.kitschpatrol.futil.utilitites.BitmapUtil;
	import com.kitschpatrol.futil.utilitites.StringUtil;
	
	public class WordButton extends BlockText {
		public var difference:Number;		
		public var normalDifference:Number;
		private var _posts:Array;
		public var word:Word; // keep the word reference
		public var yesCases:Number;
		public var noCases:Number;		
		
		public function WordButton(_word:Word)	{
			super();
			
			
			word = _word;
			normalDifference = word.normalDifference;
			_posts = word.posts;
			yesCases = word.yesCases;			
			noCases = word.noCases;			

			// set up the word button
			height = 57;
			backgroundRadius = 4;
			text = StringUtil.capitalize(word.theWord);
			textFont = Assets.FONT_BOLD;
			letterSpacing = -1;	
			textColor = 0xffffff;
			textSize = 25;
			textAlignmentMode = Alignment.TEXT_CENTER,
			paddingTop = 0;
			paddingRight = 13;
			paddingBottom = 0;
			paddingLeft = 13;
			leading = 25; // make sure we don't wrap
			backgroundColor = 0x000000;
			alignmentPoint = Alignment.CENTER;
			buttonMode = true;
			
			visible = true;
			updateColor();
		}
		
		// todo normal difference setter?
		public function updateColor():void {
			backgroundColor =	BitmapUtil.getPixelAtNormal(Assets.wordCloudGradient, normalDifference, 0);			
		}
		
		
	}
}
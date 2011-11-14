package com.civildebatewall.wallsaver.elements {
	import com.civildebatewall.resources.Assets;
	import com.kitschpatrol.futil.blocks.BlockText;
	import com.kitschpatrol.futil.constants.Alignment;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	
	public class QuestionBanner extends Sprite {

		private var questionHead:Bitmap;
		private var questionTail:Bitmap;
		private var questionTextBlock:BlockText;
		
		
		public function QuestionBanner(questionText:String) {
			super();
			
			questionHead = Assets.getQuestionArrowHead();
			addChild(questionHead);
			
			questionTextBlock = new BlockText({
				growthMode: BlockText.MAXIMIZE_HEIGHT,				
				text: questionText,
				textFont: Assets.FONT_BOLD,
				backgroundColor: 0x322f31,
				textSize: 274,
				leading: 196,
				textColor: 0xffffff,
				height: questionHead.height,
				maxWidth: Number.MAX_VALUE,
				paddingLeft: 990,
				paddingRight: 990,
				alignmentPoint: Alignment.CENTER,
				visible: true
			});
			
			trace("Num lines: " + questionTextBlock.textField.numLines);
			
			questionTextBlock.y = 0;
			questionTextBlock.x = questionHead.width;
			addChild(questionTextBlock);
			
			questionTail = Assets.getQuestionArrowTail();			
			questionTail.x = questionTextBlock.x + questionTextBlock.width;
			addChild(questionTail);
		}
		
		
	}
}
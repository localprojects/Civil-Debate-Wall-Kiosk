package com.civildebatewall.wallsaver.elements {
	import com.civildebatewall.resources.Assets;
	import com.kitschpatrol.futil.TextBlock;
	import com.kitschpatrol.futil.constants.Alignment;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	
	public class QuestionBanner extends Sprite {

		private var questionHead:Bitmap;
		private var questionTail:Bitmap;
		private var questionTextBlock:TextBlock;
		
		
		public function QuestionBanner(questionText:String) {
			super();
			
			questionHead = Assets.getQuestionArrowHead();
			addChild(questionHead);
			
			questionTextBlock = new TextBlock({text: questionText,
																				 textFont: Assets.FONT_BOLD,
																		 		 backgroundColor: 0x322f31,
																				 textSizePixels: 274,
																				 leading: 196,
																		 		 textColor: 0xffffff,
																				 alignmentPoint: Alignment.CENTER,
																		 		 height: questionHead.height,
																				 growthMode: TextBlock.MAXIMIZE_HEIGHT,
																				 paddingLeft: 990,
																				 paddingRight: 990														 
																		 		 });
			
			questionTextBlock.y = 0;
			questionTextBlock.x = questionHead.width;
			addChild(questionTextBlock);
			
			questionTail = Assets.getQuestionArrowTail();			
			questionTail.x = questionTextBlock.x + questionTextBlock.width;
			addChild(questionTail);
		}
		
		
	}
}
package com.civildebatewall.wallsaver.elements {
	import com.kitschpatrol.futil.Padding;
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
			
			// TODO make padding internal by default?
			questionTextBlock = new TextBlock({text: questionText,
																		 		 backgroundColor: 0x322f31,
																				 textSizePixels: 274,
																				 leading: 196,
																		 		 textColor: 0xffffff,
																		 		 minWidth: 500,
																				 alignmentPoint: Alignment.CENTER,
																		 		 height: questionHead.height,
																				 growthMode: TextBlock.MAXIMIZE_HEIGHT,
																				 paddingLeft: 990,
																				 paddingRight: 990														 
																		 		 });
			
			questionTextBlock.y = 0;
			questionTextBlock.x = questionHead.width;
			addChild(questionTextBlock);
			
			trace("Width: " + questionTextBlock.width);
			
			questionTail = Assets.getQuestionArrowTail();			
			questionTail.x = questionTextBlock.x + questionTextBlock.width;
			addChild(questionTail);
		}
	}
}
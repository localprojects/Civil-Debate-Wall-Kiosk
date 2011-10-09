package {
	import com.kitschpatrol.futil.TextBlock;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	
	
	public class QuestionBanner extends Sprite {
		
		private var questionText:String;
		private var questionHead:Bitmap;
		private var questionTail:Bitmap;
		private var questionBlock:TextBlock;
		
		public function QuestionBanner(questionText:String) {
			super();
			this.questionText = questionText;
			
			questionHead = Assets.getQuestionArrowHead();
			addChild(questionHead);
			
			// TODO make padding internal by default?
			questionBlock = new TextBlock({text: questionText,
																		 backgroundColor: 0x322f31,
																		 textColor: 0xffffff,
																		 minWidth: 500,
																		 minHeight: questionHead.height - 200,
																		 maxHeight: questionHead.height - 200,
																		 padding: 100});
							
			questionBlock.y = 100;
			questionBlock.x = questionHead.width + 100;
			addChild(questionBlock);
			
			trace("Width: " + questionBlock.width);
			
			questionTail = Assets.getQuestionArrowTail();			
			questionTail.x = questionBlock.x + questionBlock.width - 100;
			addChild(questionTail);

		}
	}
}
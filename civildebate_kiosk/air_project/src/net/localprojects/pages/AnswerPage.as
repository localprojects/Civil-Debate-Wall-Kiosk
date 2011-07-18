package net.localprojects.pages {
	
	import net.localprojects.Assets;
	import net.localprojects.ui.*;
	import flash.events.MouseEvent;
	
	public class AnswerPage extends Page {
		
		public function AnswerPage() {
			super();
			init();
		}
		
		private function init():void {
			// TODO global blocks array? easier transitions for just showing / hiding them?
//			blocks.push(Main.header);
//			blocks.push(Main.debatePicker);
//			blocks.push(Main.question);			
			
			
				Main.viewManager.setBlocks(Main.viewManager.header,
																	 Main.viewManager.debatePicker,
																	 Main.viewManager.question);					
			
			// put in the background portrait (TODO move to block?)
			addChild(Assets.answerBackground());
			
			

			
//			// put everything on the page
//			for (var i:int = 0; i < blocks.length; i++) {
//				addChild(blocks[i]);
//			}
			
			var addOpinionButton:BigButton = new BigButton("Add Your Opinion");
			addOpinionButton.x = 438;
			addOpinionButton.y = 1500;
			addOpinionButton.disable();
			addChild(addOpinionButton);
						
			
			
			
		}
		
	}
}

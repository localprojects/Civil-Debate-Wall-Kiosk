package net.localprojects.pages {
	
	import flash.display.Bitmap;
	
	import net.localprojects.*;
	import net.localprojects.elements.BlockLabel;
	import net.localprojects.ui.*;
	
	public class StancePage extends Page {
		
		
		public function StancePage() {
			super();
			init();
		}
		
		private function init():void {
			blocks.push(Main.header);
			blocks.push(Main.debatePicker);
			blocks.push(Main.question);	
			
			
			// put in the background portrait (TODO move to block)
			addChild(Assets.samplePortrait);
			
			// dashed lines
			var topDashedLine:Bitmap = Assets.getDashedDivider();
			topDashedLine.x = 30;
			topDashedLine.y = 263;
			
			var bottomDashedLine:Bitmap = Assets.getDashedDivider();
			bottomDashedLine.x = 30;
			bottomDashedLine.y = 467;
			
			addChild(topDashedLine);
			addChild(bottomDashedLine);
			
			var addOpinionButton:BigButton = new BigButton("Add Your Opinion");
			addOpinionButton.x = 438;
			addOpinionButton.y = 1469;
			addChild(addOpinionButton);
			
			


			// put everything on the page
			for (var i:int = 0; i < blocks.length; i++) {
				addChild(blocks[i]);
			}
			
			var blockLabel:BlockLabel = new BlockLabel();
			blockLabel.x = 100;
			blockLabel.y = 300;
			addChild(blockLabel);
			
		}
	}
}
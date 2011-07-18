package net.localprojects.pages {
	
	import com.greensock.*;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	
	import net.localprojects.*;
	import net.localprojects.elements.BlockLabel;
	import net.localprojects.elements.BlockParagraph;
	import net.localprojects.ui.*;
	
	public class StancePage extends Page {
		
		
		public function StancePage() {
			super();
			init();
		}
		
		private function init():void {
			// TODO global blocks array? easier transitions for just showing / hiding them?
//			blocks.push(Main.header);
//			blocks.push(Main.debatePicker);
//			blocks.push(Main.question);
			
			trace("View Manager: " + Main.viewManager);
			
//			Main.viewManager.setBlocks(Main.viewManager.header,
//																 Main.viewManager.debatePicker,
//																 Main.viewManager.question);			
			
			
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
			addOpinionButton.y = 1500;
			addChild(addOpinionButton);
			addOpinionButton.addEventListener(MouseEvent.MOUSE_UP, onAddOpinionButton);
						
			// put everything on the page
			for (var i:int = 0; i < blocks.length; i++) {
				addChild(blocks[i]);
			}
			
			// TODO block Label (single line block label)
			// TODO block graph class (multi line block label)
			
			var opinion:String = "Our performance in education has been behind many countries and our youths are going to be unable to compete for jobs in the global market.";
			//opinion = "MMMMMM MMMMMM MM MM MMM MMMM WWWWW WMWWWMWM  MMMMMMMMW WMMMWMWMWM MMMMMMMMMMMMM MMMMMMWMW MWMWMWMW WMWMWMW WMMWWWMMMMMMM MWMWMWMWM MWWWWWMMMMM MMEMEM MEMEME ME".toLowerCase()
				
			var opinionGraph:BlockParagraph = new BlockParagraph(915, opinion, 43, 0x009bff);
			opinionGraph.x = 100;
			opinionGraph.y = 1170;
			addChild(opinionGraph);
			
			var statsButton:IconButton = new IconButton(121, 110, "STATS", 22, 0x007cff, Assets.statsIcon());
			statsButton.x = 100;
			statsButton.y = 914;	
			addChild(statsButton);
			
			var debateMeButton:IconButton = new IconButton(121, 115, "DEBATE ME!", 16, 0x007cff, null, true);
			debateMeButton.x = 844;
			debateMeButton.y = 874;	
			addChild(debateMeButton);			
			
			var likeButton:CounterButton = new CounterButton(121, 110, "LIKE", 22, 0x007cff, Assets.likeIcon(), false, 1);
			likeButton.x = 721;
			likeButton.y = 1023;
			addChild(likeButton);
			
			
			var debateButton:BlockButton = new BlockButton(370, 63, "8 people debated this statement", 22, 0x007dff, true);
			debateButton.x = 586;
			debateButton.y = opinionGraph.y + opinionGraph.height;
			addChild(debateButton);
			
			
			// TODO pass in optional padding
			var answerLabel:BlockLabel = new BlockLabel("YES!", 100, 0xffffff, 0x009bff);
			answerLabel.x = 274;
			answerLabel.y = 240;
			addChild(answerLabel);			
			
			var nameLabel:BlockLabel = new BlockLabel("Carrie Ann Says:", 55, 0xffffff, 0x009bff);
			nameLabel.x = 274;
			nameLabel.y = 400;
			addChild(nameLabel);
			
			
//			var leftQuote:BlockLabel = new BlockLabel("\u201CTEST", 200, 0x00b9ff, 0x000000, false);
//			leftQuote.x = 100;
//			leftQuote.y = 100;
//			addChild(leftQuote);
			
			
			var leftQuotationMark:Sprite = Assets.quotation();
			TweenMax.to(leftQuotationMark, 0, {colorMatrixFilter:{colorize: 0x009bff, amount: 1}});			
			leftQuotationMark.x = 100;
			leftQuotationMark.y = 515;
			addChild(leftQuotationMark);
			
			
			var rightQuotationMark:Sprite = Assets.quotation();
			TweenMax.to(rightQuotationMark, 0, {colorMatrixFilter:{colorize: 0x009bff, amount: 1}});
			rightQuotationMark.rotation = 180;
			rightQuotationMark.x = 842;
			rightQuotationMark.y = 1730;
			addChild(rightQuotationMark);
		}
		
		private function onAddOpinionButton(e:MouseEvent):void {
			trace("stance page got opinion button");
			
			Main.state.setView(Main.viewManager.answerPage);			
		}
	}
}

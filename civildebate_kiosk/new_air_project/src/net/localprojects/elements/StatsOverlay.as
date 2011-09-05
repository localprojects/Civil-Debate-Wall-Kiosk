package net.localprojects.elements {
	import com.greensock.TweenMax;
	import com.greensock.easing.*;
	
	import fl.motion.Color;
	
	import flash.display.Shape;
	import flash.events.Event;
	
	import net.localprojects.*;
	import net.localprojects.blocks.BlockBase;
	import net.localprojects.blocks.BlockLabelBar;
	import net.localprojects.ui.BlockButton;
	import net.localprojects.ui.IconButton;
	
	public class StatsOverlay extends BlockBase {
		

		// blocks		
		public var homeButton:BlockButton;
		
		

		
		private var voteTitleBar:BlockLabelBar;
		private var voteTitleLeftDot:Shape;
		private var voteTitleRightDot:Shape;		
		private var voteStatBar:VoteStatBar;
		
		private var wordTitleBar:BlockLabelBar;
		private var wordTitleLeftDot:Shape;
		private var wordTitleRightDot:Shape;				
		private var wordCloud:WordCloud;
		private var wordSearchResults:WordFrequencyList;
		private var closeWordCloudButton:IconButton;
		
		private var wordCloudResultsTitleBar:BlockLabelBar;
		
		
		private var superlativesTitleBar:BlockLabelBar;
		private var nextSuperlativeButton:IconButton;
		private var previousSuperlativeButton:IconButton;
		private var superlativesPortrait:Portrait;
		
		private var mostDebatedPanel:MostDebatedPanel;
		
		
		public function StatsOverlay() {
			super();
			init();
		}
		
		private function generateDot(c:uint):Shape {
			var shape:Shape = new Shape();
			shape.graphics.beginFill(c);
			shape.graphics.drawCircle(0, 0, 3.6);
			shape.graphics.endFill();
			return shape;
		}
		
		private function init():void {
			this.graphics.beginFill(0xffffff);
			this.graphics.drawRect(0, 0, 1022, 1626);
			this.graphics.endFill();
			
			
			// no animation for this at the moment
			// TODO put it in the parent block instead?
			homeButton = new BlockButton(1022, 63, 0x000000, 'BACK TO DEBATE', 34, 0xffffff, Assets.FONT_HEAVY);
			
			homeButton.setStrokeColor(Assets.COLOR_GRAY_15);
			homeButton.setDefaultTweenIn(0, {x:0, y: 1563});
			homeButton.setDefaultTweenOut(0, {x:0, y: 1563});
			addChild(homeButton);
					
			
			// Voting bar
			voteTitleBar = new BlockLabelBar("Total Number of Votes", 26, 0xffffff, 1022, 63, 0x000000, Assets.FONT_BOLD);
			voteTitleBar.setDefaultTweenIn(0, {x:0, y: 0});
			voteTitleBar.setDefaultTweenOut(0, {x:0, y: 0});
			
			voteTitleLeftDot = generateDot(Assets.COLOR_YES_LIGHT);
			voteTitleLeftDot.x = 248;
			voteTitleLeftDot.y = 27;
			voteTitleBar.addChild(voteTitleLeftDot);
			
			voteTitleRightDot = generateDot(Assets.COLOR_NO_LIGHT);
			voteTitleRightDot.x = 764;
			voteTitleRightDot.y = 27;
			voteTitleBar.addChild(voteTitleRightDot);			

			addChild(voteTitleBar);			
			
			voteStatBar = new VoteStatBar();
			voteStatBar.setDefaultTweenIn(1, {x: 0, y: 78});
			voteStatBar.setDefaultTweenOut(1, {x: 0, y: 78});
			addChild(voteStatBar);
			
			
			// Word Frequency
			wordTitleBar = new BlockLabelBar('Most Frequently Used Words', 26, 0xffffff, 1022, 63, 0x000000, Assets.FONT_BOLD);
			wordTitleBar.setDefaultTweenIn(0, {x:0, y: 234});
			wordTitleBar.setDefaultTweenOut(0, {x:0, y: 234});

			wordTitleLeftDot = generateDot(Assets.COLOR_YES_LIGHT);
			wordTitleLeftDot.x = 248;
			wordTitleLeftDot.y = 27;
			wordTitleBar.addChild(wordTitleLeftDot);
			
			wordTitleRightDot = generateDot(Assets.COLOR_NO_LIGHT);
			wordTitleRightDot.x = 764;
			wordTitleRightDot.y = 27;
			wordTitleBar.addChild(wordTitleRightDot);					
			
			addChild(wordTitleBar);			

			wordCloud = new WordCloud();
			wordCloud.setDefaultTweenIn(0, {x:0, y: 312});
			wordCloud.setDefaultTweenOut(0, {x:0, y: 312});
			addChild(wordCloud);						
			
			wordCloud.addEventListener(WordCloud.EVENT_WORD_SELECTED, frequentWordView);
			wordCloud.addEventListener(WordCloud.EVENT_WORD_DESELECTED, mostDebatedView);
			
			wordSearchResults = new WordFrequencyList();
			wordSearchResults.setDefaultTweenIn(1, {alpha: 1, x:0, y: 702});
			wordSearchResults.setDefaultTweenOut(1, {alpha: 0, x:0, y: 702});
			addChild(wordSearchResults);

			closeWordCloudButton = new IconButton(63, 63, 0x000000, '', 0, 0x000000, null, Assets.getCloseButton());
			closeWordCloudButton.buttonMode = true;
			closeWordCloudButton.showBackground(false);
			closeWordCloudButton.setStrokeWeight(0);			
			closeWordCloudButton.showOutline(false, true);
			closeWordCloudButton.setDefaultTweenIn(1, {alpha: 1, x: 925, y: 234});
			closeWordCloudButton.setDefaultTweenOut(1, {alpha: 0, x: 925, y: 234});
			addChild(closeWordCloudButton);
						
			
			wordCloudResultsTitleBar = new BlockLabelBar('Results', 26, Assets.COLOR_GRAY_75, 1022, 63, Assets.COLOR_GRAY_20, Assets.FONT_BOLD);
			wordCloudResultsTitleBar.setDefaultTweenIn(0, {alpha: 1, x:0, y: 626});
			wordCloudResultsTitleBar.setDefaultTweenOut(0, {alpha: 0, x:0, y: 626});			
			addChild(wordCloudResultsTitleBar);
			
			// Superlatives
			superlativesTitleBar = new BlockLabelBar("Most Debated Opinions", 26, 0xffffff, 1022, 63, 0x000000, Assets.FONT_BOLD);
			superlativesTitleBar.setDefaultTweenIn(1, {alpha: 1, x:0, y: 626});
			superlativesTitleBar.setDefaultTweenOut(1, {alpha: 0, x:0, y: 626});
			addChild(superlativesTitleBar);
			
			previousSuperlativeButton = new IconButton(63, 63, 0x000000, '', 0, 0x000000, null, Assets.getLeftArrow());
			previousSuperlativeButton.buttonMode = true;
			previousSuperlativeButton.showBackground(false);
			previousSuperlativeButton.setStrokeWeight(0);			
			previousSuperlativeButton.showOutline(false, true);
			previousSuperlativeButton.setDefaultTweenIn(1, {alpha: 1, x:244, y: 626});
			previousSuperlativeButton.setDefaultTweenOut(1, {alpha: 0, x:244, y: 626});
			addChild(previousSuperlativeButton);
			
			nextSuperlativeButton = new IconButton(63, 63, 0x000000, '', 0, 0x000000, null, Assets.getRightArrow());
			nextSuperlativeButton.buttonMode = true;
			nextSuperlativeButton.showBackground(false);			
			nextSuperlativeButton.setStrokeWeight(0);
			nextSuperlativeButton.showOutline(false, true);			
			nextSuperlativeButton.setDefaultTweenIn(1, {alpha: 1, x: 719, y: 626});
			nextSuperlativeButton.setDefaultTweenOut(1, {alpha:0, x: 719, y: 626});
			addChild(nextSuperlativeButton);		
			
			superlativesPortrait = new Portrait();
			// TODO pass width and height into constructor?
//			superlativesPortrait.width = 504;
//			superlativesPortrait.height= 844;
			superlativesPortrait.setImage(Assets.getMostDebatedPortraitPlaceholder(), true);			
			superlativesPortrait.setDefaultTweenIn(1, {x: 0, y: 705});
			superlativesPortrait.setDefaultTweenOut(1, {x: BlockBase.OFF_LEFT_EDGE, y: 705});			
			
			addChild(superlativesPortrait);
			
			mostDebatedPanel = new MostDebatedPanel();
			mostDebatedPanel.setDefaultTweenIn(1, {x: 519, y: 705});
			mostDebatedPanel.setDefaultTweenOut(1, {x: BlockBase.OFF_RIGHT_EDGE, y: 705});			
			addChild(mostDebatedPanel);			
			
			// start with word frequency
			update();
			mostDebatedView();
			
			showDebateTotals();
			
			this.addEventListener(Event.ENTER_FRAME, onFrame);
		}
		
		private function onFrame(e:Event):void {
			//trace(mouseX / 10);
			//voteStatBar.barPercent = mouseX / 10;
		}
		
		public function frequentWordView(...args):void {
			markAllInactive();

			
			trace("Frequent word view");
			
			
			// wordFrequencyList.setWord(wordCloud.activeWord);
			
			// mutate to use current word
			
			// update based on active word?
			
			homeButton.setBackgroundColor(CDW.state.activeStanceColorDark, true);
			homeButton.setDownColor(CDW.state.activeStanceColorMedium);			
			wordCloudResultsTitleBar.setText('\u2018' + wordCloud.activeWord.getText() + '\u2019 used in '  + wordSearchResults.count + ' Opinions');
			
			
			// behaviors
			closeWordCloudButton.setOnClick(mostDebatedView);
			
			
			// blocks
			voteTitleBar.tweenIn();
			voteStatBar.tweenIn();

			wordTitleBar.tweenIn();
			closeWordCloudButton.tweenIn();			
			wordCloud.tweenIn();
			wordCloudResultsTitleBar.tweenIn();			
			wordSearchResults.tweenIn();
			homeButton.tweenIn();			
			
			
			tweenOutInactive();			
		}
		
		public function mostDebatedView(...args):void {
			markAllInactive();
			

			superlativesTitleBar.setText('Most Debated Opinions');
			homeButton.setBackgroundColor(CDW.state.activeStanceColorDark, true);
			homeButton.setDownColor(CDW.state.activeStanceColorMedium);			
			
			previousSuperlativeButton.setOnClick(null);
			nextSuperlativeButton.setOnClick(mostLikedView);
			
			voteTitleBar.tweenIn();
			voteStatBar.tweenIn();
			wordTitleBar.tweenIn();
			wordCloud.tweenIn();
			superlativesTitleBar.tweenIn();
			
			previousSuperlativeButton.tweenIn(1, {alpha: 0.25});
			nextSuperlativeButton.tweenIn();
			
			superlativesPortrait.tweenIn();
			mostDebatedPanel.tweenIn();
			homeButton.tweenIn();				
			
			tweenOutInactive();					
		}
		
		public function mostLikedView(...args):void {
			markAllInactive();
			

			superlativesTitleBar.setText('Most Liked Debates');
			homeButton.setBackgroundColor(CDW.state.activeStanceColorDark, true);
			homeButton.setDownColor(CDW.state.activeStanceColorMedium);			
			
			previousSuperlativeButton.setOnClick(mostDebatedView);
			nextSuperlativeButton.setOnClick(mostActiveUsersView);			
			
			
			voteTitleBar.tweenIn();
			voteStatBar.tweenIn();
			wordTitleBar.tweenIn();
			wordCloud.tweenIn();
			superlativesTitleBar.tweenIn();
			nextSuperlativeButton.tweenIn();
			previousSuperlativeButton.tweenIn();			
			superlativesPortrait.tweenIn();
			mostDebatedPanel.tweenIn();
			homeButton.tweenIn();				
			
			tweenOutInactive();					
		}		
		
		public function mostActiveUsersView(...args):void {
			markAllInactive();
			

			
			superlativesTitleBar.setText('Most Active Users');
			homeButton.setBackgroundColor(CDW.state.activeStanceColorDark, true);
			homeButton.setDownColor(CDW.state.activeStanceColorMedium);			
			
			previousSuperlativeButton.setOnClick(mostLikedView);
			nextSuperlativeButton.setOnClick(null);			
			
			voteTitleBar.tweenIn();
			voteStatBar.tweenIn();
						
			wordTitleBar.tweenIn();
			wordCloud.tweenIn();
			superlativesTitleBar.tweenIn();
			
			previousSuperlativeButton.tweenIn();
			nextSuperlativeButton.tweenIn(1, {alpha: 0.25});		
		
			superlativesPortrait.tweenIn();
			mostDebatedPanel.tweenIn();
			homeButton.tweenIn();				
			
			tweenOutInactive();					
		}				
		


		// like overlays
		public function showLikeTotals(...args):void {			
			// behaviors
						
			
			// mutation
			voteTitleBar.setText('Total Number of Votes');
			var yesCount:int = parseInt(CDW.database.stats['likeTotals']['yes']);
			var noCount:int = parseInt(CDW.database.stats['likeTotals']['no']);			
			var targetPercent:Number = (yesCount / (noCount + yesCount)) * 100;

			// tween in
			voteStatBar.setLabels(yesCount + ' ' + Utilities.plural('Like', yesCount), noCount + ' ' + Utilities.plural('Like', noCount));
			TweenMax.to(voteStatBar, 1, {barPercent: targetPercent, ease: Quart.easeInOut});
		}
		
		public function showDebateTotals(...args):void {			
			// behaviors;			
			
			// mutation
			voteTitleBar.setText('Total Number of Opinions');			
			var yesCount:int = parseInt(CDW.database.stats['debateTotals']['yes']);
			var noCount:int = parseInt(CDW.database.stats['debateTotals']['no']);			
			var targetPercent:Number = (yesCount / (noCount + yesCount)) * 100;
			
			// tween in
			voteStatBar.setLabels(yesCount + ' Yes', noCount + ' No');
			TweenMax.to(voteStatBar, 1, {barPercent: targetPercent, ease: Quart.easeInOut});
		}
		
		
				
		
		
		
		public function update():void {
			// anything to do here?
			trace("Updating stats");
			wordCloud.setWords(CDW.database.stats['frequentWords']);
			
		}
		
		
		// TOdo inherit these from a container class... or just put it in block base!?
		private function markAllInactive():void {

			
			// marks all FIRST LEVEL blocks as inactive
			for (var i:int = 0; i < this.numChildren; i++) {
				//if ((this.getChildAt(i) is BlockBase) && (this.getChildAt(i).visible)) {
				// attempt to fix blank screen issue....
				if (this.getChildAt(i) is BlockBase) {				
					(this.getChildAt(i) as BlockBase).active = false;
				}
			}
		}
		
		
		private function tweenOutInactive(instant:Boolean = false):void {	
			for (var i:int = 0; i < this.numChildren; i++) {
				
				if ((this.getChildAt(i) is BlockBase) && !(this.getChildAt(i) as BlockBase).active) {
					
					if (instant)
						(this.getChildAt(i) as BlockBase).tweenOut(0);
					else
						(this.getChildAt(i) as BlockBase).tweenOut();
					
				}
			}
		}		
		
		
	}
}
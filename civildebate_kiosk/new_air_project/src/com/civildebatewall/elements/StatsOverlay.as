package com.civildebatewall.elements {
	import com.civildebatewall.*;
	import com.civildebatewall.blocks.BlockBase;
	import com.civildebatewall.blocks.BlockLabelBar;
	import com.civildebatewall.ui.BlockButton;
	import com.civildebatewall.ui.IconButton;
	import com.greensock.TweenMax;
	import com.greensock.easing.*;
	
	import flash.display.Shape;
	import flash.events.Event;
	
	public class StatsOverlay extends BlockBase {
		
		// vote bar
		private var voteTitleBar:BlockLabelBar;
		private var voteTitleLeftDot:Shape;
		private var voteTitleRightDot:Shape;		
		public var voteStatBar:VoteStatBar;
		
		// word cloud and search results
		private var wordTitleBar:BlockLabelBar;
		private var wordTitleLeftDot:Shape;
		private var wordTitleRightDot:Shape;				
		private var wordCloud:WordCloud;
		private var wordCloudResultsTitleBar:BlockLabelBar;
		private var closeWordCloudButton:IconButton;		
		private var wordSearchResults:WordSearchResults;
		
		// superlatives
		private var superlativesTitleBar:BlockLabelBar;
		private var nextSuperlativeButton:IconButton;
		private var previousSuperlativeButton:IconButton;
		private var superlativesPortrait:SuperlativesPortrait;
		
		
		
		private var mostDebatedList:DebateList;
		private var mostLikedList:DebateList;
		
		// home
		public var homeButton:BlockButton;		
		
		
		public function StatsOverlay() {
			super();
			init();
		}
		
		
		private function init():void {
			this.graphics.beginFill(0xffffff);
			this.graphics.drawRect(0, 0, 1022, 1626);
			this.graphics.endFill();
			
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
			
			wordCloud.addEventListener(WordCloud.EVENT_WORD_SELECTED, onWordSelected);
			wordCloud.addEventListener(WordCloud.EVENT_WORD_DESELECTED, mostDebatedView);
			
			wordSearchResults = new WordSearchResults();
			wordSearchResults.setDefaultTweenIn(1, {alpha: 1, x:0, y: 702});
			wordSearchResults.setDefaultTweenOut(1, {alpha: 1, x:0, y: BlockBase.OFF_BOTTOM_EDGE});
			wordSearchResults.scrollField.scrollSheet.addEventListener(SearchResult.EVENT_GOTO_DEBATE, onGoToDebate, true);
			wordSearchResults.scrollField.scrollSheet.addEventListener(Comment.EVENT_FLAG, onFlag, true);			
			wordSearchResults.scrollField.scrollSheet.addEventListener(Comment.EVENT_BUTTON_DOWN, onDown, true);
			wordSearchResults.scrollField.scrollSheet.addEventListener(Comment.EVENT_DEBATE, onDown, true);			
			addChild(wordSearchResults);

			closeWordCloudButton = new IconButton(63, 63, 0x000000, '', 0, 0x000000, null, Assets.getCloseButton());
			closeWordCloudButton.buttonMode = true;
			closeWordCloudButton.showBackground(false);
			closeWordCloudButton.setOutlineWeight(0);			
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
			previousSuperlativeButton.setOutlineWeight(0);			
			previousSuperlativeButton.showOutline(false, true);
			previousSuperlativeButton.setDefaultTweenIn(1, {alpha: 1, x:244, y: 626});
			previousSuperlativeButton.setDefaultTweenOut(1, {alpha: 0, x:244, y: 626});
			addChild(previousSuperlativeButton);
			
			nextSuperlativeButton = new IconButton(63, 63, 0x000000, '', 0, 0x000000, null, Assets.getRightArrow());
			nextSuperlativeButton.buttonMode = true;
			nextSuperlativeButton.showBackground(false);			
			nextSuperlativeButton.setOutlineWeight(0);
			nextSuperlativeButton.showOutline(false, true);			
			nextSuperlativeButton.setDefaultTweenIn(1, {alpha: 1, x: 719, y: 626});
			nextSuperlativeButton.setDefaultTweenOut(1, {alpha:0, x: 719, y: 626});
			addChild(nextSuperlativeButton);		
			
			superlativesPortrait = new SuperlativesPortrait();
			superlativesPortrait.setDefaultTweenIn(1, {x: 0, y: 705});
			superlativesPortrait.setDefaultTweenOut(1, {x: BlockBase.OFF_LEFT_EDGE, y: 705});			
			addChild(superlativesPortrait);
			
			mostDebatedList = new DebateList();
			mostDebatedList.setDefaultTweenIn(1, {x: 519, y: 705});
			mostDebatedList.setDefaultTweenOut(1, {x: BlockBase.OFF_RIGHT_EDGE, y: 705});			
			addChild(mostDebatedList);
			
			mostLikedList = new DebateList();
			mostLikedList.setDefaultTweenIn(1, {x: 519, y: 705});
			mostLikedList.setDefaultTweenOut(1, {x: BlockBase.OFF_RIGHT_EDGE, y: 705});			
			addChild(mostLikedList);			
			
			homeButton = new BlockButton(1022, 63, 0x000000, 'BACK TO DEBATE', 34, 0xffffff, Assets.FONT_HEAVY);
			homeButton.setStrokeColor(Assets.COLOR_GRAY_15);
			homeButton.setDefaultTweenIn(0, {x:0, y: 1563});
			homeButton.setDefaultTweenOut(0, {x:0, y: 1563});
			addChild(homeButton);			
			
			
			// start with word frequency
			update();
			mostDebatedView();
			showDebateTotals();
			
			//this.addEventListener(Event.ENTER_FRAME, onFrame);
		}
		
		private function onFrame(e:Event):void {
			//trace(mouseX / 10);
			//voteStatBar.barPercent = mouseX / 10;
		}
		
		public function frequentWordView(...args):void {
			markAllInactive();
			trace("Frequent word view");
						
			// mutate to use current word
			wordSearchResults.updateSearch(wordCloud.activeWord.word);
			
			
			wordCloudResultsTitleBar.setText('\u2018' + wordCloud.activeWord.getText() + '\u2019 used in '  + wordSearchResults.resultCount + Utilities.plural(' Opinion', wordSearchResults.resultCount));
			
			// update based on active word?			
			homeButton.setBackgroundColor(CDW.state.activeThread.firstPost.stanceColorDark, true);
			homeButton.setDownColor(CDW.state.activeThread.firstPost.stanceColorMedium);			
			//wordCloudResultsTitleBar.setText('\u2018' + wordCloud.activeWord.getText() + '\u2019 used in '  + wordSearchResults.resultCount + Utilities.plural(' Opinion', wordSearchResults.resultCount));
			
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
		
		private function onWordSelected(e:Event):void {
			wordCloudResultsTitleBar.setText('');			
				
			if (wordSearchResults.visible) {
				// switching words				
				wordSearchResults.tweenOut(0.5, {onComplete: frequentWordView});
			}
			else {
				// opening for first time
				frequentWordView();
			}
		}
		
		
		private function onGoToDebate(e:Event):void {
			// TODO	
		}
		
		private function onDebate(e:Event):void {
			// TODO
		}
		
		private function onFlag(e:Event):void {
			// TODO			
		}
		
		private function onDown(e:Event):void {
			// TODO			
		}
		
		

		public function mostDebatedView(...args):void {
			markAllInactive();
			
			superlativesTitleBar.setText('Most Debated Opinions');
			homeButton.setBackgroundColor(CDW.state.activeThread.firstPost.stanceColorLight, true);
			homeButton.setDownColor(CDW.state.activeThread.firstPost.stanceColorMedium);			
			wordCloud.deselect();
			
			// set the first item by default
			(mostDebatedList.getChildAt(0) as DebateListItem).activate();
			
						
			
			superlativesPortrait.setPost(CDW.database.mostDebatedThreads[0].firstPost, true);			
			
			previousSuperlativeButton.setOnClick(null);
			nextSuperlativeButton.setOnClick(mostLikedView);
			mostDebatedList.setOnSelected(onMostDebatedSelected);
			
			voteTitleBar.tweenIn();
			voteStatBar.tweenIn();
			wordTitleBar.tweenIn();
			wordCloud.tweenIn();
			superlativesTitleBar.tweenIn();
			
			previousSuperlativeButton.tweenIn(1, {alpha: 0.25});
			nextSuperlativeButton.tweenIn();
			
			superlativesPortrait.tweenIn();
			mostDebatedList.tweenIn();			
			
			homeButton.tweenIn();				
			
			tweenOutInactive();					
		}
		
		private function onMostDebatedSelected(item:DebateListItem):void {
			trace("Selected item " + item.post);
			superlativesPortrait.setPost(item.post);
		}
		
		
		
		// REDO BASED ON MOST DEBATED
		public function mostLikedView(...args):void {
			markAllInactive();
			
			superlativesTitleBar.setText('Most Liked Opinions');
			homeButton.setBackgroundColor(CDW.state.activeThread.firstPost.stanceColorDark, true);
			homeButton.setDownColor(CDW.state.activeThread.firstPost.stanceColorMedium);			
			wordCloud.deselect();
			
			// set the first item by default
			
			//mostLikedList.deactivateAll();
			(mostLikedList.getChildAt(0) as DebateListItem).activate();
			superlativesPortrait.setPost(CDW.database.mostLikedPosts[0], true);			
			
			previousSuperlativeButton.setOnClick(mostDebatedView);
			nextSuperlativeButton.setOnClick(null);
			mostLikedList.setOnSelected(onMostLikedSelected);
			
			voteTitleBar.tweenIn();
			voteStatBar.tweenIn();
			wordTitleBar.tweenIn();
			wordCloud.tweenIn();
			superlativesTitleBar.tweenIn();
			
			previousSuperlativeButton.tweenIn();
			nextSuperlativeButton.tweenIn(1, {alpha: 0.25});		
			
			
			superlativesPortrait.tweenIn();
			mostLikedList.tweenIn();			
			
			homeButton.tweenIn();				
			
			tweenOutInactive();					
		}
		
		private function onMostLikedSelected(item:DebateListItem):void {
			trace("Selected item " + item.post);
			superlativesPortrait.setPost(item.post);
		}

//		// REDO BASED ON MOST DEBATED		
//		public function mostActiveUsersView(...args):void {
//			markAllInactive();
//
//			superlativesTitleBar.setText('Most Active Users');
//			homeButton.setBackgroundColor(CDW.state.activeStanceColorDark, true);
//			homeButton.setDownColor(CDW.state.activeStanceColorMedium);			
//			
//			previousSuperlativeButton.setOnClick(mostLikedView);
//			nextSuperlativeButton.setOnClick(null);			
//			
//			voteTitleBar.tweenIn();
//			voteStatBar.tweenIn();
//						
//			wordTitleBar.tweenIn();
//			wordCloud.tweenIn();
//			superlativesTitleBar.tweenIn();
//			
//			previousSuperlativeButton.tweenIn();
//			nextSuperlativeButton.tweenIn(1, {alpha: 0.25});		
//		
//			superlativesPortrait.tweenIn();
//			mostDebatedList.tweenIn();
//			homeButton.tweenIn();				
//			
//			tweenOutInactive();					
//		}				
		
		
		// default bar behavior, just this one for now
		public function showDebateTotals(...args):void {			
			// behaviors			
			
			// mutation
			voteTitleBar.setText('Total Number of Opinions');			
			var yesCount:uint = CDW.database.stanceTotals['yes'];
			var noCount:uint = CDW.database.stanceTotals['no'];			
			var targetPercent:Number = (yesCount / (noCount + yesCount)) * 100;
			
			// tween in
			voteStatBar.setLabels(yesCount, noCount);
			TweenMax.to(voteStatBar, 1, {barPercent: targetPercent, ease: Quart.easeInOut});
		}
		
		public function update():void {
			// anything to do here?
			trace("Updating stats");
			wordCloud.setWords(CDW.database.frequentWords);
			
			// pull out the first posts so we're working with posts instead of threads
			var mostDebatedFirstPosts:Array = [];
			for (var i:uint = 0; i < CDW.database.mostDebatedThreads.length; i++) {
				mostDebatedFirstPosts.push(CDW.database.mostDebatedThreads[i].firstPost);
			}
			
			
			mostDebatedList.setItems(mostDebatedFirstPosts);
			trace("most liked: " + CDW.database.mostLikedPosts);
			mostLikedList.setItems(CDW.database.mostLikedPosts);
		}		
		
		// Utiliteis and helpers
		private function generateDot(c:uint):Shape {
			var shape:Shape = new Shape();
			shape.graphics.beginFill(c);
			shape.graphics.drawCircle(0, 0, 3.6);
			shape.graphics.endFill();
			return shape;
		}		
		
		
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
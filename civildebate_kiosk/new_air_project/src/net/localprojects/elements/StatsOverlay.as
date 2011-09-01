package net.localprojects.elements {
	import com.greensock.TweenMax;
	import com.greensock.easing.*;
	
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
		private var previousVoteStatButton:IconButton;
		private var nextVoteStatButton:IconButton;		
		private var voteStatBar:VoteStatBar;
		
		private var wordTitleBar:BlockLabelBar;
		private var wordCloud:WordCloud;
		
		public function StatsOverlay() {
			super();
			init();
		}
		
		private function init():void {
			this.graphics.beginFill(0xffffff);
			this.graphics.drawRect(0, 0, 1022, 1626);
			this.graphics.endFill();
			
			
			// no animation for this at the moment
			// TODO put it in the parent block instead?
			homeButton = new BlockButton(1022, 63, Assets.COLOR_YES_MEDIUM, 'BACK TO DEBATE', 20);
			homeButton.setDefaultTweenIn(0, {x:0, y: 1563});
			homeButton.setDefaultTweenOut(0, {x:0, y: 1563});
			addChild(homeButton);			
			
			
			// Voting bar
			voteTitleBar = new BlockLabelBar("Total Number of Votes", 26, 0xffffff, 1022, 63, 0x000000, Assets.FONT_BOLD);
			voteTitleBar.setDefaultTweenIn(0, {x:0, y: 0});
			voteTitleBar.setDefaultTweenOut(0, {x:0, y: 0});
			addChild(voteTitleBar);
			
			previousVoteStatButton = new IconButton(63, 63, 0x000000, '', 0, 0x000000, null, Assets.getLeftArrow());
			previousVoteStatButton.buttonMode = true;
			previousVoteStatButton.showBackground(false);
			previousVoteStatButton.setStrokeWeight(0);			
			previousVoteStatButton.showOutline(false, true);
			previousVoteStatButton.setDefaultTweenIn(1, {alpha: 1, x:259, y: 3});
			previousVoteStatButton.setDefaultTweenOut(1, {alpha: 0.25, x:259, y: 3});
			addChild(previousVoteStatButton);
			
			nextVoteStatButton = new IconButton(63, 63, 0x000000, '', 0, 0x000000, null, Assets.getRightArrow());
			nextVoteStatButton.buttonMode = true;
			nextVoteStatButton.showBackground(false);			
			nextVoteStatButton.setStrokeWeight(0);
			nextVoteStatButton.showOutline(false, true);			
			nextVoteStatButton.setDefaultTweenIn(1, {alpha: 1, x: 734, y: 3});
			nextVoteStatButton.setDefaultTweenOut(1, {alpha: 0.25, x: 734, y: 3});
			addChild(nextVoteStatButton);						
			
			voteStatBar = new VoteStatBar();
			voteStatBar.setDefaultTweenIn(1, {x: 0, y: 78});
			voteStatBar.setDefaultTweenOut(1, {x: 0, y: 78});
			addChild(voteStatBar);
			
			
			// Word Frequency
			wordTitleBar = new BlockLabelBar('Most Frequently Used Words', 26, 0xffffff, 1022, 63, 0x000000, Assets.FONT_BOLD);
			wordTitleBar.setDefaultTweenIn(0, {x:0, y: 234});
			wordTitleBar.setDefaultTweenOut(0, {x:0, y: 234});
			addChild(wordTitleBar);			
			
			wordCloud = new WordCloud();
			wordCloud.setDefaultTweenIn(0, {x:0, y: 312});
			wordCloud.setDefaultTweenOut(0, {x:0, y: 312});
			addChild(wordCloud);						
			
			
			// start with word frequency
			update();
			frequentWordView();
			
			showLikeTotals();
			
			this.addEventListener(Event.ENTER_FRAME, onFrame);
		}
		
		private function onFrame(e:Event):void {
			//trace(mouseX / 10);
			//voteStatBar.barPercent = mouseX / 10;
		}
		
		public function frequentWordView(...args):void {
			trace("Frequent word view");
			// TODO mark as doomed
			

			voteTitleBar.tweenIn();
			voteStatBar.tweenIn();
			previousVoteStatButton.tweenIn();			
			nextVoteStatButton.tweenIn();
			wordTitleBar.tweenIn();
			wordCloud.tweenIn();			
			homeButton.tweenIn();			
			
			
			// TODO tween out unwanted
		}
		


		// like overlays
		public function showLikeTotals(...args):void {			
			// behaviors
			previousVoteStatButton.setOnClick(null);
			previousVoteStatButton.tween(1, {alpha: 0.25});			
			
			nextVoteStatButton.setOnClick(showDebateTotals);
			nextVoteStatButton.tweenIn();						
			
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
			// behaviors
			previousVoteStatButton.setOnClick(showLikeTotals);
			previousVoteStatButton.tweenIn();			
			
			nextVoteStatButton.setOnClick(null);
			nextVoteStatButton.tween(1, {alpha: 0.25});			
			
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
		
		
	}
}
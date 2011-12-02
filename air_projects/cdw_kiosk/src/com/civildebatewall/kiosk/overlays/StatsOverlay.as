package com.civildebatewall.kiosk.overlays {
	
	import com.civildebatewall.Assets;
	import com.civildebatewall.CivilDebateWall;
	import com.civildebatewall.data.Word;
	import com.civildebatewall.kiosk.elements.DebateList;
	import com.civildebatewall.kiosk.elements.StatsTitleBar;
	import com.civildebatewall.kiosk.elements.StatsTitleBarSelector;
	import com.civildebatewall.kiosk.elements.SuperlativesPortrait;
	import com.civildebatewall.kiosk.elements.VoteStatBar;
	import com.civildebatewall.kiosk.elements.WordCloud;
	import com.civildebatewall.kiosk.elements.WordSearchResults;
	import com.demonsters.debugger.MonsterDebugger;
	import com.greensock.TweenMax;
	import com.greensock.easing.Quart;
	import com.kitschpatrol.futil.blocks.BlockBase;
	import com.kitschpatrol.futil.blocks.BlockShape;
	import com.kitschpatrol.futil.constants.Alignment;
	import com.kitschpatrol.futil.constants.Char;
	import com.kitschpatrol.futil.utilitites.StringUtil;
	
	import flash.events.Event;
	
	public class StatsOverlay extends BlockBase	{
		
		private var graphTitle:StatsTitleBar;		
		private var voteStatBar:VoteStatBar;	
		private var wordCloudTitle:StatsTitleBar;		
		private var wordCloud:WordCloud;
		private var searchResultsTitle:StatsTitleBar;
		private var superlativesTitle:StatsTitleBarSelector;
		public var superlativesPortrait:SuperlativesPortrait;
		private var debateList:DebateList;		
		private var filler:BlockShape;
		private var searchResults:WordSearchResults;
		
		
		public function StatsOverlay(params:Object=null) {
			
			super(params);
			
			width = 1080;
			height = 1920;
			backgroundColor = 0xffffff;

			// votes
			graphTitle = new StatsTitleBar();
			graphTitle.text = "Number of Opinions";
			graphTitle.x = 29;
			graphTitle.visible = true;
			addChild(graphTitle);
			
			voteStatBar = new VoteStatBar();
			voteStatBar.x = 29;
			voteStatBar.y = 78;
			voteStatBar.visible = true;
			addChild(voteStatBar);
						
			
			// Word cloud
			wordCloudTitle = new StatsTitleBar();
			wordCloudTitle.text = "Most Frequently Used Words";
			wordCloudTitle.x = 29;
			wordCloudTitle.y = 234;
			wordCloudTitle.visible = true;
			addChild(wordCloudTitle);
			
			wordCloud = new WordCloud();
			wordCloud.x = 29;
			wordCloud.y = 312;
			wordCloud.visible = true;
			addChild(wordCloud);						
			
			wordCloud.addEventListener(WordCloud.EVENT_WORD_SELECTED, onWordSelected);
			wordCloud.addEventListener(WordCloud.EVENT_WORD_DESELECTED, onWordDeselected);
			
			searchResultsTitle = new StatsTitleBar(); // text set later
			searchResultsTitle.backgroundColor = Assets.COLOR_GRAY_20;
			searchResultsTitle.visible = true;
			searchResultsTitle.x = 29;
			searchResultsTitle.y = 625;
			searchResultsTitle.leftDot.visible = false;
			searchResultsTitle.rightDot.visible = false;
			searchResultsTitle.textColor = Assets.COLOR_GRAY_75;
			addChild(searchResultsTitle);
			
			searchResults = new WordSearchResults();
			searchResults.setDefaultTweenIn(0.75, {x: 29, y: 703});
			searchResults.setDefaultTweenOut(0.75, {x: 29, y: Alignment.OFF_STAGE_BOTTOM});
			addChild(searchResults);
			
			
			superlativesTitle = new StatsTitleBarSelector();
			superlativesTitle.x = 29;
			superlativesTitle.y = 625;
			addChild(superlativesTitle);

			//CivilDebateWall.data.addEventListener(Data.DATA_UPDATE_EVENT, onDataChange);
			superlativesPortrait = new SuperlativesPortrait();
			superlativesPortrait.setDefaultTweenIn(.5, {x: 29, y: 703, ease: Quart.easeInOut});
			superlativesPortrait.setDefaultTweenOut(.5, {x: Alignment.OFF_STAGE_LEFT, y: 703, ease: Quart.easeInOut});
			addChild(superlativesPortrait);
			
			debateList = new DebateList();
			debateList.setDefaultTweenIn(.5, {x: 546, y: 703, ease: Quart.easeInOut});
			debateList.setDefaultTweenOut(.5, {x: Alignment.OFF_STAGE_RIGHT, y: 703, ease: Quart.easeInOut});
			addChild(debateList);


			filler = new BlockShape();
			filler.x = 29;
			filler.y = 234;
			filler.width = 1022;
			filler.height = 0;
			filler.backgroundColor = Assets.COLOR_GRAY_5;
			addChild(filler);
			
			// todo create intro sequence?
			searchResults.tweenOut();
			superlativesPortrait.tweenIn();
			debateList.tweenIn();			
			// opinions results is just overlay
			
			// show search results if they change...
			
			
		}
		
		private var menuLowerDistance:Number = 924; // string makes it relative
		private var duration:Number = 0.6;
		
		
		// TODO not relative!
		public function lowerMenu():void {
			TweenMax.to(filler, duration, {height:  924, ease: Quart.easeInOut});

			TweenMax.to(wordCloudTitle, duration, {y: 234 + menuLowerDistance, ease: Quart.easeInOut});			
			TweenMax.to(wordCloud, duration, {y: 312 + menuLowerDistance, ease: Quart.easeInOut});
			TweenMax.to(searchResultsTitle, duration, {y: 625 + menuLowerDistance, alpha: 0, ease: Quart.easeInOut});
			TweenMax.to(superlativesTitle, duration, {y: 625 + menuLowerDistance, alpha: 0, ease: Quart.easeInOut});
			TweenMax.to(superlativesPortrait, duration, {y: 703 + menuLowerDistance, alpha: 0, ease: Quart.easeInOut});
			TweenMax.to(debateList, duration, {y: 703 + menuLowerDistance, alpha: 0, ease: Quart.easeInOut});
			TweenMax.to(searchResults, duration, {y: 703 + menuLowerDistance, alpha: 0, ease: Quart.easeInOut});
		}
		
		public function raiseMenu():void {
			TweenMax.to(filler, duration, {height:  0, ease: Quart.easeInOut});			
			TweenMax.to(wordCloudTitle, duration, {y: 234, alpha: 1, ease: Quart.easeInOut});			
			TweenMax.to(wordCloud, duration, {y: 312, alpha: 1, ease: Quart.easeInOut});
			TweenMax.to(searchResultsTitle, duration, {y: 625, alpha: 1, ease: Quart.easeInOut});
			
			// only fade the superlative title back in if we don't have an active word
			if (wordCloud.activeWord == null) {	
				TweenMax.to(superlativesTitle, duration, {alpha: 1, ease: Quart.easeInOut});
			}
			TweenMax.to(superlativesTitle, duration, {y: 625, ease: Quart.easeInOut});			
			
			TweenMax.to(superlativesPortrait, duration, {y: 703, alpha: 1, ease: Quart.easeInOut});
			TweenMax.to(debateList, duration, {y: 703, alpha: 1, ease: Quart.easeInOut});	
			TweenMax.to(searchResults, duration, {y: 703, alpha: 1, ease: Quart.easeInOut});	
		}
		
		
		private function onWordSelected(e:Event):void {
			MonsterDebugger.trace(null, "word selected");
			raiseMenu();			
			
			var word:Word = wordCloud.activeWord.word;
			searchResults.setWord(word);
			
			
			CivilDebateWall.state.setHighlightWord(word.theWord, wordCloud.activeWord.backgroundColor);
			
			TweenMax.to(searchResultsTitle, 0.5, {text: Char.LEFT_SINGLE_QUOTE + StringUtil.capitalize(word.theWord) + Char.RIGHT_SINGLE_QUOTE + " used in " + word.posts.length + " " + StringUtil.plural("Opinion", word.posts.length)});
			TweenMax.to(superlativesTitle, 0.5, {alpha: 0});
			debateList.tweenOut();
			superlativesPortrait.tweenOut();
			searchResults.tweenIn();
		}
		
		private function onWordDeselected(e:Event):void {
			wordCloud.activeWord = null;
			
			CivilDebateWall.state.setHighlightWord(null);			
			
			TweenMax.to(superlativesTitle, 0.5, {alpha: 1});
			debateList.tweenIn();
			superlativesPortrait.tweenIn();
			searchResults.tweenOut();
		}		
		
		
		
		
		
		
		
//		private function mostDebatedView():void {
//			// portrait
//			
//			// list
//			debatedSuperlativesPortrait.tweenIn();
//
//		}
//		
//		private function mostLikedView():void {
//			
//
//		}
//		
//		private function searchResultsView():void {
//			
//			
//			
//		}
//		
		
			
		
		
		
		
		
		
	}
}
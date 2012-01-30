/*--------------------------------------------------------------------
Civil Debate Wall Kiosk
Copyright (c) 2012 Local Projects. All rights reserved.

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU Affero General Public License as
published by the Free Software Foundation, either version 3 of the
License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU Affero General Public License for more details.

You should have received a copy of the GNU Affero General Public
License along with this program. 

If not, see <http://www.gnu.org/licenses/>.
--------------------------------------------------------------------*/

package com.civildebatewall.kiosk.overlays {
	
	import com.civildebatewall.Assets;
	import com.civildebatewall.CivilDebateWall;
	import com.civildebatewall.State;
	import com.civildebatewall.data.Word;
	import com.civildebatewall.kiosk.buttons.WordButton;
	import com.civildebatewall.kiosk.elements.ClearTagButton;
	import com.civildebatewall.kiosk.elements.DebateList;
	import com.civildebatewall.kiosk.elements.StatsTitleBar;
	import com.civildebatewall.kiosk.elements.StatsTitleBarSelector;
	import com.civildebatewall.kiosk.elements.SuperlativesPortrait;
	import com.civildebatewall.kiosk.elements.VoteBarGraph;
	import com.civildebatewall.kiosk.elements.WordCloud;
	import com.civildebatewall.kiosk.elements.WordCloudTitleBar;
	import com.civildebatewall.kiosk.elements.WordSearchResults;
	import com.greensock.TweenMax;
	import com.greensock.easing.Quart;
	import com.kitschpatrol.futil.blocks.BlockBase;
	import com.kitschpatrol.futil.blocks.BlockShape;
	import com.kitschpatrol.futil.constants.Alignment;
	import com.kitschpatrol.futil.constants.Char;
	import com.kitschpatrol.futil.utilitites.StringUtil;
	
	import flash.events.Event;
	
	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.getLogger;
	
	public class StatsOverlay extends BlockBase	{
		
		private static const logger:ILogger = getLogger(StatsOverlay);
		
		private var graphTitle:StatsTitleBar;		
		private var voteBarGraph:VoteBarGraph;	
		private var wordCloudTitle:WordCloudTitleBar;		
		private var wordCloud:WordCloud;
		private var searchResultsTitle:StatsTitleBar;
		private var superlativesTitle:StatsTitleBarSelector;
		public var superlativesPortrait:SuperlativesPortrait;
		private var debateList:DebateList;		
		private var filler:BlockShape;
		private var searchResults:WordSearchResults;
		private var menuLowerDistance:Number = 924;
		private var duration:Number = 0.6;		
		
		public function StatsOverlay(params:Object = null) {
			
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
			
			voteBarGraph = new VoteBarGraph();
			voteBarGraph.x = 29;
			voteBarGraph.y = 78;
			voteBarGraph.visible = true;
			addChild(voteBarGraph);
						
			// Word cloud
			wordCloudTitle = new WordCloudTitleBar();
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
			wordCloudTitle.clearTagButton.addEventListener(ClearTagButton.CLEAR_TAG_EVENT, onClearTag);
			
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
			searchResults.setDefaultTweenIn(0.75, {alpha: 1, x: 29, y: 703});
			searchResults.setDefaultTweenOut(0.75, {alpha: 0, x: 29, y: Alignment.OFF_STAGE_BOTTOM});
			addChild(searchResults);
			
			superlativesTitle = new StatsTitleBarSelector();
			superlativesTitle.x = 29;
			superlativesTitle.y = 625;
			addChild(superlativesTitle);

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
		}
		
		// TODO not relative!
		public function lowerMenu(instant:Boolean = false):void {
			var localDuration:Number = instant ? 0 : duration;
			
			TweenMax.to(filler, localDuration, {height:  924, ease: Quart.easeInOut});

			TweenMax.to(wordCloudTitle, localDuration, {y: 234 + menuLowerDistance, ease: Quart.easeInOut});			
			TweenMax.to(wordCloud, localDuration, {y: 312 + menuLowerDistance, ease: Quart.easeInOut});
			TweenMax.to(searchResultsTitle, localDuration, {y: 625 + menuLowerDistance, alpha: 0, ease: Quart.easeInOut});
			TweenMax.to(superlativesTitle, localDuration, {y: 625 + menuLowerDistance, alpha: 0, ease: Quart.easeInOut});
			TweenMax.to(superlativesPortrait, localDuration, {y: 703 + menuLowerDistance, alpha: 0, ease: Quart.easeInOut});
			TweenMax.to(debateList, localDuration, {y: 703 + menuLowerDistance, alpha: 0, ease: Quart.easeInOut});
			TweenMax.to(searchResults, localDuration, {y: 703 + menuLowerDistance, alpha: 0, ease: Quart.easeInOut});
		}
		
		public function raiseMenu(instant:Boolean = false):void {
			var localDuration:Number = instant ? 0 : duration;
			
			TweenMax.to(filler, localDuration, {height:  0, ease: Quart.easeInOut});			
			TweenMax.to(wordCloudTitle, localDuration, {y: 234, alpha: 1, ease: Quart.easeInOut});			
			TweenMax.to(wordCloud, localDuration, {y: 312, alpha: 1, ease: Quart.easeInOut});
			TweenMax.to(searchResultsTitle, localDuration, {y: 625, alpha: 1, ease: Quart.easeInOut});
			
			// only fade the superlative title back in if we don't have an active word
			if (wordCloud.activeWord == null) {	
				TweenMax.to(superlativesTitle, localDuration, {alpha: 1, ease: Quart.easeInOut});
			}
			TweenMax.to(superlativesTitle, localDuration, {y: 625, ease: Quart.easeInOut});			
			
			TweenMax.to(superlativesPortrait, localDuration, {y: 703, alpha: 1, ease: Quart.easeInOut});
			TweenMax.to(debateList, localDuration, {y: 703, alpha: 1, ease: Quart.easeInOut});	
			TweenMax.to(searchResults, localDuration, {y: 703, alpha: 1, ease: Quart.easeInOut});	
		}
		
		private function onWordSelected(e:Event):void {
			raiseMenuThroughButton();

			var wordButton:WordButton = wordCloud.activeWord; 
			var word:Word = wordButton.word;
			
			searchResults.setWord(word);

			// Clamp to extreme color instead of using gradient from word.backgroundColor, which has contrast issues
			var highlightColor:uint =  wordButton.normalDifference < 0.5 ? Assets.COLOR_NO_HIGHLIGHT : Assets.COLOR_YES_HIGHLIGHT; 
			
			CivilDebateWall.state.setHighlightWord(word.theWord, highlightColor);
			
			TweenMax.to(searchResultsTitle, 0.5, {text: Char.LEFT_SINGLE_QUOTE + StringUtil.capitalize(word.theWord) + Char.RIGHT_SINGLE_QUOTE + " used in " + word.posts.length + " " + StringUtil.plural("Opinion", word.posts.length)});
			TweenMax.to(superlativesTitle, 0.5, {alpha: 0});
			debateList.tweenOut();
			superlativesPortrait.tweenOut();
			wordCloudTitle.clearTagButton.tweenIn();			
		}
		
		private function onClearTag(e:Event):void {
			wordCloud.deselect();
			onWordDeselected(e);
		}
		
		override protected function beforeTweenIn():void {
			
			// reset if we're coming from home
			if (CivilDebateWall.state.lastView == CivilDebateWall.kiosk.homeView) {
				wordCloud.deselect();
				onWordDeselected(new Event(ClearTagButton.CLEAR_TAG_EVENT), true); // closes cloud
				wordCloudTitle.clearTagButton.tweenOut(0); // start off screen
				
				// reset the superlatives
				CivilDebateWall.state.setStatsView(State.VIEW_MOST_DEBATED);
				CivilDebateWall.state.setSuperlativePost(CivilDebateWall.data.stats.mostDebatedThreads[0].firstPost);
			}
			
			super.beforeTweenIn();
		}
		
		private function raiseMenuThroughButton(instant:Boolean = false):void {
			if (CivilDebateWall.kiosk.lowerMenuButton.lowered) {
				CivilDebateWall.kiosk.lowerMenuButton.toggle(instant);				
			}
		}

		private function onWordDeselected(e:Event, instant:Boolean = false):void {
			wordCloud.activeWord = null;			
			CivilDebateWall.state.setHighlightWord(null);			
			
			raiseMenuThroughButton(instant);
			superlativesTitle.tween(instant ? 0 : 0.5, {alpha: 1});
			debateList.tweenIn(instant ? 0 : -1);
			superlativesPortrait.tweenIn(instant ? 0 : -1);
			searchResults.tweenOut(instant ? 0 : -1);
			wordCloudTitle.clearTagButton.tweenOut(instant ? 0 : -1);
		}		

	}
}

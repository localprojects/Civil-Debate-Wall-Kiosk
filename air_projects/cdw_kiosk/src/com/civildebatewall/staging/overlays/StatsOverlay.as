package com.civildebatewall.staging.overlays {
	import com.civildebatewall.Assets;
	import com.civildebatewall.CivilDebateWall;
	import com.civildebatewall.State;
	import com.civildebatewall.kiosk.elements.DebateList;
	import com.civildebatewall.kiosk.elements.VoteStatBar;
	import com.civildebatewall.kiosk.elements.WordCloud;
	import com.civildebatewall.staging.StatsTitleBarSelector;
	import com.civildebatewall.staging.SuperlativesPortrait;
	import com.civildebatewall.staging.elements.StatsTitleBar;
	import com.greensock.TweenMax;
	import com.greensock.easing.Quart;
	import com.kitschpatrol.futil.blocks.BlockBase;
	import com.kitschpatrol.futil.blocks.BlockShape;
	import com.kitschpatrol.futil.constants.Alignment;
	import com.kitschpatrol.futil.utilitites.GraphicsUtil;
	
	public class StatsOverlay extends BlockBase	{
		
		private var graphTitle:StatsTitleBar;		
		private var voteStatBar:VoteStatBar;	
		private var wordCloudTitle:StatsTitleBar;		
		private var wordCloud:WordCloud;
		private var searchResultsTitle:StatsTitleBar;
		private var superlativesTitle:StatsTitleBarSelector;
		private var superlativesPortrait:SuperlativesPortrait;
		private var debateList:DebateList;		
		private var filler:BlockShape;
		
		

		
		
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
			
			searchResultsTitle = new StatsTitleBar(); // text set later
			searchResultsTitle.backgroundColor = Assets.COLOR_GRAY_20;
			searchResultsTitle.visible = true;
			searchResultsTitle.x = 29;
			searchResultsTitle.y = 625;
			searchResultsTitle.leftDot.visible = false;
			searchResultsTitle.rightDot.visible = false;	
			addChild(searchResultsTitle);
			
			superlativesTitle = new StatsTitleBarSelector();
			superlativesTitle.x = 29;
			superlativesTitle.y = 625;
			addChild(superlativesTitle);

			//CivilDebateWall.data.addEventListener(Data.DATA_UPDATE_EVENT, onDataChange);
			superlativesPortrait = new SuperlativesPortrait();
			superlativesPortrait.setDefaultTweenIn(1, {x: 29, y: 703, ease: Quart.easeInOut});
			superlativesPortrait.setDefaultTweenOut(1, {x: Alignment.OFF_STAGE_LEFT, y: 703, ease: Quart.easeInOut});
			addChild(superlativesPortrait);
			
			debateList = new DebateList();
			debateList.setDefaultTweenIn(1, {x: 546, y: 703, ease: Quart.easeInOut});
			debateList.setDefaultTweenOut(1, {x: Alignment.OFF_STAGE_RIGHT, y: 703, ease: Quart.easeInOut});
			addChild(debateList);


			filler = new BlockShape();
			filler.x = 29;
			filler.y = 234;
			filler.width = 1022;
			filler.height = 0;
			filler.backgroundColor = Assets.COLOR_GRAY_5;
			addChild(filler);
			
			// todo create intro sequence?
			superlativesPortrait.tweenIn();
			debateList.tweenIn();			
			// opinions results is just overlay
			
			// show search results if they change...
			
			
		}
		
		private var menuLowerDistance:String = "924"; // string makes it relative
		private var duration:Number = 0.6;
		
		
		public function lowerMenu():void {
			TweenMax.to(filler, duration, {height:  924, ease: Quart.easeInOut});
			TweenMax.to(wordCloudTitle, duration, {y: menuLowerDistance, ease: Quart.easeInOut});			
			TweenMax.to(wordCloud, duration, {y: menuLowerDistance, ease: Quart.easeInOut});
			TweenMax.to(searchResultsTitle, duration, {y: menuLowerDistance, alpha: 0, ease: Quart.easeInOut});			
			TweenMax.to(superlativesTitle, duration, {y: menuLowerDistance, alpha: 0, ease: Quart.easeInOut});
			TweenMax.to(superlativesPortrait, duration, {y: menuLowerDistance, alpha: 0, ease: Quart.easeInOut});
			TweenMax.to(debateList, duration, {y: menuLowerDistance, alpha: 0, ease: Quart.easeInOut});
			
						
			
		}
		
		public function raiseMenu():void {
			TweenMax.to(filler, duration, {height:  0, ease: Quart.easeInOut});			
			TweenMax.to(wordCloudTitle, duration, {y: "-" + menuLowerDistance, alpha: 1, ease: Quart.easeInOut});			
			TweenMax.to(wordCloud, duration, {y: "-" + menuLowerDistance, alpha: 1, ease: Quart.easeInOut});
			TweenMax.to(searchResultsTitle, duration, {y: "-" + menuLowerDistance, alpha: 1, ease: Quart.easeInOut});	
			TweenMax.to(superlativesTitle, duration, {y: "-" + menuLowerDistance, alpha: 1, ease: Quart.easeInOut});
			TweenMax.to(superlativesPortrait, duration, {y: "-" + menuLowerDistance, alpha: 1, ease: Quart.easeInOut});
			TweenMax.to(debateList, duration, {y: "-" + menuLowerDistance, alpha: 1, ease: Quart.easeInOut});	
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
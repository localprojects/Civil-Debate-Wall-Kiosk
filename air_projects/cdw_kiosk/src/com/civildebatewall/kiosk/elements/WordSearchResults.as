package com.civildebatewall.kiosk.elements {
	import com.civildebatewall.data.Word;
	import com.civildebatewall.kiosk.BlockInertialScroll;
	import com.greensock.TweenMax;
	import com.kitschpatrol.futil.blocks.BlockBase;
	import com.kitschpatrol.futil.utilitites.GraphicsUtil;
	
	import flash.display.*;
	import flash.events.*;
	
	public class WordSearchResults extends BlockInertialScroll {
		
		public var resultCount:int;		
		public var word:Word;
		
		public function WordSearchResults()	{
			super({
				backgroundColor: 0x000000,
				showBackground: false,
				width: 1022,
				height: 846,
				maxSizeBehavior: BlockBase.MAX_SIZE_CLIPS,
				scrollLimitMode: BlockBase.SCROLL_LIMIT_AUTO,
				scrollAxis: BlockInertialScroll.SCROLL_Y
			});
		}
		
		public function setWord(word:Word):void {
			this.word = word;			
			
			// TODO scroll instead?
			TweenMax.to(this, .3, {alpha: 0, onComplete: onFadeOut});
		}
		
		public function onFadeOut():void {
			GraphicsUtil.removeChildren(content);			
			resultCount = word.posts.length;
			
			var paddingBottom:Number = 14;
			var yOffset:Number = 0;

			for (var i:int = 0; i < word.posts.length; i++) {
				// create object and add it to the scroll field
				var searchResult:SearchResult = new SearchResult(word.posts[i], i + 1);
				
				
				
				searchResult.x = 0;
				searchResult.y = yOffset;
				searchResult.visible = true;
				
				yOffset += searchResult.height + paddingBottom;
				addChild(searchResult);	
			}
			
			
			
			TweenMax.to(this, 0.3, {alpha: 1});			
		}
		
//		private function onDown(e:Event):void {
//			targetSearchResult = e.target as SearchResult;
//		}
//		
//				
//		private function onDebate(e:Event):void {
//			targetButton = e.currentTarget as ButtonBase;
//			targetSearchResult = e.target as SearchResult;			
//			
//			if (scrollField.isClick) {
//				MonsterDebugger.trace(this, "Debate with post: " + targetSearchResult.post);
//				CivilDebateWall.state.userIsDebating = true;
//				CivilDebateWall.state.userRespondingTo = targetSearchResult.post;				
//		//		CivilDebateWall.kiosk.view.pickStanceView();
//			}
//			else {
//				MonsterDebugger.trace(this, 'Not a real click.');
//			}
//		}
//		
//		
//		private function onFlag(e:Event):void {
//			targetButton = e.currentTarget as ButtonBase;
//			targetSearchResult = e.target as SearchResult;			
//			
//			if (scrollField.isClick) {
//				MonsterDebugger.trace(this, "Flag post: " + targetSearchResult.post);
//				// pull in the flag overlay
//				CivilDebateWall.state.activePost = targetSearchResult.post;
//				CivilDebateWall.kiosk.view.flagOverlayView();
//			}
//			else {
//				MonsterDebugger.trace(this, 'Not a real click.');
//			}
//		}		
//		
//		private function onGoToDebate(e:Event):void {			
//			targetSearchResult = e.target as SearchResult;
//
//			CivilDebateWall.state.highlightWord =  targetSearchResult._highlight;
//			CivilDebateWall.state.setActiveThread(targetSearchResult.post.thread);
//			CivilDebateWall.state.activePost = targetSearchResult.post;
//			
//			if (targetSearchResult.post.isThreadStarter) {
//				// it's an original
//				CivilDebateWall.kiosk.view.homeView();
//			}
//			else {
//				// it's a response
//				CivilDebateWall.kiosk.view.threadView();
//			}
//		}
		
		
	}
}
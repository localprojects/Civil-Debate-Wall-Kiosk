package com.civildebatewall.kiosk.elements {
	
	import com.civildebatewall.data.Word;
	import com.civildebatewall.kiosk.BlockInertialScroll;
	import com.kitschpatrol.futil.blocks.BlockBase;
	import com.kitschpatrol.futil.utilitites.GraphicsUtil;
	
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
			
			// tween out instantly if we're just coming into the view
			var duration:Number = (this.y == defaultTweenInVars.y) ? 0.5 : 0
			tweenOut(duration, {onComplete: onScrollOut});
		}
		
		public function onScrollOut():void {
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

			tweenIn(0.5);
			scrollY = 0;
		}
		
	}
}
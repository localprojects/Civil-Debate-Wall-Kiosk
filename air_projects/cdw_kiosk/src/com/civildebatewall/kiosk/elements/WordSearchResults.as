package com.civildebatewall.kiosk.elements {
	import com.civildebatewall.Assets;
	import com.civildebatewall.CivilDebateWall;
	import com.civildebatewall.OrderedObject;
	import com.civildebatewall.Utilities;
	import com.civildebatewall.data.Post;
	import com.civildebatewall.data.Word;
	import com.civildebatewall.kiosk.Kiosk;
	import com.civildebatewall.kiosk.blocks.BlockBase;
	import com.civildebatewall.kiosk.ui.ButtonBase;
	import com.civildebatewall.kiosk.ui.InertialScrollField;
	import com.civildebatewall.kiosk.ui.WordButton;
	import com.kitschpatrol.futil.utilitites.GraphicsUtil;
	
	import flash.display.*;
	import flash.events.*;
	
	public class WordSearchResults extends BlockBase {
		
		public var scrollField:InertialScrollField;		
		public var resultCount:uint;		
		
		private var targetSearchResult:SearchResult;
		private var targetButton:ButtonBase;
		public var word:Word;
		
		public function WordSearchResults()	{
			super();
			scrollField = new InertialScrollField(1022, 843);
			addChild(scrollField);
			
			scrollField.scrollSheet.addEventListener(Comment.EVENT_DEBATE, onDebate, true);
			scrollField.scrollSheet.addEventListener(Comment.EVENT_FLAG, onFlag, true);			
			scrollField.scrollSheet.addEventListener(Comment.EVENT_BUTTON_DOWN, onDown, true);
			scrollField.scrollSheet.addEventListener(SearchResult.EVENT_GOTO_DEBATE, onGoToDebate, true);
		}
		
		
		public function updateSearch(_word:Word):void {
			word = _word;
			GraphicsUtil.removeChildren(scrollField.scrollSheet);
			scrollField.scrollSheet.y = 0;
			resultCount = word.posts.length;
			
			var paddingBottom:Number = 15;
			var yOffset:Number = 0;

			for (var i:uint = 0; i < word.posts.length; i++) {
				var post:Post = word.posts[i];
						
				// create object and add it to the scroll field
				var resultRow:SearchResult = new SearchResult(post, i + 1, word.word);
				
				resultRow.x = 0;
				resultRow.y = yOffset;
				resultRow.visible = true;
				
				yOffset += resultRow.height + paddingBottom;
				scrollField.scrollSheet.addChild(resultRow);	
			}
			
			// set scroll bounds
			scrollField.yMax = 0;			
			scrollField.yMin = -scrollField.scrollSheet.height + 843;
			
			// do we need to scroll?
			scrollField.scrollAllowed = (scrollField.scrollSheet.height > 843);			
		}
		
		private function onDown(e:Event):void {
			targetSearchResult = e.target as SearchResult;
		}
		
				
		private function onDebate(e:Event):void {
			targetButton = e.currentTarget as ButtonBase;
			targetSearchResult = e.target as SearchResult;			
			
			if (scrollField.isClick) {
				trace("Debate with post: " + targetSearchResult.post);
				CivilDebateWall.state.userIsResponding = true;
				CivilDebateWall.state.userRespondingTo = targetSearchResult.post;				
				CivilDebateWall.kiosk.view.pickStanceView();
			}
			else {
				trace('Not a real click.');
			}
		}
		
		
		private function onFlag(e:Event):void {
			targetButton = e.currentTarget as ButtonBase;
			targetSearchResult = e.target as SearchResult;			
			
			if (scrollField.isClick) {
				trace("Flag post: " + targetSearchResult.post);
				// pull in the flag overlay
				CivilDebateWall.state.activePost = targetSearchResult.post;
				CivilDebateWall.kiosk.view.flagOverlayView();
			}
			else {
				trace('Not a real click.');
			}
		}		
		
		private function onGoToDebate(e:Event):void {			
			targetSearchResult = e.target as SearchResult;

			CivilDebateWall.state.highlightWord =  targetSearchResult._highlight;
			CivilDebateWall.state.setActiveThread(targetSearchResult.post.thread);
			CivilDebateWall.state.activePost = targetSearchResult.post;
			
			if (targetSearchResult.post.isThreadStarter) {
				// it's an original
				CivilDebateWall.kiosk.view.homeView();
			}
			else {
				// it's a response
				CivilDebateWall.kiosk.view.debateOverlayView();
			}
		}
		
		
	}
}
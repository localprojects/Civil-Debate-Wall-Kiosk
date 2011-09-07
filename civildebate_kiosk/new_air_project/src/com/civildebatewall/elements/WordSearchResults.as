package com.civildebatewall.elements {
	import com.civildebatewall.Assets;
	import com.civildebatewall.CDW;
	import com.civildebatewall.OrderedObject;
	import com.civildebatewall.Utilities;
	import com.civildebatewall.blocks.BlockBase;
	import com.civildebatewall.data.Post;
	import com.civildebatewall.ui.ButtonBase;
	import com.civildebatewall.ui.InertialScrollField;
	
	import flash.display.*;
	import flash.events.*;
	
	public class WordSearchResults extends BlockBase {
		
		public var scrollField:InertialScrollField;		
		public var resultCount:uint;		
		
		private var targetSearchResult:SearchResult;
		private var targetButton:ButtonBase;
		
		public function WordSearchResults()	{
			super();
			scrollField = new InertialScrollField(1022, 843);
			addChild(scrollField);
			
			scrollField.scrollSheet.addEventListener(Comment.EVENT_DEBATE, onDebate, true);
			scrollField.scrollSheet.addEventListener(Comment.EVENT_FLAG, onFlag, true);			
			scrollField.scrollSheet.addEventListener(Comment.EVENT_BUTTON_DOWN, onDown, true);
			scrollField.scrollSheet.addEventListener(SearchResult.EVENT_GOTO_DEBATE, onGoToDebate, true);
		}
		
		
		public function updateSearch(s:String):void {
			Utilities.removeChildren(scrollField.scrollSheet);
			resultCount = 0;
			scrollField.scrollSheet.y = 0;
			
			var paddingBottom:Number = 15;
			var yOffset:Number = 0;
			
			for (var i:uint = 0; i < CDW.database.posts.length; i++) {
				var post:Post = CDW.database.posts[i];
				
				// todo better word bounding
				if (post.text.toLowerCase().indexOf(s.toLowerCase()) >= 0) {
					resultCount++;					
					
					// create object and add it to the scroll field
					// Temp kludge for nameless authors // TODO get rid of this
					var resultRow:SearchResult = new SearchResult(post, s);
					
					resultRow.x = 0;
					resultRow.y = yOffset;
					resultRow.visible = true;
					
					yOffset += resultRow.height + paddingBottom;
					scrollField.scrollSheet.addChild(resultRow);	
				}				
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
				CDW.state.userIsResponding = true;
				CDW.state.userRespondingTo = targetSearchResult.post;				
				CDW.view.pickStanceView();
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
				CDW.state.activePost = targetSearchResult.post;
				CDW.view.flagOverlayView();
			}
			else {
				trace('Not a real click.');
			}
		}		
		
		private function onGoToDebate(e:Event):void {
			trace("TODO...");
		}
		
		
	}
}
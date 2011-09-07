package com.civildebatewall.elements {
	import com.civildebatewall.Assets;
	import com.civildebatewall.CDW;
	import com.civildebatewall.OrderedObject;
	import com.civildebatewall.Utilities;
	import com.civildebatewall.blocks.BlockBase;
	import com.civildebatewall.data.Post;
	import com.civildebatewall.ui.InertialScrollField;
	import com.civildebatewall.data.Post;
	
	import flash.display.*;
	
	public class WordSearchResults extends BlockBase {
		
		public var scrollField:InertialScrollField;		
		public var resultCount:uint;		
		
		public function WordSearchResults()	{
			super();
			scrollField = new InertialScrollField(1022, 843);
			addChild(scrollField);
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
		
		
	}
}
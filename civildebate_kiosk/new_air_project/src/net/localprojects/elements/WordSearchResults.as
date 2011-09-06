package net.localprojects.elements {
	import flash.display.*;
	
	import net.localprojects.Assets;
	import net.localprojects.CDW;
	import net.localprojects.OrderedObject;
	import net.localprojects.blocks.BlockBase;
	import net.localprojects.ui.InertialScrollField;
	import net.localprojects.Utilities;
	
	public class WordSearchResults extends BlockBase {
		
		public var scrollField:InertialScrollField;		
		public var resultCount:int = 3;		
		
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
			
			for each (var debate:Object in CDW.database.debates) {
				
				// TODO switch to posts
				if (debate['opinion'].toString().toLowerCase().indexOf(s.toLowerCase()) >= 0) {
					resultCount++;					
					
					// create object and add it to the scroll field
					// portrait
					var userID:String = debate['author']['_id']['$oid'];
					var debateID:String = debate['_id']['$oid'];
					var portrait:Bitmap = CDW.database.getPortrait(userID);
					var stance:String = debate['stance'];
					
					// Temp kludge for nameless authors // TODO get rid of this
					var authorName:String = '';
					if(debate['author']['firstName'] != null) {
						authorName = debate['author']['firstName'].toString();
					}
					
					var created:Date = new Date(debate['created']['$date']);
					var opinion:String = debate['opinion'];

					var resultRow:SearchResult = new SearchResult(debateID, portrait, stance, authorName, created, opinion, s);
					
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
package net.localprojects.elements
{
	import flash.display.*;
	import flash.events.*;
	import flash.text.*;
	
	import net.localprojects.*;
	import net.localprojects.blocks.*;
	import net.localprojects.ui.*;
	
	public class DebateOverlay extends BlockBase	{
		
		public var scrollField:InertialScrollField;
		private var containerHeight:Number;
		private var targetComment:Comment;
		private var targetButton:ButtonBase;		
		private var _maxHeight:Number = Number.MAX_VALUE;
		
		public function DebateOverlay()	{
			super();
			init();
		}
		
		public function init():void {
			scrollField = new InertialScrollField(1022, 100); 
			
			addChild(scrollField)
			scrollField.yMax = 0;
			scrollField.setBackgroundColor(0xffffff, 0.9);
			scrollField.addEventListener(InertialScrollField.EVENT_NOT_CLICK, onNotClick);
			
			scrollField.scrollSheet.addEventListener(Comment.EVENT_DEBATE, onDebate, true);
			scrollField.scrollSheet.addEventListener(Comment.EVENT_FLAG, onFlag, true);			
			scrollField.scrollSheet.addEventListener(Comment.EVENT_BUTTON_DOWN, onDown, true);			
		}
		
		public function setHeight(h:Number):void {
			containerHeight = h;			
			scrollField.containerHeight = containerHeight;
			scrollField.yMin = -scrollField.scrollSheet.height + containerHeight - 60;
		}
		
		public function update():void {
			// rebuild the list
		
			// clear children
			Utilities.removeChildren(scrollField.scrollSheet);
			
			var yOffset:int = 30;
			var paddingBottom:int = 35;
			
			var index:int = 0;
			var numComments:uint = Utilities.objectLength(CDW.database.debates[CDW.state.activeDebate]['comments']);
			
			for each (var comment:Object in CDW.database.debates[CDW.state.activeDebate]['comments']) {
				//Utilities.traceObject(comment);
				
				// portrait
				var userID:String = comment['author']['id'];
				var commentID:String = comment['_id']['$oid'];
				var portrait:Bitmap = CDW.database.getPortrait(userID);
				var stance:String = comment['stance'];
				var authorName:String = comment['author']['firstName'].toString();
				var commentNumber:int = index + 1;
				var created:Date = new Date(comment['created']['$date']);
				var opinion:String = comment['comment'];
				
				var commentRow:Comment = new Comment(commentID, commentNumber, portrait, stance, authorName, created, opinion);
				
				commentRow.x = 30;
				commentRow.y = yOffset;
				commentRow.visible = true;
				
				yOffset += commentRow.height + paddingBottom;
				scrollField.scrollSheet.addChild(commentRow);
				
				
				index++;
				
				// add the lines between the comments				
				if (index < numComments) {
					var line:Shape = new Shape();
					line.graphics.lineStyle(1, Assets.COLOR_GRAY_25, 1.0, true);
					line.graphics.moveTo(0, 0);
					line.graphics.lineTo(commentRow.width, 0);
					line.x = commentRow.x;
					line.y = yOffset;
					yOffset += paddingBottom;
					
					scrollField.scrollSheet.addChild(line);
				}
			}
			
			// set scroll bounds
			scrollField.yMin = -scrollField.scrollSheet.height + containerHeight -60;
			
			
			// resize background
			this.setHeight(Math.min(scrollField.scrollSheet.height + 60, _maxHeight));
			
			// do we need to scroll?
			scrollField.scrollAllowed = (scrollField.scrollSheet.height > _maxHeight - 30);
		}
		
		
		public function setMaxHeight(maxHeight:Number):void {
			_maxHeight = maxHeight;
			trace('Max Height: ' + _maxHeight);			
		}
		

	
		private function onDown(e:Event):void {
			targetComment = e.target as Comment;
		}
		
		
		private function onNotClick(e:Event):void {
			if (targetComment != null) targetComment.unClick();
		}		
		
		
		private function onDebate(e:Event):void {
			targetButton = e.currentTarget as ButtonBase;
			targetComment = e.target as Comment;			
			
			if (scrollField.isClick) {
				trace("Debate with comment ID: " + targetComment.commentID);
				// TODO HOOK THIS UP
			}
			else {
				trace('Not a real click.');
			}
		}
		
		
		private function onFlag(e:Event):void {
			targetButton = e.currentTarget as ButtonBase;
			targetComment = e.target as Comment;			
			
			if (scrollField.isClick) {
				trace("Flag comment ID: " + targetComment.commentID);
				// TODO HOOK THIS UP				
			}
			else {
				trace('Not a real click.');
			}
		}		
		
	}
}
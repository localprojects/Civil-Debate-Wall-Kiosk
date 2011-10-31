package com.civildebatewall.kiosk.elements
{
	import com.civildebatewall.*;
	import com.civildebatewall.kiosk.blocks.*;
	import com.civildebatewall.data.Post;
	import com.civildebatewall.kiosk.ui.*;
	import com.kitschpatrol.futil.utilitites.GraphicsUtil;
	
	import flash.display.*;
	import flash.events.*;
	import flash.text.*;
	
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
			GraphicsUtil.removeChildren(scrollField.scrollSheet);
			
			var yOffset:int = 30;
			var paddingBottom:int = 35;
			
			// sort
			CivilDebateWall.state.activeThread.posts.sortOn('created', Array.DESCENDING | Array.NUMERIC);
			
			
			// set up highlight
			var highlight:String = null;
			if (CivilDebateWall.state.highlightWord != null) highlight = CivilDebateWall.state.highlightWord;
			CivilDebateWall.state.highlightWord = null; // clear it for subsequent loads
			

			// skip the last one since it's the original post
			for (var i:uint = 0; i < CivilDebateWall.state.activeThread.posts.length - 1; i++) {
				// create rows
				var commentRow:Comment = new Comment(CivilDebateWall.state.activeThread.posts[i], i + 1, highlight);
				
				commentRow.x = 30;
				commentRow.y = yOffset;
				commentRow.visible = true;
				
				yOffset += commentRow.height + paddingBottom;
				scrollField.scrollSheet.addChild(commentRow);
				
				// add the lines between the comments				
				if (i < CivilDebateWall.state.activeThread.postCount - 2) {
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
				trace("Debate with post: " + targetComment.post);
				CivilDebateWall.state.userIsResponding = true;
				CivilDebateWall.state.userRespondingTo = targetComment.post;				
				CivilDebateWall.kiosk.view.pickStanceView();
			}
			else {
				trace('Not a real click.');
			}
		}
		
		
		private function onFlag(e:Event):void {
			targetButton = e.currentTarget as ButtonBase;
			targetComment = e.target as Comment;			
			
			if (scrollField.isClick) {
				trace("Flag post: " + targetComment.post);
				// pull in the flag overlay
				CivilDebateWall.state.activePost = targetComment.post;
				CivilDebateWall.kiosk.view.flagOverlayView();
			}
			else {
				trace('Not a real click.');
			}
		}		
		
	}
}
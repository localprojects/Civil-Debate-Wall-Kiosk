package com.civildebatewall.kiosk.elements {
	import com.civildebatewall.*;
	import com.civildebatewall.data.Data;
	import com.civildebatewall.data.Thread;
	import com.civildebatewall.kiosk.BlockInertialScroll;
	import com.civildebatewall.kiosk.blocks.*;
	import com.civildebatewall.kiosk.ui.*;
	import com.kitschpatrol.futil.utilitites.GraphicsUtil;
	
	import flash.display.*;
	import flash.events.*;
	import flash.text.*;
	
	public class ThreadBrowser extends BlockInertialScroll	{
		
		public function ThreadBrowser()	{
			super({
				backgroundColor: 0xffffff,
				backgroundAlpha: 0.85,
				width: 1024,
				maxHeight: 100,
				maxSizeBehavior: MAX_SIZE_CLIPS,
				scrollAxis: SCROLL_Y
			});
			
			
			// fill up the content
			
			
			//addChild(GraphicsUtil.shapeFromSize(100, 2000));
			
			

			CivilDebateWall.data.addEventListener(Data.DATA_UPDATE_EVENT, onDataUpdate);
		}
		
		
		private function onDataUpdate(e:Event):void {
			refreshContent();
		}
		
		override protected function beforeTweenIn():void {
			refreshContent();
			super.beforeTweenIn();
		}		
			
		private function refreshContent():void {
			var yOffset:int = 30;
			var paddingBottom:int = 35;
						
			// clean up, note it's awkward to call content instead of "this"... compromises of Futil
			GraphicsUtil.removeChildren(content);			

			// sort
			CivilDebateWall.state.activeThread.posts.sortOn('created', Array.DESCENDING | Array.NUMERIC);						

			// skip the last one since it's the original post
			for (var i:uint = 0; i < CivilDebateWall.state.activeThread.posts.length - 1; i++) {
				// create rows
				var commentRow:Comment = new Comment(CivilDebateWall.state.activeThread.posts[i], i);
				
				//commentRow.number = i + 1;
				commentRow.x = 30;
				commentRow.y = yOffset;
				commentRow.visible = true;
				
				yOffset += commentRow.height + paddingBottom;
				addChild(commentRow);
				
				// add the lines between the comments				
				if (i < CivilDebateWall.state.activeThread.postCount - 2) {
					var line:Shape = new Shape();
					line.graphics.lineStyle(1, Assets.COLOR_GRAY_25, 1.0, true);
					line.graphics.moveTo(0, 0);
					line.graphics.lineTo(commentRow.width, 0);
					line.x = commentRow.x;
					line.y = yOffset;
					yOffset += paddingBottom;
					
					addChild(line);
				}
			}
			

			// do we need to scroll?
			//scrollField.scrollAllowed = (scrollField.scrollSheet.height > _maxHeight - 30);			
		}
		


		
		
		private function onNotClick(e:Event):void {

		}		
		
//		
//		private function onDebate(e:Event):void {
//			targetButton = e.currentTarget as ButtonBase;
//			targetComment = e.target as Comment;			
//			
//			if (scrollField.isClick) {
//				trace("Debate with post: " + targetComment.post);
//				CivilDebateWall.state.userIsResponding = true;
//				CivilDebateWall.state.userRespondingTo = targetComment.post;				
//				CivilDebateWall.kiosk.view.pickStanceView();
//			}
//			else {
//				trace('Not a real click.');
//			}
//		}
//		
//		
//		private function onFlag(e:Event):void {
//			targetButton = e.currentTarget as ButtonBase;
//			targetComment = e.target as Comment;			
//			
//			if (scrollField.isClick) {
//				trace("Flag post: " + targetComment.post);
//				// pull in the flag overlay
//				CivilDebateWall.state.activePost = targetComment.post;
//				CivilDebateWall.kiosk.view.flagOverlayView();
//			}
//			else {
//				trace('Not a real click.');
//			}
//		}		
		
	}
}
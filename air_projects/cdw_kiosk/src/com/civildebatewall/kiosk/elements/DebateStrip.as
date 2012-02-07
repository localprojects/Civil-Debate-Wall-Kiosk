/*--------------------------------------------------------------------
Civil Debate Wall Kiosk
Copyright (c) 2012 Local Projects. All rights reserved.

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as
published by the Free Software Foundation, either version 2 of the
License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public
License along with this program. 

If not, see <http://www.gnu.org/licenses/>.
--------------------------------------------------------------------*/

package com.civildebatewall.kiosk.elements {

	import com.civildebatewall.CivilDebateWall;
	import com.civildebatewall.State;
	import com.civildebatewall.data.Data;
	import com.civildebatewall.data.containers.User;
	import com.civildebatewall.kiosk.BlockInertialScroll;
	import com.civildebatewall.kiosk.buttons.ThumbnailButton;
	import com.greensock.TimelineMax;
	import com.greensock.TweenMax;
	import com.greensock.easing.Quart;
	import com.kitschpatrol.futil.Math2;
	import com.kitschpatrol.futil.utilitites.DepthUtil;
	import com.kitschpatrol.futil.utilitites.GraphicsUtil;
	
	import flash.events.Event;
	
	public class DebateStrip extends BlockInertialScroll {

		private var activeThumbnail:ThumbnailButton;
		
		public function DebateStrip()	{
			super({
				backgroundColor: 0xffffff,
				backgroundAlpha: 0.85,
				width: 980,
				height: 141,
				maxSizeBehavior: MAX_SIZE_CLIPS,
				scrollAxis: SCROLL_X,
				assumeButtons: true // always check for click vs. scroll, never assume scroll
			});
			
			CivilDebateWall.data.addEventListener(Data.DATA_UPDATE_EVENT, onDataUpdate);
			CivilDebateWall.state.addEventListener(State.ACTIVE_THREAD_CHANGE, onActiveDebateChange);
			CivilDebateWall.state.addEventListener(State.SORT_CHANGE, onSortChange);			
		}

		private function onActiveDebateChange(e:Event):void {
			if (CivilDebateWall.state.activeThread != null) {
				setActiveThumbnail(CivilDebateWall.state.activeThread.id);
			}
		}
		
		private function onDataUpdate(e:Event):void {
			// reads the state and builds the strip
			
			// Clean up the kids, could do a diff instead...
			GraphicsUtil.removeChildren(content);
			
			for (var i:uint = 0; i < CivilDebateWall.data.threads.length; i++) {
				var threadThumbnail:ThumbnailButton = new ThumbnailButton(CivilDebateWall.data.threads[i]);

				threadThumbnail.x = (threadThumbnail.width) * i; // compensate for dots
				threadThumbnail.y = 0;
				
				// remove the left dot from the first one
				if (i == 0) threadThumbnail.leftDot.alpha = 0;
				
				// remove the right dot from the last one				
				if (i == CivilDebateWall.data.threads.length - 1) threadThumbnail.rightDot.alpha = 0;
				addChild(threadThumbnail);
			}
		}

		public function updateUserPhoto(user:User):void {
			for (var i:int = 0; i < content.numChildren; i++) {
				if (content.getChildAt(i) is ThumbnailButton) {		
					var tempThumb:ThumbnailButton = content.getChildAt(i) as ThumbnailButton;
					if (tempThumb.thread.firstPost.user == user) {
						// rebuild the portrait
						tempThumb.updatePortrait();
					}
				}
			}
		}
		
		public function setActiveThumbnail(id:String):void {
			for (var i:int = 0; i < content.numChildren; i++) {
				if (content.getChildAt(i) is ThumbnailButton) {				
					var tempThumb:ThumbnailButton = content.getChildAt(i) as ThumbnailButton;
					
					// TODO use whole object?
					if (tempThumb.thread.id == id) {
						
						// deactivate the old on
						if (activeThumbnail != null) {			
							activeThumbnail.selected = false;
						}
						
						// select the new one
						activeThumbnail = tempThumb;
						content.setChildIndex(activeThumbnail, content.numChildren - 1); // make sure the colored dots are on top
						activeThumbnail.selected = true;		
						break;
					}
				}			
			}
			
			scrollToActive();			
		}
		
		private function onSortChange(e:Event):void {
			var timeline:TimelineMax = new TimelineMax();
			var i:int;
			var tempThumb:ThumbnailButton;
			var scrollToX:Number = 0;
			
			// fade out all dots
			for (i = 0; i < content.numChildren; i++) {
				if (content.getChildAt(i) is ThumbnailButton) {
					tempThumb = content.getChildAt(i) as ThumbnailButton;
					timeline.insert(TweenMax.to(tempThumb.leftDot, 0.25, {alpha: 0}));
					timeline.insert(TweenMax.to(tempThumb.rightDot, 0.25, {alpha: 0}));
				}
			}

			// animate the thumbnails into their new position
			for (i = 0; i < content.numChildren; i++) {
				if (content.getChildAt(i) is ThumbnailButton) {
					tempThumb = content.getChildAt(i) as ThumbnailButton;
					
					// figure out new x position
					var newX:int;
					for (var j:int = 0; j < CivilDebateWall.data.threads.length; j++) {
						if (tempThumb.thread.id == CivilDebateWall.data.threads[j].id) {
							newX = (tempThumb.width - 6) * j;
							
							// scroll to the first one if nothing is active (only at startup)
							if (j == 0)	scrollToX = newX;
							
							break;
						}
					}
					
					// tween it over
					timeline.insert(TweenMax.to(tempThumb, 1, {x: newX, ease: Quart.easeInOut}), .25);
					
					// if we have an active thumb, scroll to that instead of the first
					if ((activeThumbnail != null) && (tempThumb == activeThumbnail)) {
						DepthUtil.bringToFront(activeThumbnail);
						scrollToX = newX;
					}
				}
			}
			
			// tween the scroll view to the active item
			// scrollToX = (tempThumb == null) ? 0 : Math2.clamp(scrollToX - (width / 2) + (tempThumb.width / 2), minScrollX, maxScrollX);
			// timeline.insert(TweenMax.to(this, 1, {scrollX: scrollToX, ease: Quart.easeInOut}), .25);
			
			// scroll to start instead, per ticket #217
			timeline.insert(TweenMax.to(this, 1, {scrollX: 0, ease: Quart.easeInOut}));
			
			// fade the (Correct) dots back in
			for (i = 0; i < content.numChildren; i++) {
				if (content.getChildAt(i) is ThumbnailButton) {
					tempThumb = content.getChildAt(i) as ThumbnailButton;
					// don't tween in the edge dots!
					if (tempThumb.thread.id != CivilDebateWall.data.threads[0].id) {
						// safe to insert left dot
						timeline.insert(TweenMax.to(tempThumb.leftDot, 0.25, {alpha: 1}), 1.25);
					}

					if (tempThumb.thread.id != CivilDebateWall.data.threads[CivilDebateWall.data.threads.length - 1].id) {
						// safe to insert right dot
						timeline.insert(TweenMax.to(tempThumb.rightDot, 0.25, {alpha: 1}), 1.25);						
					}
				}
			};	
			
			timeline.play();
		}
		
		public function scrollLeft():void {
			var targetX:Number = Math2.clamp(scrollX - width, minScrollX, maxScrollX); 
			TweenMax.to(this, 1, {scrollX: targetX, ease: Quart.easeInOut});			
		}
		
		public function scrollRight():void {
			var targetX:Number = Math2.clamp(scrollX + width, minScrollX, maxScrollX); 
			TweenMax.to(this, 1, {scrollX: targetX, ease: Quart.easeInOut});			
		}
		
		public function scrollToActive():void {
			if (activeThumbnail != null) {
				TweenMax.to(this, 1, {scrollX: getActiveThumbnailX(), ease: Quart.easeInOut});
			}
		}
		
		private function getActiveThumbnailX():Number {
			if (activeThumbnail != null) {
				var activeThumbnailX:Number = activeThumbnail.x - (width / 2) + (activeThumbnail.width / 2);
				// handle literal edge cases (don't scroll past bounds)
				return Math2.clamp(activeThumbnailX, minScrollX, maxScrollX);
			}
			else {
				return 0;
			}
		}

	}
}

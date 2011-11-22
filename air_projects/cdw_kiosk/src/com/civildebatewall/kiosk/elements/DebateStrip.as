package com.civildebatewall.kiosk.elements {
	import com.civildebatewall.*;
	import com.civildebatewall.data.Data;
	import com.civildebatewall.kiosk.blocks.OldBlockBase;
	import com.civildebatewall.kiosk.ui.*;
	import com.greensock.TweenMax;
	import com.greensock.easing.*;
	import com.kitschpatrol.futil.Math2;
	import com.kitschpatrol.futil.utilitites.GeomUtil;
	import com.kitschpatrol.futil.utilitites.GraphicsUtil;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.engine.Kerning;
	
	import flashx.textLayout.elements.BreakElement;
	
	public class DebateStrip extends OldBlockBase {
		
		private var scrollField:InertialScrollField;
		private var activeThumbnail:ThumbnailButton;
		private var targetThumbnail:ThumbnailButton;		
		
		private var leftButton:Sprite;
		private var rightButton:Sprite;

		public function DebateStrip()	{
			super();
			
			// overdraw for a more friendly hit-zone
			scrollField = new InertialScrollField(980, 140, InertialScrollField.SCROLL_X);
			scrollField.x = 50;
			scrollField.addEventListener(InertialScrollField.EVENT_NOT_CLICK, onNotClick);
			
			// background strip
			scrollField.graphics.beginFill(0xffffff, 1.0);			
			scrollField.graphics.drawRect(0, 0, 980, 140);
			scrollField.graphics.endFill();
			
			// min and max get updated in update			
			addChild(scrollField);
			
			// buttons
			leftButton = new Sprite();
			leftButton.graphics.beginFill(0xffffff);
			leftButton.graphics.drawRect(0,0, 50, 140);
			leftButton.graphics.endFill();
			var leftCarat:Bitmap = Assets.getLeftCarat();
			leftButton.addChild(leftCarat);
			GeomUtil.centerWithin(leftCarat, leftButton);
			addChild(leftButton);
			
			rightButton = new Sprite();
			rightButton.graphics.beginFill(0xffffff);
			rightButton.graphics.drawRect(0,0, 50, 140);
			rightButton.graphics.endFill();
			var rightCarat:Bitmap = Assets.getRightCarat();
			rightButton.addChild(rightCarat);
			GeomUtil.centerWithin(rightCarat, rightButton);
			rightButton.x = 50 + 980;
			addChild(rightButton);
			
			CivilDebateWall.data.addEventListener(Data.DATA_UPDATE_EVENT, onDataUpdate);
			CivilDebateWall.state.addEventListener(State.ACTIVE_THREAD_CHANGE, onActiveDebateChange);
			CivilDebateWall.state.addEventListener(State.SORT_CHANGE, onSortChange);			
		}


		private function onActiveDebateChange(e:Event):void {
			setActiveThumbnail(CivilDebateWall.state.activeThread.id);
		}
		
		private function onDataUpdate(e:Event):void {
			// reads the state and builds the strip
			
			// Clean up the kids, could do a diff instead...
			GraphicsUtil.removeChildren(scrollField.scrollSheet);
			
			
			for (var i:uint = 0; i < CivilDebateWall.data.threads.length; i++) {
				var threadThumbnail:ThumbnailButton = new ThumbnailButton(CivilDebateWall.data.threads[i]);

				threadThumbnail.x = (threadThumbnail.width - 6) * i; // compensate for dots
				threadThumbnail.y = 0;
				
				threadThumbnail.addEventListener(MouseEvent.MOUSE_DOWN, onThumbnailMouseDown);
				
				// remove the left dot from the first one
				if (i == 0) threadThumbnail.removeChild(threadThumbnail.leftDot);
				
				// remove the right dot from the last one				
				if (i == CivilDebateWall.data.threads.length - 1) threadThumbnail.removeChild(threadThumbnail.rightDot);
				
				threadThumbnail.update();
				
				scrollField.scrollSheet.addChild(threadThumbnail);
				
			}
			
			// update the scroll field limits to acommodate the growing strip...
			scrollField.xMin = -scrollField.scrollSheet.width + scrollField.width;
			scrollField.xMax = 0; 	
		}
		
		
		public function setActiveThumbnail(id:String):void {
			
			for (var i:int = 0; i < scrollField.scrollSheet.numChildren; i++) {
				
				if (scrollField.scrollSheet.getChildAt(i) is ThumbnailButton) {
				
					var tempThumb:ThumbnailButton = scrollField.scrollSheet.getChildAt(i) as ThumbnailButton;
					
					// TODO use whole object?
					if (tempThumb.thread.id == id) {
						
						// deactivate the old on
						if (activeThumbnail != null) {			
							activeThumbnail.selected = false;
							activeThumbnail.setBackgroundColor(0xffffff);
							trace("deselecting: " + activeThumbnail);
						}
						
						// select the new one
						activeThumbnail = tempThumb;
						activeThumbnail.setBackgroundColor(activeThumbnail.downBackgroundColor);
						scrollField.scrollSheet.setChildIndex(activeThumbnail, scrollField.scrollSheet.numChildren - 1); // make sure the colored dots are on top
						activeThumbnail.selected = true;		
					
						break;
					}
					
				}			
			}
			
			scrollToActive();			
		}
		
		
		
		private function onSortChange(e:Event):void {
			
			// animate the thumbnails into their new position
			for (var i:int = 0; i < scrollField.scrollSheet.numChildren; i++) {
				if (scrollField.scrollSheet.getChildAt(i) is ThumbnailButton) {
					var tempThumb:ThumbnailButton = scrollField.scrollSheet.getChildAt(i) as ThumbnailButton;
					
					// figure out new x position
					var newX:int;
					for (var j:int = 0; j < CivilDebateWall.data.threads.length; j++) {
						if (tempThumb.thread.id == CivilDebateWall.data.threads[j].id) {
							newX = (tempThumb.width - 6) * j;
							break;
						}
					}
					
					// tween it over
					TweenMax.to(tempThumb, 1, {x: newX, ease: Quart.easeInOut});
				}
			}
		}
		
		
		public function scrollToActive():void {
			if (activeThumbnail != null) {
				var activeThumbnailX:Number = -activeThumbnail.x + ((1080 - activeThumbnail.width) / 2);
			
				// handle literal edge cases (don't scroll past bounds)
				activeThumbnailX = Math2.clamp(activeThumbnailX, scrollField.xMin, scrollField.xMax); 
				scrollField.scrollTo(activeThumbnailX, 0);
			}
		}
		

		private function onThumbnailMouseDown(e:MouseEvent):void {
			targetThumbnail = e.currentTarget as ThumbnailButton;			
			targetThumbnail.setBackgroundColor(targetThumbnail.downBackgroundColor, true);
			
			stage.addEventListener(MouseEvent.MOUSE_UP, onThumbnailMouseUp);			
			
		}
		
		
		private function onThumbnailMouseUp(e:MouseEvent):void {
			stage.removeEventListener(MouseEvent.MOUSE_UP, onThumbnailMouseUp);			
			
			if (scrollField.isClick) {
				// go to opinion
				if (activeThumbnail != targetThumbnail) {
					CivilDebateWall.state.setActiveThread(targetThumbnail.thread);
				}
			}
			
			
			if (activeThumbnail != targetThumbnail) targetThumbnail.setBackgroundColor(0xffffff);	
		}
		

		private function onNotClick(e:Event):void {
			if ((targetThumbnail != null) && (targetThumbnail != activeThumbnail)) targetThumbnail.setBackgroundColor(0xffffff);			
		}		
		
	}
}
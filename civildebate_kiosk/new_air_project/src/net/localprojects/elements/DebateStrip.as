package net.localprojects.elements {
	import com.greensock.TweenMax;
	import com.greensock.easing.*;
	import com.greensock.plugins.ThrowPropsPlugin;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.ui.Mouse;
	import flash.utils.getTimer;
	
	import net.localprojects.*;
	import net.localprojects.CDW;
	import net.localprojects.blocks.BlockBase;
	import net.localprojects.ui.*;
	
	
	
	public class DebateStrip extends BlockBase {
		
		private var scrollField:InertialScrollField;
		private var activeThumbnail:ThumbnailButton;
		private var targetThumbnail:ThumbnailButton;		
		
		public function DebateStrip()	{
			super();
			scrollField = new InertialScrollField(1080, 141, InertialScrollField.SCROLL_X);
			scrollField.addEventListener(InertialScrollField.EVENT_NOT_CLICK, onNotClick);
			// min and max get updated in update			
			addChild(scrollField);
		}
		
		public function update():void {
			// reads the state and builds the strip
			
			// Clean up the kids, could do a diff instead...
			while(scrollField.scrollSheet.numChildren > 0) {
				scrollField.scrollSheet.removeChild(scrollField.scrollSheet.getChildAt(0));
			}   
			
			var i:int = 0;
			for (var debateID:* in CDW.database.debates) {
				var debate:Object = CDW.database.debates[debateID];
				var debateThumbnail:ThumbnailButton = new ThumbnailButton(CDW.database.cloneDebateAuthorPortrait(debateID), debate.stance, debateID);
				debateThumbnail.x = (debateThumbnail.width - 6) * i; // compensate for dots
				debateThumbnail.y = 0;
				
				debateThumbnail.addEventListener(MouseEvent.MOUSE_DOWN, onThumbnailMouseDown);
				debateThumbnail.addEventListener(MouseEvent.MOUSE_UP, onThumbnailMouseUp);				
				
				if (CDW.state.activeDebate == debateID) {
					activeThumbnail = debateThumbnail;
				}
				else {
					debateThumbnail.selected = false;
				}
				
				// remove the left dot from the first one
				if (i == 0) debateThumbnail.removeChild(debateThumbnail.leftDot);
				scrollField.scrollSheet.addChild(debateThumbnail);
				i++;
			}
			
			// remove the right dot from the last one
			debateThumbnail.removeChild(debateThumbnail.rightDot);
			
			// wait until everything is initalized to select the active thumb so it will draw on top
			if (activeThumbnail != null) activeThumbnail.selected = true;
			
			// update the scroll field limits to acommodate the growing strip...
			scrollField.xMin = -scrollField.scrollSheet.width + 594;
			scrollField.xMax = 450; 	

			scrollToActive();
		}

		
		private function scrollToActive():void {
			var activeThumbnailX:Number = -activeThumbnail.x + ((1080 - activeThumbnail.width) / 2);
			scrollField.scrollTo(activeThumbnailX, 0);
		}
		

		private function onThumbnailMouseDown(e:MouseEvent):void {
			targetThumbnail = e.currentTarget as ThumbnailButton;			
			targetThumbnail.setBackgroundColor(targetThumbnail.downBackgroundColor, true);
		}
		
		
		private function onThumbnailMouseUp(e:MouseEvent):void {
			targetThumbnail = e.currentTarget as ThumbnailButton;

			if (scrollField.isClick) {
				trace("click");
				// go to opinion
				
				if (activeThumbnail != targetThumbnail) {
					// deactivate the old one
					activeThumbnail.selected = false;
					activeThumbnail.setBackgroundColor(0xffffff);
					
					// select the new one
					activeThumbnail = targetThumbnail;
					scrollField.scrollSheet.setChildIndex(activeThumbnail, scrollField.scrollSheet.numChildren - 1); // make sure the colored dots are on top 
					activeThumbnail.selected = true;
					CDW.state.setActiveDebate(activeThumbnail.debateID);
					CDW.view.transitionView();
					
					scrollToActive();					
				}
			}
			else {
				trace("not a click");
			}

			// Like nothing happened (unless it's active!)
			if (activeThumbnail != targetThumbnail) targetThumbnail.setBackgroundColor(0xffffff);			
		}
		
		
		private function onNotClick(e:Event):void {
			if (targetThumbnail != null) targetThumbnail.setBackgroundColor(0xffffff);			
		}		
		
	}
	
}
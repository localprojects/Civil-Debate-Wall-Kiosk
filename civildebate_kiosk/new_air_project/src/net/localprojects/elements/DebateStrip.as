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
		
		private var strip:Sprite;
		private var t1:uint, t2:uint, x1:Number, x2:Number, mouseTravel:Number;
		private var activeThumbnail:ThumbnailButton;		
		
		public function DebateStrip()	{
			super();
			
			this.buttonMode = true;
			// strip (catches mouse events.. TODO make it bigger?)
			graphics.beginFill(0xffffff);
			graphics.drawRect(0, 0, 1080, 141);
			
			strip = new Sprite();
			addChild(strip);
			
			
			
			this.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		}
		
		public function update():void {
			// reads the state and builds the strip
			
			// Clean up the kids
			while(strip.numChildren > 0) {
				strip.removeChild(strip.getChildAt(0));
			}   
			
			var i:int = 0;
			for (var debateID:* in CDW.database.debates) {
				var debate:Object = CDW.database.debates[debateID];
				var debateThumbnail:ThumbnailButton = new ThumbnailButton(CDW.database.cloneDebateAuthorPortrait(debateID), debate.stance, debateID);
				debateThumbnail.x = (debateThumbnail.width - 6) * i; // compensate for dots
				debateThumbnail.y = 0;
				
				debateThumbnail.addEventListener(MouseEvent.MOUSE_DOWN, onThumbnailMouseDown);
				debateThumbnail.addEventListener(MouseEvent.MOUSE_UP, onThumbnailMouseUp);				
				
				// todo diff updates
				if (CDW.state.activeDebate == debateID) {
					activeThumbnail = debateThumbnail;
				}
				else {
					debateThumbnail.selected = false;
				}
				
				strip.addChild(debateThumbnail);
				i++;
			}
			
			trace(debateThumbnail.width);
			
			// wait until everything is initalized to select the active thumb so it will draw on top
			if (activeThumbnail != null) {
				activeThumbnail.selected = true;
			}
			
			
			scrollToActive();
		}
		
		private function scrollToActive():void {
			// scroll to the active thumb
			TweenMax.to(strip, 1, {x: -activeThumbnail.x + ((1080 - activeThumbnail.width) / 2), ease: Quart.easeInOut});			
		}
		
		
		private var isClick:Boolean;
		
		
		private var targetThumbnail:ThumbnailButton;		
		private function onThumbnailMouseDown(e:MouseEvent):void {
			targetThumbnail = e.currentTarget as ThumbnailButton;			
			
			trace("down");
			
			targetThumbnail.setBackgroundColor(targetThumbnail.downBackgroundColor, true);
		}
		
		private function onThumbnailMouseUp(e:MouseEvent):void {
			targetThumbnail = e.currentTarget as ThumbnailButton;

			if (isClick) {
				trace("click");
				// go to opinion
				
				if (activeThumbnail != targetThumbnail) {
					activeThumbnail.selected = false;
					
					// select the new one
					activeThumbnail = targetThumbnail;
					strip.setChildIndex(activeThumbnail, strip.numChildren - 1); // make sure the colored dots are on top 
					activeThumbnail.selected = true;
					CDW.state.setActiveDebate(activeThumbnail.debateID);
					CDW.view.transitionView();
					
					scrollToActive();					
				}
				
				
			}
			else {
				trace("not a click");
			}

			
			targetThumbnail.setBackgroundColor(0xffffff);			
		}
		
		private function onMouseDown(event:MouseEvent):void {
			if (TweenMax.isTweening(strip)) {
				// ignore clicks if we're "poking" at a moving strip to stop it from inertially scrolling				
				isClick = false;
			}
			else {
				isClick = true;				
			}			
			
			TweenMax.killTweensOf(strip);
			mouseTravel = 0;
			lastMouseX = CDW.ref.stage.mouseX;
			x1 = x2 = strip.x;
			t1 = t2 = getTimer();
			strip.startDrag(false, new Rectangle(-99999, 0, 99999999, 0));
			this.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			CDW.ref.stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		}
		
		private var lastMouseX:int;
		private function onEnterFrame(event:Event):void {
			mouseTravel += Math.abs(CDW.ref.stage.mouseX - lastMouseX);
			trace(mouseTravel);	
			lastMouseX = CDW.ref.stage.mouseX;
			x2 = x1;
			t2 = t1;
			x1 = strip.x;
			t1 = getTimer();
			
			if (mouseTravel > 50) {
				if (targetThumbnail != null) {
					// fade out the hilite
					targetThumbnail.setBackgroundColor(0xffffff);
				}
				
				// cancel the click, event still fires, but we can decide not to actually navigate to the thumbnail
				isClick = false;
			}
		}
		
		private var xVelocity:Number = 0; 		
		private function onMouseUp(event:MouseEvent):void {
			
			strip.stopDrag();
			CDW.ref.stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			this.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			var time:Number = (getTimer() - t2) / 1000;
			xVelocity = (strip.x - x2) / time;
			var xOverlap:Number = Math.max(0, strip.width - this.height);
			
			if (!isClick) {
				ThrowPropsPlugin.to(strip, {throwProps:{ x:{ velocity: xVelocity, max: 450.5, min: -strip.width + 594.5, resistance:600}}, ease:Strong.easeOut}, 3, 0.3, 1);
			}
			
			trace("Throw velocity was: " + xVelocity);
			trace("Mouse travel was: " + mouseTravel);
			

			
			
		}		
		
	}
	
}
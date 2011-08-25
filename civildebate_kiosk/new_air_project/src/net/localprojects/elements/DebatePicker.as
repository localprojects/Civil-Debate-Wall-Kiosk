package net.localprojects.elements {
	import com.greensock.*;
	import com.greensock.easing.*;
	
	import flash.display.Sprite;
	import flash.events.*;
	import flash.geom.*;
	import flash.utils.*;
	
	import net.localprojects.*;
	import net.localprojects.ui.*;
	import net.localprojects.blocks.BlockBase;
	
	public class DebatePicker extends BlockBase {
		
		private var debateHolder:Sprite = new Sprite();
		private	var padding:int = 0;
		private var lastMouseX:int;
		private var activeThumbnail:ThumbnailButton;
		
		public function DebatePicker() {
			super();
			init();
		}
				
		public function init():void {
			
			this.buttonMode = true;
			// strip (catches mouse events.. TODO make it bigger?)
			graphics.beginFill(0xffffff);
			graphics.drawRect(0, 0, 1080, 141);
		
			// center the debate holder horizontally
			debateHolder.y = 0;
			debateHolder.x = (1080 - debateHolder.width) / 2;
			
			addChild(debateHolder);
			
			this.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			//this.addEventListener(TouchEvent.TOUCH_BEGIN, onMouseDown);			
			this.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		public function update():void {
			// reads the state and builds the strip
			
			var i:int = 0;
			for (var debateID:* in CDW.database.debates) {
				var debate:Object = CDW.database.debates[debateID];
				var debateThumbnail:ThumbnailButton = new ThumbnailButton(CDW.database.cloneDebateAuthorPortrait(debateID), debate.stance, debateID);
				debateThumbnail.x = padding + ((debateThumbnail.width - 6) * i); // compensate for dots
				debateThumbnail.y = 0;
				
				// todo diff updates
				if (CDW.state.activeDebate == debateID) {
					activeThumbnail = debateThumbnail;
				}
				else {
					debateThumbnail.selected = false;
				}
				
				debateHolder.addChild(debateThumbnail);
				i++;
			}
			
			// wait until everything is initalized to select the active thumb so it will draw on top
			if (activeThumbnail != null) {
				activeThumbnail.selected = true;
			}
		}
		

		
		
		
		// scroll physics
		private var vx:Number = 0;
		private var friction:Number = 0.9;
		private var vxThreshold:Number = 0.5;
		private var mouseDown:Boolean = false;
		
		private var vxSamples:Array = [];
		private var vxSampleDepth:int = 5; // average the last five mouse velocities
		private var avx:Number = 0; // average velocity over sample depth
		
		private var startX:int;
		
		private function onMouseDown(e:MouseEvent):void {
			CDW.ref.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			
		
			startX = this.stage.mouseX;
			
			mouseDown = true;
			lastMouseX = this.stage.mouseX
			vx = 0;
			vxSamples = []; // clear history
		}

		
		private function onEnterFrame(e:Event):void {
			// calculate physics
			// (previously in mouseMoved)
			if (mouseDown) {
				// scroll the strip
				debateHolder.x += this.stage.mouseX - lastMouseX;
				vx = this.stage.mouseX - lastMouseX;
				
				vxSamples.unshift(vx);
				
				while (vxSamples.length > vxSampleDepth) {
					vxSamples.pop();
				}
				
				lastMouseX = this.stage.mouseX;	
			}			
			
			
			// check bounds
			
			if(debateHolder.width < stageWidth) {
			
				// smaller than the holder
				if (debateHolder.x < 0) {
					debateHolder.x = 0;
				}
				else {
					if ((debateHolder.x + debateHolder.width) >  1080) {
						debateHolder.x = 1080 - debateHolder.width; 
					}
				}
			}
			else {
			
				
				// bigger than the holder
				if (debateHolder.x > 0) {
					debateHolder.x = 0;
					//vx = 0; // TEMP disabled for bounce
					trace('left limit');				
				}
				else if (debateHolder.x < ((debateHolder.width - 1080) * -1)) {
					debateHolder.x = (debateHolder.width - 1080) * -1;
					//vx = 0; // TEMP disabled for bounce
					trace('right limit');				
				}
			}
			
			// inertia
			if (!mouseDown && (Math.abs(avx) > vxThreshold)) {
				debateHolder.x += avx;
				avx *= friction;
			}
		}
		
		private function onMouseUp(e:MouseEvent):void {
			CDW.ref.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
						
			// take the average vx
			avx = Utilities.averageArray(vxSamples);

			trace('Last velocity: ' + vx +  '\tAverage Velocity: ' + avx); 
			
			mouseDown = false;
			
			// now find the one we clicked
			// are we clicking on a thumbnail? or just scrolling?
			var objects:Array = this.getObjectsUnderPoint(new Point(this.stage.mouseX, this.stage.mouseY));
						
			for (var i:int = 0; i < objects.length; i++) {
				
				// kind of gross, use introspection to find out what's under the mouse instead of adding listeners to the thumbnails, need to block event bubbling instead?
				if (objects[i] is ThumbnailButton) {

					// figure out if we should interpret a click or a scroll (does the touchscreen do this for us?)
					// interpret as a click only if we've moved less than 10 pixels
					var distanceTraveled:int = Math.abs(startX - this.stage.mouseX);
					var travelThreshold:int = 10;
					
					if (distanceTraveled < travelThreshold) {
						trace('Clicked thumbnail for debate ' + objects[i].debateID);
						
						// TODO fire on view?
						if (CDW.state.activeDebate != objects[i].debateID) {
							// deselect the active one
							activeThumbnail.selected = false;
							
							// select the new one
							activeThumbnail = objects[i];
							debateHolder.setChildIndex(activeThumbnail, debateHolder.numChildren - 1); // make sure the colored dots are on top 
							activeThumbnail.selected = true;
							CDW.state.setActiveDebate(activeThumbnail.debateID);
							CDW.view.transitionView();
						}
					}
				}
			}
		}
	}
}
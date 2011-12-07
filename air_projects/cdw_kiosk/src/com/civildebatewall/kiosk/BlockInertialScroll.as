package com.civildebatewall.kiosk {
	
	import com.greensock.TweenLite;
	import com.greensock.plugins.ThrowPropsPlugin;
	import com.kitschpatrol.futil.blocks.BlockBase;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.utils.getTimer;
	
	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.getLogger;
	
	public class BlockInertialScroll extends BlockBase {
		
		private static const logger:ILogger = getLogger(BlockInertialScroll);
		
		// Constants for constraining scroll axis
		public static const SCROLL_BOTH:String = "xy";
		public static const SCROLL_X:String = "x";
		public static const SCROLL_Y:String = "y";
		public var scrollAxis:String;
		
		// settings
		private var wiggleVelocityThreshold:Number = 2500; // How much mouse wiggle before we call it a drag instead of a click // TODO DO THIS ON VELOCITY
		private var wiggleTravelThreshold:Number = 40; // How much mouse wiggle before we call it a drag instead of a click // TODO DO THIS ON VELOCITY
		private var resistance:Number = 800;
		private var maxDuration:Number = 1; // max coast time, seconds
		private var minDuration:Number = 0.1; // min coast time, seconds
		private var overshootTolerance:Number = 0.25; // maximum time spent overshooting		
				
		// mouse blocker
		private var mouseBlocker:Sprite;
		private var isButtonPress:Boolean;

		// heuristics
		private var lastMouseX:Number;
		private var lastMouseY:Number;
		private var mouseTravel:Number;		
		private var mouseTravelX:Number;
		private var mouseTravelY:Number;		
		private var scrollStartX:Number;
		private var scrollStartY:Number;
		private var mouseStartX:Number;
		private var mouseStartY:Number;		
		
		private var time:Number;
		private var yVelocity:Number;
		private var xVelocity:Number;		
	  private var t1:uint;
	  private var t2:uint;
	  private var y1:Number;
	  private var y2:Number;
		private var x1:Number;
		private var x2:Number;
		private var coastTween:TweenLite;
		
		public var assumeButtons:Boolean; // always checks for buttons! // TODO make this a string mocal, with assumeScroll as well
		
		public function BlockInertialScroll(params:Object = null)	{
			assumeButtons = false; // default			
			
			super(params);
			
			// set initial scroll position
			scrollX = 0;
			scrollY = 0;			
			isButtonPress = false;
			
			this.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);			
		}
		
		protected function onMouseDown(e:MouseEvent):void {
			// stop any coasting, this is the "poke"
			if (coastTween != null) coastTween.kill();
			
			x1 = x2 = stage.mouseX;
			y1 = y2 = stage.mouseY;
			t1 = t2 = getTimer();
			
			scrollStartX = scrollX;
			scrollStartY = scrollY;
			mouseTravelX = 0;
			mouseTravelY = 0;
			mouseStartX = lastMouseX = stage.mouseX;
			mouseStartY = lastMouseY = stage.mouseY;
			time = 0;
			xVelocity = 0;
			yVelocity = 0;	

			this.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			this.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			this.stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp, false, -1);

			isButtonPress = assumeButtons ? true : isButtonUnderMouse(); // only discriminate between click and scroll if there's a button
			
			if (isButtonPress) {
				//trace("Could be button press.");
			}
			else {
				//trace("no buttons under there...");
			}
		}
		
		private function isButtonUnderMouse():Boolean {
			// are we over a button?
			var objectsUnderMouse:Array = stage.getObjectsUnderPoint(new Point(stage.mouseX, stage.mouseY));
			
			for (var i:int = 0; i < objectsUnderMouse.length; i++) {
				var displayObject:DisplayObject = objectsUnderMouse[i] as DisplayObject;
				if (displayObject.toString().indexOf("instance") > -1) return true; // ugh... long story
			}
			return false; // not a button!
		}
		
		
		private var zeroCount:int = 0;
		private var zeroPad:int = 5; // how many frames of zero before we actuall call it zero
		
		private var actualXVelocity:Number;
		private var actualYVelocity:Number;
		
		private function onEnterFrame(e:Event):void {				
			t2 = t1;
			t1 = getTimer();
			
			y2 = y1;
			y1 = stage.mouseY;
				
			x2 = x1;
			x1 = stage.mouseX;
			

			time = (t1 - t2) / 1000;
			actualXVelocity = (x1 - x2) / time;
			actualYVelocity = (y1 - y2) / time;	
			
			
			if (actualYVelocity == 0) {
				if(zeroCount > zeroPad) {
					yVelocity = actualYVelocity;	
				}
				zeroCount++;
			}
			else {
				yVelocity = actualYVelocity;
				zeroCount = 0;
			}
			
			if (actualXVelocity == 0) {
				if(zeroCount > zeroPad) {
					xVelocity = actualXVelocity;	
				}
				zeroCount++;
			}
			else {
				xVelocity = actualXVelocity;
				zeroCount = 0;
			}
		}		
		

		private function onMouseMove(e:MouseEvent):void {
			if (((scrollAxis == SCROLL_BOTH) && (isOverflowX || isOverflowY)) ||
				  ((scrollAxis == SCROLL_X) && isOverflowX) ||
					((scrollAxis == SCROLL_Y) && isOverflowY)) {
				
				// Actually scroll the window
				if ((scrollAxis == SCROLL_BOTH) || (scrollAxis == SCROLL_X)) scrollX = scrollStartX + (mouseStartX - stage.mouseX);
				if ((scrollAxis == SCROLL_BOTH) || (scrollAxis == SCROLL_Y)) scrollY = scrollStartY + (mouseStartY - stage.mouseY);
				
				if (isButtonPress) {
					// Mouse odometry
					mouseTravelX += Math.abs(stage.mouseX - lastMouseX);
					mouseTravelY += Math.abs(stage.mouseY - lastMouseY);		
					
					// velocity tells between a click and scroll
					var velocity:Number;
					var mouseTravel:Number;
	
					// Click or drag?
					if (scrollAxis == SCROLL_BOTH) {
						velocity = Math.max(xVelocity, yVelocity);
						mouseTravel = Math.sqrt((mouseTravelX * mouseTravelX) + (mouseTravelY * mouseTravelY));
					}
					else if (scrollAxis == SCROLL_X) {
						velocity = xVelocity;
						mouseTravel = mouseTravelY;
					}
					else if (scrollAxis == SCROLL_Y) {
						velocity = yVelocity;
						mouseTravel = mouseTravelX;
					}
				
					if ((Math.abs(velocity) > wiggleVelocityThreshold) || (mouseTravel > wiggleTravelThreshold)) {
						trace("Not a click.")
						disableChildren(content);
						isButtonPress = false;
					}
				}
				
				// Keep mouse history for comparison
				lastMouseX = stage.mouseX;
				lastMouseY = stage.mouseY;				
			}
		}
		
		private function onMouseUp(e:MouseEvent):void {
			// Remove listeners
			this.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			this.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);

			// zero velocity if we're out of bounds
			if ((scrollY > maxScrollY) || (scrollY < minScrollY)) yVelocity = 0;
			//if ((scrollX > maxScrollX) || (scrollX < minScrollX)) averageVelocity.x = 0;
			
			// Tween the flick
			var props:Object = {throwProps: {}};
				
			if ((scrollAxis == SCROLL_X) || (scrollAxis == SCROLL_BOTH)) {
				// X Stuff
				props.throwProps.scrollX = {};
				props.throwProps.scrollX.velocity = -xVelocity;
				props.throwProps.scrollX.min = minScrollX;
				props.throwProps.scrollX.max = maxScrollX;
				props.throwProps.scrollX.resistance = resistance; // coasting time (less is "heavier"!	
			}
			if ((scrollAxis == SCROLL_Y) || (scrollAxis == SCROLL_BOTH)) {
				// Y Stuff
				props.throwProps.scrollY = {};					
				props.throwProps.scrollY.velocity = -yVelocity;
				props.throwProps.scrollY.min = minScrollY;
				props.throwProps.scrollY.max = maxScrollY;
				props.throwProps.scrollY.resistance = resistance;
				
			}
				
			//trace("Velocity: " + yVelocity);
			
			// Stopped Here
			if (!isButtonPress) {
				coastTween =	ThrowPropsPlugin.to(this, props, maxDuration, minDuration, overshootTolerance);
				
				// Restore child mouse functionality
				enableChildren(content);
				// trace("Throw velocity was: " + xVelocity + " / " + yVelocity);
				// trace("Mouse travel was: " + mouseTravel);
			}
		}
		
		
		// Move to utility?
		// How to block mouse events from children?
		// This works for the children't event listeners, but what if they've put a listener on the stage!
		// You'd have to check mouseenabled manually inside your method.
		// Also, if you want an "onmousedisable" functionality, just override the setter
		
		private var formerlyEnabledObjects:Vector.<DisplayObjectContainer>;
		
		private function disableChildren(d:DisplayObjectContainer):void {
			formerlyEnabledObjects = new Vector.<DisplayObjectContainer>(0);
			disableChildrenSub(d);
		}
		
		private function disableChildrenSub(d:DisplayObjectContainer):void {
			if (d.mouseEnabled) {
				formerlyEnabledObjects.push(d);
				d.mouseEnabled = false;
			}

			for(var i:int = 0; i < d.numChildren; i++) {
				if (d.getChildAt(i) is DisplayObjectContainer) {
					disableChildrenSub(d.getChildAt(i) as DisplayObjectContainer);	
				}
			}
		}
		
		private function enableChildren(d:DisplayObjectContainer):void {
			if (formerlyEnabledObjects != null) {
				for (var i:int = 0; i < formerlyEnabledObjects.length; i++) {
					formerlyEnabledObjects[i].mouseEnabled = true;
				}
				formerlyEnabledObjects = new Vector.<DisplayObjectContainer>(0);
			}
		}

	}
}
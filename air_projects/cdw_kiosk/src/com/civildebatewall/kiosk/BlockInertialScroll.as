package com.civildebatewall.kiosk {
	
	import com.greensock.TweenMax;
	import com.greensock.easing.Quart;
	import com.greensock.plugins.ThrowPropsPlugin;
	import com.kitschpatrol.futil.blocks.BlockBase;
	
	import flash.display.DisplayObject;
	import flash.display.DisplayObjectContainer;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.utils.getTimer;
	
	
	public class BlockInertialScroll extends BlockBase {
		
		
		// Constants for constraining scroll axis
		public static const SCROLL_BOTH:String = "xy";
		public static const SCROLL_X:String = "x";
		public static const SCROLL_Y:String = "y";
		public var scrollAxis:String;
		
		// settings
		private var wiggleThreshold:Number = 75; // How much mouse wiggle before we call it a drag instead of a click
		private var resistance:Number = 800;
		private var maxDuration:Number = 2; // max coast time, seconds
		private var minDuration:Number = 0.25; // min coast time, seconds
		private var overshootTolerance:Number = 0.5; // maximum time spent overshooting		
				
		// mouse blocker
		private var mouseBlocker:Sprite;
		private var isClick:Boolean;

		// Drag Heuristics
		private var dragStartTime:uint;
		private var xVelocity:Number;
		private var yVelocity:Number;
		
		// my heuristics		
		private var lastMouseX:Number;
		private var lastMouseY:Number;
		private var mouseTravel:Number;		
		private var mouseTravelX:Number;
		private var mouseTravelY:Number;		
		private var scrollStartX:Number;
		private var scrollStartY:Number;
		private var mouseStartX:Number;
		private var mouseStartY:Number;
		
		
		public function BlockInertialScroll(params:Object = null)	{
			super(params);
			
			
			this.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);			
		}
		
		private function onMouseDown(e:MouseEvent):void {
			
			// stop any coasting, this is the "poke"
			TweenMax.killTweensOf(this);			
			
			// reset heuristics
			lastMouseX = stage.mouseX;
			lastMouseY = stage.mouseY;			
			mouseTravelX = 0;
			mouseTravelY = 0;
			dragStartTime = getTimer();
			
			scrollStartX = scrollX;
			scrollStartY = scrollY;
			mouseStartX = stage.mouseX;
			mouseStartY = stage.mouseY;
			
			isClick = true;

			this.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			this.stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp, false, 1);
		}
		
		
		private function onMouseMove(e:MouseEvent):void {
			// Actually scroll the window
			if((scrollAxis == SCROLL_BOTH) || (scrollAxis == SCROLL_X)) scrollX = scrollStartX + (mouseStartX - stage.mouseX);
			if((scrollAxis == SCROLL_BOTH) || (scrollAxis == SCROLL_Y)) scrollY = scrollStartY + (mouseStartY - stage.mouseY);
			
			// Mouse odometry
			mouseTravelX += Math.abs(stage.mouseX - lastMouseX);
			mouseTravelY += Math.abs(stage.mouseY - lastMouseY);
			
			// Click or drag?
			
			// use the mouse travel values that apply to the axis we're scrolling
			if(scrollAxis == SCROLL_BOTH) mouseTravel = Math.sqrt((mouseTravelX * mouseTravelX) + (mouseTravelY * mouseTravelY));
			else if(scrollAxis == SCROLL_X) mouseTravel = mouseTravelX;
			else if(scrollAxis == SCROLL_Y) mouseTravel = mouseTravelY;			
			
			if (isClick && (mouseTravel > wiggleThreshold)) {
				trace("Not a click.")
				disableChildren(content);
				isClick = false;
			}
			
			// Keep mouse history for comparison
			lastMouseX = stage.mouseX;
			lastMouseY = stage.mouseY;
		}
		
		
		private function onMouseUp(e:MouseEvent):void {
			// Remove listeners
			stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			this.removeEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			
			// Calculate mouse velocity
			var dragDuration:Number = (getTimer() - dragStartTime) / 1000;
			trace("Drag duration: " + dragDuration);	
			xVelocity = (scrollX - scrollStartX) / dragDuration;
			yVelocity = (scrollY - scrollStartY) / dragDuration;
			
			// Tween the flick
			var props:Object = {throwProps: {}};
				
			if ((scrollAxis == SCROLL_X) || (scrollAxis == SCROLL_BOTH)) {
				// X Stuff
				props.throwProps.scrollX = {};
				props.throwProps.scrollX.velocity = xVelocity;
				props.throwProps.scrollX.min = 0;
				props.throwProps.scrollX.max = maxScrollX;
				props.throwProps.scrollX.resistance = resistance; // coasting time (less is "heavier"!	
			}
			if ((scrollAxis == SCROLL_Y) || (scrollAxis == SCROLL_BOTH)) {
				// Y Stuff
				props.throwProps.scrollY = {};					
				props.throwProps.scrollY.velocity = yVelocity;
				props.throwProps.scrollY.min = 0;
				props.throwProps.scrollY.max = maxScrollY;
				props.throwProps.scrollY.resistance = resistance;					
			}
				
			props.ease = Quart.easeOut;
				
			// Stopped Here
			if (!isClick) {
				ThrowPropsPlugin.to(this, props, maxDuration, minDuration, overshootTolerance);
				
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
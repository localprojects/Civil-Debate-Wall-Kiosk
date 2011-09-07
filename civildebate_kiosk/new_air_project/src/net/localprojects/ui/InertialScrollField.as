package net.localprojects.ui {
	import com.greensock.*;
	import com.greensock.TweenMax;
	import com.greensock.easing.*;
	import com.greensock.plugins.ThrowPropsPlugin;
	
	import flash.display.*;
	import flash.display.Sprite;
	import flash.events.*;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	import flash.text.*;
	import flash.ui.Mouse;
	import flash.utils.getTimer;
	
	import net.localprojects.*;
	import net.localprojects.CDW;
	import net.localprojects.blocks.BlockBase;
	
	public class InertialScrollField extends Sprite {
		
		public static const SCROLL_BOTH:String = "scrollBoth";
		public static const SCROLL_X:String = "scrollX";
		public static const SCROLL_Y:String = "scrollY";
		
		public static const EVENT_NOT_CLICK:String = "notClick";		
		
		private var _scrollAxis:String;
		private var _containerWidth:Number;
		private var _containerHeight:Number;
		
		// settable
		public var scrollSheet:Sprite;
		public var xMin:Number = Number.MIN_VALUE;
		public var xMax:Number = Number.MAX_VALUE;
		public var yMin:Number = Number.MIN_VALUE;		
		public var yMax:Number = Number.MAX_VALUE;
		
		private var _backgroundColor:uint;
		private var _backgroundAlpha:Number;	
		private var _scrollAllowed:Boolean;
		
		
		private var scrollMask:Shape;
		private var dragBounds:Rectangle;
		
		// settings
		private var wiggleThreshold:Number = 75; // How much mouse wiggle before we call it a drag instead of a click
		private var resistance:Number = 800;
		private var maxDuration:Number = 2; // max coast time, seconds
		private var minDuration:Number = 0.25; // min coast time, seconds
		private var overshootTolerance:Number = 0.5; // maximum time spent overshooting		
		
		// heuristics
		private var t1:uint;
		private var t2:uint;
		private var x1:Number;
		private var x2:Number;
		private var y1:Number;
		private var y2:Number;		
		private var lastMouseX:Number;
		private var lastMouseY:Number;
		private var mouseTravelX:Number;
		private var mouseTravelY:Number;
		private var mouseTravel:Number; // axis-agnostic
		private var xVelocity:Number;
		private var yVelocity:Number;
		private var YOverlap:Number;		
		private var xOverlap:Number;
		
		public var isClick:Boolean; // clicking through the pane, else it's a scroll
		
		public function InertialScrollField(containerWidth:Number, containerHeight:Number, scrollAxis:String = SCROLL_Y) {
			super();
			
			_backgroundColor = 0xffffff;
			_backgroundAlpha = 1.0;			
			
			scrollSheet = new Sprite();
			addChild(scrollSheet);
			
			scrollMask = new Shape();
			addChild(scrollMask);
			
			scrollSheet.mask = scrollMask;
			scrollSheet.cacheAsBitmap = true;
			
			_containerWidth = containerWidth;
			_containerHeight = containerHeight;
			setContainerSize(_containerWidth , _containerHeight);
			
			dragBounds = new Rectangle();
			_scrollAxis = scrollAxis;
			setScrollAxis(_scrollAxis);
			
			_scrollAllowed = true;

			this.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
		}
		
		
		// creates and resizes the container defining the bounds of the scroll area
		public function setContainerSize(containerWidth:Number, containerHeight:Number):void {
			_containerWidth = containerWidth;
			_containerHeight = containerHeight;
			
			this.graphics.clear();
			this.graphics.beginFill(_backgroundColor, _backgroundAlpha);
			this.graphics.drawRect(0, 0, _containerWidth, _containerHeight);
			this.graphics.endFill();
			
			scrollMask.graphics.clear();
			scrollMask.graphics.beginFill(0x000000, 1);
			scrollMask.graphics.drawRect(0, 0, _containerWidth, _containerHeight);
			scrollMask.graphics.endFill();
		}
		
		
		private function setScrollAxis(scrollAxis:String):void {
			_scrollAxis = scrollAxis;
			
			// TODO what is with these numbers?			
			
			switch (_scrollAxis) {
				case SCROLL_BOTH:
					trace ('Scrolling both axes.');
					dragBounds = new Rectangle(-99999, -99999, 99999999, 99999999);
					break;
				case SCROLL_X:
					trace ('Scrolling X axis.');
					dragBounds =  new Rectangle(-99999, 0, 99999999, 0);					
					break;
				case SCROLL_Y:
					trace ('Scrolling Y axis.');
					dragBounds = new Rectangle(0, -99999, 0, 99999999);					
					break;
				default:
					trace ('Invalid axis.');
			}
		}
		
		
		// 
		private function onMouseDown(e:MouseEvent):void {
			// ignore clicks if we're "poking" at a moving
			// strip to stop it from inertially scrolling
			

			isClick = (!TweenMax.isTweening(scrollSheet));
			//isClick = true;
			
			// stop any coasting, this is the "poke"
			TweenMax.killTweensOf(scrollSheet);
			
			// reset heuristics
			// TODO direction restrictions?
			mouseTravelX = 0;
			mouseTravelY = 0;			
			lastMouseX = CDW.ref.stage.mouseX;
			lastMouseY = CDW.ref.stage.mouseY;
			x1 = x2 = scrollSheet.x;
			y1 = y2 = scrollSheet.y;
			t1 = t2 = getTimer();
			
			// follow the mouse
			if (_scrollAllowed) {
				scrollSheet.startDrag(false, dragBounds);
			}
			
			this.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			CDW.ref.stage.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		}
		
		
		private function onEnterFrame(event:Event):void {
			if (_scrollAllowed) {
				// Odometer for the mouse
				// Not just distance! cumulative to handle double-back situation
				mouseTravelX += Math.abs(CDW.ref.stage.mouseX - lastMouseX);
				mouseTravelY += Math.abs(CDW.ref.stage.mouseY - lastMouseY);			
				lastMouseX = CDW.ref.stage.mouseX;
				lastMouseY = CDW.ref.stage.mouseY;
				
				y2 = y1;
				x2 = x1;
				t2 = t1;
				y1 = scrollSheet.y;			
				x1 = scrollSheet.x;
				t1 = getTimer();
				
				// use the mouse travel values that apply to the axis we're scrolling
				if(_scrollAxis == SCROLL_BOTH) mouseTravel = mouseTravelX + mouseTravelY; // Take square root?
				else if(_scrollAxis == SCROLL_X) mouseTravel = mouseTravelX; // Take square root?
				else if(_scrollAxis == SCROLL_Y) mouseTravel = mouseTravelY; // Take square root?			
				
				// detect scroll vs. click			
				if (mouseTravel > wiggleThreshold) {
					this.dispatchEvent(new Event(EVENT_NOT_CLICK));	
					
					// cancel the click
					// child events still fire, but we can decide not
					// to actually act on them based on this public flag
					isClick = false;
				}
				
				// TODO manual dragging instead? Increase friction at bounds?
			}
		}
		
		private function onMouseUp(event:MouseEvent):void {
			// Hand it over to the throw tween
			scrollSheet.stopDrag();
			
			CDW.ref.stage.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			this.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			
			var time:Number = (getTimer() - t2) / 1000;
			xVelocity = (scrollSheet.x - x2) / time;
			yVelocity = (scrollSheet.y - y2) / time;
			
			if (_scrollAllowed && !isClick) {
				
				var props:Object = {throwProps: {}};
				
				if ((_scrollAxis == SCROLL_X) || (_scrollAxis == SCROLL_BOTH)) {
					// X Stuff
					props.throwProps.x = {};
					props.throwProps.x.velocity = xVelocity;
					props.throwProps.x.min = xMin; // always lands within min / max range
					props.throwProps.x.max = xMax;
					props.throwProps.x.resistance = resistance; // coasting time (less is "heavier"!	
				}
				if ((_scrollAxis == SCROLL_Y) || (_scrollAxis == SCROLL_BOTH)) {
					// Y Stuff
					props.throwProps.y = {};					
					props.throwProps.y.velocity = yVelocity;
					props.throwProps.y.min = yMin;
					props.throwProps.y.max = yMax;
					props.throwProps.y.resistance = resistance;					
				}
				
				props.ease = Quart.easeOut;
				
				// Stopped Here
				ThrowPropsPlugin.to(scrollSheet, props, maxDuration, minDuration, overshootTolerance);
				
				
				trace("Throw velocity was: " + xVelocity + " / " + yVelocity);
				trace("Mouse travel was: " + mouseTravel);			
			}
		}
		
		public function get containerWidth():Number {
			return _containerWidth;
		}
		
		public function set containerWidth(n:Number):void {
			_containerWidth = n;
			setContainerSize(_containerWidth, _containerHeight);			
			
		}
		
		public function get containerHeight():Number {
			return _containerHeight;
		}
		
		public function set containerHeight(n:Number):void {
			_containerHeight = n;
			setContainerSize(_containerWidth, _containerHeight);
		}	
		
		
		public function get scrollAllowed():Boolean {
			return _scrollAllowed;
		}
		
		public function set scrollAllowed(b:Boolean):void {
			_scrollAllowed = b;
		}			
		
		public function setBackgroundColor(c:uint, a:Number = 1.0):void {
			_backgroundColor = c;
			_backgroundAlpha = a;
			setContainerSize(_containerWidth, _containerHeight);			
		}
		
		public function scrollTo(x:Number, y:Number):void {
			TweenMax.to(scrollSheet, 1, {x: x, y: y, ease: Quart.easeInOut, roundProps:['x']});
		}
		
	}
}
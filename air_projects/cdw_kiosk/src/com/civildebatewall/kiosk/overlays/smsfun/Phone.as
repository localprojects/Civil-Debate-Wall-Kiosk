package com.civildebatewall.kiosk.overlays.smsfun {
	
	import com.civildebatewall.Assets;
	import com.greensock.TweenMax;
	import com.greensock.easing.Quart;
	import com.kitschpatrol.futil.utilitites.GraphicsUtil;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.Point;
	
	public class Phone extends Sprite	{
		
		// TODO use global constants here instead	
		public static var YES:int = 0;
		public static var NO:int = 1;
		private var type:int = 0;
		
		private var handset:Sprite;
		
		protected var screenHeight:Number;
		protected var screenWidth:Number;
		
		protected var yesBubble:Sprite;
		protected var noBubble:Sprite;
		
		// pointers...
		protected var activeBubble:Sprite;
		protected var inactiveBubble:Sprite;		

		public var popped:Boolean;
		
		protected var screen:Sprite;
		private var screenMask:Shape;	

		protected var centerY:Number;
		
		public function Phone(type:int)	{
			this.type = type;
			
			// Nominal pixel size 594 x 1118
			handset = (type == YES) ? Assets.getYesPhone() : Assets.getNoPhone();			
			handset.x = handset.width / -2;
			handset.y = handset.height / -2;	
			addChild(handset);
			
			// held constant for subsequent animation measurements
			screenWidth = 435;
			screenHeight = 736;
			
			screen = new Sprite();
			screen.graphics.beginFill(0xffffff);
			screen.graphics.drawRect(0, 0, screenWidth, screenHeight);
			screen.graphics.endFill();
			screen.x = screenWidth / -2;
			screen.y = -368;
			addChild(screen);		
			
			screenMask = new Shape();
			screenMask = GraphicsUtil.shapeFromSize(screenWidth, screenHeight, 0xff0000);
			screenMask.x = screen.x;
			screenMask.y = screen.y;
			addChild(screenMask);
			screen.mask = screenMask;
			
			// TODO start with message that matches type
			yesBubble = Assets.getYesBubble();
			yesBubble.scaleX = 4;
			yesBubble.scaleY = 4;
			yesBubble.x = (screenWidth / 2) - ((yesBubble.width * 4) / 2);	
			yesBubble.y = (screenHeight / 2) - ((yesBubble.height * 4) / 2);
			screen.addChild(yesBubble);

			noBubble = Assets.getNoBubble();
			noBubble.scaleX = 4;
			noBubble.scaleY = 4;
			noBubble.x = (screenWidth / 2) - ((noBubble.width * 4) / 2);
			noBubble.y = (screenHeight / 2) - ((noBubble.height * 4) / 2);	
			screen.addChild(noBubble);		
						
			// start with a message that's opposite of your type
			if (type == YES) {
				activeBubble = yesBubble;
				inactiveBubble = noBubble;				
			}
			else {
				activeBubble = noBubble;
				inactiveBubble = yesBubble;				
			}
						
			centerY = activeBubble.y;
			inactiveBubble.y = screenHeight + activeBubble.height;
			
			popped = false;			
		}
		
		public function popMessage():void {
			// fade out the old one
			inactiveBubble.y = screenHeight + activeBubble.height;

			TweenMax.to(activeBubble, .25, {y: -activeBubble.height, ease: Quart.easeInOut});
			TweenMax.to(inactiveBubble, .25, {y: centerY, ease: Quart.easeInOut});			
			
			// Swap them
			// activeBubble = activeBubble ^ inactiveBubble;
			// XoR is actually slower... http://lostinactionscript.com/2008/11/01/tips-on-how-to-write-efficient-as3-part-2/
			var temp:Sprite = activeBubble;
			activeBubble = inactiveBubble;
			inactiveBubble = temp;
		}
		
		public function get position():Point {
			return new Point(x, y);
		}
		
		public function set position(point:Point):void {
			x = point.x;
			y = point.y;
		}
		
		// for chaining
		public function setPosition(point:Point):Phone {
			position = point;
			return this;
		}
		
		// for chaining
		public function setScale(value:Number):Phone {
			scaleX = value;
			scaleY = value;
			return this;
		}
		
	}
}
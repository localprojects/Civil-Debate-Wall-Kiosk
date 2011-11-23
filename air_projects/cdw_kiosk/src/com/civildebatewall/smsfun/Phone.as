package com.civildebatewall.smsfun {
	
	
	import com.civildebatewall.Assets;
	import com.greensock.TimelineLite;
	import com.greensock.TimelineMax;
	import com.greensock.TweenLite;
	import com.greensock.TweenMax;
	import com.greensock.easing.Elastic;
	import com.greensock.easing.Quart;
	import com.kitschpatrol.futil.Math2;
	import com.kitschpatrol.futil.Random;
	import com.kitschpatrol.futil.easing.Ease;
	import com.kitschpatrol.futil.utilitites.GeomUtil;
	import com.kitschpatrol.futil.utilitites.GraphicsUtil;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.geom.Point;
	
	public class Phone extends Sprite	{

		
		public static var YES:int = 0;
		public static var NO:int = 1;
		private var type:int = 0;
		
		
		private var handset:Sprite;
		private var bubble:Sprite;
		private var screen:Shape;
		
		
		private var yesBubble:Sprite;
		private var noBubble:Sprite;
		
		private var timeline:TimelineLite;
		
		// black phone border?
		
		public function Phone(type:int = NaN)	{
			
			// pick randomly if none provided
			if (isNaN(type)) {
				this.type = int(Random.range(0, 2));
			}
			else {
				this.type = type;
			}
			
			screen = GraphicsUtil.shapeFromSize(129, 209, 0xffffff);
			screen.x = screen.width / -2;
			screen.y = -105;
			addChild(screen);	
			
			// Default size 158 x 298
			handset = (type == YES) ? Assets.getYesPhone() : Assets.getNoPhone();			
			handset.x = handset.width / -2;
			handset.y = handset.height / -2;	
			addChild(handset);
			
			yesBubble = Assets.getYesBubble();
			yesBubble.alpha = 0;
			addChild(yesBubble);
			
			noBubble = Assets.getNoBubble();
			noBubble.alpha = 0;
			addChild(noBubble);			
			
			
			var timeline:TimelineMax = new TimelineMax({repeat: -1, repeatDelay: 1});
			timeline.append(new TweenMax(yesBubble, 0, {transformAroundCenter:{scaleX: 0, scaleY: 0}, alpha: 1})); // init yes			
			timeline.append(new TweenMax(yesBubble, 1, {transformAroundCenter:{scaleX: 1, scaleY: 1}, alpha: 1, ease: Elastic.easeOut})); // sms up
			timeline.append(new TweenMax(yesBubble, 0.25, {transformAroundCenter:{scaleX: 3, scaleY: 3}, alpha: 0, ease: Quart.easeOut, delay: 3})); // sms pop			
			timeline.append(new TweenMax(noBubble, 0, {transformAroundCenter:{scaleX: 0, scaleY: 0}, alpha: 1})); // init yes			
			timeline.append(new TweenMax(noBubble, 1, {transformAroundCenter:{scaleX: 1, scaleY: 1}, alpha: 1, ease: Elastic.easeOut})); // sms up
			timeline.append(new TweenMax(noBubble, 0.25, {transformAroundCenter:{scaleX: 3, scaleY: 3}, alpha: 0, ease: Quart.easeOut, delay: 3})); // sms pop			
			
			
			
			
			timeline.play();
		
			
			
		}
		
		
		public function get position():Point {
			return new Point(x, y);
		}
		
		public function set position(point:Point):void {
			x = point.x;
			y = point.y;
		}
		
		
		
		
		
		
		
		// yes no timeline
		
		
		
		
		
	}
}
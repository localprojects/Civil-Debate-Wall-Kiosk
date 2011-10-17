package com.civildebatewall.wallsaver.sequences {
	import com.civildebatewall.resources.Assets;
	import com.civildebatewall.wallsaver.elements.MessageBanner;
	import com.greensock.TimelineMax;
	import com.greensock.TweenAlign;
	import com.greensock.TweenMax;
	import com.greensock.easing.*;
	import com.kitschpatrol.futil.utilitites.GraphicsUtil;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	
	
	public class CallToActionSequence extends Sprite implements ISequence {
		
		private var joinBanner1:MessageBanner;
		private var touchBanner1:MessageBanner;
		private var joinBanner2:MessageBanner;
		private var touchBanner2:MessageBanner;
		private var joinBanner3:MessageBanner;				
		
		public function CallToActionSequence() {
			super();
			
			var yOffset:Number = 123;
			
			// build the banners and their masks (TODO use blit thing?)
			joinBanner1= new MessageBanner(Assets.getJoinTheDebateText(), MessageBanner.BLUE);
			var screen1Mask:Shape = GraphicsUtil.shapeFromRect(Main.screens[0]);
			
			addChild(joinBanner1);
			addChild(screen1Mask);
			joinBanner1.mask = screen1Mask;
			joinBanner1.y = yOffset;
			
			touchBanner1 = new MessageBanner(Assets.getTouchToBeginText(), MessageBanner.ORANGE);
			var screen2Mask:Shape = GraphicsUtil.shapeFromRect(Main.screens[1]);
			
			addChild(touchBanner1);
			addChild(screen2Mask);
			touchBanner1.mask = screen2Mask;
			touchBanner1.y = yOffset;			
			
			joinBanner2 = new MessageBanner(Assets.getJoinTheDebateText(), MessageBanner.ORANGE);
			var screen3Mask:Shape = GraphicsUtil.shapeFromRect(Main.screens[2]);
			
			addChild(joinBanner2);
			addChild(screen3Mask);
			joinBanner2.mask = screen3Mask;
			joinBanner2.y = yOffset;	
			
			touchBanner2 = new MessageBanner(Assets.getTouchToBeginText(), MessageBanner.BLUE);			
			var screen4Mask:Shape = GraphicsUtil.shapeFromRect(Main.screens[3]);
			
			addChild(touchBanner2);
			addChild(screen4Mask);
			touchBanner2.mask = screen4Mask;			
			touchBanner2.y = yOffset;
			
			joinBanner3 = new MessageBanner(Assets.getJoinTheDebateText(), MessageBanner.BLUE);
			var screen5Mask:Shape = GraphicsUtil.shapeFromRect(Main.screens[4]);
			
			addChild(joinBanner3);
			addChild(screen5Mask);
			joinBanner3.mask = screen5Mask;
			joinBanner3.y = yOffset;			
		}
		
		public function getTimelineIn():TimelineMax	{
			return null;
		}
		
		public function getTimelineOut():TimelineMax {
			return null;
		}
		
		public function getTimeline():TimelineMax	{
			var timeline:TimelineMax = new TimelineMax({useFrames: true});
			
			// join banners in
			timeline.appendMultiple([
				TweenMax.fromTo(joinBanner1, 100, {x: Main.screens[0].x - joinBanner1.width}, {x: "1372", ease: Quart.easeOut, roundProps: ["x"]}),
				TweenMax.fromTo(joinBanner2, 100, {x: Main.screens[2].x - joinBanner2.width}, {x: "1372", ease: Quart.easeOut, roundProps: ["x"]}),
				TweenMax.fromTo(joinBanner3, 100, {x: Main.screens[4].x - joinBanner3.width}, {x: "1372", ease: Quart.easeOut, roundProps: ["x"]})
			], 50, TweenAlign.START, 0);
			
			
			// join banners out, touch banners in
			timeline.appendMultiple([
				TweenMax.to(joinBanner1, 100, {x: Main.screens[0].x + Main.screens[0].width, ease: Quart.easeInOut, roundProps: ["x"]}),
				TweenMax.fromTo(touchBanner1, 100, {x: Main.screens[1].x - touchBanner1.width}, {x: "1372", ease: Quart.easeInOut, roundProps: ["x"]}),				
				TweenMax.to(joinBanner2, 100, {x: Main.screens[2].x + Main.screens[2].width, ease: Quart.easeInOut, roundProps: ["x"]}),
				TweenMax.fromTo(touchBanner2, 100, {x: Main.screens[3].x - touchBanner1.width}, {x: "1372", ease: Quart.easeInOut, roundProps: ["x"]}),															 
				TweenMax.to(joinBanner3, 100, {x: Main.screens[4].x + Main.screens[4].width, ease: Quart.easeInOut, roundProps: ["x"]})
			], 150, TweenAlign.START, 0);			
			
			
			// touch banners out
			timeline.appendMultiple([
				TweenMax.to(touchBanner1, 100, {x: Main.screens[1].x + Main.screens[1].width, ease: Quart.easeIn, roundProps: ["x"]}),
				TweenMax.to(touchBanner2, 100, {x: Main.screens[3].x + Main.screens[3].width, ease: Quart.easeIn, roundProps: ["x"]}),
			], 150, TweenAlign.START, 0);			
			
			return timeline;
		}
	}
}
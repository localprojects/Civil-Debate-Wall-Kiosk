package com.civildebatewall.wallsaver.sequences {
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
			
			// build the banners and their masks (TODO use blit thing?)
			joinBanner1= new MessageBanner(Assets.getJoinTheDebateText(), MessageBanner.BLUE);
			var screen1Mask:Shape = GraphicsUtil.shapeFromRect(CivilDebateWallSaver.screens[0]);
			
			addChild(joinBanner1);
			addChild(screen1Mask);
			joinBanner1.mask = screen1Mask;
			
			
			touchBanner1 = new MessageBanner(Assets.getTouchToBeginText(), MessageBanner.ORANGE);
			var screen2Mask:Shape = GraphicsUtil.shapeFromRect(CivilDebateWallSaver.screens[1]);
			
			addChild(touchBanner1);
			addChild(screen2Mask);
			touchBanner1.mask = screen2Mask;
			
			
			joinBanner2 = new MessageBanner(Assets.getJoinTheDebateText(), MessageBanner.ORANGE);
			var screen3Mask:Shape = GraphicsUtil.shapeFromRect(CivilDebateWallSaver.screens[2]);
			
			addChild(joinBanner2);
			addChild(screen3Mask);
			joinBanner2.mask = screen3Mask;
			
			
			touchBanner2 = new MessageBanner(Assets.getTouchToBeginText(), MessageBanner.BLUE);			
			var screen4Mask:Shape = GraphicsUtil.shapeFromRect(CivilDebateWallSaver.screens[3]);
			
			addChild(touchBanner2);
			addChild(screen4Mask);
			touchBanner2.mask = screen4Mask;			
			
			
			joinBanner3 = new MessageBanner(Assets.getJoinTheDebateText(), MessageBanner.BLUE);
			var screen5Mask:Shape = GraphicsUtil.shapeFromRect(CivilDebateWallSaver.screens[4]);
			
			addChild(joinBanner3);
			addChild(screen5Mask);
			joinBanner3.mask = screen5Mask;
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
				TweenMax.fromTo(joinBanner1, 120, {x: CivilDebateWallSaver.screens[0].x - joinBanner1.width}, {x: "1372", ease: Expo.easeOut, roundProps: ["x"]}),
				TweenMax.fromTo(joinBanner2, 120, {x: CivilDebateWallSaver.screens[2].x - joinBanner2.width}, {x: "1372", ease: Expo.easeOut, roundProps: ["x"]}),
				TweenMax.fromTo(joinBanner3, 120, {x: CivilDebateWallSaver.screens[4].x - joinBanner3.width}, {x: "1372", ease: Expo.easeOut, roundProps: ["x"]})
			], 0, TweenAlign.START, 0);
			
			
			// join banners out, touch banners in
			timeline.appendMultiple([
				TweenMax.to(joinBanner1, 120, {x: CivilDebateWallSaver.screens[0].x + CivilDebateWallSaver.screens[0].width, ease: Expo.easeInOut, roundProps: ["x"]}),
				TweenMax.fromTo(touchBanner1, 120, {x: CivilDebateWallSaver.screens[1].x - touchBanner1.width}, {x: "1372", ease: Expo.easeInOut, roundProps: ["x"]}),				
				TweenMax.to(joinBanner2, 120, {x: CivilDebateWallSaver.screens[2].x + CivilDebateWallSaver.screens[2].width, ease: Expo.easeInOut, roundProps: ["x"]}),
				TweenMax.fromTo(touchBanner2, 120, {x: CivilDebateWallSaver.screens[3].x - touchBanner1.width}, {x: "1372", ease: Expo.easeInOut, roundProps: ["x"]}),															 
				TweenMax.to(joinBanner3, 120, {x: CivilDebateWallSaver.screens[4].x + CivilDebateWallSaver.screens[4].width, ease: Expo.easeInOut, roundProps: ["x"]})
			], 150, TweenAlign.START, 0);			
			
			
			// touch banners out
			timeline.appendMultiple([
				TweenMax.to(touchBanner1, 120, {x: CivilDebateWallSaver.screens[1].x + CivilDebateWallSaver.screens[1].width, ease: Expo.easeIn, roundProps: ["x"]}),
				TweenMax.to(touchBanner2, 120, {x: CivilDebateWallSaver.screens[3].x + CivilDebateWallSaver.screens[3].width, ease: Expo.easeIn, roundProps: ["x"]}),
			], 150, TweenAlign.START, 0);			
			
			return timeline;
		}
	}
}
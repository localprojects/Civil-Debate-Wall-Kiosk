package com.civildebatewall.wallsaver.sequences {
	import com.civildebatewall.resources.Assets;
	import com.civildebatewall.wallsaver.core.WallSaver;
	import com.greensock.TimelineMax;
	import com.greensock.TweenAlign;
	import com.greensock.TweenMax;
	import com.greensock.easing.Quart;
	import com.kitschpatrol.futil.blocks.BlockText;
	import com.kitschpatrol.futil.utilitites.GeomUtil;
	import com.kitschpatrol.futil.utilitites.GraphicsUtil;
	
	import flash.display.Bitmap;
	import flash.display.Shape;
	import flash.display.Sprite;
	
	public class TitleSequence extends Sprite implements ISequence {		
		
		private var underlay:Shape;
		private var maskShape:Shape;
		private var theTitle:Bitmap;
		private var wallTitle:Bitmap;
		private var tagline:Bitmap;
		private var chevronA:Bitmap;
		private var chevronB:Bitmap;	
		private var chevronC:Bitmap;
		private var topBar:Shape;
		private var bottomBar:Shape;
		private var question:BlockText;

		public function TitleSequence()	{
			super();
			
			underlay = new Shape();
			GraphicsUtil.fillRect(underlay.graphics, 1080, 1920, 0xffffff);
			underlay.alpha = 0;
			addChild(underlay);	
			
			// keep this screen masked... TODO fill the background with white?
			maskShape = GraphicsUtil.shapeFromRect(Main.screens[0]);
			addChild(maskShape);
			this.mask = maskShape;

			// chevrons go below title text
			chevronA = Assets.getTitleChevron();
			chevronA.y = 277;
			addChild(chevronA);
			
			chevronB = Assets.getTitleChevron();
			chevronB.y = 277;
			addChild(chevronB);
			
			chevronC = Assets.getTitleChevron();	
			chevronC.y = 277;
			addChild(chevronC);			
			
			theTitle = Assets.getTheText();
			addChild(theTitle);
			
			wallTitle = Assets.getWallText();
			addChild(wallTitle);
			
			tagline = Assets.getTaglineText();
			tagline.y = 777;
			addChild(tagline);
			
			topBar = GraphicsUtil.shapeFromSize(962, 6, Assets.COLOR_YES_LIGHT);
			topBar.x = 59;
			addChild(topBar);
			
			bottomBar = GraphicsUtil.shapeFromSize(962, 6, Assets.COLOR_NO_LIGHT);
			bottomBar.x = 59;
			addChild(bottomBar);
			
			// TODO get question from server
			question = new BlockText({
				width: 962,
				height: 847,
				textFont: Assets.FONT_REGULAR,
				textColor: 0x000000,
				backgroundAlpha: 0,
				textSize: 62,
				leading: 57,
				text: "Do you feel our public education provides our children with a very thorough education?",
				visible: true,
				y: 950
			});
			addChild(question);
			
		}
		
		
		public function getTimelineIn():TimelineMax	{
			var timelineIn:TimelineMax = new TimelineMax({useFrames: true});

			// centered y positions
			var theTitleY:Number = (1920 - (theTitle.height + 48 + wallTitle.height)) / 2;
			var wallTitleY:Number =  theTitleY + theTitle.height + 48;
			
			// show the underline
			
			// tween in the titles
			timelineIn.appendMultiple([
				TweenMax.fromTo(theTitle, 60, {x: 1080, y: theTitleY}, {x: 59, y: theTitleY, ease: Quart.easeInOut}),
				TweenMax.fromTo(wallTitle, 60, {x: -wallTitle.width, y: wallTitleY}, {x: 59, y: wallTitleY, ease: Quart.easeInOut}),
			]);
			
			timelineIn.append(TweenMax.fromTo(underlay, 0, {alpha: 0}, {alpha: 1}));			
			
			timelineIn.appendMultiple([
				TweenMax.to(theTitle, 60, {y: 277, ease: Quart.easeInOut}),
				TweenMax.to(wallTitle, 60, {y: 277 + theTitle.height + 48, ease: Quart.easeInOut})			
			]);
			
			// bring in the tagline
			timelineIn.appendMultiple([
				TweenMax.fromTo(tagline, 40, {x: 1080}, {x: 59, ease: Quart.easeInOut})
			], -30);
			
			// fade in the chevrons
			timelineIn.appendMultiple([
				TweenMax.fromTo(chevronA, 60, {x: 640, alpha: 0}, {x: 950, alpha: 1, ease: Quart.easeOut}),
				TweenMax.fromTo(chevronB, 60, {x: 640, alpha: 0}, {x: 889, alpha: 1, ease: Quart.easeOut}),
				TweenMax.fromTo(chevronC, 60, {x: 640, alpha: 0}, {x: 828, alpha: 1, ease: Quart.easeOut})
			], -30, TweenAlign.START, 20);
			
			// bring in the top and bottom bars			
			timelineIn.appendMultiple([
				TweenMax.fromTo(topBar, 60, {y: -topBar.height, alpha: 0}, {y: 217, alpha: 1, ease: Quart.easeOut}),
				TweenMax.fromTo(bottomBar, 60, {y: 1920, alpha: 0}, {y: 869, alpha: 1, ease: Quart.easeOut})
			], -100);

			// scroll in the question
			timelineIn.appendMultiple([
				TweenMax.fromTo(question, 60, {x: -question.width}, {x: 59, ease: Quart.easeOut})
			], -80);
			
			return timelineIn;
		}
		
		public function getTimelineOut():TimelineMax {
			// Just flip the in timeline
			var timelineOut:TimelineMax = new TimelineMax({useFrames: true});

			
			// centered y positions
			var theTitleY:Number = (1920 - (theTitle.height + 48 + wallTitle.height)) / 2;
			var wallTitleY:Number =  theTitleY + theTitle.height + 48;
			
			// scroll out the question
			timelineOut.appendMultiple([
				TweenMax.fromTo(question, 100, {x: 59}, {x: 1080, ease: Quart.easeIn})
			]);
			
			// fade out the chevrons
			timelineOut.appendMultiple([
				TweenMax.fromTo(chevronA, 60, {x: 950, alpha: 1, ease: Quart.easeIn}, {x: 1080, alpha: 0}),
				TweenMax.fromTo(chevronB, 60, {x: 889, alpha: 1, ease: Quart.easeIn}, {x: 1080, alpha: 0}),
				TweenMax.fromTo(chevronC, 60, {x: 828, alpha: 1, ease: Quart.easeIn}, {x: 1080, alpha: 0})
			], -30, TweenAlign.START, 20);			
			
			
			// send outin the top and bottom bars			
			timelineOut.appendMultiple([
				TweenMax.fromTo(topBar, 60, {y: 217, alpha: 1, ease: Quart.easeIn}, {y: -topBar.height, alpha: 0}),
				TweenMax.fromTo(bottomBar, 60, {y: 869, alpha: 1, ease: Quart.easeIn}, {y: 1920, alpha: 0})
			], -100);
			
			// send out the tagline
			timelineOut.appendMultiple([
				TweenMax.fromTo(tagline, 40, {x: 59, ease: Quart.easeInOut}, {x: 1080})
			], -30);
			
			
			// remove title, push down
			timelineOut.appendMultiple([
				TweenMax.to(theTitle, 60, {y: theTitleY, ease: Quart.easeInOut}),
				TweenMax.to(wallTitle, 60, {y: wallTitleY, ease: Quart.easeInOut})			
			]);			
			
			timelineOut.append(TweenMax.fromTo(underlay, 0, {alpha: 1}, {alpha: 0}));			
			
			// send titles out
			timelineOut.appendMultiple([
				TweenMax.fromTo(theTitle, 60, {x: 59, y: theTitleY, ease: Quart.easeInOut}, {x: 1080, y: theTitleY}),
				TweenMax.fromTo(wallTitle, 60, {x: 59, y: wallTitleY, ease: Quart.easeInOut}, {x: -wallTitle.width, y: wallTitleY}),
			]);

			return timelineOut;
		}
		
		public function getTimeline():TimelineMax {
			var timeline:TimelineMax = new TimelineMax({useFrames: true});
			timeline.append(getTimelineIn());
			timeline.append(getTimelineOut());
			return timeline;
		}			
		
	}
}
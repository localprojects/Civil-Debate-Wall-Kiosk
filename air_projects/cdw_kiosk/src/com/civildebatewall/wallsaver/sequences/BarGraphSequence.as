package com.civildebatewall.wallsaver.sequences {
	import com.civildebatewall.Assets;
	import com.civildebatewall.CivilDebateWall;
	import com.civildebatewall.wallsaver.elements.ArrowBanner;
	import com.civildebatewall.wallsaver.elements.GraphCounter;
	import com.greensock.TimelineMax;
	import com.greensock.TweenAlign;
	import com.greensock.TweenMax;
	import com.greensock.easing.Quart;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.PixelSnapping;
	import flash.display.Sprite;
	import flash.geom.Point;
	
	// Yes / No bar graphs
	public class BarGraphSequence extends Sprite implements ISequence {
		
		private const arrowWidth:int = 296;
		private const arrowHeight:int = 1674;		
		
		// TODO get these from back end
		private var yesResponses:int = 215;
		private var noResponses:int = 15;
		// END back end
		
		private var scrollVelocity:Number;		
		private var yesWidth:int;
		private var noWidth:int;
		
		private var yesBar:Sprite;
		private var noBar:Sprite;
		private var yesBarMask:Sprite;		
		private var noBarMask:Sprite;
		
		private var counter:GraphCounter;
		private var yesText:Bitmap;
		private var noText:Bitmap;
		private var labelLine:Bitmap;
		
		// white versions
		private var whiteLayer:Sprite;
		private var counterWhite:GraphCounter;
		private var yesTextWhite:Bitmap;
		private var noTextWhite:Bitmap;
		private var labelLineWhite:Bitmap;		

		
		public function BarGraphSequence() {
			super();
			
			// Settings
			scrollVelocity = 30;
			
			// Parse stats
			var totalResponses:int = yesResponses + noResponses;
			
			// raw width
			yesWidth = Math.round((yesResponses / totalResponses) * (CivilDebateWall.flashSpan.settings.totalWidth - CivilDebateWall.flashSpan.settings.physicalScreenWidth)); // less one screen
			noWidth = Math.round((noResponses / totalResponses) * (CivilDebateWall.flashSpan.settings.totalWidth - CivilDebateWall.flashSpan.settings.physicalScreenWidth)); // less one screen			
			
			// first, find where the division between the graphs falls
			
			
			
			var borderIndex:int = CivilDebateWall.flashSpan.pointIsNearScreen(new Point(yesWidth + CivilDebateWall.flashSpan.settings.physicalScreenWidth, CivilDebateWall.flashSpan.settings.totalHeight / 2));
			var labelIndex:int;
			
			
			if (noWidth <= yesWidth) {
				// no is first, and no comes in from the right, so put it one screen to the left of the no border screen
				labelIndex = Math.max(Math.min(borderIndex - 1, 4), 0);
			}
			else {
				// yes is first, and yes comes in from the left, so put it one screen to the right of the yes border screen
				labelIndex = Math.max(Math.min(borderIndex + 1, 4), 0);
			}
			
			// label bar
			labelLine = new Bitmap(new BitmapData(702, 9, false, 0xffffff), PixelSnapping.ALWAYS);
			labelLine.x = CivilDebateWall.flashSpan.settings.screens[labelIndex].x + 189;
			labelLine.y = (1920 / 2) - (labelLine.height / 2);
			
			labelLineWhite = new Bitmap(labelLine.bitmapData.clone(), PixelSnapping.ALWAYS);			
			
			// label counter
			counter = new GraphCounter();
			counter.x = CivilDebateWall.flashSpan.settings.screens[labelIndex].x + 189;
			counter.y = labelLine.y + labelLine.height + 100;
			
			counterWhite = new GraphCounter();
			// position gets updated dynamically to match color counter
			
			// yes and no labels
			yesText = Assets.getGraphLabelYes();
			yesText.x = labelLine.x;
			yesTextWhite = Assets.getGraphLabelYes();
						
			noText = Assets.getGraphLabelNo();
			noText.x = labelLine.x + 46; // centered			
			noTextWhite = Assets.getGraphLabelNo();

			// colorize, yes and no are permanent
			TweenMax.to(yesText, 0, {colorTransform: {tint: Assets.COLOR_YES_LIGHT, tintAmount: 1}});			
			TweenMax.to(noText, 0, {colorTransform: {tint: Assets.COLOR_NO_LIGHT, tintAmount: 1}});
			// line and counter color is dynamic, set in timeline
			
			// no graph points left
			noBar = new ArrowBanner(noWidth, arrowWidth, arrowHeight, Assets.COLOR_NO_LIGHT, ArrowBanner.LEFT);
			noBarMask = new ArrowBanner(noWidth, arrowWidth, arrowHeight, 0, ArrowBanner.LEFT);
			yesBar = new ArrowBanner(yesWidth, arrowWidth, arrowHeight, Assets.COLOR_YES_LIGHT, ArrowBanner.RIGHT);
			yesBarMask = new ArrowBanner(yesWidth, arrowWidth, arrowHeight, 0, ArrowBanner.RIGHT);
			
			noBar.y = 123;
			noBarMask.y = 123;			
			yesBar.y = 123;
			yesBarMask.y = 123;			
			
			// Put all the white stuff in on container so we can use a single mask			
			whiteLayer = new Sprite();
			
			// color goes under bars
			addChild(labelLine);
			addChild(yesText);			
			addChild(noText);	
			addChild(counter);		
			
			// make sure the bars are added
			// in the correct order
			if (noResponses <= yesResponses) {
				// no is first
				addChild(noBar);
				addChild(yesBar);
				addChild(yesBarMask);
				
				whiteLayer.mask = yesBarMask;
			}
			else {
				// yes is first
				addChild(yesBar);
				addChild(noBar);
				addChild(noBarMask);
				
				counterWhite.mask = noBarMask;
				labelLineWhite.mask = noBarMask;
				noTextWhite.mask = noBarMask;
				yesTextWhite.mask = noBarMask;
			}
			
			// white goes over bars
			whiteLayer.addChild(counterWhite);
			whiteLayer.addChild(labelLineWhite);
			whiteLayer.addChild(yesTextWhite);
			whiteLayer.addChild(noTextWhite);
			addChild(whiteLayer);
		}

		
		// binds white overlay positions to the main object
		private function updateWhiteOverlays():void {
			// update overlays
			counterWhite.x = counter.x;
			counterWhite.y = counter.y;
			counterWhite.count = counter.count;			
			
			labelLineWhite.x = labelLine.x;
			labelLineWhite.y = labelLine.y;
			
			yesTextWhite.x = yesText.x;
			yesTextWhite.y = yesText.y;			
		
			noTextWhite.x = noText.x;
			noTextWhite.y = noText.y;				
			
			// update masks, too
			yesBarMask.x = yesBar.x;
			yesBarMask.y = yesBar.y;
			
			noBarMask.y = noBar.y;			
			noBarMask.x = noBar.x;
		}
		
		
		public function getTimelineIn():TimelineMax	{
			var timelineIn:TimelineMax = new TimelineMax({useFrames: true, onUpdate: updateWhiteOverlays}); // keep the white overlays aligned with their color representations

			var yesBarScrollDuration:int = (yesBar.width - arrowWidth) / scrollVelocity;			
			var yesBarTweenIn:TweenMax = TweenMax.fromTo(yesBar, yesBarScrollDuration, {x: -yesBar.width + CivilDebateWall.flashSpan.settings.physicalScreenWidth}, {x: -arrowWidth + CivilDebateWall.flashSpan.settings.physicalScreenWidth, ease: Quart.easeOut});
			
			var noBarScrollDuration:int = (CivilDebateWall.flashSpan.settings.totalWidth - CivilDebateWall.flashSpan.settings.physicalScreenWidth - noWidth - arrowWidth)  / scrollVelocity;						
			var noBarTweenIn:TweenMax = TweenMax.fromTo(noBar, noBarScrollDuration, {x: CivilDebateWall.flashSpan.settings.totalWidth}, {x: CivilDebateWall.flashSpan.settings.totalWidth - noWidth - arrowWidth, ease: Quart.easeOut});			

			// Smaller bar scrolls in first
			if (noResponses <= yesResponses) {
				
				// No bar and label in (Design calls for steps, look sbetter simultaneously.
				// tween to orange, complicated because of the shader
				timelineIn.appendMultiple([
					TweenMax.fromTo(labelLine, 1, {visible:false}, {visible: true}),
					TweenMax.fromTo(noText, 1, {visible:false}, {visible: true}),
					TweenMax.fromTo(yesText, 1, {visible:false}, {visible: true}),
					TweenMax.fromTo(counter, 1, {visible:false}, {visible: true}),		
					TweenMax.fromTo(labelLineWhite, 1, {visible:false}, {visible: true}),					
					TweenMax.fromTo(noTextWhite, 1, {visible:false}, {visible: true}),
					TweenMax.fromTo(yesTextWhite, 1, {visible:false}, {visible: true}),
					TweenMax.fromTo(counterWhite, 1, {visible:false}, {visible: true}),
					TweenMax.fromTo(noBar, 1, {visible:false}, {visible: true}),
					TweenMax.fromTo(yesBar, 1, {visible:false}, {visible: true}),
					
					noBarTweenIn,
					
					TweenMax.to(labelLine, 0, {colorTransform: {tint: Assets.COLOR_NO_LIGHT, tintAmount: 1}}),
					TweenMax.to(counter, 0, {colorTransform: {tint: Assets.COLOR_NO_LIGHT, tintAmount: 1}}),
					
					// fade stuff in quickly
					TweenMax.fromTo(labelLine, 30, {alpha: 0}, {alpha: 1, ease: Quart.easeOut}),
					TweenMax.fromTo(counter, 30, {alpha: 0}, {alpha: 1, ease: Quart.easeOut}),
					TweenMax.fromTo(noText, 30, {alpha: 0}, {alpha: 1, ease: Quart.easeOut}),					

					// count up
					TweenMax.fromTo(counter, noBarScrollDuration, {count: 0}, {count: noResponses, ease: Quart.easeOut}),
					TweenMax.fromTo(noText, 60, {y: -noText.height}, {y: labelLine.y - 323, ease: Quart.easeOut})
				], 0, TweenAlign.START);
				
				// No label out, yes bar and label in
				timelineIn.appendMultiple([
					// remove the no
					TweenMax.to(noText, 60, {alpha: 0, ease: Quart.easeOut}),
					TweenMax.to(noText, 60, {y: 1920, ease: Quart.easeOut}),

					// fade in the yes text
					TweenMax.fromTo(yesText, 30, {alpha: 0}, {alpha: 1, ease: Quart.easeOut}),					
					TweenMax.fromTo(yesText, 60, {y: -yesText.height}, {y: labelLine.y - 323, ease: Quart.easeOut}),					
					
					// change the line and counter color
					TweenMax.to(labelLine, 60, {colorTransform: {tint: Assets.COLOR_YES_LIGHT, tintAmount: 1}}),
					TweenMax.to(counter, 60, {colorTransform: {tint: Assets.COLOR_YES_LIGHT, tintAmount: 1}}),
					
					TweenMax.to(counter, yesBarScrollDuration, {count: yesResponses, ease: Quart.easeOut}),

					TweenMax.to(yesBar, 0, {visible: true}),
					yesBarTweenIn					
					
				], 120, TweenAlign.START);				
			}
			else {
				// TODO after above is solid				
			}

			return timelineIn;
		}
		
		public function getTimelineOut():TimelineMax {

			var timelineOut:TimelineMax = new TimelineMax({useFrames: true});			
			
			// Graphs out
			var yesBarOutDuration:int = (yesBar.width - arrowWidth)  / (scrollVelocity - 10); // a bit slower to compensate for easing
			var noBarOutDuration:int = (CivilDebateWall.flashSpan.settings.totalWidth - noWidth - arrowWidth)  / (scrollVelocity - 10);
			
			timelineOut.appendMultiple([
				TweenMax.to(labelLine, 1, {visible: false}),
				TweenMax.to(noText, 1, {visible: false}),
				TweenMax.to(yesText, 1, {visible: false}),
				TweenMax.to(counter, 1, {visible: false}),	
				TweenMax.to(noBar, noBarOutDuration, {x: -noBar.width + CivilDebateWall.flashSpan.settings.physicalScreenWidth, ease: Quart.easeIn}),
				TweenMax.to(yesBar, yesBarOutDuration, {x: CivilDebateWall.flashSpan.settings.totalWidth, ease: Quart.easeIn})
			], 100, TweenAlign.START);			

			timelineOut.appendMultiple([
				TweenMax.to(noBar, 1, {visible: false}),
				TweenMax.to(yesBar, 1, {visible: false}),				
				TweenMax.to(labelLineWhite, 1, {visible: false}),					
				TweenMax.to(noTextWhite, 1, {visible: false}),
				TweenMax.to(yesTextWhite, 1, {visible: false}),
				TweenMax.to(counterWhite, 1, {visible: false}),			
			], 0, TweenAlign.START);

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
package com.civildebatewall.wallsaver.sequences {
	import avmplus.FLASH10_FLAGS;
	
	import com.civildebatewall.CivilDebateWall;
	import com.civildebatewall.data.Data;
	import com.civildebatewall.data.Post;
	import com.civildebatewall.wallsaver.elements.OpinionBanner;
	import com.civildebatewall.wallsaver.elements.OpinionRow;
	import com.greensock.TimelineMax;
	import com.greensock.TweenAlign;
	import com.greensock.TweenMax;
	import com.greensock.easing.Linear;
	import com.greensock.easing.Quart;
	import com.kitschpatrol.flashspan.FlashSpan;
	import com.kitschpatrol.flashspan.Settings;
	import com.kitschpatrol.futil.utilitites.GraphicsUtil;
	import com.kitschpatrol.futil.utilitites.StringUtil;
	
	import flash.display.Sprite;
	import flash.events.Event;
	
	// Scrolling User Opinions
	public class OpinionSequence extends Sprite implements ISequence {
		
		// TODO replace with backend
		private var maxQuotes:int;
		private var quotes:Vector.<Post>;
		
		// END Back end		
		
		// Settings
		private var vxIntro:Number;
		private var vxMiddle:Number;
		private var vxOutro:Number;
		private var easeIntroFrames:int;
		private var easeOutroFrames:int;		
		
		// Internal
		private var opinionRows:Vector.<OpinionRow>;		
		
		
		public function OpinionSequence()	{
			super();	
			CivilDebateWall.data.addEventListener(Data.DATA_UPDATE_EVENT, onDataUpdate);
		}
		
		private function compareRowLength(a:OpinionRow, b:OpinionRow):Number {
			return a.width - b.width;			
		}
		
		
		private function compareBannerDate(a:OpinionBanner, b:OpinionBanner):Number {
			// sorts by date, newest first	
			return b.post.created.time - a.post.created.time;
		}
		
		private function onDataUpdate(e:Event):void {

			// clear everything
			GraphicsUtil.removeChildren(this);
			quotes = new Vector.<Post>;
			

			// Settings
			maxQuotes = 40;
			vxIntro = 50;
			vxMiddle = 15; // but only for the longest row, all others are slower!
			vxOutro = 50;
			easeIntroFrames = 500;
			easeOutroFrames = 500;
			
			// Try to get the number required. If there aren't enough, get as many as possible.
			var quoteCount:int = Math.min(maxQuotes, CivilDebateWall.data.posts.length);
			
			for (var k:int = 0; k < quoteCount; k++) {
				// most recent first? // some other selection filter here?
				quotes.push(CivilDebateWall.data.posts[k]);
			}			
			
			// generate the display quotes
			var yesQuotes:Vector.<OpinionBanner> = new Vector.<OpinionBanner>;
			var noQuotes:Vector.<OpinionBanner> = new Vector.<OpinionBanner>;
			for each (var quote:Post in quotes) {
				if (quote.stance == Post.STANCE_YES) {
					yesQuotes.push(new OpinionBanner(quote));
				}
				else {
					noQuotes.push(new OpinionBanner(quote));
				}
			}
			
			// sort the quotes by date
			yesQuotes = yesQuotes.sort(compareBannerDate);
			noQuotes = noQuotes.sort(compareBannerDate);
			
			
			// Generate the quote rows
			opinionRows = new Vector.<OpinionRow>(5);
			
			for (var i:int = 0; i < opinionRows.length; i++) {
				var quoteLine:OpinionRow = new OpinionRow();
				quoteLine.x = 1080 + CivilDebateWall.flashSpan.settings.bezelWidth;
				quoteLine.y = 123 + (i * 357);
				addChild(quoteLine);
				
				// alternating stances
				if (i % 2 == 0) {
					quoteLine.lastStance = Post.STANCE_NO;
				}
				else {
					quoteLine.lastStance = Post.STANCE_YES;					
				}

				opinionRows[i] = quoteLine;
			}			
			
			// add opinions to rows
			while ((yesQuotes.length > 0) && (noQuotes.length > 0)) {
				// find the shortest row
				var shortestRow:OpinionRow = opinionRows.sort(compareRowLength)[0];

				
				// alternate stances
				var opinionBanner:OpinionBanner;
				if (shortestRow.lastStance == Post.STANCE_YES) {
					opinionBanner = noQuotes.pop();
					shortestRow.lastStance = Post.STANCE_NO;
				}
				else {
					opinionBanner = yesQuotes.pop();
					shortestRow.lastStance = Post.STANCE_YES;					
				}
				
				// not the first, move it to the right
				if (shortestRow.width > 0) {
					opinionBanner.x = shortestRow.width + 130;
					opinionBanner.y = 0;
				}
				
				shortestRow.addChild(opinionBanner);
			}
			
			// flip first, third, and fourth so they start as yes? Can't guarantee that a row will end on a "yes" or "no"
			// just keep them random for now,

			// sort the rows, shortest first
			opinionRows = opinionRows.sort(compareRowLength);
			
			
			/*
			
			// Contruction done, now pre-calculate animation

			// Find longest row, this sets bounds for the rest of the 
			var longestRow:OpinionRow = opinionRows[0];
			for (var l:int = 1; l < opinionRows.length; l++) {			
				if (opinionRows[l].width > longestRow.width) longestRow = opinionRows[l];
			}
			
			// var start:int = getTimer();
			
			// First, calculate the longest row, since it determines the middle velocity of the rest
			longestRow.calculateFrames(vxIntro, vxMiddle, vxOutro, easeIntroFrames, easeOutroFrames);
			
			// Now calculate the rest, based on the longest row's total duration
			for (var j:int = 0; j < opinionRows.length; j++) {			
				if (opinionRows[j] != longestRow) {
					//vxMiddle = (quoteRows[k].width) / (longestRow.totalFrames - longestRow.introFrameCount - longestRow.outroFrameCount);
					// TODO a better guess at the vxMiddle before iterating towards it?
					opinionRows[j].calculateFrames(vxIntro, vxMiddle, vxOutro, easeIntroFrames, easeOutroFrames, longestRow.totalFrames);
				}
			}
			
//			// Debug, review how long it took to generate velocities.
//			MonsterDebugger.trace(this, "Calculated opinion rows middle velocities in " + (getTimer() - start) + "ms.");
//			for each(var row:OpinionRow in opinionRows) {
//				MonsterDebugger.trace(this, "Frames: " + row.totalFrames);
//			}
			
			*/
			
		}
		
		
		public function getTimelineIn():TimelineMax	{
			return null;
		}
		
		
		public function getTimelineOut():TimelineMax {
			return null;
		}
		
		
		public function getTimeline():TimelineMax	{
			var timeline:TimelineMax = new TimelineMax({useFrames: true});
			
			var flashSpanSettings:Settings = CivilDebateWall.flashSpan.settings;
			var scrollVelocity:Number = 10;
			var duration:int = Math.round((flashSpanSettings.totalWidth - flashSpanSettings.screenWidth - flashSpanSettings.bezelWidth) / scrollVelocity);			
			
			var spacing:int = 109;
			
			var maxWidth:Number = opinionRows[opinionRows.length - 1].width;
			
			var rowTweens:Array = [];
			for (var i:int = 0; i < opinionRows.length; i++) {
				opinionRows[i].y = 123 + ((opinionRows[i].height + spacing) * i);
				rowTweens.push(TweenMax.fromTo(opinionRows[i], duration, {x: flashSpanSettings.totalWidth + (maxWidth - opinionRows[i].width)}, {x: -opinionRows[i].width + flashSpanSettings.screenWidth + flashSpanSettings.bezelWidth - ((maxWidth - opinionRows[i].width)), ease: customEase}));
			}
			
			
			timeline.append(TweenMax.to(this, 0, {visible: true}));
			timeline.appendMultiple(rowTweens, 0, TweenAlign.START);
			timeline.append(TweenMax.to(this, 0, {visible: false}));			
			
//			timeline.appendMultiple([
//				TweenMax.fromTo(opinionRows[0], opinionRows[0].totalFrames,
//					{frame: opinionRows[0].totalFrames, ease: Linear.easeNone},
//					{frame: 0}),				
//				TweenMax.fromTo(opinionRows[1], opinionRows[1].totalFrames,
//					{frame: opinionRows[1].totalFrames},
//				{frame: 0, ease: Linear.easeNone}),				
//				TweenMax.fromTo(opinionRows[2], opinionRows[2].totalFrames,
//					{frame: opinionRows[2].totalFrames, ease: Linear.easeNone},
//				{frame: 0}),				
//				TweenMax.fromTo(opinionRows[3], opinionRows[3].totalFrames,
//					{frame: opinionRows[3].totalFrames},
//				{frame: 0, ease: Linear.easeNone}),				
//				TweenMax.fromTo(opinionRows[4], opinionRows[4].totalFrames,
//					{frame: opinionRows[4].totalFrames, ease: Linear.easeNone},
//					{frame: 0}),	
//			], 0, TweenAlign.START, 0);			
			
			
			
			return timeline;
		}
		
		
		import flash.geom.Point;
		import fl.motion.BezierSegment;
		
		// Custom Easing Function for TweenMax
		public var customEase:Function = function(t:Number, b:Number, c:Number, d:Number):Number{
			var points:Array = [
				{point:[0,0],pre:[0,0],post:[0,0.49]},
				{point:[1,1],pre:[1,0.49],post:[1,1]},
			];
			var bezier:BezierSegment = null;
			for (var i:int = 0; i < points.length - 1; i++) {
				if (t / d >= points[i].point[0] && t / d <= points[i+1].point[0]) {
					bezier = new BezierSegment(
						new Point(points[i].point[0], points[i].point[1]),
						new Point(points[i].post[0], points[i].post[1]),
						new Point(points[i+1].pre[0], points[i+1].pre[1]),
						new Point(points[i+1].point[0], points[i+1].point[1]));
					break;
				}
			}
			return c * bezier.getYForX(t / d) + b;
		};
		// Apply easing function such as...
		//TweenMax.to(target_mc, 4, {x:400, ease:ease});		
		
	
	}
}
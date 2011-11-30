package com.civildebatewall.wallsaver.sequences {
	import com.civildebatewall.CivilDebateWall;
	import com.civildebatewall.data.Data;
	import com.civildebatewall.data.Post;
	import com.civildebatewall.wallsaver.elements.OpinionBanner;
	import com.civildebatewall.wallsaver.elements.OpinionRow;
	import com.greensock.TimelineMax;
	import com.greensock.TweenAlign;
	import com.greensock.TweenMax;
	import com.greensock.easing.Linear;
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
				var shortestRowIndex:int = 0;
				var minWidth:Number = Number.MAX_VALUE;
				for (var m:int = 0; m < opinionRows.length; m++) {
					if (opinionRows[m].width < minWidth) {
						minWidth = opinionRows[m].width;
						shortestRowIndex = m;
					}
				}

				
				// alternate stances
				var tempQuotationBanner:OpinionBanner;
				if (opinionRows[shortestRowIndex].lastStance == Post.STANCE_YES) {
					tempQuotationBanner = noQuotes.pop();
					opinionRows[shortestRowIndex].lastStance = Post.STANCE_NO;
				}
				else {
					tempQuotationBanner = yesQuotes.pop();
					opinionRows[shortestRowIndex].lastStance = Post.STANCE_YES;					
				}
				
				if (minWidth > 0) {
					tempQuotationBanner.x = minWidth + 130;
					tempQuotationBanner.y = 0;
				}
				
				opinionRows[shortestRowIndex].addChild(tempQuotationBanner);
			}
			
			// flip first, third, and fourth so they start as yes? Can't guarantee that a row will end on a "yes" or "no"
			// just keep them random for now,

			
			
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
			
		}
		
		
		public function getTimelineIn():TimelineMax	{
			return null;
		}
		
		
		public function getTimelineOut():TimelineMax {
			return null;
		}
		
		
		public function getTimeline():TimelineMax	{
			var timeline:TimelineMax = new TimelineMax({useFrames: true});
			
			timeline.appendMultiple([
				TweenMax.fromTo(opinionRows[0], opinionRows[0].totalFrames,
					{frame: opinionRows[0].totalFrames, ease: Linear.easeNone},
					{frame: 0}),				
				TweenMax.fromTo(opinionRows[1], opinionRows[1].totalFrames,
					{frame: opinionRows[1].totalFrames},
				{frame: 0, ease: Linear.easeNone}),				
				TweenMax.fromTo(opinionRows[2], opinionRows[2].totalFrames,
					{frame: opinionRows[2].totalFrames, ease: Linear.easeNone},
				{frame: 0}),				
				TweenMax.fromTo(opinionRows[3], opinionRows[3].totalFrames,
					{frame: opinionRows[3].totalFrames},
				{frame: 0, ease: Linear.easeNone}),				
				TweenMax.fromTo(opinionRows[4], opinionRows[4].totalFrames,
					{frame: opinionRows[4].totalFrames, ease: Linear.easeNone},
					{frame: 0}),	
			], 0, TweenAlign.START, 0);			
			
			return timeline;
		}
		
	
	}
}
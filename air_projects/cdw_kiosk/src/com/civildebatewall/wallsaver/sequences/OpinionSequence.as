package com.civildebatewall.wallsaver.sequences {
	import com.civildebatewall.CivilDebateWall;
	import com.civildebatewall.wallsaver.elements.OpinionBanner;
	import com.civildebatewall.wallsaver.elements.OpinionRow;
	import com.greensock.TimelineMax;
	import com.greensock.TweenAlign;
	import com.greensock.TweenMax;
	import com.greensock.easing.Linear;
	import com.kitschpatrol.futil.Math2;
	import com.kitschpatrol.futil.Random;
	import com.kitschpatrol.futil.utilitites.StringUtil;
	
	import flash.display.Sprite;
	import flash.utils.getTimer;
	
	// Scrolling User Opinions
	public class OpinionSequence extends Sprite implements ISequence {
		
		// TODO replace with backend
		private var quotesDesired:int = 20;
		private var quotes:Array = [];
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
			
			// TODO replace with backend			
			while (quotes.length < quotesDesired) {
				var dummyQuote:String = StringUtil.trim(StringUtil.dummyText(Random.range(20, 140)));
				
				if (Math.random() > 0.5)
					quotes.push([dummyQuote,  "yes"]);
				else
					quotes.push([dummyQuote, "no"]);			
			}
			// END Back end
			
			
			// Settings
			vxIntro = 50;
			vxMiddle = 15; // but only for the longest row, all others are slower!
			vxOutro = 50;
			easeIntroFrames = 500;
			easeOutroFrames = 500;
			
			
			
			// generate the display quotes
			var yesQuotes:Array = [];
			var noQuotes:Array = [];
			for each (var quoteSource:Array in quotes) {
				if (quoteSource[1] == "yes") {
					yesQuotes.push(new OpinionBanner(quoteSource[0], quoteSource[1]));
				}
				else {
					noQuotes.push(new OpinionBanner(quoteSource[0], quoteSource[1]));
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
					quoteLine.lastStance = "no";
				}
				else {
					quoteLine.lastStance = "yes"					
				}

				opinionRows[i] = quoteLine;
			}			
			
			// add opinions to rows
			while ((yesQuotes.length > 0) && (noQuotes.length > 0)) {
				// find the shortest row
				var shortestRowIndex:int = 0;
				var minWidth:Number = Number.MAX_VALUE;
				for (var j:int = 0; j < opinionRows.length; j++) {
					if (opinionRows[j].width < minWidth) {
						minWidth = opinionRows[j].width;
						shortestRowIndex = j;
					}
				}

				
				// alternate stances
				var tempQuotationBanner:OpinionBanner;
				if (opinionRows[shortestRowIndex].lastStance == "yes") {
					tempQuotationBanner = noQuotes.pop();
					opinionRows[shortestRowIndex].lastStance = "no";
				}
				else {
					tempQuotationBanner = yesQuotes.pop();
					opinionRows[shortestRowIndex].lastStance = "yes";					
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
			for (var k:int = 0; k < opinionRows.length; k++) {			
				if (opinionRows[k] != longestRow) {
					//vxMiddle = (quoteRows[k].width) / (longestRow.totalFrames - longestRow.introFrameCount - longestRow.outroFrameCount);
					// TODO a better guess at the vxMiddle before iterating towards it?
					opinionRows[k].calculateFrames(vxIntro, vxMiddle, vxOutro, easeIntroFrames, easeOutroFrames, longestRow.totalFrames);
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
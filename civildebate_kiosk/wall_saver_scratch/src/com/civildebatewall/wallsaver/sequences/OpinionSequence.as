package com.civildebatewall.wallsaver.sequences {
	import com.adobe.utils.StringUtil;
	import com.civildebatewall.wallsaver.elements.OpinionBanner;
	import com.civildebatewall.wallsaver.elements.OpinionRow;
	import com.greensock.TimelineMax;
	import com.greensock.TweenAlign;
	import com.greensock.TweenMax;
	import com.greensock.easing.Linear;
	import com.kitschpatrol.futil.Math2;
	import com.kitschpatrol.futil.Utilities;
	import com.kitschpatrol.futil.easing.EaseMap;
	
	import fl.motion.BezierSegment;
	
	import flash.display.Sprite;
	import flash.geom.Point;
	import flash.utils.getTimer;
	
	// Scrolling Quotes
	public class OpinionSequence extends Sprite implements ISequence {
		
		
		// TODO replace with backend
		private var quotesDesired:int = 20;
		private var quotes:Array = [];
		
		// Settings
		private var scrollVelocity:Number;
		private var quoteRows:Vector.<OpinionRow>;		
		
		
		public function OpinionSequence()	{
			super();
			
			while (quotes.length < quotesDesired) {
				var dummyQuote:String = StringUtil.trim(Utilities.dummyText(Math2.randRange(20, 140)));
				
				if (Math.random() > 0.5)
					quotes.push([dummyQuote,  "yes"]);
				else
					quotes.push([dummyQuote, "no"]);			
			}
			// END Back end
			
			
			// Settings
			scrollVelocity = 10;	
			
			
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
			quoteRows = new Vector.<OpinionRow>(5);
			
			for (var i:int = 0; i < quoteRows.length; i++) {
				var quoteLine:OpinionRow = new OpinionRow();
				quoteLine.x = 0;
				quoteLine.y = 123 + (i * (247 + 109));
				addChild(quoteLine);
				
				// alternating stances
				//				if (i % 1 == 0) {
				//					quoteLine.lastStance = "yes";
				//				}
				//				else {
				//					quoteLine.lastStance = "no"					
				//				}
				
				quoteRows[i] = quoteLine;
			}			
			
			// add them to rows
			while ((yesQuotes.length > 0) && (noQuotes.length > 0)) {
				// find the shortest row
				var shortestRowIndex:int = 0;
				var minWidth:Number = Number.MAX_VALUE;
				for (var j:int = 0; j < quoteRows.length; j++) {
					if (quoteRows[j].width < minWidth) {
						minWidth = quoteRows[j].width;
						shortestRowIndex = j;
					}
				}
				
				// add to it
				
				// alternate stances
				var tempQuotationBanner:OpinionBanner;
				if (quoteRows[shortestRowIndex].lastStance == "yes") {
					tempQuotationBanner = noQuotes.pop();
					quoteRows[shortestRowIndex].lastStance = "no";
				}
				else {
					tempQuotationBanner = yesQuotes.pop();
					quoteRows[shortestRowIndex].lastStance = "yes";					
				}
				
				if (minWidth > 0) {
					tempQuotationBanner.x = minWidth + 130;
					tempQuotationBanner.y = 0;
				}
				
				
				quoteRows[shortestRowIndex].addChild(tempQuotationBanner);
				//quoteRows[shortestRowIndex].lastStance = tempQuotationBanner.stance;
			}
			
			
			
			// Contruction done, now pre-calculate animation

			
			// Find longest row 
			var longestRow:OpinionRow = quoteRows[0];
			for (var l:int = 1; l < quoteRows.length; l++) {			
				if (quoteRows[l].width > longestRow.width) longestRow = quoteRows[l];
			}			
			
			trace("Longest row is " + longestRow.width);
			
			
			// Animation configuration (tweak these, and these alone!) // TODO move to constructor
			var vxIntro:Number = 25;
			var vxMiddle:Number = 5; // but only for the longest row, all others are slower!
			var vxOutro:Number = 25;
			var easeIntroFrames:int = 300;
			var easeOutroFrames:int = 300;
			
			
			var start:int = getTimer();
			
			// First, calculate the longest row, since it determines the middle velocity of the rest
			longestRow.calculateFrames(vxIntro, vxMiddle, vxOutro, easeIntroFrames, easeOutroFrames);
			
			// Now calculate the rest, based on the longest row's total duration
			for (var k:int = 0; k < quoteRows.length; k++) {			
				if (quoteRows[k] != longestRow) {
					//vxMiddle = (quoteRows[k].width) / (longestRow.totalFrames - longestRow.introFrameCount - longestRow.outroFrameCount);
					// TODO a better guess at the vxMiddle before iterating towards it?
					quoteRows[k].calculateFrames(vxIntro, vxMiddle, vxOutro, easeIntroFrames, easeOutroFrames, longestRow.totalFrames);
				}
			}
			
			trace("calculated opinion rows in " + (getTimer() - start) + "ms");
			for each(var row:OpinionRow in quoteRows) {
				trace("Frames: " + row.totalFrames);
			}
			
		}
		
		
		public function getTimelineIn():TimelineMax	{
			return null;
		}
		
		
		public function getTimelineOut():TimelineMax {
			return null;
		}
		
		
		public function getTimeline():TimelineMax	{
			var timeline:TimelineMax = new TimelineMax({useFrames: true});
			// Quotation field
			
			timeline.appendMultiple([
				TweenMax.fromTo(quoteRows[0], quoteRows[0].totalFrames,
					{frame: 0},
					{frame: quoteRows[0].totalFrames, ease: Linear.easeNone}),
				TweenMax.fromTo(quoteRows[1], quoteRows[1].totalFrames,
					{frame: quoteRows[1].totalFrames},
					{frame: 0, ease: Linear.easeNone}),
				TweenMax.fromTo(quoteRows[2], quoteRows[2].totalFrames,
					{frame: 0},
					{frame: quoteRows[2].totalFrames, ease: Linear.easeNone}),
				TweenMax.fromTo(quoteRows[3], quoteRows[3].totalFrames,
					{frame: quoteRows[3].totalFrames},
					{frame: 0, ease: Linear.easeNone}),
				TweenMax.fromTo(quoteRows[4], quoteRows[4].totalFrames,
					{frame: 0},
					{frame: quoteRows[4].totalFrames, ease: Linear.easeNone})
			], 0, TweenAlign.START, 0);			
			
			return timeline;
		}
		
	
	}
}
package com.civildebatewall.wallsaver.sequences {
	import com.civildebatewall.wallsaver.elements.OpinionBanner;
	import com.civildebatewall.wallsaver.elements.OpinionRow;
	import com.greensock.TimelineMax;
	import com.greensock.TweenAlign;
	import com.greensock.TweenMax;
	import com.kitschpatrol.futil.Math2;
	import com.kitschpatrol.futil.Utilities;
	
	import fl.motion.BezierSegment;
	
	import flash.display.Sprite;
	import flash.geom.Point;
	
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
				var dummyQuote:String = Utilities.dummyText(Math2.randRange(20, 140));
				
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
				quoteLine.y = 120 + (i * (240 + 120));
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
			var quotationScrollDuration:int = (Main.totalWidth + quoteRows[0].width)  / scrollVelocity;
			
			timeline.appendMultiple([
				TweenMax.fromTo(quoteRows[0], quotationScrollDuration,
					{x: -quoteRows[0].width},
					{x: Main.totalWidth + 100, 	 ease: OpinionSequence.easeOutIn, roundProps: ["x"]}),
				TweenMax.fromTo(quoteRows[1], quotationScrollDuration,
					{x: Main.totalWidth + 100},
					{x: -quoteRows[1].width, ease: OpinionSequence.easeOutIn, roundProps: ["x"]}),
				TweenMax.fromTo(quoteRows[2], quotationScrollDuration,
					{x: -quoteRows[2].width},
					{x: Main.totalWidth + 100,ease: OpinionSequence.easeOutIn, roundProps: ["x"]}),
				TweenMax.fromTo(quoteRows[3], quotationScrollDuration,
					{x: Main.totalWidth + 100},
					{x: -quoteRows[3].width, ease: OpinionSequence.easeOutIn, roundProps: ["x"]}),
				TweenMax.fromTo(quoteRows[4], quotationScrollDuration,
					{x: -quoteRows[4].width},
					{x: Main.totalWidth + 100, ease: OpinionSequence.easeOutIn, roundProps: ["x"]})
			], 0, TweenAlign.START, 0);			
			
			return timeline;
		}
		
		
		// Custom ease
		// Custom Easing Function for TweenMax
		public static var easeOutIn:Function = function(t:Number, b:Number, c:Number, d:Number):Number{
			var points:Array = [
				{point:[0,0],pre:[0,0],post:[0,0.5]},
				{point:[1,1],pre:[1,0.5],post:[1,1]},
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
				
	}
}
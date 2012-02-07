/*--------------------------------------------------------------------
Civil Debate Wall Kiosk
Copyright (c) 2012 Local Projects. All rights reserved.

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as
published by the Free Software Foundation, either version 2 of the
License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public
License along with this program. 

If not, see <http://www.gnu.org/licenses/>.
--------------------------------------------------------------------*/

package com.civildebatewall.wallsaver.sequences {

	import com.civildebatewall.CivilDebateWall;
	import com.civildebatewall.data.Data;
	import com.civildebatewall.data.containers.Post;
	import com.civildebatewall.wallsaver.elements.OpinionBanner;
	import com.civildebatewall.wallsaver.elements.OpinionRow;
	import com.greensock.TimelineMax;
	import com.greensock.TweenAlign;
	import com.greensock.TweenMax;
	import com.kitschpatrol.flashspan.Settings;
	import com.kitschpatrol.futil.utilitites.GraphicsUtil;
	
	import com.civildebatewall.BezierSegment;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.Point;
	
	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.getLogger;
	
	// Scrolling User Opinions
	public class OpinionSequence extends Sprite implements ISequence {

		private static const logger:ILogger = getLogger(OpinionSequence);
		
		// Settings
		private var scrollVelocity:Number;
		private var maxQuotes:int;
		
		// Internal
		private var opinionRows:Vector.<OpinionRow>;		
		
		
		public function OpinionSequence()	{
			super();	
			
			// Settings
			scrollVelocity = 14;
			maxQuotes = 8;
			
			CivilDebateWall.data.addEventListener(Data.DATA_UPDATE_EVENT, onDataUpdate);
		}
		
		private function onDataUpdate(e:Event):void {
			// clear everything
			GraphicsUtil.removeChildren(this);
			
			// generate the display quotes
			var yesQuotes:Vector.<Post> = new Vector.<Post>;
			var noQuotes:Vector.<Post> = new Vector.<Post>;

			// get yes and no qiuotes
			for (var k:int = 0; k < CivilDebateWall.data.posts.length; k++) {			
				if (CivilDebateWall.data.posts[k].stance == Post.STANCE_YES) {
					yesQuotes.push(CivilDebateWall.data.posts[k]);
				}
				else {
					noQuotes.push(CivilDebateWall.data.posts[k]);
				}
			}
			
			// sort the quotes by date
			yesQuotes = yesQuotes.sort(comparePostDate);
			noQuotes = noQuotes.sort(comparePostDate);
			
			// Generate the quote rows
			opinionRows = new Vector.<OpinionRow>(5);
			
			for (var i:int = 0; i < opinionRows.length; i++) {
				var opinionRow:OpinionRow = new OpinionRow();
				opinionRow.x = 1080 + CivilDebateWall.flashSpan.settings.bezelWidth;
				addChild(opinionRow);
				
				// alternating stances
				opinionRow.lastStance = (i % 2 == 0) ? Post.STANCE_NO : Post.STANCE_YES;
				opinionRows[i] = opinionRow;
			}
			
			// add opinions to rows
			
			// Try to get the number required. If there aren't enough, get as many as possible.
			var quoteCount:int = Math.min(maxQuotes, CivilDebateWall.data.posts.length);			
			logger.info("Creating opinion sequence with " + quoteCount + " quotes");
			for (var m:int = 0; m < quoteCount; m++) {
				// find the shortest row
				var shortestRow:OpinionRow = opinionRows.sort(compareRowLength)[0];
				
				// alternate stances while possible
				var post:Post;
				
				if (shortestRow.lastStance == Post.STANCE_YES && (noQuotes.length > 0)) {
					post = noQuotes.pop();
					shortestRow.lastStance = Post.STANCE_NO;
				}
				else if (shortestRow.lastStance == Post.STANCE_NO && (yesQuotes.length > 0)) {
					post  = yesQuotes.pop();
					shortestRow.lastStance = Post.STANCE_YES;
				}
				else if (yesQuotes.length == 0) {
					// have to say no
					post  = noQuotes.pop();										
					shortestRow.lastStance = Post.STANCE_NO;					
				}
				else if (noQuotes.length == 0) {
					// have to say yes
					post  = yesQuotes.pop();
					shortestRow.lastStance = Post.STANCE_YES;					
				}				
				else {
					// Shouldn't get here					
				}
				
				var opinionBanner:OpinionBanner = new OpinionBanner(post);				
				
				
				// not the first, move it to the right
				if (shortestRow.width > 0) {
					opinionBanner.x = shortestRow.width + 130;
					opinionBanner.y = 0;
				}
				
				shortestRow.addChild(opinionBanner);				
			}
			
			opinionRows = opinionRows.sort(compareRowLength); // sort the rows, shortest first
			opinionRows.reverse(); // longest on top for parallax reasons
			
			for (var j:int = 0; j < opinionRows.length; j++) {
				opinionRows[j].y = 123 + (j * (247 + 108));
			}
		}
		
		
		private function compareRowLength(a:OpinionRow, b:OpinionRow):Number {
			return a.width - b.width;			
		}
		
		
		private function comparePostDate(a:Post, b:Post):Number {
			// sorts by date, newest first	
			return b.created.time - a.created.time;
		}		
		
		
		public function getTimelineIn():TimelineMax	{
			return null;
		}
		
		
		public function getTimelineOut():TimelineMax {
			return null;
		}
		
		
		public function getTimeline():TimelineMax	{
			var timeline:TimelineMax = new TimelineMax({useFrames: true});
			
			var maxWidth:Number = opinionRows[0].width; // first one is longest			
			var flashSpanSettings:Settings = CivilDebateWall.flashSpan.settings;
			var duration:int = Math.round((maxWidth + (flashSpanSettings.totalWidth - flashSpanSettings.screenWidth - flashSpanSettings.bezelWidth)) / scrollVelocity);			
			
			var rowTweens:Array = [];
			for (var i:int = 0; i < opinionRows.length; i++) {
				rowTweens.push(TweenMax.fromTo(opinionRows[i], duration, {x: flashSpanSettings.totalWidth + (maxWidth - opinionRows[i].width)}, {x: -opinionRows[i].width + flashSpanSettings.screenWidth + flashSpanSettings.bezelWidth - ((maxWidth - opinionRows[i].width)), ease: customEase}));
			}
			
			timeline.append(TweenMax.to(this, 0, {visible: true}));
			timeline.appendMultiple(rowTweens, 0, TweenAlign.START);
			timeline.append(TweenMax.to(this, 0, {visible: false}));			
			
			return timeline;
		}
		

		// TODO change points based on duration to keep ins and outs relatively consistent?
		// OR dynamic ease for each row based on length to give more of a speed out feeling?
		// Custom Easing Function for TweenMax
		private var customEase:Function = function(t:Number, b:Number, c:Number, d:Number):Number {
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
	}
}

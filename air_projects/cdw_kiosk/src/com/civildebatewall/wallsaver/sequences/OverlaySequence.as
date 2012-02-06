/*--------------------------------------------------------------------
Civil Debate Wall Kiosk
Copyright (c) 2012 Local Projects. All rights reserved.

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU Affero General Public License as
published by the Free Software Foundation, either version 3 of the
License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU Affero General Public License for more details.

You should have received a copy of the GNU Affero General Public
License along with this program. 

If not, see <http://www.gnu.org/licenses/>.
--------------------------------------------------------------------*/

package com.civildebatewall.wallsaver.sequences {

	import com.civildebatewall.CivilDebateWall;
	import com.greensock.TimelineMax;
	import com.greensock.TweenAlign;
	import com.greensock.TweenMax;
	import com.greensock.easing.Quad;
	import com.kitschpatrol.futil.utilitites.GraphicsUtil;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	
	public class OverlaySequence extends Sprite implements ISequence  {
		
		private var overlays:Vector.<Shape>;		
		
		public function OverlaySequence()	{
			
			// Draw the white overlays
			overlays = new Vector.<Shape>(CivilDebateWall.flashSpan.settings.screenCount);
			
			for (var i:int = 0; i < CivilDebateWall.flashSpan.settings.screenCount; i++) {
				overlays[i] = GraphicsUtil.shapeFromRect(CivilDebateWall.flashSpan.settings.screens[i], 0xffffff);
			}
			
			// Add them to the Sprite
			for each (var shape:Shape in overlays) addChild(shape);			
		}
		
		public function getTimelineIn():TimelineMax {
			var timelineIn:TimelineMax = new TimelineMax({useFrames: true});
			
			// Overlays block out the background TODO break into own squence?
			var overlayTweens:Array = [];
			for (var i:int = overlays.length - 1; i >= 0; i--) {
				overlayTweens.push(TweenMax.fromTo(overlays[i], 60, {alpha: 0}, {alpha: 1, ease: Quad.easeIn}));
			}
			timelineIn.appendMultiple(overlayTweens, 0, TweenAlign.START, 20);
			
			return timelineIn;
		}
		
		public function getTimelineOut():TimelineMax {
			var timelineOut:TimelineMax = new TimelineMax({useFrames: true});
			timelineOut = getTimelineIn();
			timelineOut.reversed = true;
			
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

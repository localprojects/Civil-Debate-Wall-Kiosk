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
	import com.civildebatewall.wallsaver.elements.JoinButton;
	import com.greensock.TimelineMax;
	import com.greensock.TweenAlign;
	import com.greensock.TweenMax;
	import com.greensock.easing.Quint;
	import com.kitschpatrol.futil.blocks.BlockText;
	
	import flash.display.Sprite;

	public class ButtonSequence extends Sprite implements ISequence {
		
		private var buttons:Vector.<BlockText>;
		
		public function ButtonSequence() {
			// Build objects
			
			buttons = new Vector.<BlockText>(CivilDebateWall.flashSpan.settings.screenCount);
			
			for (var i:int = 0; i < CivilDebateWall.flashSpan.settings.screenCount; i++) {
				buttons[i] = new JoinButton();
				buttons[i].x = CivilDebateWall.flashSpan.settings.screens[i].right - 30; // issues with inconsistent initial X? check futil?
			}
			
			// Add them to the Sprite
			for each (var button:BlockText in buttons) addChild(button);
		}
		
		public function getTimelineIn():TimelineMax {
			var timelineIn:TimelineMax = new TimelineMax({useFrames: true});
			
			// Buttons
			var buttonTweens:Array = [];
			for (var j:int = 0; j < buttons.length; j++) {
				buttonTweens.push(TweenMax.fromTo(buttons[j], 40, {y: CivilDebateWall.flashSpan.settings.totalHeight + buttons[j].height}, {y: CivilDebateWall.flashSpan.settings.totalHeight - 30, ease: Quint.easeOut, roundProps: ["y"]}));
			}
			
			timelineIn.appendMultiple(buttonTweens, -25, TweenAlign.START, 10);
			
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

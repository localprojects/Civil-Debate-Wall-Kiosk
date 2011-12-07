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
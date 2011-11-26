package com.civildebatewall.wallsaver.sequences {

	import com.civildebatewall.wallsaver.elements.JoinButton;
	import com.greensock.TimelineMax;
	import com.greensock.TweenAlign;
	import com.greensock.TweenMax;
	import com.greensock.easing.*;
	import com.kitschpatrol.futil.blocks.BlockText;
	
	import flash.display.Sprite;	

	public class ButtonSequence extends Sprite implements ISequence {
		
		private var buttons:Vector.<BlockText>;
		
		public function ButtonSequence() {
			// Build objects
		
			buttons = new Vector.<BlockText>(Main.screens.length);
			
			for (var i:int = 0; i < Main.screens.length; i++) {
				buttons[i] = new JoinButton();
				buttons[i].x = Main.screens[i].right - 30; // issues with inconsistent initial X? check futil?
			}
			
			// Add them to the Sprite
			for each (var button:BlockText in buttons) addChild(button);
		}
		
		
		public function getTimelineIn():TimelineMax {
			var timelineIn:TimelineMax = new TimelineMax({useFrames: true});
			
			// Buttons
			var buttonTweens:Array = [];
			for (var j:int = 0; j < buttons.length; j++) {
				buttonTweens.push(TweenMax.fromTo(buttons[j], 40, {y: Main.totalHeight + buttons[j].height}, {y: Main.totalHeight - 30, ease: Quint.easeOut, roundProps: ["y"]}));
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
package com.civildebatewall.wallsaver.sequences {
	import com.civildebatewall.wallsaver.elements.QuestionBanner;
	import com.greensock.TimelineMax;
	import com.greensock.TweenMax;
	import com.greensock.easing.Linear;
	
	import flash.display.Sprite;
	
	
	
	public class QuestionSequence extends Sprite implements ISequence {
		
		// TODO get this from back end
		private var question:String = "Do you feel our public education provides our children with a thorough education these days?";
		
		
		private var scrollVelocity:Number;
		private var questionBanner:QuestionBanner;
		
		public function QuestionSequence()	{
			// settings
			scrollVelocity = 20;
			
			// build the question, text pending
			questionBanner = new QuestionBanner(question);
			questionBanner.y = 125;
			
			addChild(questionBanner);
		}
		
		public function getTimelineIn():TimelineMax	{
			// No special "in"
			return null;
		}
		
		public function getTimelineOut():TimelineMax {
			// No special "out"
			return null;
		}
		
		public function getTimeline():TimelineMax {
			var timeline:TimelineMax = new TimelineMax({useFrames: true});
			
			var duration:int = (CivilDebateWallSaver.totalWidth + questionBanner.width)  / scrollVelocity;
			timeline.append(TweenMax.fromTo(questionBanner, duration, {x: CivilDebateWallSaver.totalWidth}, {x: -questionBanner.width, ease: Linear.easeNone, roundProps: ["x"]}));

			return timeline;
		}		
		
	}
}
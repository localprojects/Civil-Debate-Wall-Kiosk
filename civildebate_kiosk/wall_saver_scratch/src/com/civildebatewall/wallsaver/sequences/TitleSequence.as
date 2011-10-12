package com.civildebatewall.wallsaver.sequences {
	import com.greensock.TimelineMax;
	import com.greensock.TweenMax;
	import com.greensock.easing.Linear;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	
	
	public class TitleSequence extends Sprite implements ISequence {
		
		private var scrollVelocity:Number;
		private var title:Bitmap;		
		
		public function TitleSequence()	{
			super();
			
			// Settings
			scrollVelocity = 20;
			
			// Build the title
			title = Assets.title; // Just pass a reference (saves memory?)
			title.y = 0; // TBD
			
			addChild(title);			
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
			
			var duration:int = (CivilDebateWallSaver.totalWidth + title.width)  / scrollVelocity;
			timeline.append(TweenMax.fromTo(title, duration, {x: CivilDebateWallSaver.totalWidth}, {x: -title.width, ease: Linear.easeNone, roundProps: ["x"]}));
			
			return timeline;
		}	
	}
}


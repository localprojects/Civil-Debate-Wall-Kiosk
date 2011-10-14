package com.civildebatewall.wallsaver.sequences {
	import com.greensock.TimelineMax;
	import com.greensock.TweenMax;
	import com.greensock.easing.Linear;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	
	
	public class TitleSequence extends Sprite implements ISequence {
		
		private var scrollVelocity:Number;
		private var title:Sprite;		
		
		
		public function TitleSequence()	{
			super();
			
			// Settings
			scrollVelocity = 20;
			
			// Build the title
			title = new Sprite();
			
			// stitch together bitmaps, for some reason the single giant one creates graphics flitches
			for (var i:int = 1; i <= 7; i++) { 
				Assets["titleSlice_0" + i].x = title.width;
				title.addChild(Assets["titleSlice_0" + i]);
			}
			

			title.y = 123;
			addChild(title);
			
			this.cacheAsBitmap = true;
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
			
			var duration:int = (Main.totalWidth + title.width)  / scrollVelocity;
			timeline.append(TweenMax.fromTo(title, duration, {x: Main.totalWidth}, {x: -title.width, ease: Linear.easeNone, roundProps: ["x"]}));
			
			return timeline;
		}	
	}
}


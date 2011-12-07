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
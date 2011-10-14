package com.civildebatewall.wallsaver.core {
	
	import com.civildebatewall.wallsaver.sequences.*;
	import com.greensock.TimelineMax;
	import com.greensock.TweenAlign;
	import com.greensock.TweenMax;
	import com.greensock.easing.*;
	import com.kitschpatrol.futil.Utilities;
	
	import flash.display.Sprite;	
	
	public class WallSaver extends Sprite {
		
		public var timeline:TimelineMax;		
		private var canvas:Sprite;
		
		
		public function WallSaver()	{
			super();
			
			// The wallsaver canvas
			canvas = new Sprite();
			canvas.alpha = 0;
			canvas.visible = false;
			addChild(canvas);			
			
			timeline = new TimelineMax({useFrames: true});
		}
		
		
		// TODO put this into a big conditional?
		private function preSequenceBuildTasks():void {
			if (timeline.active) timeline.stop();
			
			// Clean up
			Utilities.removeChildren(canvas);
			
			// Clear the timeline
			timeline.clear();
			timeline.currentTime = 0;
			
			// Restore the canvas
			canvas.alpha = 1;
			canvas.visible = true;
		}
		
		
		private function postSequenceBuildTasks():void {
			// make sure all of the froms are in position
			timeline.goto(timeline.totalDuration); 
			timeline.goto(0);			
			timeline.stop();
		}
		
		
		public function playSequenceA():void {
			preSequenceBuildTasks();
			
			// Create display objects
			var buttonSequence:ButtonSequence = new ButtonSequence();
			canvas.addChild(buttonSequence);
			
			var titleSequence:TitleSequence = new TitleSequence();
			canvas.addChild(titleSequence);
			
			var questionSequence:QuestionSequence = new QuestionSequence();
			canvas.addChild(questionSequence);
			
			var opinionSequence:OpinionSequence = new OpinionSequence();
			canvas.addChild(opinionSequence);
			
			var callToActionSequence:CallToActionSequence = new CallToActionSequence();			
			canvas.addChild(callToActionSequence);
			
			// Assemble the timeline
			timeline.appendMultiple([
				buttonSequence.getTimelineIn(),
				titleSequence.getTimeline(),
				questionSequence.getTimeline(),
				opinionSequence.getTimeline(),
				callToActionSequence.getTimeline(),
				buttonSequence.getTimelineOut()				
			], 0, TweenAlign.SEQUENCE);
			
			postSequenceBuildTasks();
		}
		
		public function playSequenceB():void {		
			preSequenceBuildTasks();
			
			// Create display objects
			var buttonSequence:ButtonSequence = new ButtonSequence();
			canvas.addChild(buttonSequence);
			
			var questionSequence:QuestionSequence = new QuestionSequence();
			canvas.addChild(questionSequence);
			
			var barGraphSequence:BarGraphSequence = new BarGraphSequence();
			canvas.addChild(barGraphSequence);
			
			var callToActionSequence:CallToActionSequence = new CallToActionSequence();			
			canvas.addChild(callToActionSequence);
			
			// Assemble the timeline
			timeline.appendMultiple([
				buttonSequence.getTimelineIn(),
				questionSequence.getTimeline(),
				barGraphSequence.getTimeline(),
				callToActionSequence.getTimeline(),
				buttonSequence.getTimelineOut()				
			], 0, TweenAlign.SEQUENCE);
			
			postSequenceBuildTasks();
		}
		
		
		public function playSequenceC():void {
			preSequenceBuildTasks();
			
			// Create display objects
			var buttonSequence:ButtonSequence = new ButtonSequence();
			canvas.addChild(buttonSequence);
			
			var questionSequence:QuestionSequence = new QuestionSequence();
			canvas.addChild(questionSequence);
			
			var faceGridSequence:FaceGridSequence = new FaceGridSequence();
			canvas.addChild(faceGridSequence);
			
			var callToActionSequence:CallToActionSequence = new CallToActionSequence();
			canvas.addChild(callToActionSequence);
			
			var titleSequence:TitleSequence = new TitleSequence();
			canvas.addChild(titleSequence);
			
			// Assemble the timeline
			timeline.appendMultiple([
				buttonSequence.getTimelineIn(),
				questionSequence.getTimeline(),
				faceGridSequence.getTimeline(),
				callToActionSequence.getTimeline(),	
				titleSequence.getTimeline(),
				buttonSequence.getTimelineOut()				
			], 0, TweenAlign.SEQUENCE);
			
			postSequenceBuildTasks();			
		}
		
		
		// Ends the sequence early, usually when someone touches the screen... move this to parent?
		// TODO make the fade flow "out" from the touched screen.
		public function endSequence():void {
			TweenMax.to(canvas, 1.5, {alpha: 0, onComplete: postAnimationTasks});
		}
		
		private function postAnimationTasks():void {
			canvas.visible = false;
		}
		
		
	}
}
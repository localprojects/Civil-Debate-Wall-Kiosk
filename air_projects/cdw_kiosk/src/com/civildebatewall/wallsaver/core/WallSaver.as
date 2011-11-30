package com.civildebatewall.wallsaver.core {
	
	import com.civildebatewall.CivilDebateWall;
	import com.civildebatewall.wallsaver.sequences.*;
	import com.demonsters.debugger.MonsterDebugger;
	import com.greensock.TimelineMax;
	import com.greensock.TweenAlign;
	import com.greensock.TweenMax;
	import com.greensock.easing.*;
	import com.kitschpatrol.futil.utilitites.GraphicsUtil;
	import com.kitschpatrol.futil.utilitites.ObjectUtil;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.StageDisplayState;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	
	public class WallSaver extends Sprite {
		
		public var timeline:TimelineMax;		
		private var canvas:Sprite;
		
		private var topBar:Shape;
		private var bottomBar:Shape;
		
		// static
		private var overlaySequence:OverlaySequence;		
		private var calltoActionSequence:CallToActionSequence;		
		private var buttonSequence:ButtonSequence;
		
		// bound to data
		private var opinionSequence:OpinionSequence;
		private var titleSequence:TitleSequence;
		private var barGraphSequence:BarGraphSequence;
		private var faceGridSequence:FaceGridSequence;
		
		
		public function WallSaver()	{
			super();
			
			// The wallsaver canvas
			canvas = new Sprite();
			canvas.alpha = 0;
			canvas.visible = false;
			addChild(canvas);
			
			timeline = new TimelineMax({useFrames: true});
			
			// TODO more singleton sequences, ready for updates (or just update before animation?)
			overlaySequence = new OverlaySequence();
			calltoActionSequence = new CallToActionSequence();
			buttonSequence = new ButtonSequence();
			faceGridSequence = new FaceGridSequence();
			opinionSequence = new OpinionSequence();
			titleSequence = new TitleSequence();
			barGraphSequence = new BarGraphSequence();
			
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(e:Event):void {
			// default to sequence A
			//Main.controls.targetStageSetup();
			
			//playSequenceA();
			//Main.controls.updateTimeSlider();			
		}

		
		private function preSequenceBuildTasks():void {
			if (timeline.active) timeline.stop();
			
			// Clean up
			GraphicsUtil.removeChildren(canvas);
			
			// Clear the timeline
			timeline = new TimelineMax({useFrames: true});
			
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
		
		
		public function cueSequenceA():void {
			preSequenceBuildTasks();
			
			// add sequences to stage
			canvas.addChild(overlaySequence);
			canvas.addChild(opinionSequence);
			canvas.addChild(calltoActionSequence);
			canvas.addChild(titleSequence);
			canvas.addChild(buttonSequence);			

			// build the timeline
			timeline.append(overlaySequence.getTimelineIn());			
			timeline.append(buttonSequence.getTimelineIn());			
			timeline.append(titleSequence.getTimelineIn(), -60);
			timeline.append(opinionSequence.getTimeline(), -60);
			timeline.append(calltoActionSequence.getTimeline());
			timeline.append(titleSequence.getTimelineOut(), -100);
			timeline.append(buttonSequence.getTimelineOut(), -100);						
			timeline.append(overlaySequence.getTimelineOut());
			
			postSequenceBuildTasks();
		}
		
		public function cueSequenceB():void {		
			preSequenceBuildTasks();
			
			// add sequences to stage
			canvas.addChild(overlaySequence);
			canvas.addChild(barGraphSequence);
			canvas.addChild(faceGridSequence);
			canvas.addChild(titleSequence);			
			canvas.addChild(buttonSequence);			

			// build the timeline			
			timeline.append(overlaySequence.getTimelineIn());
			timeline.append(buttonSequence.getTimelineIn());
			timeline.append(titleSequence.getTimelineIn(), -100);
			timeline.append(barGraphSequence.getTimeline(), -60);
			timeline.append(faceGridSequence.getTimeline());
			timeline.append(titleSequence.getTimelineOut(), -270);
			timeline.append(buttonSequence.getTimelineOut(), -100);						
			timeline.append(overlaySequence.getTimelineOut());
			
			postSequenceBuildTasks();
		}
		
		// Ends the sequence early, usually when someone touches the screen... move this to parent?
		// TODO make the fade flow "out" from the touched screen.
		// TODO interactive button.
		public function endSequence():void {
			TweenMax.to(canvas, 1.5, {alpha: 0, onComplete: postAnimationTasks});
		}
		
		private function postAnimationTasks():void {
			timeline.stop();
			canvas.visible = false;
		}
		
		
	}
}
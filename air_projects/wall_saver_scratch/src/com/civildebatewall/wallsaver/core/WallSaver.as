package com.civildebatewall.wallsaver.core {
	
	import com.civildebatewall.wallsaver.sequences.*;
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
		
		public function WallSaver()	{
			super();
			
			// The wallsaver canvas
			canvas = new Sprite();
			canvas.alpha = 0;
			canvas.visible = false;
			addChild(canvas);
			
			timeline = new TimelineMax({useFrames: true});
			
			addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		private function onAddedToStage(e:Event):void {
			// default to sequence A
			Main.controls.targetStageSetup();
			
			playSequenceA();
			Main.controls.updateTimeSlider();			
		}
		
		public function toggleFullScreen():void {
			if (stage.displayState == StageDisplayState.NORMAL) {
				stage.displayState = StageDisplayState.FULL_SCREEN_INTERACTIVE;
				stage.scaleMode = StageScaleMode.SHOW_ALL;
				
				// block off extras
				// TODO fix this
				topBar = GraphicsUtil.shapeFromSize(stage.stageWidth, 1080- Main.totalHeight / 2);
				bottomBar = GraphicsUtil.shapeFromSize(stage.stageWidth,1080 - Main.totalHeight / 2);
				
				addChild(topBar);
				trace(topBar.height)
				canvas.y = topBar.height;
				bottomBar.y = canvas.x + canvas.height;
				addChild(bottomBar);
			}
			else {
				stage.displayState = StageDisplayState.NORMAL;
				stage.scaleMode = StageScaleMode.EXACT_FIT;				
			}					
		}
		
		
		
		// TODO put this into a big conditional?
		private function preSequenceBuildTasks():void {
			if (timeline.active) timeline.stop();
			
			// Clean up
			GraphicsUtil.removeChildren(canvas);
			
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
			
			var overlaySequence:OverlaySequence = new OverlaySequence();
			canvas.addChild(overlaySequence);

			var opinionSequence:OpinionSequence = new OpinionSequence();
			canvas.addChild(opinionSequence);
			
			var calltoActionSequence:CallToActionSequence = new CallToActionSequence();
			canvas.addChild(calltoActionSequence);
			
			// title goes over 4 screen animations
			var titleSequence:TitleSequence = new TitleSequence();
			canvas.addChild(titleSequence);
			
			// buttons go over everything
			var buttonSequence:ButtonSequence = new ButtonSequence();
			canvas.addChild(buttonSequence);			

			// build the timeline
			timeline.append(overlaySequence.getTimelineIn());			
			timeline.append(buttonSequence.getTimelineIn());			
			timeline.append(titleSequence.getTimelineIn(), -60);
			timeline.append(opinionSequence.getTimeline());
			timeline.append(calltoActionSequence.getTimeline(), -60);
			timeline.append(titleSequence.getTimelineOut(), -100);
			timeline.append(buttonSequence.getTimelineOut());						
			timeline.append(overlaySequence.getTimelineOut());
			
			postSequenceBuildTasks();
		}
		
		public function playSequenceB():void {		
			preSequenceBuildTasks();
			
			// B: Title, Graph, Face Grid			
			var overlaySequence:OverlaySequence = new OverlaySequence();
			canvas.addChild(overlaySequence);			
			
			var barGraphSequence:BarGraphSequence = new BarGraphSequence();
			canvas.addChild(barGraphSequence);
			
			var faceGridSequence:FaceGridSequence = new FaceGridSequence();
			canvas.addChild(faceGridSequence);
			
			// title goes over 4 screen animations
			var titleSequence:TitleSequence = new TitleSequence();
			canvas.addChild(titleSequence);			
			
			// buttons go over everything
			var buttonSequence:ButtonSequence = new ButtonSequence();
			canvas.addChild(buttonSequence);

			timeline.append(overlaySequence.getTimelineIn());			
			timeline.append(buttonSequence.getTimelineIn());			
			timeline.append(titleSequence.getTimelineIn(), -60);
			timeline.append(barGraphSequence.getTimeline(), -60);
			timeline.append(faceGridSequence.getTimeline());
			timeline.append(titleSequence.getTimelineOut());
			timeline.append(buttonSequence.getTimelineOut());						
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
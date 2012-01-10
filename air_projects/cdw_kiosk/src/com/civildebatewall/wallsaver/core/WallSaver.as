package com.civildebatewall.wallsaver.core {
	
	import com.civildebatewall.CivilDebateWall;
	import com.civildebatewall.wallsaver.sequences.BarGraphSequence;
	import com.civildebatewall.wallsaver.sequences.ButtonSequence;
	import com.civildebatewall.wallsaver.sequences.CallToActionSequence;
	import com.civildebatewall.wallsaver.sequences.FaceGridSequence;
	import com.civildebatewall.wallsaver.sequences.OpinionSequence;
	import com.civildebatewall.wallsaver.sequences.OverlaySequence;
	import com.civildebatewall.wallsaver.sequences.TitleSequence;
	import com.greensock.TimelineMax;
	import com.greensock.TweenMax;
	import com.kitschpatrol.futil.utilitites.GraphicsUtil;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.getLogger;
	
	public class WallSaver extends Sprite {
		
		private static const logger:ILogger = getLogger(WallSaver);
		
		public var timeline:TimelineMax;		
		private var canvas:Sprite;
		
		// static
		private var overlaySequence:OverlaySequence;		
		private var calltoActionSequence:CallToActionSequence;		
		private var buttonSequence:ButtonSequence;
		
		// bound to data
		private var opinionSequence:OpinionSequence;
		private var titleSequence:TitleSequence;
		private var barGraphSequence:BarGraphSequence;
		private var faceGridSequence:FaceGridSequence;
		
		public var orderedOpinionRows:Boolean;
		
		public function rebuildFaceGrid():void {
			faceGridSequence.buildPortraits();
		}
		
		public function WallSaver()	{
			super();
			
			orderedOpinionRows = false;
			
			// The wallsaver canvas
			canvas = new Sprite();
			canvas.alpha = 0;
			canvas.visible = false;
			addChild(canvas);
			
			timeline = new TimelineMax({useFrames: true, onComplete: onTimelineComplete});
			
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
			if (TweenMax.isTweening(canvas)) TweenMax.killTweensOf(canvas);
			
			// Clean up	
			GraphicsUtil.removeChildren(canvas);
			canvas.removeChildren();
			
			removeChild(canvas);
			canvas = new Sprite();
			canvas.alpha = 0;
			canvas.visible = false;
			addChild(canvas);					
			
			// Clear the timeline
			timeline = new TimelineMax({useFrames: true, onComplete: onTimelineComplete});
			
			
			// watch for touches
			canvas.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
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
			timeline.append(barGraphSequence.getTimeline(), 0);
			timeline.append(faceGridSequence.getTimeline());
			timeline.append(titleSequence.getTimelineOut(), -250);
			timeline.append(buttonSequence.getTimelineOut(), -100);						
			timeline.append(overlaySequence.getTimelineOut());
			
			postSequenceBuildTasks();
		}
		
		private function postSequenceBuildTasks():void {
			// make sure all of the froms are in position
			timeline.goto(timeline.totalDuration); 
			timeline.goto(0);			
			timeline.stop();
			
			// Restore the canvas
			canvas.alpha = 1;
			canvas.visible = true;			
		}
		
		// Ends the sequence early, usually when someone touches the screen... move this to parent?
		// TODO make the fade flow "out" from the touched screen.
		// TODO interactive button.
		
		private function onTimelineComplete():void {
			postAnimationTasks();
			CivilDebateWall.flashSpan.stop();			
		}
		
		public function endSequence():void {
			TweenMax.to(canvas, 0.5, {alpha: 0, onComplete: postAnimationTasks});			
		}
		
		private function postAnimationTasks():void {
			timeline.stop();
			removeMouseUpListener();
			canvas.visible = false;
		}
		
		private function removeMouseUpListener():void {
			if (canvas.hasEventListener(MouseEvent.MOUSE_UP)) canvas.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);
		}
		
		private function onMouseUp(e:MouseEvent):void {
			removeMouseUpListener();
			CivilDebateWall.flashSpan.stop();
		}
		
	}
}
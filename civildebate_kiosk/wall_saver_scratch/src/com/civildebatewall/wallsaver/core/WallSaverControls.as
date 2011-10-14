package com.civildebatewall.wallsaver.core {
	
	import com.bit101.components.*;
	import com.kitschpatrol.futil.utilitites.GraphicsUtil;
	
	import flash.display.NativeWindow;
	import flash.display.NativeWindowInitOptions;
	import flash.display.NativeWindowSystemChrome;
	import flash.display.NativeWindowType;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.geom.Point;
	
	public class WallSaverControls extends NativeWindow {
		
		private var frameCountLabel:Label;
		private var fpsMeter:FPSMeter;
		private var timeSlider:Slider;
		private var target:WallSaver;
		
		
		public function WallSaverControls(target:WallSaver)	{
			this.target = target;
			
			// Prep window
			var windowOptions:NativeWindowInitOptions = new NativeWindowInitOptions();
			windowOptions.systemChrome = NativeWindowSystemChrome.STANDARD;
			windowOptions.type = NativeWindowType.UTILITY;
			windowOptions.resizable = false;
			windowOptions.maximizable = false;
			windowOptions.minimizable = true;

			// Create window
			super(windowOptions);
			alwaysInFront = true;
			title = "Controls";
			minSize = new Point(800, 100);			
			maxSize = new Point(800, 100);

			// Set up stage
			stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
			stage.addChild(GraphicsUtil.shapeFromSize(width, height, Style.PANEL));
			
			// Add the gui			
			frameCountLabel = new Label(stage, 5, 6, "Frame: 0 / 0");
			
			timeSlider = new Slider("horizontal", stage, 5, 25, onTimeSlider);
			timeSlider.width = 780;
			
			var buttonPos:int = 5;
			new PushButton(stage, buttonPos, 50, "Play", onPlayButton);
			new PushButton(stage, buttonPos += 105, 50, "Pause", onPauseButton);
			new PushButton(stage, buttonPos += 105, 50, "Sequence A", onSequenceA);
			new PushButton(stage, buttonPos += 105, 50, "Sequence B", onSequenceB);
			new PushButton(stage, buttonPos += 105, 50, "Sequence C", onSequenceC);
			new PushButton(stage, buttonPos += 105, 50, "Sequence All", onSequenceAll);			
			new PushButton(stage, buttonPos += 105, 50, "End Sequence", endSequence);			
			

			// Get updates from timeline and watch FPS
			// (FPS is reason to use ENTER_FRAME on main instead of TweenEvent.UPDATE on timeline)
			Main.self.addEventListener(Event.ENTER_FRAME, onEnterFrame);

			// Position it under the main window
			this.x = Main.self.stage.nativeWindow.bounds.left;
			this.y = Main.self.stage.nativeWindow.bounds.bottom;
			
			
			// Close when the parent closes
			// "windowOptions.owner = Main.self.stage.nativeWindow;" should work, but doesn't
			Main.self.stage.nativeWindow.addEventListener(Event.CLOSING, function():void { close(); });
		}
		
		// Control callbacks
		private function onTimeSlider(e:Event):void {
			target.timeline.currentTime = Math.min(target.timeline.duration, Math.round(timeSlider.value)); 
		}
		
		
		private function onSequenceA(e:Event):void {
			target.playSequenceA();
			updateTimeSlider();			
		}
		
		
		private function onSequenceB(e:Event):void {
			target.playSequenceB();
			updateTimeSlider();			
		}		
		
		
		private function onSequenceC(e:Event):void {
			target.playSequenceC();
			updateTimeSlider();	
		}
		
		private function onSequenceAll(e:Event):void {
			target.playSequenceAll();
			updateTimeSlider();	
		}		
		
		
		private function endSequence(e:Event):void {
			target.endSequence();
		}		
		
		
		private function onPlayButton(e:Event):void {
			if (target.timeline != null) target.timeline.play();
		}
		
		
		private function onPauseButton(e:Event):void {
			if (target.timeline != null) target.timeline.pause();
		}
		
		
		private function updateTimeSlider():void {
			timeSlider.maximum = target.timeline.totalDuration;
			timeSlider.value = target.timeline.currentTime;
		}
		
		
		// Watch the timeline to reflect updates in the control panel
		private function onEnterFrame(e:Event):void {
			if (target.timeline != null) {
				frameCountLabel.text = "Timeline Controls \t Frame: " + target.timeline.currentTime + " / " + 	target.timeline.totalDuration + "\tFPS: " + Main.fpsMeter.fps;
			

				if (target.timeline.active) {
					timeSlider.value = target.timeline.currentTime;					
				}
			}
		}
			
		
	}
}


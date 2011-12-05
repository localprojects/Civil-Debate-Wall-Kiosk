package com.civildebatewall {
	
	import com.bit101.components.CheckBox;
	import com.bit101.components.Label;
	import com.bit101.components.PushButton;
	import com.bit101.components.TextArea;
	import com.bit101.components.Window;
	import com.kitschpatrol.futil.utilitites.CoreUtil;
	import com.kitschpatrol.futil.utilitites.FileUtil;
	
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	import flash.system.System;
	
	public class Dashboard extends Window	{
		private var randomOpinionToggle:CheckBox;
		
		
		private var wallsaverFrameLabel:Label;
		private var frameRateLabel:Label;
		private var memoryUsageLabel:Label;
		private var framesRenderedLabel:Label;
		private var latencyLabel:Label; 
		
		private var inactivityLabel:Label;
		
		private var stateTextArea:TextArea;
		
		private var framesRendered:uint;		
		private var memory:int;
		private var maxMemory:int;
		
		public function Dashboard(parent:DisplayObjectContainer = null, xpos:Number=0, ypos:Number=0, title:String = "Dashboard")	{
			super(parent, xpos, ypos, title);
			this.width = 250;
			this.height = 500;
			this.hasMinimizeButton = true;
			this.minimized = true;
			
			new PushButton(this, 5, 5, "Play Sequence A", function():void { CivilDebateWall.self.PlaySequenceA(); });
			new PushButton(this, 110, 5, "Play Sequence B", function():void { CivilDebateWall.self.PlaySequenceB(); });
			new PushButton(this, 5, 55, "Slow", function():void { CoreUtil.sleep(1000); });
			new PushButton(this, 110, 55, "Update Data", function():void { CivilDebateWall.data.update(); });
			new PushButton(this, 110, 30, "Test Image Save", function():void {
				CivilDebateWall.kiosk.view.portraitCamera.takePhoto();
				FileUtil.saveJpeg(CivilDebateWall.kiosk.view.portraitCamera.cameraBitmap, CivilDebateWall.settings.imagePath, "test-image.jpg");			
			});
			
			new PushButton(this, 5, 80, "Inactive", function():void { CivilDebateWall.state.setView(CivilDebateWall.kiosk.view.inactivityOverlayView) });			
			new PushButton(this, 5, 30, "Calibrate Camera", function():void { CivilDebateWall.kiosk.view.cameraCalibrationOverlayView(); });
			
			//new CheckBox(this, 5, 75, "Ordered Opinion Rows", function():void {CivilDebateWall.wallSaver.orderedOpinionRows = !CivilDebateWall.wallSaver.orderedOpinionRows });
			
			wallsaverFrameLabel = new Label(this, 5, 100, "Sync Frame Number:");
			frameRateLabel = new Label(this, 5, 125, "Frame Rate:");
			memoryUsageLabel = new Label(this, 5, 135, "Memory Usage:");
			framesRenderedLabel = new Label(this, 5, 150, "Frames Rendered:");
			latencyLabel = new Label(this, 5, 175, "Latency: ");
			inactivityLabel = new Label(this, 5, 162, "Inactivity:");
			
			stateTextArea = new TextArea(this, 5, 200, "State")
			stateTextArea.width = 240;
			stateTextArea.height = 300;
			
			CivilDebateWall.self.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		
		private function onEnterFrame(e:Event):void {
			
			wallsaverFrameLabel.text = "Frame Number: " + CivilDebateWall.flashSpan.frameCount;
			frameRateLabel.text = "Frame Rate: " + CivilDebateWall.self.fpsMeter.fps;
			framesRenderedLabel.text = "Frames Rendered: " + framesRendered++;
			latencyLabel.text = "Latency: " + CivilDebateWall.flashSpan.settings.thisScreen.latency;
			
			memory = Math.round(System.totalMemory / 1024 / 1024)
			maxMemory = Math.max(memory, maxMemory);
			memoryUsageLabel.text = "Memory Usage: " + memory + " MB \tMax: " + maxMemory + " MB"; 
				
			stateTextArea.text = CivilDebateWall.state.stateLog();
			
			var armedString:String = CivilDebateWall.inactivityTimer.armed ? "(ARMED)" : "(DISARMED)";
			
			inactivityLabel.text = "Inactivity: " + CivilDebateWall.inactivityTimer.secondsInactive + " / " + CivilDebateWall.settings.inactivityTimeout + " " + armedString;
		}

		
		
	}
}
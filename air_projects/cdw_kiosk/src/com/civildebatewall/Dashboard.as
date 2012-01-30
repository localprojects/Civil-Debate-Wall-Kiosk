/*--------------------------------------------------------------------
Civil Debate Wall Kiosk
Copyright (c) 2012 Local Projects. All rights reserved.

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU Affero General Public License as
published by the Free Software Foundation, either version 3 of the
License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU Affero General Public License for more details.

You should have received a copy of the GNU Affero General Public
License along with this program. 

If not, see <http://www.gnu.org/licenses/>.
--------------------------------------------------------------------*/

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
	
	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.getLogger;
	
	public class Dashboard extends Window	{

		private static const logger:ILogger = getLogger(Dashboard);
		
		private var randomOpinionToggle:CheckBox;
		private var wallsaverFrameLabel:Label;
		private var frameRateLabel:Label;
		private var memoryUsageLabel:Label;
		private var framesRenderedLabel:Label;
		private var imagesLoadedLabel:Label;
		private var latencyLabel:Label; 
		private var inactivityTimerLabel:Label;
		private var randomDebateTimerLabel:Label;
		private var dataUpdateTimerLabel:Label;
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
			
			new PushButton(this, 5, 5, "Play Sequence A", function():void { CivilDebateWall.self.playSequenceA(); });
			new PushButton(this, 110, 5, "Play Sequence B", function():void { CivilDebateWall.self.playSequenceB(); });
			new PushButton(this, 5, 55, "Slow", function():void { CoreUtil.sleep(1000); });
			new PushButton(this, 110, 55, "Update Data", function():void { CivilDebateWall.data.update(); });
			new PushButton(this, 110, 30, "Test Image Save", function():void {
				CivilDebateWall.kiosk.portraitCamera.takePhoto();
				FileUtil.saveJpeg(CivilDebateWall.kiosk.portraitCamera.cameraBitmap, CivilDebateWall.settings.imagePath, "test-image.jpg");			
			});
			
			new PushButton(this, 5, 80, "Inactive", function():void { CivilDebateWall.state.setView(CivilDebateWall.kiosk.inactivityOverlayView) });			
			new PushButton(this, 5, 30, "Calibrate Camera", function():void { CivilDebateWall.kiosk.cameraCalibrationOverlayView(); });

			wallsaverFrameLabel = new Label(this, 5, 100, "Sync Frame Number:");
			imagesLoadedLabel = new Label(this, 5, 110, "Images loaded:");
			frameRateLabel = new Label(this, 5, 120, "Frame Rate:");
			memoryUsageLabel = new Label(this, 5, 130, "Memory Usage:");
			framesRenderedLabel = new Label(this, 5, 140, "Frames Rendered:");
			inactivityTimerLabel = new Label(this, 5, 150, "Inactivity Timer:");
			randomDebateTimerLabel = new Label(this, 5, 160, "Random Debate Timer:");
			dataUpdateTimerLabel = new Label(this, 5, 170, "Data Update Timer:");
			latencyLabel = new Label(this, 5, 180, "Latency: ");
			
			stateTextArea = new TextArea(this, 5, 200, "State")
			stateTextArea.width = 240;
			stateTextArea.height = 300;
			
			CivilDebateWall.self.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		
		private function onEnterFrame(e:Event):void {
			// TODO stop these when hidden
			wallsaverFrameLabel.text = "Sync Frame Number: " + CivilDebateWall.flashSpan.frameCount;
			if (CivilDebateWall.data.photoQueue != null) {			
				imagesLoadedLabel.text = "Images loaded: " + CivilDebateWall.data.photoQueue.bytesLoaded + " / " + CivilDebateWall.data.photoQueue.bytesTotal;
			}		
			frameRateLabel.text = "Frame Rate: " + CivilDebateWall.self.fpsMeter.fps;
			
			memory = Math.round(System.totalMemory / 1024 / 1024)
			maxMemory = Math.max(memory, maxMemory);
			memoryUsageLabel.text = "Memory Usage: " + memory + " MB \tMax: " + maxMemory + " MB";
			
			framesRenderedLabel.text = "Frames Rendered: " + framesRendered++;	
			
			inactivityTimerLabel.text = "Inactivity Timer: " + CivilDebateWall.state.secondsInactive + " / " + CivilDebateWall.settings.inactivityTimeout + " " + (CivilDebateWall.state.inactivityOverlayArmed ? "(ARMED)" : "(DISARMED)");
			randomDebateTimerLabel.text = "Random Debate Timer: " + CivilDebateWall.randomDebateTimer.currentCount + " " + (CivilDebateWall.randomDebateTimer.running ? "(RUNNING)" : "(STOPPED)");
			dataUpdateTimerLabel.text = "Data Update Timer: " + CivilDebateWall.dataUpdateTimer.currentCount + " " + (CivilDebateWall.dataUpdateTimer.running ? "(RUNNING)" : "(STOPPED)");			
			latencyLabel.text = "Latency: " + CivilDebateWall.flashSpan.settings.thisScreen.latency;
			
			stateTextArea.text = CivilDebateWall.state.stateLog();
		}
		
	}
}

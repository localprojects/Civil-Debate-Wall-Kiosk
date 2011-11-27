package com.civildebatewall {
	import com.bit101.components.*;
	import com.civildebatewall.data.Question;
	import com.civildebatewall.kiosk.Kiosk;
	
	import flash.display.*;
	import flash.events.Event;
	
	
	public class Dashboard extends Window	{
		
		private var logBox:TextArea;
		private var viewChooser:ComboBox;
		private var overlaySlider:Slider;
		private var focalLengthSlider:Slider;
		private var barTestSlider:Slider;		
		
		
		public function Dashboard(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0, title:String="Dashboard")	{
			super(parent, xpos, ypos, title);
			this.width = 250;
			this.height = 500;
			this.hasMinimizeButton = true;
			this.minimized = true;
			logBox = new TextArea(this, 5, 5, "Dashboard ready");
			logBox.width = this.width - 10;
			logBox.height = 90;
			
			overlaySlider = new Slider("horizontal", this, 120, 103, onOverlaySlider);
			overlaySlider.minimum = 0;
			overlaySlider.maximum = 1;
			overlaySlider.value = 0.5;
			
			focalLengthSlider = new Slider("horizontal", this, 120, 120, onFocalLengthSlider);
			focalLengthSlider.minimum = 1;
			focalLengthSlider.maximum = 3;
			focalLengthSlider.value = 1;	
			
		
			
			viewChooser = new ComboBox(this, 5, 140, 'View');
			viewChooser.addItem('Home');
			viewChooser.addItem('Debate Overlay');
			viewChooser.addItem('Pick Stance');	
			viewChooser.addItem('SMS Prompt');
			viewChooser.addItem('Photo Booth');
			viewChooser.addItem('Name Entry');
			viewChooser.addItem('Verify Opinion');
			viewChooser.addItem('Edit Opinion');	
			viewChooser.addItem('Stats Overlay');
			viewChooser.addItem('Inactivity Overlay');
			viewChooser.addItem('Submit Overlay');			
			
			viewChooser.numVisibleItems = viewChooser.items.length;
			
			viewChooser.addEventListener(Event.SELECT, onViewSelect);
			viewChooser.width = this.width - 10;
			

			
			
			
		}
		
		// logs a single line of text to the window
		public function log(s:String):void {
			logBox.text = s + "\n" + logBox.text;
		}
		
		private function onOverlaySlider(e:Event):void {
			Kiosk.testOverlay.alpha = overlaySlider.value;
		}
		
		private function onFocalLengthSlider(e:Event):void {
			CivilDebateWall.kiosk.view.portraitCamera.setFocalLength(focalLengthSlider.value);
		}
		

		
		private function onViewSelect(e:Event):void {
			var selection:String = e.target.selectedItem;

			if (selection == 'Home') CivilDebateWall.kiosk.view.homeView();
			if (selection == 'Debate Overlay') CivilDebateWall.kiosk.view.threadView();
			if (selection == 'Photo Booth') CivilDebateWall.kiosk.view.photoBoothView();
			if (selection == 'Stats Overlay') CivilDebateWall.kiosk.view.statsView();
			if (selection == 'Inactivity Overlay') CivilDebateWall.kiosk.view.inactivityOverlayView();			
		}
		
		
	}
}
package com.civildebatewall {
	import com.bit101.components.*;
	import com.civildebatewall.data.Question;
	
	import flash.display.*;
	import flash.events.Event;
	import com.civildebatewall.kiosk.Kiosk;
	
	
	public class Dashboard extends Window	{
		
		private var logBox:TextArea;
		private var viewChooser:ComboBox;
		private var testOverlayCheckbox:CheckBox;
		private var overlaySlider:Slider;
		private var focalLengthSlider:Slider;
		private var barTestSlider:Slider;		
		
		
		private var testImages:Array;
		
		public function Dashboard(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0, title:String="Dashboard")	{
			super(parent, xpos, ypos, title);
			this.width = 250;
			this.height = 500;
			this.hasMinimizeButton = true;
			this.minimized = true;
			logBox = new TextArea(this, 5, 5, "Dashboard ready");
			logBox.width = this.width - 10;
			logBox.height = 90;
			
			testOverlayCheckbox = new CheckBox(this, 5, 103, 'Show test overlay', onOverlayToggle);
			
			overlaySlider = new Slider("horizontal", this, 120, 103, onOverlaySlider);
			overlaySlider.minimum = 0;
			overlaySlider.maximum = 1;
			overlaySlider.value = 0.5;
			
			focalLengthSlider = new Slider("horizontal", this, 120, 120, onFocalLengthSlider);
			focalLengthSlider.minimum = 1;
			focalLengthSlider.maximum = 3;
			focalLengthSlider.value = 1;	
			
			barTestSlider = new Slider("horizontal", this, 120, 130, onBarTestSlider);
			barTestSlider.minimum = 0;
			barTestSlider.maximum = 100;
			barTestSlider.value = 50;				
			
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
			
			new PushButton(this, 5, viewChooser.y + viewChooser.height + 5, "Test", function():void {
				//CDW.data.question = new Question({'id':'32424', 'text':'asdfasdf'});
				
			
			});
			
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
		
		private function onBarTestSlider(e:Event):void {
			CivilDebateWall.kiosk.view.statsOverlay.voteStatBar.setLabels(Math.round(barTestSlider.value * 10), Math.round(barTestSlider.value * 100));
			CivilDebateWall.kiosk.view.statsOverlay.voteStatBar.barPercent = barTestSlider.value;
			
		}		
		
		private function onOverlayToggle(e:Event):void {
			Kiosk.testOverlay.visible = testOverlayCheckbox.selected;
		}
		
		private function onViewSelect(e:Event):void {
			var selection:String = e.target.selectedItem;

			if (selection == 'Home') CivilDebateWall.kiosk.view.homeView();
			if (selection == 'Debate Overlay') CivilDebateWall.kiosk.view.threadView();
	//		if (selection == 'Pick Stance') CivilDebateWall.kiosk.view.pickStanceView();
			if (selection == 'SMS Prompt') CivilDebateWall.kiosk.view.smsPromptView();
			if (selection == 'Photo Booth') CivilDebateWall.kiosk.view.photoBoothView();
			if (selection == 'Name Entry') CivilDebateWall.kiosk.view.nameEntryView();
			if (selection == 'Verify Opinion') CivilDebateWall.kiosk.view.verifyOpinionView();
			if (selection == 'Edit Opinion') CivilDebateWall.kiosk.view.editOpinionView();
			if (selection == 'Stats Overlay') CivilDebateWall.kiosk.view.statsView();
			if (selection == 'Inactivity Overlay') CivilDebateWall.kiosk.view.inactivityOverlayView();
			if (selection == 'Submit Overlay') CivilDebateWall.kiosk.view.submitOverlayView();			
		}
		
		
	}
}
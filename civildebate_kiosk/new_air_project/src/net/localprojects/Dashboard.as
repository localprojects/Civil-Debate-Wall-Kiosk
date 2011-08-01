package net.localprojects {
	import com.bit101.components.*;
	
	import flash.display.DisplayObjectContainer;
	import flash.events.Event;
	
	public class Dashboard extends Window	{
		
		private var logBox:TextArea;
		private var viewChooser:ComboBox;
		
		public function Dashboard(parent:DisplayObjectContainer=null, xpos:Number=0, ypos:Number=0, title:String="Dashboard")	{
			super(parent, xpos, ypos, title);
			this.width = 250;
			this.height = 150;
			this.hasMinimizeButton = true;
			this.minimized = true;
			logBox = new TextArea(this, 5, 5, "Dashboard ready");
			logBox.width = this.width - 10;
			logBox.height = 90;
			
			
			viewChooser = new ComboBox(this, 5, 100, 'View');
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
			
			viewChooser.numVisibleItems = viewChooser.items.length;
			
			viewChooser.addEventListener(Event.SELECT, onViewSelect);
			viewChooser.width = this.width - 10;			
		}
		
		// logs a single line of text to the window
		public function log(s:String):void {
			logBox.text = s + "\n" + logBox.text;
		}
		
		private function onViewSelect(e:Event):void {
			var selection:String = e.target.selectedItem;
			
			if (selection == 'Home') CDW.view.homeView();
			if (selection == 'Debate Overlay') CDW.view.debateOverlayView();
			if (selection == 'Pick Stance') CDW.view.pickStanceView();			
			if (selection == 'SMS Prompt') CDW.view.textPromptView();
			if (selection == 'Photo Booth') CDW.view.photoBoothView();
			if (selection == 'Name Entry') CDW.view.nameEntryView();			
			if (selection == 'Verify Opinion') CDW.view.verifyOpinionView();
			if (selection == 'Edit Opinion') CDW.view.editOpinionView();			
			if (selection == 'Stats Overlay') CDW.view.statsView();
			if (selection == 'Inactivity Overlay') CDW.view.inactivityView();						
			

			
			
		}
		
		
	}
}
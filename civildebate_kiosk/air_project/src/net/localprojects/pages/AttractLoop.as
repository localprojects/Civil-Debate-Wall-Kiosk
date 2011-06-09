package net.localprojects.pages {
	
	import flash.events.Event;
	
	public class AttractLoop extends Page	{
		
		import com.bit101.components.PushButton;		
		
		public function AttractLoop() {
			super();
			name = "attract";
			setTitle("The Great Civil Debate Wall");
			setPlaceholderText("Attract Loop");
			
			// add the shutter button
			var button:PushButton = new PushButton(this, 0, 0, "TOUCH TO START", onTouch);
			button.x = (Main.stageWidth - button.width) / 2;
			button.y = Main.stageHeight - 150;						
		}
		
		
		private function onTouch(e:Event):void {
			// todo go to view
			trace("touching to start");
			Main.mainRef.goToPage("home");
		}		
	}
}
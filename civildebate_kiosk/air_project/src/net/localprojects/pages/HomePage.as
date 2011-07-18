package net.localprojects.pages {
	import com.bit101.components.PushButton;
	import com.greensock.*;
	
	import flash.display.*;
	import flash.events.*;
	
	import net.localprojects.*;
	import net.localprojects.blocks.*;
	import net.localprojects.ui.*;
	

	public class HomePage extends Page {	

		public function HomePage() {
			super();
			init();
		}
		
		private function init():void {
			// todo use global blocks
//			blocks.push(Main.header);
//			blocks.push(Main.debatePicker);
//			blocks.push(Main.question);
//			blocks.push(Main.faceOff);
			
			
			Main.viewManager.setBlocks(Main.viewManager.header,
																 Main.viewManager.debatePicker,
																 Main.viewManager.question,
																 Main.viewManager.faceOff);
			
			
			this.name = "home"; // how we find it
//			this.setTitle("This week's debate:\n[voting topic]"); 
//			this.setPlaceholderText("Home Page");
			
			// put everything on the page
			
			// temp buttons
			var replayButton:BigButton = new BigButton("Replay Debate");
			replayButton.x = 531;
			replayButton.y = 1550;
			addChild(replayButton);			
			
			var opinionButton:BigButton = new BigButton("Add Your Opinion");
			opinionButton.x = 29;
			opinionButton.y = 1550;		
			addChild(opinionButton);

		}		
	}
}
package net.localprojects.pages {
	import com.bit101.components.PushButton;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.PerspectiveProjection;
	import flash.geom.Point;
	
	import net.localprojects.MugShot;
	import net.localprojects.blocks.Header;
	import net.localprojects.ui.BigButton;
	

	public class HomePage extends Page {	

		public function HomePage() {
			super();
			init();
		}
		
		private function init():void {
			blocks.push(Main.header);
			blocks.push(Main.debatePicker);
			
			this.name = "home"; // how we find it
//			this.setTitle("This week's debate:\n[voting topic]"); 
//			this.setPlaceholderText("Home Page");
			
			// put everything on the page
			for (var i:int = 0; i < blocks.length; i++) {
				addChild(blocks[i]);
			}
		}		
	}
}
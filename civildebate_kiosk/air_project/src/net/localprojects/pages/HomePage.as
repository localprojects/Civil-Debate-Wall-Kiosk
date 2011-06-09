package net.localprojects.pages {
	import flash.display.Sprite;
	import flash.events.Event;
	
	import net.localprojects.MugShot;
	

	public class HomePage extends Page {	

		
		private var shot1:MugShot;
		private var shot2:MugShot;		
		
		public function HomePage() {
			super();
			this.name = "home"; // how we find it
			this.setTitle("This week's debate"); 
			this.setPlaceholderText("Home Page");
			
			shot1 = new MugShot();
			shot1.rotationY = 345;
			shot1.x = ((Main.stageWidth / 2) - shot1.w) / 2;
			shot1.y = 240;
			addChild(shot1);
			
			shot2 = new MugShot();
			shot2.rotationY = -345;
			shot2.x = (((Main.stageWidth / 2) - shot1.w) / 2) + (Main.stageWidth / 2);
			shot2.y = 240;			
			addChild(shot2);			

				
			this.addEventListener(Event.ENTER_FRAME, update);
			
		}
		
		private function update(e:Event):void {
			//shot2.rotationY = Main.mouseX;			
		}
		
	}
}
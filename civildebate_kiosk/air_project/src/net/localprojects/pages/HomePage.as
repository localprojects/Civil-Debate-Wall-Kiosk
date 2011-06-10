package net.localprojects.pages {
	import com.bit101.components.PushButton;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.PerspectiveProjection;
	import flash.geom.Point;
	
	import net.localprojects.MugShot;
	

	public class HomePage extends Page {	

		
		private var shot1:MugShot;
		private var shot2:MugShot;		
		
		public function HomePage() {
			super();
			this.name = "home"; // how we find it
			this.setTitle("This week's debate:\n[voting topic]"); 
			this.setPlaceholderText("Home Page");
			
			// add question of the week
			var prevButton:PushButton = new PushButton(this, 0, 0, "PREV QUESTION", null);
			prevButton.x = 20;
			prevButton.y = 76;
			
			var nextButton:PushButton = new PushButton(this, 0, 0, "NEXT QUESTION", null);
			nextButton.x = Main.stageWidth - (nextButton.width + 20);
			nextButton.y = 76;
			

			
			
			
			
			shot1 = new MugShot();
			
			shot1.x = Main.stageWidth * 0.25;
			shot1.y = 310;
			
			shot1.transform.perspectiveProjection = new PerspectiveProjection ();
			shot1.transform.perspectiveProjection.projectionCenter = shot1.localToGlobal(new Point(0, 0));						
			
			shot1.rotationY = 345;			
			
			addChild(shot1);

			shot2 = new MugShot();
			
			shot2.x = Main.stageWidth * 0.75;
			shot2.y = 310;

			shot2.transform.perspectiveProjection = new PerspectiveProjection ();
			shot2.transform.perspectiveProjection.projectionCenter = shot2.localToGlobal(new Point(0, 0));			
			
			shot2.rotationY = -345;			
			
			addChild(shot2);			

			
			
			// rebuttal buttons
			var leftRebuttal:PushButton = new PushButton(this, 0, 0, "ENTER REBUTTAL", onRebuttal);
			leftRebuttal.x = (Main.stageWidth * .25) - (leftRebuttal.width / 2);
			leftRebuttal.y = 400;
			
			var rightRebuttal:PushButton = new PushButton(this, 0, 0, "ENTER REBUTTAL", onRebuttal);
			rightRebuttal.x = (Main.stageWidth * .75) - (rightRebuttal.width / 2);
			rightRebuttal.y = 400;			
						
			
			// vote buttons
			var leftVote:PushButton = new PushButton(this, 0, 0, "VOTE UP", null);
			leftVote.x = (Main.stageWidth * .25) - (leftVote.width / 2);
			leftVote.y = 500;
			
			var rightVote:PushButton = new PushButton(this, 0, 0, "VOTE UP", null);
			rightVote.x = (Main.stageWidth * .75) - (rightVote.width / 2);
			rightVote.y = 500;			
						
			
			
				
			this.addEventListener(Event.ENTER_FRAME, update);
			
		}
		
		private function onRebuttal(e:Event):void {
			Main.state.setView(Main.portraitPage);
		}
		
		private function update(e:Event):void {
			//shot2.rotationY = Main.mouseX;			
		}
		
	}
}
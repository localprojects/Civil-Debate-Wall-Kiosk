package net.localprojects.pages {
	import com.bit101.components.PushButton;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.geom.PerspectiveProjection;
	import flash.geom.Point;
	
	import net.localprojects.*;
	import net.localprojects.blocks.*;
	import net.localprojects.ui.*;
	

	public class HomePage extends Page {	

		public function HomePage() {
			super();
			init();
		}
		
		private function init():void {
			blocks.push(Main.header);
			blocks.push(Main.debatePicker);
			blocks.push(Main.question);			
			
			this.name = "home"; // how we find it
//			this.setTitle("This week's debate:\n[voting topic]"); 
//			this.setPlaceholderText("Home Page");
			
			// put everything on the page
			for (var i:int = 0; i < blocks.length; i++) {
				addChild(blocks[i]);
			}
			
			
			
			
			
			
			
			
			
			
			// debate comparator overlay
			// TODO move to black class?
			var debator:Sprite = new Sprite();
			
			debator.graphics.beginFill(0xffffff);
			debator.graphics.drawRect(0, 0, 1010, 1221);
			debator.graphics.endFill();
			
			debator.x = 30;
			debator.y = 264;

			//var debatorMask:Bitmap = new Bitmap(new BitmapData(1010, 1221, false, 0xff0000));
			//debatorMask.bitmapData.draw(Assets.triangleMask);
			
			Assets.triangleMask.x = debator.x;
			Assets.triangleMask.y = debator.y;
						
			
			// insert the portrait
			var portrait:Bitmap = new Bitmap(Assets.obama.bitmapData.clone());
			portrait.x = 0;
			portrait.y = 221;
			
			debator.addChild(portrait);
			
			
			
			addChild(Assets.triangleMask);
			addChild(debator);

			debator.mask = Assets.triangleMask;			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
			
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
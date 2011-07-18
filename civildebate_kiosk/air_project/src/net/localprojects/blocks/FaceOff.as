package net.localprojects.blocks {
	import com.greensock.*;
	
	import flash.display.*;
	import flash.geom.*;
	import flash.text.*;
	
	import net.localprojects.*;
	import net.localprojects.elements.*;
	
	public class FaceOff extends Block	{
		
		private var leftFace:Face;
		private var rightFace:Face;
		
		public function FaceOff() {
			super();
			init();
		}
		
		private function init():void {
			// background
			graphics.beginFill(0x000000);
			graphics.drawRect(0, 0, 1080, 1304);
			graphics.endFill();		
			
			this.x = 0;
			this.y = 245;


			// TODO load face data from DB
			// TODO capture and store it when the image is captured			
			leftFace = new LeftFace();
			leftFace.setName("John Paul Barbagallo");
			leftFace.setStatement("Our performance in education has been behind many countries and our youths are going to be unable to compete for jobs in the global market.");
			leftFace.setPortrait(new Bitmap(Assets.obama.bitmapData.clone()), new Rectangle(346, 388, 542, 688)); 
			leftFace.x = 30;
			leftFace.y = 20;
				
			rightFace = new RightFace();
			rightFace.setName("John Paul Barbagallo");
			rightFace.setStatement("Our performance in education has been behind many countries and our youths are going to be unable to compete for jobs in the global market.");
			rightFace.setPortrait(new Bitmap(Assets.obama.bitmapData.clone()), new Rectangle(346, 388, 542, 688)); 
			rightFace.x = 40;
			rightFace.y = 33;
			
			
			
			// set their position
			
			//feed in data from the state
			
			// add to stage
			addChild(leftFace);
			addChild(rightFace);
			
			
		}
		
	}
}
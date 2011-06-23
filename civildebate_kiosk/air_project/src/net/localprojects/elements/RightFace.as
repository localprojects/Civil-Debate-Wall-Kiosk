package net.localprojects.elements {
	
	import net.localprojects.*;
	import flash.geom.*;
	import flash.display.*;
	
	public class RightFace extends Face {
		
		public function RightFace() {
			triangleMask = new Assets.triangleMaskClass as Sprite;

			// flip it
			triangleMask.scaleX = -1;			
			triangleMask.scaleY = -1;
			triangleMask.x += triangleMask.width;
			triangleMask.y += triangleMask.height;
						
			tintColor =  0xff6213;
			nameTextColor = 0xff5a00;
			statementTextColor = 0xff5a00;	
			faceTarget = new Point(792, 662); // ideal center face position
			super();
			
			// position the statement wrapper (not at the top left)
			statementWrapper.y = this.height - statementWrapper.height;
			nameText.x = 200;
			statementText.x = 200;
		}
	}
}
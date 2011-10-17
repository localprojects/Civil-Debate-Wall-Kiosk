package net.localprojects.elements {
	
	import net.localprojects.*;
	import flash.geom.*;
	import flash.display.*;
	
	public class LeftFace extends Face {
		
		public function LeftFace() {
			triangleMask = new Assets.triangleMaskClass as Sprite;
			tintColor =  0x01a5ec;
			nameTextColor = 0x00a5ff;
			statementTextColor = 0x00b9ff;	
			faceTarget = new Point(370, 480); // ideal center face position
			super();
		}
	}
}
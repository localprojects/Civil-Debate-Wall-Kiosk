package net.localprojects {
	import flash.geom.Matrix;
	import flash.geom.Transform;
	import flash.display.Sprite;
	
	
	public class Utilities {
		public function Utilities()	{
		}
		
		public static function setRegistrationPoint(s:Sprite, regx:Number, regy:Number, showRegistration:Boolean):void {
			//translate movieclip 
			s.transform.matrix = new Matrix(1, 0, 0, 1, -regx, -regy);
			
			//registration point.
			if (showRegistration)
			{
				var mark:Sprite = new Sprite();
				mark.graphics.lineStyle(1, 0x000000);
				mark.graphics.moveTo(-5, -5);
				mark.graphics.lineTo(5, 5);
				mark.graphics.moveTo(-5, 5);
				mark.graphics.lineTo(5, -5);
				s.parent.addChild(mark);
			}
		}
		
	}
}
package com.kitschpatrol.futil.constants {
	
	import flash.geom.Point;
	
	
	
	public class Alignment {
				
		// Have to use function to get a new copy of the object each time
		public static function get CENTER():Point { return new Point(0.5, 0.5); }	
		public static function get TOP_LEFT():Point { return new Point(0.0, 0.0); }
		public static function get TOP():Point { return new Point(0.5, 0); }		
		public static function get TOP_RIGHT():Point { return new Point(1, 0); }
		public static function get RIGHT():Point { return new Point(1, 0.5); }		
		public static function get BOTTOM_RIGHT():Point { return new Point(1, 1); }
		public static function get BOTTOM():Point { return new Point(0.5, 1); }		
		public static function get BOTTOM_LEFT():Point { return new Point(0, 1); }
		public static function get LEFT():Point { return new Point(0, 0.5); }
		

		// these put the object just outside the stage
		public static const OFF_STAGE_TOP:String = "offStageTop";
		public static const OFF_STAGE_RIGHT:String = "offStageRight";
		public static const OFF_STAGE_BOTTOM:String = "offStageBottom";		
		public static const OFF_STAGE_LEFT:String = "offStageLeft";
		public static const CENTER_STAGE:String = "centerStage";
		
		// ripped from flashx.textLayout.formats.TextAlign; for convenience
		public static const TEXT_LEFT:String = "left";
		public static const TEXT_CENTER:String = "center";
		public static const TEXT_RIGHT:String = "right";
		public static const TEXT_JUSTIFY:String = "justify";		
	}
}
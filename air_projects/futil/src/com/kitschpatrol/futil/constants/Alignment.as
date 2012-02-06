//-------------------------------------------------------------------------------
// Copyright (c) 2012 Eric Mika
// 
// Permission is hereby granted, free of charge, to any person obtaining a copy 
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights 
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell 
// copies of the Software, and to permit persons to whom the Software is 
// furnished to do so, subject to the following conditions:
// 	
// 	The above copyright notice and this permission notice shall be included in 
// 	all copies or substantial portions of the Software.
// 		
// 	THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, 
// 	EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF 
// 	MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. 
// 	IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY 
// 	CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT 
// 	OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR 
// 	THE	USE OR OTHER DEALINGS IN THE SOFTWARE.
//-------------------------------------------------------------------------------

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

package com.kitschpatrol.futil {
	import flash.geom.Point;

	public class Random	{
		
		public function Random() {
			throw new Error("Futil's Random is a static class and cannot be instantiated.");
		}
		
		
		
		// Convenience function for picking screen locations "in the wings"
		public static function randomOnScreenPoint(screenWidth:int, screenHeight:int):Point {
			return new Point(Random.range(0, screenWidth), Random.range(0, screenHeight));
		}
		
		public static function range(low:Number, high:Number):Number {
			return Math.random() * (high - low + 1) + low;			
		}
		
		
		
		// returns a random point from a field to the left of the screen
		public static function randomOffScreenLeftPoint(minEdgeDistance:Number, maxEdgeDistance:Number, screenWidth:int, screenHeight:int):Point {
			return new Point(
				range(-minEdgeDistance, -maxEdgeDistance),
				range(-maxEdgeDistance, screenHeight + maxEdgeDistance)
			);
		}
		
		public static function randomOffScreenRightPoint(minEdgeDistance:Number, maxEdgeDistance:Number, screenWidth:int, screenHeight:int):Point {
			return new Point(
				range(screenWidth + minEdgeDistance, screenWidth + maxEdgeDistance),
				range(-maxEdgeDistance, screenHeight + maxEdgeDistance)
			);
		}
		
		public static function randomOffScreenTopPoint(minEdgeDistance:Number, maxEdgeDistance:Number, screenWidth:int, screenHeight:int):Point {
			return new Point(
				range(-maxEdgeDistance, screenWidth + maxEdgeDistance),
				range(-minEdgeDistance, -maxEdgeDistance)
			);
		}
		
		public static function randomOffScreenBottomPoint(minEdgeDistance:Number, maxEdgeDistance:Number, screenWidth:int, screenHeight:int):Point {
			return new Point(
				range(-maxEdgeDistance, screenWidth + maxEdgeDistance),
				range(screenHeight + minEdgeDistance, screenHeight + maxEdgeDistance)
			);
		}
		
		// keep an array of the function to pick from
		private static const randomOffScreenFunctions:Vector.<Function> = new <Function>[
			randomOffScreenLeftPoint,
			randomOffScreenRightPoint,
			randomOffScreenTopPoint,
			randomOffScreenBottomPoint
		];
		
		public static function randomOffScreenPoint(minEdgeDistance:Number, maxEdgeDistance:Number, screenWidth:int, screenHeight:int):Point {
			return randomOffScreenFunctions[int(Math.random() * 4)](minEdgeDistance, maxEdgeDistance, screenWidth, screenHeight);
		}
		
	}
}
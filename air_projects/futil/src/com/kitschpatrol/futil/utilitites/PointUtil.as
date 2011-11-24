package com.kitschpatrol.futil.utilitites
{
	import flash.geom.Point;

	public class PointUtil
	{
		public static function distanceSquared(a:Point, b:Point):Number {
			return ((a.x - b.x) * (a.x - b.x)) + ((a.y - b.y) * (a.y - b.y));
		}
		
	}
}
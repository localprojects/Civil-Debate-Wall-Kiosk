package com.kitschpatrol.futil.utilitites {
	import com.kitschpatrol.futil.Math2;
	
	public class NumberUtil {
		
		
		// takes a number between 0 and 1 and steps it by the step value
		// like adjustring precision, but more flexible
		public static function quantize(normal:Number, stepSize:Number):Number {
			return int(normal / stepSize) * stepSize;
		}
		
		
		// only returns 0 or 1 if we are exactly on them, otherwise counts steps
		public static function quantizeInclusive(normal:Number, stepSize:Number):Number {
			if (normal == 0) return normal;
			if (normal == 1) return normal;
			
			// TODO last step already equals destination
			return int(Math2.map(normal, 0, 1, stepSize, 1) / stepSize) * stepSize;
		}
	
		// The start of a unit test for the above
		/*
		var counts:Object = {}; // keep stats
		for(var i:Number = 0; i <= 1; i += 0.01) {
			var quantized:Number = NumberUtil.quantizeInclusive(i, 0.2); 
			
			trace(i + " : " + quantized);
			
			// intiialize
			if (!counts.hasOwnProperty(quantized.toString())) counts[quantized.toString()] = 0;
			
			// increment
			counts[quantized.toString()]++;
		}
		Utilities.traceObject(counts);
		*/
		
		
		
	}
}
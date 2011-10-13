package com.civildebatewall.wallsaver.elements {
	import com.kitschpatrol.futil.Math2;
	
	import fl.motion.BezierSegment;
	
	import flash.display.Sprite;
	import flash.geom.Point;
	
	
	
	public class OpinionRow extends Sprite {
		
		// TODO Move the data
		
		public var lastStance:String;
		private var _step:Number;

		// where the in / out points are in the graph
		private var graphMidStart:Number = 0.2;
		private var graphMidEnd:Number = 0.8;
		
		// how long they last as a percentage of the animation
		private var inDuration:Number = 0.4;
		private var outDuration:Number = 0.4;		
		
		
		public function OpinionRow() {
			super();
			step = 0; 
		}
		
		
		public function get step():Number { return _step; }
		public function set step(n:Number):void {
			_step = n;
			
//			if (n == 0) {
//				// init
//				this.x = -this.width;
//			}
//			else if (n == 1) {
//				// end 
//				this.x = 5720;
//			}			
//			else if (n <= inDuration) {
//				// lerp in
//				//var introPosition:Number = Math2.map(n, 0, inDuration, 0, graphMidStart); // allows time control over intro and outro
//				//this.x = Math2.map(vectorLerp(introPosition, map), 0, graphMidStart, -this.width, -this.width + 5720); // TODO pass in total width
//				
//				var introPosition:Number = Math2.map(n, 0, inDuration, 0, graphMidStart); // allows time control over intro and outro
//				this.x = Math2.map(vectorLerp(introPosition, map), 0, 1, -this.width, 5720); // TODO pass in total width				
//			}
//			else if (n >= (1 - outDuration)) {
//				// lerp out
//				//var outroPosition:Number = Math2.map(n, 1 - outDuration, 1, graphMidEnd, 1); // allows time control over intro and outro
//				//this.x = Math2.map(vectorLerp(outroPosition, map), graphMidEnd, 1, 0, 5720); // TODO pass in total width
//				
//				var outroPosition:Number = Math2.map(n, 1 - outDuration, 1, graphMidEnd, 1); // allows time control over intro and outro
//				this.x = Math2.map(vectorLerp(outroPosition, map), 0, 1, -this.width, 5720); // TODO pass in total width				
//			}
//			else {
//				// middle
//				var middlePosition:Number = Math2.map(n, inDuration, 1 - outDuration, graphMidStart, graphMidEnd);
//				this.x = Math2.map(vectorLerp(middlePosition, map), 0, 1, -this.width, 5720); // TODO pass in total width				
//				//this.x = Math2.map(n, inDuration, 1 - outDuration, -this.width + 5720, 0); // TODO pass in total width				
//			}

			
			if (n == 0) {
				// init
				this.x = -this.width;
			}
			else if (n == 1) {
				// end 
				this.x = 5720;
			}
			else {
				// middle
				//this.x = Math2.map(vectorLerp(n, map), 0, 1, -this.width, 5720); // TODO pass in total width				
			}			
	
			
		}
		

		

		
		
		
		


	}
}
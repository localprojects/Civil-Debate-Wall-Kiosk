package com.civildebatewall.wallsaver.elements {

	import com.kitschpatrol.futil.easing.EaseMap;
	
	import flash.display.Sprite;
	

	public class OpinionRow extends Sprite {
				
		public var lastStance:String;
		private var _frame:int;

		public var xPositions:Vector.<int>;
		public var totalFrames:int;
		public var introFrameCount:int;
		public var outroFrameCount:int;
		

		public function OpinionRow() {
			super();
			_frame = 0; 
		}
		
		
		// Create X Position lookup table.
		// Mix of velocity and duration bound animation makes this unweildy to do directly in TweenMax.
		// Technically the right custom easing curve could do it, but that proved too imprecise.		
		public function calculateFrames(vxIntro:Number, vxMiddle:Number, vxOutro:Number, easeIntroFrames:int, easeOutroFrames:int, targetFrameCount:int = -1):void {			
			introFrameCount = Main.totalWidth / vxIntro;
			outroFrameCount = Main.totalWidth / vxOutro;			
			
			// First, calculate the frames for the longest row
			// Left to right
			var introFrames:Vector.<int> = new Vector.<int>(0);
			var middleFrames:Vector.<int> = new Vector.<int>(0);
			var outroFrames:Vector.<int> = new Vector.<int>(0);
			

			// Recalculate VX if required (to match total travel time of the longest row)
			if (targetFrameCount > -1) {
				//trace(vxMiddle);
				vxMiddle -= 0.01; // smaller is more accurate... but a performance sink
			}
			
			// Calculate intro frames, from the left
			var tempX:Number;
			
			tempX = (-this.width - Main.screenWidth) - vxIntro; // a little off-screen padding
			while (introFrames.length < (introFrameCount - easeIntroFrames)) {
				introFrames.push(tempX);
				tempX += vxIntro;
			}
			
			// Ease intro
			while (introFrames.length < introFrameCount) {
				introFrames.push(tempX);
				tempX += EaseMap.easeInQuart(introFrames.length, introFrameCount - easeIntroFrames, introFrameCount, vxIntro, vxMiddle);
			}
						
			
			// Calculate outro frames, from the right
			tempX = Main.totalWidth + vxOutro; // a little off-screen padding
			while (outroFrames.length < (outroFrameCount - easeOutroFrames)) {
				outroFrames.push(tempX);
				tempX -= vxOutro;
			}
			
			// Ease outro, <= since tempX is going to change below
			while (outroFrames.length < outroFrameCount) {
				tempX -= EaseMap.easeInQuart(outroFrames.length, outroFrameCount - easeOutroFrames, outroFrameCount, vxOutro, vxMiddle);				
				outroFrames.push(tempX);
			}	
						
			
			// now flip the outro, so the easing comes first
			outroFrames = outroFrames.reverse();
			
			// And fill in the middle, needs to move from the last frame in the intro to the first frame in the outro
			tempX = introFrames[introFrames.length - 1];
			
			while (tempX < outroFrames[0]) {
				tempX += vxMiddle;
				middleFrames.push(tempX);
			}
			middleFrames.pop();
			
			// Glue frame sets together
			this.xPositions = introFrames.concat(middleFrames).concat(outroFrames);
			
			this.totalFrames = this.xPositions.length - 1;
			
			// If we weren't the longest line, we'll need to adjust our middle velocity until
			// the total frame count roughtly matches the longest
			if (targetFrameCount > -1) {
				if (totalFrames < targetFrameCount) {
					// recurse! note vxMiddle is incremented at top
					calculateFrames(vxIntro, vxMiddle, vxOutro, easeIntroFrames, easeOutroFrames, targetFrameCount)
				}
			}
			
		}
		
		// Set the frame... tweened with TweenMax in OpinionSequence.
		public function get frame():Number { return _frame; }
		public function set frame(n:Number):void {
			_frame = Math.round(n); // faster way?
			this.x = xPositions[_frame];
			//trace("Frame: " + _frame + "\tPosition: " + this.xPositions[_frame]);
		}
		

	}
}
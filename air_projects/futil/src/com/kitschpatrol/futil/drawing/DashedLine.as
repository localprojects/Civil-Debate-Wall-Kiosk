package com.kitschpatrol.futil.drawing {
	
	import flash.display.CapsStyle;
	import flash.display.Graphics;
	import flash.display.LineScaleMode;
	import flash.display.Sprite;
	import flash.text.ReturnKeyLabel;

	public class DashedLine extends Sprite	{ // could be shape...
		// Builds on Senocular's Path class to make a tweenable, progressively drawing, color alternating dashed line
		
		// draw through this
		public var path:Path;

		public var colorA:uint;
		public var colorB:uint;
		public var thickness:Number;
		public var caps:String;
		public var onLength:Number;
		public var offLength:Number;
		
		private var _step:Number;	
		private var onStepSize:Number;
		private var offStepSize:Number;
		private var penStep:Number; // how far to move the		
		private var activeColor:uint;
		private var lineScaleMode:String;
		
		// TODO set more line style params? Thickness, etc?
		private var colorChanges:Vector.<DashedLineColor>;
		
		public function DashedLine(thickness:Number, onLength:Number, offLength:Number, colorA:uint, colorB:uint, caps:String = CapsStyle.NONE, lineScaleMode:String = LineScaleMode.NORMAL) {
			path = new Path();
			_step = 0;
			
			this.thickness = thickness;
			this.onLength = onLength;
			this.offLength = offLength;
			this.colorA = colorA;
			this.colorB = colorB;
			this.caps = caps;
			this.lineScaleMode = lineScaleMode;
			
			colorChanges = new Vector.<DashedLineColor>();
			
		}
		
		// quick hack for CDW... this should really be on Path.as instead...
		public function setColors(colorA:uint, colorB:uint):void {
			colorChanges.push(new DashedLineColor(colorA, colorB, path.length));
		}
		
		
		protected function draw():void {
			// from normal distance to pixels...			
			onStepSize = onLength / path.length; 
			offStepSize = offLength / path.length;						
			
			
			graphics.clear();
				
			// draw each dash
			var alternator:int = 0;
			for (var penStep:Number = 0; penStep < _step; penStep += (onStepSize + offStepSize)) {
				
				// cycle colors
				var currentLength:Number = penStep * path.length;
				
				// look up the color (optional)
				for (var i:int = 0; i < colorChanges.length; i++) {
					if (colorChanges[i].length > currentLength) {
						break;
					}
					else {
						colorA = colorChanges[i].colorA;
						colorB = colorChanges[i].colorB;
					}
				}
				
				activeColor = (alternator++ % 2 == 0) ? colorA : colorB; 
				graphics.lineStyle(thickness, activeColor, 1.0, false, lineScaleMode, caps);				
				
				// draw into self
				path.draw(graphics, penStep, penStep + onStepSize);
			}
		}
		
		
		// for tweening
		public function get step():Number {
			return _step;
		}
		
		public function set step(n:Number):void {
			_step = n;
			draw();
		}
				
	}
}
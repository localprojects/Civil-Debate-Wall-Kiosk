package com.civildebatewall.staging.elements {
	import com.bit101.charts.PieChart;
	import com.civildebatewall.Assets;
	import com.civildebatewall.staging.futilProxies.BlockBaseTweenable;
	import com.greensock.layout.ScaleMode;
	import com.kitschpatrol.futil.Math2;
	import com.kitschpatrol.futil.utilitites.GeomUtil;
	import com.kitschpatrol.futil.utilitites.GraphicsUtil;
	
	import flash.display.Bitmap;
	import flash.display.CapsStyle;
	import flash.display.JointStyle;
	import flash.display.Shape;
	
	public class StatsButton extends BlockBaseTweenable {
		
		private var yesRing:Shape;
		private var noRing:Shape;
		private var label:Bitmap;
		
		public function StatsButton(params:Object=null) {
			super(params);
		
			noRing = new Shape();
			noRing.graphics.beginFill(Assets.COLOR_NO_LIGHT);
			noRing.graphics.drawCircle(0, 0, 71);
			noRing.graphics.endFill();
			noRing.x = 71;
			noRing.y = 71;
			addChild(noRing);
			
			yesRing = new Shape();
			yesRing.x = 71;
			yesRing.y = 71;	
			addChild(yesRing);
			
			
			label = Assets.getStatsButtonCenter();
			label.x = 15;
			label.y = 15;
			addChild(label);
			
			setStats(0.5);
		}
		
		
		private function setStats(normalizedYes:Number):void {
			var degrees:Number = Math2.map(normalizedYes, 0, 1, 0, 360);
			drawSegment(yesRing, -90, degrees - 90, 71, 0, 0, 2, Assets.COLOR_YES_LIGHT);			
		}
		
		
		private function drawSegment(holder:Shape, startAngle:Number, endAngle:Number, segmentRadius:Number, xpos:Number, ypos:Number,  step:Number, fillColor:Number):void {
			holder.graphics.clear();
			holder.graphics.beginFill(fillColor);
			
			var degreesPerRadian:Number = Math.PI / 180;
			startAngle *= degreesPerRadian;
			endAngle *= degreesPerRadian;
			step *= degreesPerRadian;
			
			// Draw the segment
			holder.graphics.moveTo(xpos, ypos);
			for (var theta:Number = startAngle; theta < endAngle; theta += Math.min(step, endAngle - theta)) {
				holder.graphics.lineTo(xpos + segmentRadius * Math.cos(theta), ypos + segmentRadius * Math.sin(theta));
			}
			holder.graphics.lineTo(xpos + segmentRadius * Math.cos(endAngle), ypos + segmentRadius * Math.sin(endAngle));
			holder.graphics.lineTo(xpos, ypos);
		}		

		
	}
}
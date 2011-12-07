package com.civildebatewall.kiosk.buttons {
	import com.bit101.charts.PieChart;
	import com.civildebatewall.Assets;
	import com.civildebatewall.CivilDebateWall;
	import com.civildebatewall.data.Data;

	import com.greensock.TweenMax;
	import com.greensock.layout.ScaleMode;
	import com.kitschpatrol.futil.Math2;
	import com.kitschpatrol.futil.blocks.BlockBase;
	import com.kitschpatrol.futil.utilitites.GeomUtil;
	import com.kitschpatrol.futil.utilitites.GraphicsUtil;
	
	import flash.display.Bitmap;
	import flash.display.CapsStyle;
	import flash.display.JointStyle;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class StatsButton extends BlockBase {
		
		
		private var _percent:Number;
		private var yesRing:Shape;
		private var noRing:Shape;
		private var label:Bitmap;
		private var degrees:Number; // how much ring to draw
		
		public function StatsButton(params:Object=null) {
			super(params);
		
			noRing = new Shape();

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
			
			//setStats(0.5);
			
			_percent = 0;
			buttonMode = true;
			
			onButtonDown.push(onDown);
			onButtonUp.push(onUp);
			
			backgroundAlpha = 0;
			
			// todo get stats from data changes
			CivilDebateWall.data.addEventListener(Data.DATA_UPDATE_EVENT, onDataUpdate);
		}
		
		public function get percent():Number { return _percent; }
		public function set percent(value:Number):void {
			_percent = value;
			setStats(_percent);
		}
		

		private function onMove(e:MouseEvent):void {
			if (this.stage != null) {
				percent = Math2.map(this.stage.mouseX, 0, 1080, 0, 1);
			}
		}
			
		
		private function onDataUpdate(e:Event):void {
			// why can't tween?
			percent = CivilDebateWall.data.stats.yesPercent;
		}
		
		private function onDown(e:Event):void {
			drawDown();
		}
		
		private function onUp(e:Event):void {
			draw();
			CivilDebateWall.state.setView(CivilDebateWall.kiosk.view.statsView);
		}
		
		// tween this
		private function setStats(normalizedYes:Number):void {
			degrees = Math2.map(normalizedYes, 0, 1, 0, 360);
			draw();
		}
		
		//public function set degrees(value:Number
		
		private function draw():void {
			noRing.graphics.clear();
			noRing.graphics.beginFill(Assets.COLOR_NO_LIGHT);
			noRing.graphics.drawCircle(0, 0, 71);
			noRing.graphics.endFill();			
			drawSegment(yesRing, -90, degrees - 90, 71, 0, 0, 2, Assets.COLOR_YES_LIGHT);			
		}
		
		private function drawDown():void {
			noRing.graphics.clear();
			noRing.graphics.beginFill(Assets.COLOR_NO_DARK);
			noRing.graphics.drawCircle(0, 0, 71);
			noRing.graphics.endFill();			
			drawSegment(yesRing, -90, degrees - 90, 71, 0, 0, 2, Assets.COLOR_YES_DARK);			
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
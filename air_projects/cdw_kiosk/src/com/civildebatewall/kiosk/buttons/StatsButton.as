/*--------------------------------------------------------------------
Civil Debate Wall Kiosk
Copyright (c) 2012 Local Projects. All rights reserved.

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU Affero General Public License as
published by the Free Software Foundation, either version 3 of the
License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU Affero General Public License for more details.

You should have received a copy of the GNU Affero General Public
License along with this program. 

If not, see <http://www.gnu.org/licenses/>.
--------------------------------------------------------------------*/

package com.civildebatewall.kiosk.buttons {
	
	import com.civildebatewall.Assets;
	import com.civildebatewall.CivilDebateWall;
	import com.civildebatewall.data.Data;
	import com.kitschpatrol.futil.Math2;
	import com.kitschpatrol.futil.blocks.BlockBase;
	
	import flash.display.Bitmap;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class StatsButton extends BlockBase {

		private var _percent:Number;
		private var yesRing:Shape;
		private var noRing:Shape;
		private var label:Bitmap;
		private var degrees:Number; // how much ring to draw
		
		public function StatsButton(params:Object = null) {
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

			_percent = 0;
			buttonMode = true;
			
			onButtonDown.push(onDown);
			onButtonUp.push(onUp);
			
			backgroundAlpha = 0;
			
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
			CivilDebateWall.state.setView(CivilDebateWall.kiosk.statsView);
		}
		
		// tween this
		private function setStats(normalizedYes:Number):void {
			degrees = Math2.map(normalizedYes, 0, 1, 0, 360);
			draw();
		}
		
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

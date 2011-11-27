package com.civildebatewall.kiosk.elements {
	import com.civildebatewall.*;
	import com.civildebatewall.data.Data;
	import com.kitschpatrol.futil.Math2;
	import com.kitschpatrol.futil.blocks.BlockBase;
	import com.kitschpatrol.futil.blocks.BlockText;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	
	
	public class VoteStatBar extends BlockBase {
		

		private var bar:Shape;
	
		private var _barPercent:Number;

		private var arrowWidth:Number = 24;
		private var midPoint:Number = 0;
		
		private var overlay:Sprite;
		private var yesLabel:BlockText;
		private var noLabel:BlockText;		
		
		public function VoteStatBar()	{
			super();
			
			maxSizeBehavior = MAX_SIZE_CLIPS;			
			width = 1022;
			height = 141;
			backgroundColor = Assets.COLOR_NO_LIGHT;
						
			bar = new Shape();
			addChild(bar);
			
			overlay = new Sprite();
			
			
			// TODO
			yesLabel = new BlockText({
				text: "YES!",
				visible: true
			});
			
			noLabel = new BlockText({
				text: "NO!",
				visible: true
			});			
			
			
			overlay.y = 36;
			addChild(overlay);
			
			
			
			// TODO update from data
			
			CivilDebateWall.data.addEventListener(Data.DATA_UPDATE_EVENT, onDataUpdate);
		}
		
		private function onDataUpdate(e:Event):void {
			barPercent = CivilDebateWall.data.yesPercent * 100;
			//setLabels(CivilDebateWall.data.stanceTotals.yes, CivilDebateWall.data.stanceTotals.no);
		}
		
		public function get barPercent():Number {
			return _barPercent;
		}
		
		public function set barPercent(n:Number):void {
			_barPercent = n; // limit to 0 - 100
			
			var w:Number = Math2.mapClamp(_barPercent, 0, 100, -arrowWidth, width);  // limit to 0 - 100
			midPoint = w + (arrowWidth / 2);
			
			
			
			// redraw the bar
			bar.graphics.clear();
			
			bar.graphics.beginFill(Assets.COLOR_YES_LIGHT);
			bar.graphics.moveTo(-arrowWidth, 0);
			bar.graphics.lineTo(w, 0);
			bar.graphics.lineTo(w + arrowWidth, height / 2);
			bar.graphics.lineTo(w, height);
			bar.graphics.lineTo(-arrowWidth, height );
			bar.graphics.lineTo(-arrowWidth, 0);
			bar.graphics.endFill();
			
			overlay.x = midPoint - 88;
			
			
			if(overlay.x < 20) overlay.x = 20;
			if(overlay.x + overlay.width > width - 20) overlay.x = height - 20 - overlay.width;
			
			// figure out the ratio?
//			yesLabel.setSize(_barPercent);
//			noLabel.setSize(Math.abs(100 - _barPercent));			
		}
		
//		public function setLabels(yesValue:uint, noValue:uint):void {
//			yesLabel.setCount(yesValue);
//			noLabel.setCount(noValue);
//		}
		
		
		
		
		
		
		
	}
}
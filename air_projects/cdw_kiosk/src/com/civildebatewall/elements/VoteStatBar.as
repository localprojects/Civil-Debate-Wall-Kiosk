package com.civildebatewall.elements {
	import com.civildebatewall.*;
	import com.civildebatewall.blocks.BlockBase;
	import com.kitschpatrol.futil.Math2;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	
	
	public class VoteStatBar extends BlockBase {
		
		private var barWidth:Number;
		private var barHeight:Number;		
		private var bar:Shape;
		private var barMask:Shape;		
		private var _barPercent:Number;

		private var arrowWidth:Number = 24;
		private var midPoint:Number = 0;
		
		private var overlay:Sprite;
		private var yesLabel:BarLabel;
		private var noLabel:BarLabel;		
		
		public function VoteStatBar()	{
			super();
			
			barWidth = 1022;
			barHeight = 141;
			
			this.graphics.beginFill(Assets.COLOR_NO_LIGHT);
			this.graphics.drawRect(0, 0, barWidth, barHeight);
			this.graphics.endFill();
			
			bar = new Shape();
			addChild(bar);
			
			barMask = new Shape();
			barMask.graphics.beginFill(0x000000);
			barMask.graphics.drawRect(0, 0, barWidth, barHeight);
			barMask.graphics.endFill();
			addChild(barMask);
			
			this.mask = barMask;
			
			overlay = new Sprite();
			
			yesLabel = new BarLabel('YES!', 255);
			yesLabel.visible = true;
			overlay.addChild(yesLabel);
			
			noLabel = new BarLabel('NO!', 5);
			noLabel.visible = true;
			noLabel.x = yesLabel.width + 30;
			overlay.addChild(noLabel);
			
			overlay.y = 36;
			addChild(overlay);
			
			barPercent = 50;
		}
		
		public function get barPercent():Number {
			return _barPercent;
		}
		
		public function set barPercent(n:Number):void {
			_barPercent = n; // limit to 0 - 100
			
			var w:Number = Math2.mapClamp(_barPercent, 0, 100, -arrowWidth, barWidth);  // limit to 0 - 100
			midPoint = w + (arrowWidth / 2);
			
			// redraw the bar
			bar.graphics.clear();
			
			bar.graphics.beginFill(Assets.COLOR_YES_LIGHT);
			bar.graphics.moveTo(-arrowWidth, 0);
			bar.graphics.lineTo(w, 0);
			bar.graphics.lineTo(w + arrowWidth, barHeight / 2);
			bar.graphics.lineTo(w, barHeight );
			bar.graphics.lineTo(-arrowWidth, barHeight );
			bar.graphics.lineTo(-arrowWidth, 0);
			bar.graphics.endFill();
			
			overlay.x = midPoint - 88;
			
			
			if(overlay.x < 20) overlay.x = 20;
			if(overlay.x + overlay.width > barWidth - 20) overlay.x = barWidth - 20 - overlay.width;
			
			// figure out the ratio?
			yesLabel.setSize(_barPercent);
			noLabel.setSize(Math.abs(100 - _barPercent));			
			
			
		}
		
		public function setLabels(yesValue:uint, noValue:uint):void {
			yesLabel.setCount(yesValue);
			noLabel.setCount(noValue);
		}
		
		
		
		
		
		
		
	}
}
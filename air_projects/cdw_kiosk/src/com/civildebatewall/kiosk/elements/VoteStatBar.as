package com.civildebatewall.kiosk.elements {
	import com.civildebatewall.*;
	import com.kitschpatrol.futil.Math2;
	import com.kitschpatrol.futil.blocks.BlockBase;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	
	
	public class VoteStatBar extends BlockBase {
		

		private var bar:Shape;
	
		private var _barPercent:Number;

		private var arrowWidth:Number = 24;
		private var midPoint:Number = 0;
		
		private var overlay:Sprite;
		private var yesLabel:BarLabel;
		private var noLabel:BarLabel;		
		
		public function VoteStatBar()	{
			super();
			
			maxSizeBehavior = MAX_SIZE_CLIPS;			
			width = 1022;
			height = 141;
			backgroundColor = Assets.COLOR_NO_LIGHT;
						
			bar = new Shape();
			addChild(bar);
			
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
			
			// TODO update from data
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
			yesLabel.setSize(_barPercent);
			noLabel.setSize(Math.abs(100 - _barPercent));			
		}
		
		public function setLabels(yesValue:uint, noValue:uint):void {
			yesLabel.setCount(yesValue);
			noLabel.setCount(noValue);
		}
		
		
		
		
		
		
		
	}
}
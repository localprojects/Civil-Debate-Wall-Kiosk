package net.localprojects.elements {
	import flash.display.Bitmap;
	import flash.display.Shape;
	import flash.display.Sprite;
	
	import net.localprojects.*;
	import net.localprojects.blocks.BlockBase;
	import net.localprojects.ui.BlockButton;
	
	
	public class VoteStatBar extends BlockBase {
		
		private var barWidth:Number;
		private var barHeight:Number;		
		private var bar:Shape;
		private var barMask:Shape;		
		private var _barPercent:Number;

		private var arrowWidth:Number = 24;
		private var midPoint:Number = 0;
		
		
		private var overlay:Sprite;
		private var leftLabel:BlockButton; // use button for now, better text transitions
		private var rightLabel:BlockButton; // use button for now, better text transitions		
		private var leftDash:Bitmap;
		private var rightDash:Bitmap;
		
		
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
			
			leftDash = Assets.getDashedBar();
			overlay.addChild(leftDash);			
			
			
			leftLabel = new BlockButton(160, 57, 0x000000, 'Left', 26);
			leftLabel.setOutlineWeight(0);
			leftLabel.shiftBaseline(0);
			leftLabel.showOutline(false);
			leftLabel.showBackground(false);
			leftLabel.visible = true;
			overlay.addChild(leftLabel);
			
			rightLabel = new BlockButton(160, 57, 0x000000, 'Right', 26);
			rightLabel.setOutlineWeight(0);
			rightLabel.shiftBaseline(0);
			rightLabel.showOutline(false);
			rightLabel.showBackground(false);
			rightLabel.visible = true;
			rightLabel.x = 160;
			overlay.addChild(rightLabel);			

			rightDash = Assets.getDashedBar();
			rightDash.x = 320;
			overlay.addChild(rightDash);
	
			overlay.y = (barHeight - overlay.height) / 2;
			addChild(overlay);
			
			barPercent = 50;
		}
		
		public function get barPercent():Number {
			return _barPercent;
			
		}
		public function set barPercent(n:Number):void {
			_barPercent = n; // limit to 0 - 100
			
			var w:Number = Utilities.mapClamp(_barPercent, 0, 100, -arrowWidth, barWidth);  // limit to 0 - 100
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
			
			overlay.x = midPoint - 150;
			
			
			if(overlay.x < 20) overlay.x = 20;
			if(overlay.x + overlay.width > barWidth - 20) overlay.x = barWidth - 20 - overlay.width;			
		}
		
		
		public function setLabels(ls:String, rs:String):void {
			leftLabel.setLabel(ls);
			rightLabel.setLabel(rs);			
		}
		
		
		
		
		
		
		
	}
}
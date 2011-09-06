package net.localprojects.elements {
	import com.greensock.TweenMax;
	
	import flash.display.LineScaleMode;
	import flash.display.Shape;
	
	import net.localprojects.Assets;
	import net.localprojects.Utilities;
	import net.localprojects.blocks.BlockBase;
	import net.localprojects.blocks.BlockLabel;
	import net.localprojects.blocks.BlockLabelBar;
	
	
	
	public class BarLabel extends BlockBase {
		
		protected var mainLabel:BlockLabelBar;
		protected var _mainLabelText:String;
		protected var horizontalRule:Shape;
		protected var counterLabel:BlockLabelBar;
		protected var _counterLabelAmount:uint;
		
		protected var minScale:Number = 0.45; // smallest of the small
		
		
		public function BarLabel(mainLabelText:String, startingAmount:uint = 0)	{
			super();
			_mainLabelText = mainLabelText;
			_counterLabelAmount = startingAmount;
			
			mainLabel = new BlockLabelBar(_mainLabelText, 33, 0xffffff, 80, 30, 0xff0000, Assets.FONT_HEAVY);
			mainLabel.bar.alpha = 0;			
			mainLabel.visible = true;
			addChild(mainLabel);
			
			
			
			horizontalRule = new Shape();
			horizontalRule.graphics.lineStyle(1, 0xffffff, 1.0, true, LineScaleMode.NONE);
			horizontalRule.graphics.lineTo(70, 0);
			horizontalRule.x = 5;
			horizontalRule.y = mainLabel.y + mainLabel.height - 7;
			addChild(horizontalRule);
			
			counterLabel = new BlockLabelBar(_counterLabelAmount.toString(), 30, 0xffffff, 80, 35, 0xf00000, Assets.FONT_REGULAR);
			counterLabel.bar.alpha = 0;
			counterLabel.visible = true;
			addChild(counterLabel);
			counterLabel.y = horizontalRule.y + horizontalRule.height + 2;
		}
		
		public function setCount(n:uint):void {
			_counterLabelAmount = n;
			counterLabel.setText(_counterLabelAmount.toString());
		}
		
		// takes a percentage from 0 to 100
		public function setSize(n:Number):void {
			var targetScale:Number = Utilities.mapClamp(n, 0, 100, minScale, 1);	
			TweenMax.to(this, 1, {transformAroundCenter:{scaleX: targetScale, scaleY: targetScale}});
		}
		
		
		// set scale
	}
}
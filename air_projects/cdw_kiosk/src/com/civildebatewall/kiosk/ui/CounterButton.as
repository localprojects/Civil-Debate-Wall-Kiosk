package com.civildebatewall.kiosk.ui {
	import flash.display.Bitmap;
	import flash.display.Shape;
	import flash.events.MouseEvent;
	import flash.text.*;
	
	import com.civildebatewall.Assets;
	import com.civildebatewall.Utilities;
	import com.civildebatewall.kiosk.blocks.BlockLabel;

	import com.greensock.TweenMax;
	import com.greensock.easing.*;	
	
	public class CounterButton extends BlockButton	{
		private var _count:int;
		private var _baseLabel:String;
		
		private var counterLabel:BlockLabel;
		private var buttonLabel:BlockLabel;		
		private var icon:Bitmap;
		
		
		public function CounterButton(buttonWidth:Number, buttonHeight:Number, backgroundColor:uint, labelText:String, labelSize:Number, labelColor:uint = 0xffffff, labelFont:String = null, startingCount:int = 0) {
			super(buttonWidth, buttonHeight, backgroundColor, '', labelSize, labelColor, labelFont)
			

			
			// Icon
			icon = Assets.getLikeIcon();
			icon.x = 49;
			icon.y = 19;	
			addChild(icon);
			
			
			// Dynamic count text
			counterLabel = new BlockLabel(_count.toString(), labelSize, labelColor, backgroundColor, labelFont, false);
			counterLabel.visible = true;
			counterLabel.x = icon.x - counterLabel.checkWidth(_count.toString()) - 6;
			counterLabel.y = 16;			
			addChild(counterLabel);			
			
			
			
			// Static label text
			buttonLabel = new BlockLabel(labelText, labelSize, labelColor, backgroundColor, labelFont, false);
			buttonLabel.visible = true;
			buttonLabel.x = 85;
			buttonLabel.y = 16;				
			addChild(buttonLabel);

			_count = startingCount;
			_baseLabel = labelText;
			updateLabel();
		}
			
		private function updateLabel():void {
			counterLabel.setText(_count.toString());
			TweenMax.to(counterLabel, 0.5, {x: icon.x - counterLabel.checkWidth(_count.toString()) - 6, ease: Quart.easeInOut});
		}

	
		public function getCount():int	{
			return _count;
		}
	
		
		public function setCount(value:int):void	{
			_count = value;			
			updateLabel();
		}
	}
}

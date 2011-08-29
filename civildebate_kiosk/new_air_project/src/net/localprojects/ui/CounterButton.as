package net.localprojects.ui {
	import flash.display.Bitmap;
	import flash.display.Shape;
	import flash.events.MouseEvent;
	import flash.text.*;
	
	import net.localprojects.Assets;
	import net.localprojects.Utilities;
	import net.localprojects.blocks.BlockLabel;

	public class CounterButton extends BlockButton	{
		private var _count:int;
		private var _baseLabel:String;
		
		private var counterLabel:BlockLabel;
		private var buttonLabel:BlockLabel;		
		private var icon:Bitmap;
		
		
		public function CounterButton(buttonWidth:Number, buttonHeight:Number, backgroundColor:uint, labelText:String, labelSize:Number, labelColor:uint = 0xffffff, labelFont:String = null, startingCount:int = 0) {
			super(buttonWidth, buttonHeight, backgroundColor, '', labelSize, labelColor, labelFont)
			
			// Dynamic count text
			counterLabel = new BlockLabel(_count.toString(), labelSize, labelColor, backgroundColor, labelFont, false);
			counterLabel.visible = true;
			counterLabel.x = 15;
			counterLabel.y = 13;			
			addChild(counterLabel);
			
			// Icon
			icon = Assets.getLikeIcon();
			icon.x = 49;
			icon.y = 17;	
			addChild(icon);
			
			
			
			// Static label text
			buttonLabel = new BlockLabel(labelText, labelSize, labelColor, backgroundColor, labelFont, false);
			buttonLabel.visible = true;
			buttonLabel.x = 85;
			buttonLabel.y = 13;				
			addChild(buttonLabel);
			
			
			
			
			
			_count = startingCount;
			_baseLabel = labelText;
			updateLabel();
		}
			
		private function updateLabel():void {
			counterLabel.setText(_count.toString());			
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

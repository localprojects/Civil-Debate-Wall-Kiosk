package net.localprojects.ui {
	import flash.display.Bitmap;
	import flash.events.MouseEvent;
	import flash.text.*;
	import net.localprojects.Utilities;
	
	import net.localprojects.Assets;	

	public class CounterButton extends BlockButton	{
		private var _count:int;
		private var _baseLabel:String;
		
		
		public function CounterButton(buttonWidth:Number, buttonHeight:Number, backgroundColor:uint, labelText:String, labelSize:Number, labelColor:uint = 0xffffff, labelFont:String = null, startingCount:int = 0) {
			super(buttonWidth, buttonHeight, backgroundColor, labelText, labelSize, labelColor, labelFont)
			
			_count = startingCount;
			_baseLabel = labelText;
			updateLabel();
		}
			
		private function updateLabel():void {
			setLabel(_count + ' ' + Utilities.plural(_baseLabel, _count));			
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

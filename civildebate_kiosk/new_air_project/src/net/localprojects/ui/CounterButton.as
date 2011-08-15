package net.localprojects.ui {
	import flash.display.Bitmap;
	import flash.events.MouseEvent;
	import flash.text.*;
	import net.localprojects.Utilities;
	
	import net.localprojects.Assets;	

	public class CounterButton extends BlockButton	{
		private var _count:int;
		private var _baseLabel:String;
		
		
		public function CounterButton(buttonWidth:Number, buttonHeight:Number, labelText:String, labelSize:Number, backgroundColor:uint, startingCount:int = 0) {
			_count = startingCount;
			super(buttonWidth, buttonHeight, labelText, labelSize, backgroundColor, false, false);
			_baseLabel = labelText;
			updateLabel();
		}
		

		
		private function updateLabel():void {
			labelField.text = _count + ' ' + Utilities.plural(_baseLabel, _count);			
		}
		
		
		// do this elsewhere
//		override protected function onClick(e:MouseEvent):void {
//			super.onClick(e);
//			count++;
//		}	
		
		// TODO make the graphics update accordingly		
		public function get count():int	{
			return _count;
		}
		
		public function set count(value:int):void	{
			_count = value;			
			updateLabel();
			//counterField.text = _count.toString();
			// TODO increment animation
		}
	}
}

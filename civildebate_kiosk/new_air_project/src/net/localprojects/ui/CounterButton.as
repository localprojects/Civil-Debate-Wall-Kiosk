package net.localprojects.ui {
	import flash.display.Bitmap;
	import flash.text.*;
	import net.localprojects.Assets;
	import flash.events.MouseEvent;	

	public class CounterButton extends IconButton	{
		
		private var _count:int;
		private var counterField:TextField;		
		
		public function CounterButton(buttonWidth:Number, buttonHeight:Number, labelText:String, labelSize:Number, backgroundColor:uint, icon:Bitmap = null, tail:Boolean = false, startingCount:int = 0) {
			_count = startingCount;
			super(buttonWidth, buttonHeight, labelText, labelSize, backgroundColor, icon, tail);
		}
		
		override protected function draw():void {
			super.draw();

			// counter
			// set up the text format
			var textFormat:TextFormat = new TextFormat();			
			textFormat.bold = true;
			textFormat.font =  Assets.FONT_REGULAR;
			textFormat.align = TextFormatAlign.CENTER;
			textFormat.size = _labelSize;
						
			counterField = new TextField();
			counterField.defaultTextFormat = textFormat;
			counterField.embedFonts = true;
			counterField.selectable = false;
			counterField.mouseEnabled = false;
			counterField.gridFitType = GridFitType.NONE;
			counterField.antiAliasType = AntiAliasType.ADVANCED;
			counterField.textColor = 0xffffff;
			counterField.width = _buttonWidth;
			counterField.autoSize = TextFieldAutoSize.CENTER;
			counterField.text = _count.toString();
			counterField.x = (_buttonWidth / 2) - (counterField.width / 2) - 1;
			counterField.y = (_buttonHeight / 2) - (counterField.height / 2) - 6;			
			
			addChild(counterField);	
		}
		
		
		override protected function onClick(e:MouseEvent):void {
			super.onClick(e);
			count++;
		}		
		
		
		// TODO make the graphics update accordingly		
		public function get count():int	{
			return _count;
		}
		
		public function set count(value:int):void	{
			_count = value;			
			counterField.text = _count.toString();
			// TODO increment animation
		}
	}
}

package net.localprojects.ui {
	import flash.display.*;
	import flash.events.MouseEvent;
	import net.localprojects.*;
	import flash.text.*;
	
	public class IconButton extends Sprite {

		protected var _buttonWidth:Number;
		protected var _buttonHeight:Number;
		protected var _labelText:String;
		protected var _labelSize:Number;
		protected var _backgroundColor:uint;
		protected var _icon:Bitmap;
		protected var _tail:Boolean;
		
		public function IconButton(buttonWidth:Number, buttonHeight:Number, labelText:String, labelSize:Number, backgroundColor:uint, icon:Bitmap = null, tail:Boolean = false) {
			super();
			
			_buttonWidth = buttonWidth;
			_buttonHeight = buttonHeight;
			_labelText = labelText;
			_labelSize = labelSize;
			_backgroundColor = backgroundColor;
			_icon = icon;
			_tail = tail;
			
			draw();
			
			// set up events			
			this.buttonMode = true;
			this.addEventListener(MouseEvent.CLICK, onClick);
		}
		
		
		
		protected function draw():void {
			// draw stuff
			this.graphics.clear();

			var lineThickness:Number = 4;
			
			// base rectangles
			var roundRect:Shape = new Shape();
			roundRect.graphics.beginFill(_backgroundColor);
			roundRect.graphics.lineStyle(lineThickness, 0xffffff);
			roundRect.graphics.drawRoundRect(0, 0, _buttonWidth, _buttonHeight, 8, 8);
			roundRect.graphics.endFill();			
			addChild(roundRect);			
			
			// tail
			if (_tail) {
				var tailWidth:Number = 25;
				var tailHeight:Number = 30;			
				
				var outlinedTail:Shape = new Shape();
				
				outlinedTail.graphics.beginFill(_backgroundColor);
				outlinedTail.graphics.lineStyle(lineThickness, 0xffffff);
				outlinedTail.graphics.moveTo(tailWidth / -2, 0);
				outlinedTail.graphics.lineTo(tailWidth / 2, 0);
				outlinedTail.graphics.lineTo(0, tailHeight);
				outlinedTail.graphics.lineTo(tailWidth / -2, 0);			
				outlinedTail.graphics.endFill();
				
				outlinedTail.x = this.width / 2;
				outlinedTail.y = this.height - (lineThickness * 2);			
				
				addChild(outlinedTail);
				this.swapChildrenAt(0, 1);
				
				var bareTail:Shape = new Shape();
				
				bareTail.graphics.beginFill(_backgroundColor);
				bareTail.graphics.moveTo((tailWidth - lineThickness) / -2, 0);
				bareTail.graphics.lineTo((tailWidth - lineThickness) / 2, 0);
				bareTail.graphics.lineTo(0, tailHeight);
				bareTail.graphics.lineTo((tailWidth - lineThickness) / -2, 0);			
				bareTail.graphics.endFill();
				
				bareTail.x = outlinedTail.x;
				bareTail.y = outlinedTail.y - (lineThickness / 2);
				
				addChild(bareTail);
			}
						
			// labels
			// set up the text format
			var textFormat:TextFormat = new TextFormat();			
			textFormat.bold = true;
			textFormat.font =  Assets.FONT_REGULAR;
			textFormat.align = TextFormatAlign.CENTER;
			textFormat.size = _labelSize;
			

			var labelField:TextField = new TextField();
			labelField.defaultTextFormat = textFormat;
			labelField.embedFonts = true;
			labelField.selectable = false;
			labelField.mouseEnabled = false;
			labelField.gridFitType = GridFitType.NONE;
			labelField.antiAliasType = AntiAliasType.ADVANCED;
			labelField.textColor = 0xffffff;
			labelField.width = _buttonWidth;
			labelField.autoSize = TextFieldAutoSize.CENTER;
			labelField.text = _labelText;
			labelField.x = (_buttonWidth / 2) - (labelField.width / 2);
			labelField.y = (_buttonHeight / 2) - (labelField.height / 2);			
			
			addChild(labelField);
			
			// icons...
			if (_icon != null) {
				addChild(_icon);
				_icon.x = (this.width / 2) - (_icon.width / 2);
				_icon.y = 20;
				
				// nudge the label down
				labelField.y = 72;		
			}
		}
		
		protected function update():void {
			
		}
		
		
		protected function onClick(e:MouseEvent):void {
			trace("clicked");
		}
		
		
		// getters and setters
		// TODO make the graphics update accordingly
		public function get buttonWidth():Number {
			return _buttonWidth;
		}
		
		public function set buttonWidth(value:Number):void {
			_buttonWidth = value;
			update();
			// TODO REDRAW, DELETE CHILDREN?
		}
		
		public function get buttonHeight():Number	{
			return _buttonHeight;
		}
		
		public function set buttonHeight(value:Number):void	{
			_buttonHeight = value;
			update();
			// TODO REDRAW, DELETE CHILDREN?			
		}
		
		public function get labelText():String {
			return _labelText;
		}
		
		public function set labelText(value:String):void {
			_labelText = value;
			update();
		}
		
		public function get labelSize():Number {
			return _labelSize;
		}
		
		public function set labelSize(value:Number):void {
			_labelSize = value;
			update();			
		}
		
		public function get backgroundColor():uint {
			return _backgroundColor;
		}
		
		public function set backgroundColor(value:uint):void {
			_backgroundColor = value;
			update();			
		}
		
		public function get icon():Bitmap {
			return _icon;
		}
		
		public function set icon(value:Bitmap):void {
			_icon = value;
			update();			
		}
		
		public function get tail():Boolean {
			return _tail;
		}
		
		public function set tail(value:Boolean):void {
			_tail = value;
			update();			
		}		
		
	}
}

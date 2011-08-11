package net.localprojects.ui {
	import com.greensock.*;
	import com.greensock.easing.*;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.*;
	
	
	import net.localprojects.*;
	
	public class BigButton extends ButtonBase	{
		
		private var labelText:TextField;
		private var label:String;
		private var buttonWidth:Number;
		private var buttonHeight:Number;
		private var button:Sprite;		
		private var textPanelWidth:Number;
		private var textPanelHeight:Number;
		private var buttonMask:Shape;
		
		public function BigButton(buttonLabel:String) {
			super();
			buttonWidth = 520;
			buttonHeight = 141;
			textPanelWidth = 485;
			textPanelHeight = 98;
			label = buttonLabel;			
			init();
		}
		
		private function init():void {
	
			// draw the bounding box
			buttonMask = new Shape();
			buttonMask.graphics.beginFill(0x000000);
			buttonMask.graphics.drawRect(0, 0, 520, 141);
			buttonMask.graphics.endFill();
			
			// create the actual button panel
			button = new Sprite();
			
			// background image
			button.addChild(Assets.buttonBackground());
				
			// create the button text format
			var textFormat:TextFormat = new TextFormat();
			textFormat.bold = true;
			textFormat.font =  Assets.FONT_REGULAR;
			textFormat.align = TextFormatAlign.CENTER;
			textFormat.size = 36;
			
			// button label
			labelText = new TextField();
			labelText.defaultTextFormat = textFormat;
			labelText.embedFonts = true;
			labelText.selectable = false;
			labelText.multiline = false;
			labelText.cacheAsBitmap = false;
			labelText.mouseEnabled = false;			
			labelText.autoSize = TextFieldAutoSize.CENTER;
			labelText.gridFitType = GridFitType.NONE;
			labelText.antiAliasType = AntiAliasType.NORMAL;
			labelText.textColor = 0x414042;
			labelText.text = label.toUpperCase();
			labelText.x = (buttonWidth - textPanelWidth) + (textPanelWidth - labelText.width) / 2;
			labelText.y = (textPanelHeight - labelText.height) / 2;
			
			buttonMode = true;
			
			addChild(buttonMask);
			addChild(button);
			button.addChild(labelText);
			
			button.mask = buttonMask;
			
			enable();
		}
		
		override protected function onMouseDown(e:MouseEvent):void {
			super.onMouseDown(e);
			disable();
		}
		
		// move to parent?
		override public function disable():void {
			super.disable();
			TweenMax.to(button, 0.25, {x: -26, y: 32, ease:Strong.easeOut, colorMatrixFilter:{saturation: 0}});
						
		}
		
		override public function enable():void {
			super.enable();
			TweenMax.to(button, 0.1, {x: 0, y: 0, ease:Strong.easeOut, colorMatrixFilter:{saturation: 1}});
						
		}

		
		
		

		
		
	}
}
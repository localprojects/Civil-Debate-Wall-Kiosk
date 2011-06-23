package net.localprojects.ui {
	import com.greensock.*;
	import com.greensock.easing.*;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.text.*;
	
	import net.localprojects.Assets;
	
	public class BigButton extends Sprite	{
		
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
			button.graphics.beginBitmapFill(Assets.bigButtonBackground.bitmapData);
			button.graphics.drawRect(0, 0, buttonWidth, buttonHeight);
			button.graphics.endFill();
				
			// create the button text format
			var textFormat:TextFormat = new TextFormat();
			textFormat.font =  Assets.BUTTON_FONT;
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
			
			addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			
		}
		
		private function onMouseDown(e:MouseEvent):void {
			TweenMax.to(button, 0.2, {x: -29, y: 36, ease:Strong.easeOut});
			Main.stageRef.addEventListener(MouseEvent.MOUSE_UP, onMouseUp, true);			
		}
		
		private function onMouseUp(e:MouseEvent):void {
			// fire event
			Main.stageRef.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);			
			TweenMax.to(button, 0.2, {x: 0, y: 0, ease:Strong.easeOut});
		}
		
		
		

		
		
	}
}
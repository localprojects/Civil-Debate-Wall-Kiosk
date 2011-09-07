package com.civildebatewall.ui {
	import flash.display.*;
	import flash.events.MouseEvent;
	import flash.text.*;
	
	import com.civildebatewall.*;
	import com.civildebatewall.blocks.BlockBase;
	
	
	
	public class IconButton extends BlockButton {
		
		public static const ICON_RIGHT:String = "iconRight";
		public static const ICON_LEFT:String = "iconLeft";		
		
		protected var _iconPosition:String;
		public var _icon:Bitmap;
		
		// TODO skip the subclass and just roll this into BlockButton? Same for counter?
		public function IconButton(buttonWidth:Number, buttonHeight:Number, backgroundColor:uint, labelText:String, labelSize:Number, labelColor:uint, labelFont:String = null, icon:Bitmap = null, iconPosition:String = ICON_LEFT) {
			super(buttonWidth, buttonHeight, backgroundColor, labelText, labelSize, labelColor, labelFont);			
			_iconPosition = iconPosition;
			_icon = icon;
			
			// fit the icon
			var iconPadding:Number = 9;
			
			
			
			if (labelFieldA.text.length > 0) {
				
				if (_iconPosition == ICON_LEFT) {
					_icon.x = (buttonWidth - (_icon.width + iconPadding + labelFieldA.width)) / 2;
					_icon.y = labelFieldA.y + 3;
					
					// reposition text					
					labelFieldA.x = _icon.x + _icon.width + iconPadding;
				}
				else if (_iconPosition == ICON_RIGHT) {
					_icon.x = buttonWidth - (_icon.width + iconPadding);
					_icon.y = labelFieldA.y + 3;
					
					labelFieldA.x -= _icon.width;
				}
			}
			else {
				_icon.x = ((buttonWidth - _icon.width) / 2) - (strokeWeight / 2);
				_icon.y = ((buttonHeight - _icon.height) / 2) - (strokeWeight / 2);						
			}
			
			addChild(_icon);
			
		}
		
		override protected function generateLabel(text:String):TextField {
			// label
			var tempTextField:TextField = super.generateLabel(text);
			//tempTextField.y -= 2;
			
			return tempTextField;
		}		
		
		override public function setOutlineWeight(weight:Number):void {
			super.setOutlineWeight(weight);
			
			if (labelFieldA.text.length == 0) {			
				_icon.x = ((_buttonWidth - _icon.width) / 2) - (strokeWeight / 2);
				_icon.y = ((_buttonHeight - _icon.height) / 2) - (strokeWeight / 2);
			}
		}
						
		
	}
}

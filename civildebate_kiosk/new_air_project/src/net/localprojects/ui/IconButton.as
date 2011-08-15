package net.localprojects.ui {
	import flash.display.*;
	import flash.events.MouseEvent;
	import flash.text.*;
	
	import net.localprojects.*;
	import net.localprojects.blocks.BlockBase;
	
	public class IconButton extends BlockButton {

		protected var _icon:Bitmap;
		
		// TODO skip the subclass and just roll this into BlockButton? Same for counter?
		public function IconButton(buttonWidth:Number, buttonHeight:Number, labelText:String, labelSize:Number, backgroundColor:uint, icon:Bitmap = null) {
			super(buttonWidth, buttonHeight, labelText, labelSize, backgroundColor, false, false);			
		
			
			_icon = icon;
			
			// fit the icon
			var iconPadding:Number = 9;
			
			if (labelField.text.length > 0) {
				_icon.x = (buttonWidth - (_icon.width + iconPadding + labelField.width)) / 2;
				_icon.y = labelField.y + 2;
				
				// reposition text
				labelField.x = _icon.x + _icon.width + iconPadding;			
			}
			else {
				_icon.x = (buttonWidth - _icon.width) / 2;
				_icon.y = (buttonHeight - _icon.height) / 2;						
			}
			
			addChild(_icon);
		}		
						
		
	}
}

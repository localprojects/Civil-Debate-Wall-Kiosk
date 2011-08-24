package net.localprojects.ui {
	import flash.display.*;
	import flash.events.MouseEvent;
	import flash.text.*;
	
	import net.localprojects.*;
	import net.localprojects.blocks.BlockBase;
	
	public class IconButton extends BlockButton {

		protected var _icon:Bitmap;
		
		// TODO skip the subclass and just roll this into BlockButton? Same for counter?
		public function IconButton(buttonWidth:Number, buttonHeight:Number, backgroundColor:uint, labelText:String, labelSize:Number, labelColor:uint, labelFont:String = null, icon:Bitmap = null) {
			super(buttonWidth, buttonHeight, backgroundColor, labelText, labelSize, labelColor, labelFont);			
		
			_icon = icon;
			
			// fit the icon
			var iconPadding:Number = 9;
			
			if (labelFieldA.text.length > 0) {
				_icon.x = (buttonWidth - (_icon.width + iconPadding + labelFieldA.width)) / 2;
				_icon.y = labelFieldA.y + 2;
				
				// reposition text
				labelFieldA.x = _icon.x + _icon.width + iconPadding;			
			}
			else {
				_icon.x = (buttonWidth - _icon.width) / 2;
				_icon.y = (buttonHeight - _icon.height) / 2;						
			}
			
			addChild(_icon);
		}		
						
		
	}
}

package net.localprojects.ui {
	import com.greensock.*;
	
	import flash.display.*;
	import flash.text.*;
	
	import net.localprojects.*;
	import net.localprojects.Assets;
	import net.localprojects.blocks.BlockBase;
	
	public class ThumbnailButton extends BlockBase {
	
		private var roundedPortrait:Sprite;
		private var portrait:Bitmap;
		private var _active:Boolean;
		private var textField:TextField;
		
		private var textBackground:Sprite;
		
		public function ThumbnailButton(image:Bitmap, stance:String) {
			_active = false;
			
			this.graphics.beginFill(0xffffff);
			this.graphics.drawRect(0, 0, 173, 141);
			this.graphics.endFill();
			

			portrait = image;
			roundedPortrait = new Sprite();
			
			portrait.width = 173;
			portrait.height = 141;
			portrait.bitmapData = Utilities.scaleToFill(portrait.bitmapData, 100, 100)
			
			roundedPortrait.graphics.beginBitmapFill(portrait.bitmapData, null, false, true);
			roundedPortrait.graphics.drawRoundRect(0, 0, 100, 100, 15, 15);
			roundedPortrait.graphics.endFill();			
			roundedPortrait.cacheAsBitmap = false;
			this.cacheAsBitmap = false;
			Utilities.centerWithin(roundedPortrait, this);			
			

			
			//  the text
			var textFormat:TextFormat = new TextFormat();			
			textFormat.bold = false;
			textFormat.font =  Assets.FONT_REGULAR;
			textFormat.align = TextFormatAlign.LEFT;
			textFormat.size = 13;
			
			textField = new TextField();
			textField.defaultTextFormat = textFormat;
			textField.embedFonts = true;
			textField.selectable = false;
			textField.cacheAsBitmap = false;
			textField.mouseEnabled = false;
			textField.gridFitType = GridFitType.NONE;
			textField.antiAliasType = AntiAliasType.ADVANCED;
			textField.textColor = 0xffffff;
			textField.autoSize = TextFieldAutoSize.CENTER;
			textField.x = roundedPortrait.x;
			textField.y = 89;
			textField.width = portrait.width;
			
			var tempColor:uint;
			if (stance == 'yes') {
				tempColor = Assets.COLOR_YES_LIGHT;
				textField.text = 'YES!';
			}
			else if (stance == 'no') {
				tempColor = Assets.COLOR_NO_LIGHT;				
				textField.text = 'NO!';				
			}
			else {
				trace('unknown stance "' + stance + '"');
			}			
			
			// top line
			this.graphics.beginFill(tempColor);
			this.graphics.drawRect(2, 4, 169, 5);			
			this.graphics.endFill();
			
			// bottom line
			this.graphics.beginFill(tempColor);
			this.graphics.drawRect(2, 132, 169, 5);			
			this.graphics.endFill();			

			// text background			
			textBackground = new Sprite();
			textBackground.graphics.beginFill(tempColor);
			textBackground.graphics.drawRect(0, 0, portrait.width, 24);
			textBackground.graphics.endFill();
			textBackground.x = roundedPortrait.x;
			textBackground.y = 85;						

				

				addChild(roundedPortrait);
				addChild(textBackground);
			addChild(textField);
			
			
			// override blockbase hiding behavior
			visible = true;
		}
		
	
		
		private function update():void {
			if(_active) {
				// saturate
				TweenMax.to(roundedPortrait, 0, {colorMatrixFilter:{saturation: 1}});				
			}
			else {
				// desaturate
				TweenMax.to(roundedPortrait, 0, {colorMatrixFilter:{saturation: 0}});				
			}
		}
		
//		public function get active():Boolean {
//			return _active;
//		}
//		
//		public function set active(b:Boolean):void {
//			_active = b;	
//			update();			
//		}		
	}
}
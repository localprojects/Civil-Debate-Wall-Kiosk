package net.localprojects.ui {
	import com.greensock.*;
	import com.greensock.easing.*;
	
	import flash.display.*;
	import flash.text.*;
	
	import net.localprojects.*;
	import net.localprojects.Assets;
	import net.localprojects.blocks.BlockBase;
	import net.localprojects.elements.BlockLabel;
	
	public class ThumbnailButton extends BlockBase {
	
		private var roundedPortrait:Sprite;
		private var portrait:Bitmap;
		private var _selected:Boolean;
		private var textField:BlockLabel;
		public var debateID:String;
		private var tempColor:uint;
		
		private var textBackground:Sprite;
		
		private var leftDot:Shape;
		private var rightDot:Shape;		
		
		public function ThumbnailButton(image:Bitmap, stance:String, debate:String) {
			_selected = false;
			
			this.graphics.beginFill(0xffffff);
			this.graphics.drawRect(0, 0, 173, 141);
			this.graphics.endFill();
			
			debateID = debate;
			portrait = image;
			roundedPortrait = new Sprite();
			
			portrait.width = 71;
			portrait.height = 96;
			portrait.bitmapData = Utilities.scaleToFill(portrait.bitmapData, 71, 96)
			
			roundedPortrait.graphics.beginBitmapFill(portrait.bitmapData, null, false, true);
			roundedPortrait.graphics.drawRoundRect(0, 0, 71, 96, 15, 15);
			roundedPortrait.graphics.endFill();			
			roundedPortrait.cacheAsBitmap = false;
			this.cacheAsBitmap = false;
			Utilities.centerWithin(roundedPortrait, this);			
			

			
			//  the text
			textField = new BlockLabel('', 14, 0xffffff, 0x000000, Assets.FONT_BOLD, true);
			textField.background.alpha = 0;
			textField.setPadding(0, 0, 0, 0);
			textField.visible = true;

			
			
			if (stance == 'yes') {
				tempColor = Assets.COLOR_YES_LIGHT;
				textField.setText('YES!', true);
			}
			else if (stance == 'no') {
				tempColor = Assets.COLOR_NO_LIGHT;				
				textField.setText('NO!', true);				
			}
			else {
				trace('unknown stance "' + stance + '"');
			}			
			
			// top line
			this.graphics.beginFill(tempColor);
			this.graphics.drawRect(2, 4, 169, 3);			
			this.graphics.endFill();
			
			// bottom line
			this.graphics.beginFill(tempColor);
			this.graphics.drawRect(2, 132, 169, 3);			
			this.graphics.endFill();			

			// text background			
			textBackground = new Sprite();
			textBackground.graphics.beginFill(tempColor);
			textBackground.graphics.drawRect(0, 0, 71, 24);
			textBackground.graphics.endFill();
			textBackground.x = roundedPortrait.x;
			textBackground.y = 85;					

			
			// dots
			leftDot = new Shape();
			rightDot = new Shape();			

			setDotColor(Assets.COLOR_INSTRUCTION_MEDIUM);
			
			leftDot.y = 70;
			leftDot.x = 0;
						
			rightDot.y = 70;
			rightDot.x = width;			
			
				
			addChild(roundedPortrait);
			addChild(textBackground);
			textBackground.addChild(textField);
			addChild(leftDot);
			addChild(rightDot);			
			
			textField.x = ((textBackground.width - textField.background.width) / 2);
			textField.y = ((textBackground.height - textField.background.height) / 2) - 2;			
			

			// override blockbase hiding behavior
			visible = true;
			
			this.cacheAsBitmap = true;
		}
		
		private function setDotColor(c:uint):void {
			leftDot.graphics.clear();
			leftDot.graphics.beginFill(c);
			leftDot.graphics.drawCircle(-1.5, -1.5, 3);
			leftDot.graphics.endFill();
			
			rightDot.graphics.clear();
			rightDot.graphics.beginFill(c);
			rightDot.graphics.drawCircle(-1.5, -1.5, 3);
			rightDot.graphics.endFill();			
		}
		
	
		
		public function update():void {
			if(_selected) {
				// saturate
				TweenMax.to(roundedPortrait, 1, {colorMatrixFilter:{saturation: 1}, ease: Quart.easeInOut});
				TweenMax.to(textBackground, 0.5, {y: this.height, alpha: 0, ease: Quart.easeOut});				
				setDotColor(tempColor);
			}
			else {
				// desaturate
				TweenMax.to(roundedPortrait, 1, {colorMatrixFilter:{saturation: 0}, ease: Quart.easeInOut});
				TweenMax.to(textBackground, 0.5, {y: 85, alpha: 1, ease: Quart.easeOut});				
				setDotColor(Assets.COLOR_INSTRUCTION_MEDIUM);				
			}
		}
		
		public function get selected():Boolean {
			return _selected;
		}
		
		public function set selected(b:Boolean):void {
			_selected = b;	
			update();			
		}		
	}
}
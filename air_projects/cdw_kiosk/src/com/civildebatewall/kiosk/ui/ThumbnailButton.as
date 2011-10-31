package com.civildebatewall.kiosk.ui {
	import com.civildebatewall.*;
	import com.civildebatewall.Assets;
	import com.civildebatewall.kiosk.blocks.BlockBase;
	import com.civildebatewall.kiosk.blocks.BlockLabel;
	import com.civildebatewall.data.Post;
	import com.civildebatewall.data.Thread;
	import com.greensock.*;
	import com.greensock.easing.*;
	import com.kitschpatrol.futil.utilitites.BitmapUtil;
	import com.kitschpatrol.futil.utilitites.GeomUtil;
	
	import flash.display.*;
	import flash.text.*;
	
	public class ThumbnailButton extends BlockBase {
	
		private var _thread:Thread;
		private var _backgroundColor:uint;
		private var background:Sprite;
		private var lines:Sprite;
		private var roundedPortrait:Sprite;
		private var _selected:Boolean;
		private var textField:BlockLabel;
		public var downBackgroundColor:uint = 0xffffff;		
		private var textBackground:Sprite;
		public var leftDot:Shape;
		public  var rightDot:Shape;		
		
		public function ThumbnailButton(thread:Thread) {
			_thread = thread;
			_selected = false;
			
			background = new Sprite();
			background.graphics.beginFill(0xffffff);
			background.graphics.drawRect(0, 0, 173, 141);
			background.graphics.endFill();
			addChild(background);
			
			roundedPortrait = new Sprite();
			

			var scaledPhotoData:BitmapData = BitmapUtil.scaleToFill(thread.firstPost.user.photo.bitmapData, 71, 96)
			
			roundedPortrait.graphics.beginBitmapFill(scaledPhotoData, null, false, true);
			roundedPortrait.graphics.drawRoundRect(0, 0, 71, 96, 15, 15);
			roundedPortrait.graphics.endFill();			
      // roundedPortrait.cacheAsBitmap = false;
			this.cacheAsBitmap = false;
			GeomUtil.centerWithin(roundedPortrait, this);			
						
			//  the text
			textField = new BlockLabel('', 14, 0xffffff, 0x000000, Assets.FONT_BOLD, true);
			textField.background.alpha = 0;
			textField.setPadding(0, 0, 0, 0);
			textField.visible = true;

			downBackgroundColor = _thread.firstPost.stanceColorWatermark;
			textField.setText(_thread.firstPost.stanceFormatted, true);			
			

			// top line
			lines = new Sprite();
			
			lines.graphics.beginFill(_thread.firstPost.stanceColorLight);
			lines.graphics.drawRect(2, 4, 169, 3);			
			lines.graphics.endFill();
			
			// bottom line
			lines.graphics.beginFill(_thread.firstPost.stanceColorLight);
			lines.graphics.drawRect(2, 132, 169, 3);			
			lines.graphics.endFill();		
			
			addChild(lines);

			// text background			
			textBackground = new Sprite();
			textBackground.graphics.beginFill(_thread.firstPost.stanceColorLight);
			textBackground.graphics.drawRect(0, 0, 71, 24);
			textBackground.graphics.endFill();
			textBackground.x = roundedPortrait.x;
			textBackground.y = 85;					

			
			// dots
			leftDot = new Shape();
			rightDot = new Shape();			

			setDotColor(Assets.COLOR_GRAY_50);
			
			leftDot.y = 70;
			leftDot.x = 1;
						
			rightDot.y = 70;
			rightDot.x = width + 1;			
			
				
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
		
		
		override public function setBackgroundColor(c:uint, instant:Boolean = false):void {
			_backgroundColor = c;
			if (instant) {
				TweenMax.to(background, 0, {ease: Quart.easeOut, colorTransform: {tint: _backgroundColor, tintAmount: 1}});				
			}
			else {
				TweenMax.to(background, 0.5, {ease: Quart.easeOut, colorTransform: {tint: _backgroundColor, tintAmount: 1}});			
			}
		}
	
		
		public function update():void {
			if(_selected) {
				// saturate
				TweenMax.to(roundedPortrait, 1, {colorMatrixFilter:{saturation: 1}, ease: Quart.easeInOut});
				TweenMax.to(textBackground, 0.5, {y: this.height, alpha: 0, ease: Quart.easeOut});				
				setDotColor(_thread.firstPost.stanceColorLight);
			}
			else {
				// desaturate
				TweenMax.to(roundedPortrait, 1, {colorMatrixFilter:{saturation: 0}, ease: Quart.easeInOut});
				TweenMax.to(textBackground, 0.5, {y: 85, alpha: 1, ease: Quart.easeOut});				
				setDotColor(Assets.COLOR_GRAY_50);				
			}
		}
		
		public function get thread():Thread { return _thread; }
		
		public function get selected():Boolean {
			return _selected;
		}
		
		public function set selected(b:Boolean):void {
			_selected = b;	
			update();			
		}		
	}
}
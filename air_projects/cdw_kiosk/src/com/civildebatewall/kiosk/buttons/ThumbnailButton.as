package com.civildebatewall.kiosk.buttons {
	import com.civildebatewall.*;
	import com.civildebatewall.Assets;
	import com.civildebatewall.data.Post;
	import com.civildebatewall.data.Thread;
	import com.civildebatewall.kiosk.legacyBlocks.OldBlockBase;
	import com.greensock.*;
	import com.greensock.easing.*;
	import com.kitschpatrol.futil.blocks.BlockBase;
	import com.kitschpatrol.futil.blocks.BlockText;
	import com.kitschpatrol.futil.utilitites.BitmapUtil;
	import com.kitschpatrol.futil.utilitites.GeomUtil;
	
	import flash.display.*;
	import flash.text.*;
	
	public class ThumbnailButton extends BlockBase {
	
		private var _thread:Thread;
		private var _backgroundColor:uint;
		private var lines:Sprite;
		private var roundedPortrait:Sprite;
		private var _selected:Boolean;
		private var textField:BlockText;
		public var downBackgroundColor:uint = 0xffffff;		
		private var textBackground:Sprite;
		public var leftDot:Shape;
		public  var rightDot:Shape;		
		
		public function ThumbnailButton(thread:Thread) {
			_thread = thread;
			_selected = false;
			
			super({
				width: 173,
				height: 141,
				backgroundColor: 0xffffff,
				visible: true			
			});

			
			roundedPortrait = new Sprite();
			var scaledPhotoData:BitmapData = BitmapUtil.scaleDataToFill(thread.firstPost.user.photo.bitmapData, 71, 96)
			
			roundedPortrait.graphics.beginBitmapFill(scaledPhotoData, null, false, true);
			roundedPortrait.graphics.drawRoundRect(0, 0, 71, 96, 15, 15);
			roundedPortrait.graphics.endFill();			
      // roundedPortrait.cacheAsBitmap = false;
			this.cacheAsBitmap = false;
			GeomUtil.centerWithin(roundedPortrait, this);			
						
			//  the text
			textField = new BlockText({
				textColor: 0xffffff,
				textFont: Assets.FONT_BOLD,
				textBold: true,
				textSize: 14,
				backgroundAlpha: 0,
				visible: true,
				text: _thread.firstPost.stanceFormatted
			});
			
			// down background color: _thread.firstPost.stanceColorWatermark;


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
		
		
	
		
//		public function update():void {
//			if(_selected) {
//				// saturate
//				TweenMax.to(roundedPortrait, 1, {colorMatrixFilter:{saturation: 1}, ease: Quart.easeInOut});
//				TweenMax.to(textBackground, 0.5, {y: this.height, alpha: 0, ease: Quart.easeOut});				
//				setDotColor(_thread.firstPost.stanceColorLight);
//			}
//			else {
//				// desaturate
//				TweenMax.to(roundedPortrait, 1, {colorMatrixFilter:{saturation: 0}, ease: Quart.easeInOut});
//				TweenMax.to(textBackground, 0.5, {y: 85, alpha: 1, ease: Quart.easeOut});				
//				setDotColor(Assets.COLOR_GRAY_50);				
//			}
//		}
		
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
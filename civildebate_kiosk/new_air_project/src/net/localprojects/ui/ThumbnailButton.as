package net.localprojects.ui {
	import com.greensock.*;
	
	import flash.display.Bitmap;
	import flash.display.Shape;
	import flash.display.Sprite;
	
	import net.localprojects.*;
	import net.localprojects.Assets;
	
	public class ThumbnailButton extends Sprite	{
	
		private var roundedPortrait:Sprite;
		private var portrait:Bitmap;
		private var _active:Boolean;
		
		public function ThumbnailButton(image:Bitmap, stance:String) {
			_active = false;
			
			this.graphics.beginFill(0xffffff);
			this.graphics.drawRect(0, 0, 173, 141);
			this.graphics.endFill();
			
			// tandem yes / no for now
			
			if (stance == 'yes') {
				// top line
				this.graphics.beginFill(Assets.COLOR_YES_LIGHT);
				this.graphics.drawRect(2, 4, 169, 5);			
				this.graphics.endFill();
				
				// bottom line
				this.graphics.beginFill(Assets.COLOR_YES_LIGHT);
				this.graphics.drawRect(2, 132, 169, 5);			
				this.graphics.endFill();
			}
			else if (stance == 'no') {
				// top line
				this.graphics.beginFill(Assets.COLOR_NO_LIGHT);
				this.graphics.drawRect(2, 4, 169, 5);			
				this.graphics.endFill();
				
				// bottom line
				this.graphics.beginFill(Assets.COLOR_NO_LIGHT);
				this.graphics.drawRect(2, 132, 169, 5);
				this.graphics.endFill();				
			}
			else {
				trace('unknown stance "' + stance + '"');
			}
			
			portrait = image;
			
			roundedPortrait = new Sprite();
			roundedPortrait.graphics.beginBitmapFill(portrait.bitmapData, null, false, true);
			roundedPortrait.graphics.drawRoundRect(0, 0, portrait.width - 1, portrait.height - 1, 15, 15);
			roundedPortrait.graphics.endFill();
			
			roundedPortrait.cacheAsBitmap = false;
			this.cacheAsBitmap = false;
			Utilities.centerWithin(roundedPortrait, this);			
			
			addChild(roundedPortrait);
			
			// TODO text overlay
			
			
			
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
		
		public function get active():Boolean {
			return _active;
		}
		
		public function set active(b:Boolean):void {
			_active = b;	
			update();			
		}		
	}
}
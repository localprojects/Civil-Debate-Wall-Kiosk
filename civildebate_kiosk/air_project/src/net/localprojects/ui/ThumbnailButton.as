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
		
		public function ThumbnailButton() {
			
			_active = false;
			
			this.graphics.beginFill(0xffffff);
			this.graphics.drawRect(0, 0, 173, 141);
			this.graphics.endFill();
			
			
			// tandom yes / no for now
			
			if (Math.random() > 0.5) {
				// top line
				this.graphics.beginFill(0x00b9ff);
				this.graphics.drawRect(2, 4, 169, 5);			
				this.graphics.endFill();
				
				// bottom line
				this.graphics.beginFill(0x00b9ff);
				this.graphics.drawRect(2, 132, 169, 5);			
				this.graphics.endFill();
			}
			else {
				// top line
				this.graphics.beginFill(0xff5a00);
				this.graphics.drawRect(2, 4, 169, 5);			
				this.graphics.endFill();
				
				// bottom line
				this.graphics.beginFill(0xff5a00);
				this.graphics.drawRect(2, 132, 169, 5);			
				this.graphics.endFill();				
			}
			
			
			
			// random portrait for now 
			switch (Utilities.randRange(1, 5)) {
				case 1: portrait = Assets.samplePortrait1(); break;
				case 2: portrait = Assets.samplePortrait2(); break;
				case 3: portrait = Assets.samplePortrait3(); break;
				case 4: portrait = Assets.samplePortrait4(); break;
				case 5: portrait = Assets.samplePortrait5(); break;				
			}
			
			roundedPortrait = new Sprite();
			roundedPortrait.graphics.beginBitmapFill(portrait.bitmapData, null, false, true);
			roundedPortrait.graphics.drawRoundRect(0, 0, portrait.width - 1, portrait.height - 1, 15, 15);
			roundedPortrait.graphics.endFill();
		
			
			roundedPortrait.cacheAsBitmap = false;
			this.cacheAsBitmap = false;
			Utilities.centerWithin(roundedPortrait, this);			
			
			addChild(roundedPortrait);
			
			
			
			
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
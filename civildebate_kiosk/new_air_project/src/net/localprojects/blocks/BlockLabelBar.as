package net.localprojects.blocks {
	import flash.display.*;
	import net.localprojects.Utilities;
	
	
	public class BlockLabelBar extends BlockLabel {
		
		private var _backgroundWidth:Number;
		private var _backgroundHeight:Number;
		private var bar:Bitmap;
		
		public function BlockLabelBar(text:String, textSize:Number, textColor:uint, backgroundWidth:Number, backgroundHeight:Number, backgroundColor:uint, font:String=null) {
			_backgroundColor = backgroundColor;
			_backgroundWidth = backgroundWidth;
			_backgroundHeight = backgroundHeight;
			preInit();
			super(text, textSize, textColor, backgroundColor, font, false);

			postInit();
		}
		
		private function preInit():void {
			bar = new Bitmap(new BitmapData(_backgroundWidth, _backgroundHeight, false, _backgroundColor), PixelSnapping.ALWAYS, false);
			addChild(bar);			
		}
		
		private function postInit():void {
			textField.x = 33;
			textField.y = (bar.height / 2) - (textField.height / 2);
			bar.pixelSnapping = PixelSnapping.ALWAYS;
			cacheAsBitmap = true;
		}
	}
}
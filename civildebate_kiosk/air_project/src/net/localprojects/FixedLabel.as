package net.localprojects {
	import com.bit101.components.Text;
	
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.text.engine.FontLookup;
	import flash.text.engine.Kerning;
	import flash.text.engine.RenderingMode;
	
	import flashx.textLayout.factory.StringTextLineFactory;
	import flashx.textLayout.factory.TruncationOptions;
	import flashx.textLayout.formats.TextAlign;
	import flashx.textLayout.formats.TextLayoutFormat;
	

	public class FixedLabel extends Sprite {
		
		public var format:TextBoxLayoutFormat;
		public var text:String;
		
		private var factory:StringTextLineFactory;
		
		public function FixedLabel(_text:String, _format:TextBoxLayoutFormat = null) {
			super();
			
			text = _text;
			
			if (_format == null) {
				// use some defaults
				format = new TextBoxLayoutFormat();
				format.fontFamily = "Helvetica, Arial, _sans";
				format.fontSize = 12;
				format.color = 0x000000;
				format.kerning = Kerning.ON;
				format.renderingMode = RenderingMode.CFF;
				format.textAlign = TextAlign.LEFT;			
				format.fontLookup = FontLookup.EMBEDDED_CFF;
			}
			else {
				format = _format;			
			}
			
			// set up the factory
			factory = new StringTextLineFactory();
				
			// how to truncate
			var truncationOptions:TruncationOptions = new TruncationOptions('...', 3);
			factory.truncationOptions = truncationOptions;
			
			// defaults
			factory.paragraphFormat = format;
			factory.text = text;
			
			update();
		}
		
		public function update():void {
			graphics.clear();
			
			while (this.numChildren > 0) {
				this.removeChildAt(0);
			}
			
			if (format.showSpriteBackground) {
				graphics.beginFill(format.backgroundSpriteColor);
				graphics.drawRect(0, 0, format.boundingWidth, format.boundingHeight);
				graphics.endFill();
			}

			// text rect size
			var bounds:Rectangle = new Rectangle(0, 0, format.boundingWidth, format.boundingHeight);
			factory.compositionBounds = bounds;
			factory.createTextLines( useTextLines );			
		}
		
		private function useTextLines(line:DisplayObject):void {
			var displayObject:DisplayObject = this.addChild(line);
		}			
	}
}
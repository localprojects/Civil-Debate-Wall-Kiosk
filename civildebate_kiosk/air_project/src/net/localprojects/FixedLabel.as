package net.localprojects {
	import flash.display.DisplayObject;
	import flash.display.Sprite;
	import flash.geom.Rectangle;
	import flash.text.engine.FontLookup;
	import flash.text.engine.Kerning;
	import flash.text.engine.RenderingMode;
	
	import flashx.textLayout.factory.StringTextLineFactory;
	import flashx.textLayout.factory.TruncationOptions;
	import flashx.textLayout.formats.TextLayoutFormat;
	import flashx.textLayout.formats.TextAlign;
	
	
	public class FixedLabel extends Sprite {
		
		
		private var backgroundColor:uint = 0xff0000;
		
		
		
		public function FixedLabel(text:String) {
			super();
			trace("creating label"); 
			
			// set up the factory
			var factory:StringTextLineFactory = new StringTextLineFactory();
			
			// text rect size
			var bounds:Rectangle = new Rectangle(0, 0, 540, 40);
			factory.compositionBounds = bounds;
			
			// background rect
			graphics.beginFill(backgroundColor);
			graphics.drawRect(bounds.x, bounds.y, bounds.width, bounds.height);
			graphics.endFill();						
			
			// how to truncate
			var truncationOptions:TruncationOptions = new TruncationOptions('...',3);
			factory.truncationOptions = truncationOptions;
			
			
			
			// formatting
			var format:TextLayoutFormat = new TextLayoutFormat();
			format.fontFamily = "Verdana, _sans";
			format.fontSize = 40;
			format.color = 0x000000;
			format.kerning = Kerning.ON;
			format.renderingMode = RenderingMode.CFF;
			format.textAlign = TextAlign.CENTER;			
			format.textAlignLast = TextAlign.CENTER;
			
			//format.textAlign.set(TextAlign.CENTER);
			
			format.fontLookup = FontLookup.EMBEDDED_CFF;
			
			factory.paragraphFormat = format;
			
			factory.text = "text";
			
			factory.createTextLines( useTextLines );
			
			
			

			
		}
		
		private function useTextLines(line:DisplayObject):void {
			trace("adding");
			var displayObject:DisplayObject = this.addChild(line);
		}			
	}
}
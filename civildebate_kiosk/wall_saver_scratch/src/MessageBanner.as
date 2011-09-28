package {
	import flash.display.Bitmap;
	import flash.display.Sprite;
	
	
	public class MessageBanner extends Sprite {
		
		public static const BLUE:String = "blue";
		public static const ORANGE:String = "orange";		
		private var color:String;
		private var head:Bitmap;
		private var tail:Bitmap;
		private var fillColor:uint;
		private var textBitmap:Bitmap;
		
		public function MessageBanner(textBitmap:Bitmap, color:String)	{
			super();
			this.color = color;
			this.textBitmap = textBitmap;
			
			if (color == BLUE) {
				head = Assets.getBlueArrowHead();
				tail = Assets.getBlueArrowTail();
				fillColor = 0x32b6ff;
			}
			else {
				head = Assets.getOrangeArrowHead();
				tail = Assets.getOrangeArrowTail();
				fillColor = 0xf75e00;				
			}
			
			addChild(tail);
			
			graphics.beginFill(fillColor);
			graphics.drawRect(tail.width, 0, 1080, tail.height);
			graphics.endFill();
			
			textBitmap.x = 143 + tail.width;
			textBitmap.y = 204;
			addChild(textBitmap);
			
			head.x = width;
			addChild(head);			
		}
	}
}
package {
	import com.kitschpatrol.futil.TextBlock;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;
	
	import mx.states.AddChild;
	
	
	public class QuotationBanner extends Sprite {
		
		
		private var openQuote:Bitmap;
		private var closeQuote:Bitmap;
		private var textBlock:TextBlock;
		private var backgroundColor:uint;
		
		public function QuotationBanner(quote:String, stance:String) {
			super();
			
			if (stance == "yes") {
				openQuote = Assets.getQuoteYesOpen();
				closeQuote = Assets.getQuoteYesClose();
				backgroundColor = Assets.COLOR_YES_LIGHT;
			}
			else {
				openQuote = Assets.getQuoteNoOpen();
				closeQuote = Assets.getQuoteNoClose();
				backgroundColor = Assets.COLOR_NO_LIGHT;				
			}
			
			openQuote.x = 0;
			openQuote.y = 0;
			addChild(openQuote);
			
			textBlock = new TextBlock({text: quote,
																 backgroundColor: backgroundColor,
																 paddingTop: 54,
																 paddingLeft: 97,
																 paddingRight: 97,
																 textSizePixels: 117,
																 textColor: 0xffffff,
																 height: 240});
			
			textBlock.x = openQuote.width + 120;
			textBlock.y = 0;
			addChild(textBlock);
			
			closeQuote.x = textBlock.x + textBlock.width + 120;; 
			closeQuote.y = 120;
			addChild(closeQuote);
		}
	}
}
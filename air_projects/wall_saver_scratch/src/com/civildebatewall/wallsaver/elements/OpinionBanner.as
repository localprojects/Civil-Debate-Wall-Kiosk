package com.civildebatewall.wallsaver.elements {
	import com.civildebatewall.resources.Assets;
	import com.kitschpatrol.futil.Random;
	import com.kitschpatrol.futil.blocks.BlockShape;
	import com.kitschpatrol.futil.blocks.BlockText;
	import com.kitschpatrol.futil.constants.Alignment;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;

	public class OpinionBanner extends Sprite {

		private var openQuote:Bitmap;
		private var closeQuote:Bitmap;
		private var quotation:BlockShape;
		private var backgroundColor:uint;
		public var stance:String;		
		
		public function OpinionBanner(quote:String, stance:String) {
			super();
			this.stance = stance;

//			this.scaleX = 4;
//			this.scaleY = 4;
			
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
			
//			//quotation = new BlockText({
//				height: 247,
//				backgroundColor: backgroundColor,
//				paddingLeft: 110,
//				paddingRight: 110,
//				alignmentPoint: Alignment.LEFT,
//				textSize: 142,				
//				textColor: 0xffffff,
//				text: quote,
//				visible: true
//			//});
			quotation = new BlockShape();
			quotation.width = Random.range(500, 2000);
			quotation.height = 247;
			quotation.backgroundColor = backgroundColor;
			
			quotation.x = openQuote.width + 33;
			quotation.y = 0;
			addChild(quotation);
			
			closeQuote.x = quotation.x + quotation.width + 33; 
			closeQuote.y = 111;
			addChild(closeQuote);
			
			this.cacheAsBitmap = true; // helps?
		}
		
	}
}
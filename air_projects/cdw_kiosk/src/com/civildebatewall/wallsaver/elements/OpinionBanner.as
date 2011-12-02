package com.civildebatewall.wallsaver.elements {
	import com.civildebatewall.Assets;
	import com.civildebatewall.data.Post;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;

	public class OpinionBanner extends Sprite {

		private var openQuote:Bitmap;
		private var closeQuote:Bitmap;
		public var post:Post;
		private var opinionText:OpinionTextBasic;
		
		public function OpinionBanner(post:Post) {
			super();
			this.post = post;
				
			openQuote = (post.stance == Post.STANCE_YES) ? Assets.getQuoteYesOpen() : Assets.getQuoteNoOpen();
			closeQuote = (post.stance == Post.STANCE_YES) ? Assets.getQuoteYesClose() : Assets.getQuoteNoClose();

			openQuote.x = 0;
			openQuote.y = 0;
			addChild(openQuote);
			
			opinionText = new OpinionTextBasic(post.text);
			
			// background
			this.graphics.beginFill(post.stanceColorLight);
			this.graphics.drawRect(openQuote.width + 33, 0, opinionText.width , 247);
			this.graphics.endFill();
			
			opinionText.x = openQuote.width + 33;
			opinionText.y = 37;
			addChild(opinionText);
				

			closeQuote.x = opinionText.x + opinionText.width + 33; 
			closeQuote.y = 111;
			addChild(closeQuote);
			
			this.cacheAsBitmap = true; // helps?
		}
		
	}
}
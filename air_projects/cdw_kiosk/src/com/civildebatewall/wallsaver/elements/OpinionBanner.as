package com.civildebatewall.wallsaver.elements {
	import com.civildebatewall.Assets;
	import com.civildebatewall.data.Post;
	import com.kitschpatrol.futil.blocks.BlockText;
	import com.kitschpatrol.futil.constants.Alignment;
	
	import flash.display.Bitmap;
	import flash.display.Sprite;

	public class OpinionBanner extends Sprite {

		private var openQuote:Bitmap;
		private var closeQuote:Bitmap;
		private var quotation:BlockText;
		private var post:Post;
		
		
		public function OpinionBanner(post:Post) {
			super();
			this.post = post;
//			this.scaleX = 4;
//			this.scaleY = 4;
				
			openQuote = (post.stance == Post.STANCE_YES) ? Assets.getQuoteYesOpen() : Assets.getQuoteNoOpen();
			closeQuote = (post.stance == Post.STANCE_YES) ? Assets.getQuoteYesClose() : Assets.getQuoteNoClose();

			openQuote.x = 0;
			openQuote.y = 0;
			addChild(openQuote);
			
			quotation = new BlockText({
				height: 247,
				backgroundColor: post.stanceColorLight,
				paddingLeft: 110,
				paddingRight: 110,
				alignmentPoint: Alignment.LEFT,
				textFont: Assets.FONT_REGULAR,
				textSize: 142,				
				textColor: 0xffffff,
				text: post.text,
				visible: true
			});
			
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
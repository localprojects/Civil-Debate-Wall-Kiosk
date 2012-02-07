/*--------------------------------------------------------------------
Civil Debate Wall Kiosk
Copyright (c) 2012 Local Projects. All rights reserved.

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as
published by the Free Software Foundation, either version 2 of the
License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public
License along with this program. 

If not, see <http://www.gnu.org/licenses/>.
--------------------------------------------------------------------*/

package com.civildebatewall.wallsaver.elements {

	import com.civildebatewall.Assets;
	import com.civildebatewall.data.containers.Post;
	
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
			
			//this.cacheAsBitmap = true; // helps?
		}
		
	}
}

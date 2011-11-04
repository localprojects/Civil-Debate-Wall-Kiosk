package com.civildebatewall.kiosk.elements {
	import com.civildebatewall.*;
	import com.civildebatewall.data.Post;
	import com.civildebatewall.kiosk.blocks.*;
	import com.civildebatewall.kiosk.ui.*;
	import com.civildebatewall.staging.elements.BalloonButton;
	import com.kitschpatrol.futil.blocks.BlockBase;
	import com.kitschpatrol.futil.utilitites.BitmapUtil;
	import com.kitschpatrol.futil.utilitites.GraphicsUtil;
	import com.kitschpatrol.futil.utilitites.NumberUtil;
	
	import flash.display.*;
	import flash.events.Event;

	public class Comment extends BlockBase {
		
		protected var _post:Post;
		protected var _postNumber:int;
		protected var postNumberString:String;
		public var _highlight:String;
		
		protected var portraitWidth:int;
		protected var portraitHeight:int;
		protected var portrait:Sprite;
		protected var stanceLabel:BlockLabel;
		
		public function Comment(post:Post, postNumber:int = -1) {
			super({		
				width: 1024,
				minHeight: 257,
				backgroundAlpha: 0,
				paddingLeft: 30,
				paddingRight: 30,
				paddingTop: 34,
				paddingBottom: 34
			});
			
			portraitWidth = 138;
			portraitHeight = 189;			
			
			_post = post;
			this.postNumber = postNumber;
			
			draw();
		}
		
		private function draw():void {
			GraphicsUtil.removeChildren(content);

			// draw the portrait
			portrait = new Sprite();
			portrait.graphics.beginBitmapFill(BitmapUtil.scaleToFill(_post.user.photo.bitmapData, portraitWidth, portraitHeight), null, false, true);
			portrait.graphics.drawRoundRect(0, 0, portraitWidth, portraitHeight, 5, 5);
			portrait.graphics.endFill();
			
			portrait.graphics.beginFill(_post.stanceColorMedium);
			portrait.graphics.drawRect(0, 132, portraitWidth, 39);
			portrait.graphics.endFill();
			
			var bannerText:Bitmap;
			if (_post.stance == Post.STANCE_YES) {
				bannerText = Assets.getPortraitBannerYes();
				bannerText.x = 39;
				bannerText.y = 141;			
			}
			else {
				bannerText = Assets.getPortraitBannerNo();
				bannerText.x = 44;
				bannerText.y = 140;				
			}
			portrait.addChild(bannerText);
			addChild(portrait);
			
			// add the byline
			var authorText:String = postNumberString + _post.user.usernameFormatted.toUpperCase() + '\u0027S RESPONSE';
			var authorLabel:BlockLabel = new BlockLabel(authorText, 17, _post.stanceColorLight, 0x000000, Assets.FONT_HEAVY, false);
			authorLabel.setPadding(0, 0, 0, 0);
			authorLabel.visible = true;
			
			authorLabel.x = 167;
			authorLabel.y = 16;
			
			addChild(authorLabel);
			
			// add the timestamp
			var timeString:String = NumberUtil.zeroPad(_post.created.hours, 2) + NumberUtil.zeroPad(_post.created.minutes, 2);
			var dateString:String = NumberUtil.zeroPad(_post.created.month, 2) + NumberUtil.zeroPad(_post.created.date, 2) + (_post.created.fullYear - 2000);
			var timestamp:String = 'Posted at ' + timeString + ' hours on ' + dateString;
			
			var timeLabel:BlockLabel = new BlockLabel(timestamp, 12, _post.stanceColorMedium, 0x000000, Assets.FONT_BOLD_ITALIC, false);
			timeLabel.setPadding(0, 0, 0, 0);
			timeLabel.visible = true;				
			
			timeLabel.x = authorLabel.x + authorLabel.width + 10;
			timeLabel.y = 21;
			
			addChild(timeLabel);
			
			// flag button
			var flagButton:FlagButton = new FlagButton();
			flagButton.targetPost = _post;
			flagButton.x = 802;
			flagButton.y = 0;
			flagButton.visible = true;
			addChild(flagButton);
			
			// add the hairline
			var hairline:Shape = new Shape();
			hairline.graphics.lineStyle(1, _post.stanceColorLight, 0.6, true); // some alpha to make it appear thinner
			hairline.graphics.moveTo(0, 0);
			hairline.graphics.lineTo(652, 0);
			hairline.x = 167;
			hairline.y = 42;
			addChild(hairline);
			
			// Add the opinoin
			var opinion:BlockParagraph = new BlockParagraph(652, _post.stanceColorLight, _post.textAt, 23);
			opinion.setPadding(11, 18, 14, 18);
			opinion.visible = true;
			opinion.x = 167;
			opinion.y = 60;
			
			addChild(opinion);
			
			// Add the debate me button
			var debateButton:BalloonButton = new BalloonButton();
			debateButton.targetPost = _post;
			debateButton.x = 860;
			debateButton.y = 60;
			debateButton.visible = true;
			addChild(debateButton);					
		}
		
		public function get post():Post {
			return _post;
		}
		
		public function set post(p:Post):void {
			_post = p;
			draw();
		}
		
		public function get postNumber():int { 
			return _postNumber;
		}
		
		public function set postNumber(number:int):void {
			_postNumber = number;
			if (_postNumber == -1) {
				postNumberString = "";
			}
			else {
				postNumberString = _postNumber.toString() + ". ";
			}
		}		

	}
}
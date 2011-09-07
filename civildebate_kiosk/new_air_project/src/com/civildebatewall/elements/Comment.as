package com.civildebatewall.elements {
	import com.civildebatewall.*;
	import com.civildebatewall.blocks.*;
	import com.civildebatewall.data.Post;
	import com.civildebatewall.ui.*;
	
	import flash.display.*;
	import flash.events.Event;

	public class Comment extends BlockBase {
		
		
		public static const EVENT_FLAG:String = 'eventFlag';
		public static const EVENT_DEBATE:String = 'eventDebate';
		public static const EVENT_BUTTON_DOWN:String = 'eventButtonDown';
		
		
		protected var _post:Post;
		protected var _postNumber:uint;
		
		public var activeButton:ButtonBase;
		protected var portraitWidth:int;
		protected var portraitHeight:int;
		protected var portrait:Sprite;
		protected var stanceLabel:BlockLabel;
		
		public function Comment(post:Post, postNumber:uint) {
			super();
			portraitWidth = 137;
			portraitHeight = 188;			
			
			_post = post;
			_postNumber = postNumber;
			
			init();
		}
		
		protected function init():void {
			// draw the portrait
			portrait = new Sprite();
			portrait.graphics.beginBitmapFill(_post.user.photo.bitmapData, null, false, true);
			portrait.graphics.drawRoundRect(0, 0, portraitWidth, portraitHeight, 15, 15);
			portrait.graphics.endFill();
			
			// draw the stance banner
			stanceLabel = new BlockLabel('', 28, 0xffffff, 0x000000, Assets.FONT_BOLD, false);
			stanceLabel.setPadding(0, 0, 0, 0);
			stanceLabel.visible = true;
			stanceLabel.setText(_post.stanceFormatted, true);
			
			portrait.graphics.beginFill(_post.stanceColorLight);				
			portrait.graphics.drawRect(0, 131, portraitWidth, 38);
			portrait.graphics.endFill();
			
			stanceLabel.y = 130;
			stanceLabel.x = (portraitWidth / 2) - (stanceLabel.width / 2);				
			
			portrait.addChild(stanceLabel)
			addChild(portrait);
			
			// add the byline
			var authorText:String = _postNumber + '. ' + _post.user.usernameFormatted + '\u0027S REBUTTAL STATEMENT';
			var authorLabel:BlockLabel = new BlockLabel(authorText, 17, _post.stanceColorLight, 0x000000, Assets.FONT_HEAVY, false);
			authorLabel.setPadding(0, 0, 0, 0);
			authorLabel.visible = true;
			
			authorLabel.x = 167;
			authorLabel.y = 16;
			
			addChild(authorLabel);
			
			// add the timestamp
			var timeString:String = Utilities.zeroPad(_post.created.hours, 2) + Utilities.zeroPad(_post.created.minutes, 2);
			var dateString:String = Utilities.zeroPad(_post.created.month, 2) + Utilities.zeroPad(_post.created.date, 2) + (_post.created.fullYear - 2000);
			
			var timestamp:String = 'Posted at ' + timeString + ' hours on ' + dateString;
			
			var timeLabel:BlockLabel = new BlockLabel(timestamp, 12, _post.stanceColorMedium, 0x000000, Assets.FONT_BOLD_ITALIC, false);
			timeLabel.setPadding(0, 0, 0, 0);
			timeLabel.visible = true;				
			
			timeLabel.x = authorLabel.x + authorLabel.width + 10;
			timeLabel.y = 21;
			
			addChild(timeLabel);
			
			// add the flag button
			var flagButton:IconButton = new IconButton(33, 32, _post.stanceColorDark, '', 0, 0x000000, null, Assets.getSmallFlagIcon());
			flagButton.setDownColor(_post.stanceColorMedium);
			flagButton.setOutlineWeight(2);
			flagButton.setStrokeColor(Assets.COLOR_GRAY_15);
			flagButton.visible = true;
			flagButton.x = 791;
			flagButton.y = 8;
			
			addChild(flagButton);
			flagButton.setOnDown(onDown);			
			flagButton.setOnClick(onFlag);
			
			// add the hairline
			var hairline:Shape = new Shape();
			hairline.graphics.lineStyle(1, _post.stanceColorLight, 0.6, true); // some alpha to make it appear thinner
			hairline.graphics.moveTo(0, 0);
			hairline.graphics.lineTo(652, 0);
			
			hairline.x = 167;
			hairline.y = 42;
			
			addChild(hairline);
			
			// Add the opinoin
			var opinion:BlockParagraph = new BlockParagraph(652, _post.stanceColorLight, _post.text, 23);
			opinion.setPadding(11, 18, 14, 18);
			opinion.visible = true;
			opinion.x = 167;
			opinion.y = 60;
			
			addChild(opinion);
			
			// Add the debate me button
			var debateButton:BalloonButton = new BalloonButton(110, 101, 0x000000, 'LET\u0027S\nDEBATE !', 15);
			
			
			debateButton = new BalloonButton(152, 135, 0x000000, 'LET\u2019S\nDEBATE !', 22, 0xffffff, Assets.FONT_HEAVY);
			debateButton.scaleX = 0.75;  
			debateButton.scaleY = 0.75;				
			debateButton.setBackgroundColor(_post.stanceColorDark, true);
			debateButton.setDownColor(_post.stanceColorMedium);				
			debateButton.setStrokeColor(Assets.COLOR_GRAY_15);				
			debateButton.visible = true;
			
			debateButton.x = 849;
			debateButton.y = 61;
			
			debateButton.setOnDown(onDown);
			debateButton.setOnClick(onDebate);
			
			addChild(debateButton);				
			
			// TODO debate button functionality
		}
		
		public function unClick():void {
			activeButton.setBackgroundColor(_post.stanceColorDark);
		}
		
		public function get post():Post {
			return _post;
		}
		
		protected function onDebate(e:Event):void {
			// forward to parent
			this.dispatchEvent(new Event(EVENT_DEBATE, true, true));
		}
		
		protected function onFlag(e:Event):void {
			// forward to parent
			this.dispatchEvent(new Event(EVENT_FLAG, true, true));
		}
		
		protected function onDown(e:Event):void {
			activeButton = e.currentTarget as ButtonBase;
			this.dispatchEvent(new Event(EVENT_BUTTON_DOWN, true, true));			
		}
	}
}
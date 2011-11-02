package com.civildebatewall.kiosk.elements {
	import com.civildebatewall.*;
	import com.civildebatewall.kiosk.blocks.*;
	import com.civildebatewall.data.Post;
	import com.civildebatewall.kiosk.ui.*;
	import com.kitschpatrol.futil.utilitites.BitmapUtil;
	import com.kitschpatrol.futil.utilitites.NumberUtil;
	
	import flash.display.*;
	import flash.events.Event;
	
	// TODO change aesthetics
	public class SearchResult extends Comment {

		public static const EVENT_GOTO_DEBATE:String = 'eventGoToDebate';		
		
		protected var leftPadding:Number = 32;
		protected var rightPadding:Number = 32;
		protected var topPadding:Number = 27;
		protected var bottomPadding:Number = 22;		
		
		protected var goToDebateButton:IconButton;
		//protected var background:Shape;
		
		public function SearchResult() {
			super(null, -1);
			//_highlight = highlight;
			//super(post, index, _highlight);
		}
		
//		override protected function init():void {
//		
//			background = new Shape();
//			addChild(background);
//			
//			// draw the portrait
//			portrait = new Sprite();
//			portrait.graphics.beginBitmapFill(BitmapUtil.scaleToFill(_post.user.photo.bitmapData, portraitWidth, portraitHeight), null, false, true); // TODO resize?
//			portrait.graphics.drawRoundRect(0, 0, portraitWidth, portraitHeight, 15, 15);
//			portrait.graphics.endFill();
//			
//			// draw the stance banner
//			stanceLabel = new BlockLabel(_post.stanceFormatted, 28, 0xffffff, 0x000000, Assets.FONT_BOLD, false);
//			stanceLabel.setPadding(0, 0, 0, 0);
//			stanceLabel.visible = true;
//			
//			var carat:Bitmap;
//			if (_post.stance == Post.STANCE_YES) {
//				carat = Assets.getBlueRightCarat();
//			}
//			else {
//				carat = Assets.getOrangeRightCarat();				
//			}
//			
//			goToDebateButton = new IconButton(120, 30, Assets.COLOR_GRAY_5, 'Go To Debate', 14, _post.stanceColorLight, Assets.FONT_BOLD, carat, IconButton.ICON_RIGHT);
//			
//			portrait.graphics.beginFill(_post.stanceColorLight);				
//			portrait.graphics.drawRect(0, 131, portraitWidth, 38);
//			portrait.graphics.endFill();
//			
//			stanceLabel.y = 130;
//			stanceLabel.x = (portraitWidth / 2) - (stanceLabel.width / 2);				
//			
//			portrait.x = leftPadding;
//			portrait.y = topPadding;
//			
//			portrait.addChild(stanceLabel)
//			addChild(portrait);
//			
//			// add the byline
//			var authorText:String;
//			if (_post.isThreadStarter) {
//				authorText = _postNumber + '. ' + _post.user.usernameFormatted.toUpperCase() + '\u0027S OPINION';
//			}
//			else {
//				authorText = _postNumber + '. ' + _post.user.usernameFormatted.toUpperCase() + '\u0027S REBUTTAL';				
//			}
//			
//			var authorLabel:BlockLabel = new BlockLabel(authorText, 17, _post.stanceColorLight, 0x000000, Assets.FONT_HEAVY, false);
//			authorLabel.setPadding(0, 0, 0, 0);
//			authorLabel.visible = true;
//			
//			authorLabel.x = 219;
//			authorLabel.y = 37;
//			
//			addChild(authorLabel);
//			
//			// add the timestamp
//			var timeString:String = NumberUtil.zeroPad(_post.created.hours, 2) + NumberUtil.zeroPad(_post.created.minutes, 2);
//			var dateString:String = NumberUtil.zeroPad(_post.created.month, 2) + NumberUtil.zeroPad(_post.created.date, 2) + (_post.created.fullYear - 2000);
//			
//			var timestamp:String = 'Posted at ' + timeString + ' hours on ' + dateString;
//			
//			var timeLabel:BlockLabel = new BlockLabel(timestamp, 12, _post.stanceColorMedium, 0x000000, Assets.FONT_BOLD_ITALIC, false);
//			timeLabel.setPadding(0, 0, 0, 0);
//			timeLabel.visible = true;				
//			
//			timeLabel.x = authorLabel.x + authorLabel.width + 10;
//			timeLabel.y = 42;
//			
//			addChild(timeLabel);
//			
//			// add the flag button
//			var flagButton:IconButton = new IconButton(34, 33, _post.stanceColorDark, '', 0, 0x000000, null, Assets.getSmallFlagIcon());
//			flagButton.setDownColor(_post.stanceColorMedium);
//			flagButton.setOutlineWeight(2);
//			flagButton.visible = true;
//			flagButton.x = 817;
//			flagButton.y = 26;
//			
//			addChild(flagButton);
//			flagButton.setOnDown(onDown);			
//			flagButton.setOnClick(onFlag);
//			
//			// add the hairline
//			var hairline:Shape = new Shape();
//			hairline.graphics.lineStyle(1, _post.stanceColorLight, 0.6, true); // some alpha to make it appear thinner
//			hairline.graphics.moveTo(0, 0);
//			hairline.graphics.lineTo(650, 0);
//			
//			hairline.x = 196;
//			hairline.y = 69;
//			
//			addChild(hairline);
//			
//			// Add the opinoin
//			var opinion:BlockParagraph = new BlockParagraph(650, _post.stanceColorLight, _post.text, 23);
//			opinion.setPadding(11, 18, 14, 18);
//			opinion.visible = true;
//			opinion.x = 196;
//			opinion.y = 88;
//			
//			
//			
//			opinion.setHighlightColor(_post.stanceColorHighlight);
//			opinion.setHighlight(_highlight);
//			
//			addChild(opinion);
//			
//			
//			// Add the go to debate button
//			goToDebateButton.visible = true;
//			goToDebateButton.x = 742;
//			goToDebateButton.y = opinion.y + opinion.height + 10;
//			goToDebateButton.setOnClick(onGoToDebate);
//			goToDebateButton._icon.y += 2;
//			goToDebateButton.setDownColor(Assets.COLOR_GRAY_5);
//			addChild(goToDebateButton);
//			
//			
//			// Add the debate me button
//			var debateButton:BalloonButtonOld = new BalloonButtonOld(110, 101, 0x000000, 'LET\u0027S\nDEBATE !', 15);
//			
//			
//			debateButton = new BalloonButtonOld(152, 135, 0x000000, 'LET\u2019S\nDEBATE !', 22, 0xffffff, Assets.FONT_HEAVY);
//			debateButton.scaleX = 0.67;  
//			debateButton.scaleY = 0.67;				
//			debateButton.setBackgroundColor(_post.stanceColorDark, true);
//			debateButton.setDownColor(_post.stanceColorMedium);
//			goToDebateButton.setOutlineWeight(0);
//			goToDebateButton.showOutline(false);
//			debateButton.visible = true;
//			
//			debateButton.x = 888;
//			debateButton.y = 90;
//			
//			debateButton.setOnDown(onDown);
//			debateButton.setOnClick(onDebate);
//			
//			addChild(debateButton);				
//			
//			// fill in the background
//			
//			var resultHeight:Number = Math.max(portrait.y + portrait.height, goToDebateButton.y + goToDebateButton.height) + bottomPadding;
//			
//			background.graphics.beginFill(Assets.COLOR_GRAY_5);
//			background.graphics.drawRect(0, 0, 1022, resultHeight);
//			background.graphics.endFill();
//			
//			// TODO debate button functionality
//		}
		
		protected function onGoToDebate(e:Event):void {
			// forward to parent
			trace(" go to debate!");
			this.dispatchEvent(new Event(EVENT_GOTO_DEBATE, true, true));
		}
		
	}
}
package com.civildebatewall.elements {
	import flash.display.*;
	import flash.events.Event;
	
	import com.civildebatewall.*;
	import com.civildebatewall.blocks.*;
	import com.civildebatewall.ui.*;
	
	// TODO change aesthetics
	public class SearchResult extends Comment {

		public static const EVENT_GOTO_DEBATE:String = 'eventGoToDebate';		
		
		protected var leftPadding:Number = 32;
		protected var rightPadding:Number = 32;
		protected var topPadding:Number = 27;
		protected var bottomPadding:Number = 22;		
		
		protected var goToDebateButton:IconButton;
		protected var _highlight:String;
		protected var background:Shape;
		
		public function SearchResult(commentID:String, portrait:Bitmap, stance:String, authorName:String, created:Date, opinion:String, highlight:String) {
			_highlight = highlight;
			super(commentID, 0, portrait, stance, authorName, created, opinion);
		}
		
		override protected function init():void {
		
			background = new Shape();
			addChild(background);
			
			// draw the portrait
			portrait = new Sprite();
			portrait.graphics.beginBitmapFill(_portraitData, null, false, true);
			portrait.graphics.drawRoundRect(0, 0, portraitWidth, portraitHeight, 15, 15);
			portrait.graphics.endFill();
			
			// draw the stance banner
			stanceLabel = new BlockLabel('', 28, 0xffffff, 0x000000, Assets.FONT_BOLD, false);
			stanceLabel.setPadding(0, 0, 0, 0);
			stanceLabel.visible = true;
			
			if (_stance == 'yes') {
				stanceColorLight = Assets.COLOR_YES_LIGHT;
				stanceColorMedium = Assets.COLOR_YES_MEDIUM;
				stanceColorDark = Assets.COLOR_YES_DARK;
				stanceLabel.setText('YES!', true);
				
				goToDebateButton = new IconButton(120, 30, Assets.COLOR_GRAY_5, 'Go To Debate', 14, Assets.COLOR_YES_LIGHT, Assets.FONT_BOLD, Assets.getBlueRightCarat(), IconButton.ICON_RIGHT);
				
			}
			else {
				stanceColorLight = Assets.COLOR_NO_LIGHT;
				stanceColorMedium = Assets.COLOR_NO_MEDIUM;
				stanceColorDark = Assets.COLOR_NO_DARK;					
				stanceLabel.setText('NO!', true);
				
				goToDebateButton = new IconButton(120, 30, Assets.COLOR_GRAY_5, 'Go To Debate', 14, Assets.COLOR_NO_LIGHT, Assets.FONT_BOLD, Assets.getOrangeRightCarat(), IconButton.ICON_RIGHT);				
			}
			
			portrait.graphics.beginFill(stanceColorLight);				
			portrait.graphics.drawRect(0, 131, portraitWidth, 38);
			portrait.graphics.endFill();
			
			stanceLabel.y = 130;
			stanceLabel.x = (portraitWidth / 2) - (stanceLabel.width / 2);				
			
			portrait.x = leftPadding;
			portrait.y = topPadding;
			
			portrait.addChild(stanceLabel)
			addChild(portrait);
			
			// add the byline
			var authorText:String = _authorName.toUpperCase() + '\u0027S REBUTTAL STATEMENT';
			var authorLabel:BlockLabel = new BlockLabel(authorText, 17, stanceColorLight, 0x000000, Assets.FONT_HEAVY, false);
			authorLabel.setPadding(0, 0, 0, 0);
			authorLabel.visible = true;
			
			authorLabel.x = 219;
			authorLabel.y = 37;
			
			addChild(authorLabel);
			
			// add the timestamp
			var timeString:String = Utilities.zeroPad(_created.hours, 2) + Utilities.zeroPad(_created.minutes, 2);
			var dateString:String = Utilities.zeroPad(_created.month, 2) + Utilities.zeroPad(_created.date, 2) + (_created.fullYear - 2000);
			
			var timestamp:String = 'Posted at ' + timeString + ' hours on ' + dateString;
			
			var timeLabel:BlockLabel = new BlockLabel(timestamp, 12, stanceColorMedium, 0x000000, Assets.FONT_BOLD_ITALIC, false);
			timeLabel.setPadding(0, 0, 0, 0);
			timeLabel.visible = true;				
			
			timeLabel.x = authorLabel.x + authorLabel.width + 10;
			timeLabel.y = 42;
			
			addChild(timeLabel);
			
			// add the flag button
			var flagButton:IconButton = new IconButton(34, 33, stanceColorDark, '', 0, 0x000000, null, Assets.getSmallFlagIcon());
			flagButton.setDownColor(stanceColorMedium);
			flagButton.setOutlineWeight(2);
			flagButton.visible = true;
			flagButton.x = 817;
			flagButton.y = 26;
			
			addChild(flagButton);
			flagButton.setOnDown(onDown);			
			flagButton.setOnClick(onFlag);
			
			// add the hairline
			var hairline:Shape = new Shape();
			hairline.graphics.lineStyle(1, stanceColorLight, 0.6, true); // some alpha to make it appear thinner
			hairline.graphics.moveTo(0, 0);
			hairline.graphics.lineTo(650, 0);
			
			hairline.x = 196;
			hairline.y = 69;
			
			addChild(hairline);
			
			// Add the opinoin
			var opinion:BlockParagraph = new BlockParagraph(650, stanceColorLight, _opinion, 23);
			opinion.setPadding(11, 18, 14, 18);
			opinion.visible = true;
			opinion.x = 196;
			opinion.y = 88;
			
			
			trace("highlighting with: " + _highlight);
			opinion.setHighlightColor(Assets.COLOR_GRAY_85);
			opinion.setHighlight(_highlight);
			
			addChild(opinion);
			
			
			// Add the go to debate button
			goToDebateButton.visible = true;
			goToDebateButton.x = 742;
			goToDebateButton.y = opinion.y + opinion.height + 10;
			goToDebateButton.setOnClick(onGoToDebate);
			goToDebateButton._icon.y += 2;
			goToDebateButton.setDownColor(Assets.COLOR_GRAY_5);
			addChild(goToDebateButton);
			
			
			// Add the debate me button
			var debateButton:BalloonButton = new BalloonButton(110, 101, 0x000000, 'LET\u0027S\nDEBATE !', 15);
			
			
			debateButton = new BalloonButton(152, 135, 0x000000, 'LET\u2019S\nDEBATE !', 22, 0xffffff, Assets.FONT_HEAVY);
			debateButton.scaleX = 0.67;  
			debateButton.scaleY = 0.67;				
			debateButton.setBackgroundColor(stanceColorDark, true);
			debateButton.setDownColor(stanceColorMedium);
			goToDebateButton.setOutlineWeight(0);
			goToDebateButton.showOutline(false);
			debateButton.visible = true;
			
			debateButton.x = 888;
			debateButton.y = 90;
			
			debateButton.setOnDown(onDown);
			debateButton.setOnClick(onDebate);
			
			addChild(debateButton);				
			
			// fill in the background
			
			var resultHeight:Number = Math.max(portrait.y + portrait.height, goToDebateButton.y + goToDebateButton.height) + bottomPadding;
			
			background.graphics.beginFill(Assets.COLOR_GRAY_5);
			background.graphics.drawRect(0, 0, 1022, resultHeight);
			background.graphics.endFill();
			
			// TODO debate button functionality
		}
		
		protected function onGoToDebate(e:Event):void {
			// forward to parent
			trace(" go to debate!");
			this.dispatchEvent(new Event(EVENT_GOTO_DEBATE, true, true));
		}
		
	}
}
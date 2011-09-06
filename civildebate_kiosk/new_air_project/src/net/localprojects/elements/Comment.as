package net.localprojects.elements {
	import flash.display.*;
	import flash.events.Event;
	
	import net.localprojects.*;
	import net.localprojects.blocks.*;
	import net.localprojects.ui.*;

	public class Comment extends BlockBase {
		
		
		public static const EVENT_FLAG:String = 'eventFlag';
		public static const EVENT_DEBATE:String = 'eventDebate';
		public static const EVENT_BUTTON_DOWN:String = 'eventButtonDown';
		
		
		protected var _commentID:String;
		protected var _commentNumber:int;		
		protected var _portraitData:BitmapData;
		protected var _stance:String;
		protected var _authorName:String;
		protected var _created:Date;
		protected var _opinion:String;
		
		public var activeButton:ButtonBase;
		
		protected var portraitWidth:int;
		protected var portraitHeight:int;
		protected var portrait:Sprite;
		public var stanceColorLight:uint;
		public var stanceColorMedium:uint;
		public var stanceColorDark:uint;
		
		protected var stanceLabel:BlockLabel;
		
		public function Comment(commentID:String, commentNumber:int, portrait:Bitmap, stance:String, authorName:String, created:Date, opinion:String) {
			super();
			
			portraitWidth = 137;
			portraitHeight = 188;			
			
			_commentID = commentID;
			_commentNumber = commentNumber;
			_portraitData = Utilities.scaleToFill(portrait.bitmapData, portraitWidth, portraitHeight);
			_stance = stance;
			_authorName = authorName;
			_created = created;
			_opinion = opinion;
			
			init();
		}
		
		protected function init():void {
			
			
			
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
			}
			else {
				stanceColorLight = Assets.COLOR_NO_LIGHT;
				stanceColorMedium = Assets.COLOR_NO_MEDIUM;
				stanceColorDark = Assets.COLOR_NO_DARK;					
				stanceLabel.setText('NO!', true);					
			}
			
			portrait.graphics.beginFill(stanceColorLight);				
			portrait.graphics.drawRect(0, 131, portraitWidth, 38);
			portrait.graphics.endFill();
			
			stanceLabel.y = 130;
			stanceLabel.x = (portraitWidth / 2) - (stanceLabel.width / 2);				
			
			portrait.addChild(stanceLabel)
			addChild(portrait);
			
			// add the byline
			var authorText:String = _commentNumber + '. ' + _authorName.toUpperCase() + '\u0027S REBUTTAL STATEMENT';
			var authorLabel:BlockLabel = new BlockLabel(authorText, 17, stanceColorLight, 0x000000, Assets.FONT_HEAVY, false);
			authorLabel.setPadding(0, 0, 0, 0);
			authorLabel.visible = true;
			
			authorLabel.x = 167;
			authorLabel.y = 16;
			
			addChild(authorLabel);
			
			// add the timestamp
			var timeString:String = Utilities.zeroPad(_created.hours, 2) + Utilities.zeroPad(_created.minutes, 2);
			var dateString:String = Utilities.zeroPad(_created.month, 2) + Utilities.zeroPad(_created.date, 2) + (_created.fullYear - 2000);
			
			var timestamp:String = 'Posted at ' + timeString + ' hours on ' + dateString;
			
			var timeLabel:BlockLabel = new BlockLabel(timestamp, 12, stanceColorMedium, 0x000000, Assets.FONT_BOLD_ITALIC, false);
			timeLabel.setPadding(0, 0, 0, 0);
			timeLabel.visible = true;				
			
			timeLabel.x = authorLabel.x + authorLabel.width + 10;
			timeLabel.y = 21;
			
			addChild(timeLabel);
			
			// add the flag button
			var flagButton:IconButton = new IconButton(33, 32, stanceColorDark, '', 0, 0x000000, null, Assets.getSmallFlagIcon());
			flagButton.setDownColor(stanceColorMedium);
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
			hairline.graphics.lineStyle(1, stanceColorLight, 0.6, true); // some alpha to make it appear thinner
			hairline.graphics.moveTo(0, 0);
			hairline.graphics.lineTo(652, 0);
			
			hairline.x = 167;
			hairline.y = 42;
			
			addChild(hairline);
			
			// Add the opinoin
			var opinion:BlockParagraph = new BlockParagraph(652, stanceColorLight, _opinion, 23);
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
			debateButton.setBackgroundColor(stanceColorDark, true);
			debateButton.setDownColor(stanceColorMedium);				
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
			activeButton.setBackgroundColor(stanceColorDark);
		}
		
		public function get commentID():String {
			return _commentID;
		}
		
		public function set commentID(s:String):void {
			_commentID = s;
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
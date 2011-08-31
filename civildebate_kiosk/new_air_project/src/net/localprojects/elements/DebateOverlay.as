package net.localprojects.elements
{
	import flash.display.*;
	import flash.text.*;
	
	import net.localprojects.*;
	import net.localprojects.blocks.*;
	import net.localprojects.ui.BalloonButton;
	import net.localprojects.ui.IconButton;
	
	public class DebateOverlay extends BlockBase	{
		
		// scrolling TBA....
		
		private var containerHeight:Number;
		
		private var scrollSheet:Sprite;
		private var scrollMask:Sprite;
		
		
		public function DebateOverlay()	{
			super();
			init();
		}
		
		public function init():void {
			scrollSheet = new Sprite(); 
			scrollMask = new Sprite();
			
			addChild(scrollSheet); // TODO add to scroll container
			addChild(scrollMask);
		}
		
		public function setHeight(h:Number):void {
			containerHeight = h;
			// todo defined by available space
			this.graphics.clear();
			this.graphics.beginFill(0xffffff, 0.9);
			this.graphics.drawRect(0, 0, 1022, containerHeight);
			this.graphics.endFill()
				
			scrollMask.graphics.clear();
			scrollMask.graphics.beginFill(0x000000);
			scrollMask.graphics.drawRect(0, 0, 1022, containerHeight);
			scrollMask.graphics.endFill()				
				
			scrollSheet.mask = scrollMask; 
			
			
		}
		
		public function update():void {
			// rebuild the list
		
			// clear children
			while(scrollSheet.numChildren > 0) {
				scrollSheet.removeChild(scrollSheet.getChildAt(0));
			}			
			
			var yOffset:int = 30;
			var paddingBottom:int = 20;
			
			var index:int = 0;
			for each (var comment:Object in CDW.database.debates[CDW.state.activeDebate]['comments']) {
				trace('comment!');
				//trace(comment);
				
				// portrait
				
				var userID:String = comment['author']['id'];
				
				Utilities.traceObject(comment);
				
				var commentRow:Sprite = new Sprite();
//				commentRow.graphics.beginFill(0xffffff);
//				commentRow.graphics.drawRect(0, 0, 957, 188);
//				commentRow.graphics.endFill();				
				
				
				var portraitWidth:int = 137;
				var portraitHeight:int= 188;
				
				var portraitBitmapData:BitmapData = Utilities.scaleToFill(CDW.database.getPortrait(userID).bitmapData, portraitWidth, portraitHeight);
				
				var portrait:Sprite = new Sprite();
				
				portrait.graphics.beginBitmapFill(portraitBitmapData, null, false, true);
				portrait.graphics.drawRoundRect(0, 0, portraitWidth, portraitHeight, 15, 15);
				portrait.graphics.endFill();
				
				// draw the stance banner
				var stanceLabel:BlockLabel = new BlockLabel('', 28, 0xffffff, 0x000000, Assets.FONT_BOLD, false);
				stanceLabel.setPadding(0, 0, 0, 0);
				stanceLabel.visible = true;
				
				var stanceColorLight:uint;
				var stanceColorMedium:uint;
				var stanceColorDark:uint;				
				
				if (comment['stance'] == 'yes') {
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
				commentRow.addChild(portrait);

				// add the byline
				var authorText:String = (index + 1) + '. ' + comment['author']['firstName'].toString().toUpperCase() + '\u0027S REBUTTAL STATEMENT';
				var authorLabel:BlockLabel = new BlockLabel(authorText, 17, stanceColorLight, 0x000000, Assets.FONT_HEAVY, false);
				authorLabel.setPadding(0, 0, 0, 0);
				authorLabel.visible = true;
				
				authorLabel.x = 167;
				authorLabel.y = 16;
				
				commentRow.addChild(authorLabel);
				
				// add the timestamp
				var created:Date = new Date(comment['created']['$date'])
				var timeString:String = Utilities.zeroPad(created.hours, 2) + Utilities.zeroPad(created.minutes, 2);
				var dateString:String = Utilities.zeroPad(created.month, 2) + Utilities.zeroPad(created.date, 2) + (created.fullYear - 2000);
				
				var timestamp:String = 'Posted at ' + timeString + ' hours on ' + dateString;
				
				var timeLabel:BlockLabel = new BlockLabel(timestamp, 12, stanceColorMedium, 0x000000, Assets.FONT_BOLD_ITALIC, false);
				timeLabel.setPadding(0, 0, 0, 0);
				timeLabel.visible = true;				
				
				timeLabel.x = authorLabel.x + authorLabel.width + 10;
				timeLabel.y = 21;
				
				commentRow.addChild(timeLabel);
				
				// add the flag button
				var flagButton:IconButton = new IconButton(33, 32, stanceColorDark, '', 0, 0x000000, null, Assets.getSmallFlagIcon());
				flagButton.setDownColor(stanceColorMedium);
				flagButton.setStrokeWeight(2);
				flagButton.setStrokeColor(Assets.COLOR_GRAY_15);
				flagButton.visible = true;
				flagButton.x = 791;
				flagButton.y = 0;
				
				commentRow.addChild(flagButton);
				// TODO flag button functionality
				
				// add the hairline
				var hairline:Shape = new Shape();
				hairline.graphics.lineStyle(1, stanceColorLight, 0.6, true); // some alpha to make it appear thinner
				hairline.graphics.moveTo(0, 0);
				hairline.graphics.lineTo(652, 0);
				
				hairline.x = 167;
				hairline.y = 42;
				
				commentRow.addChild(hairline);

				// Add the opinoin
				var opinion:BlockParagraph = new BlockParagraph(652, stanceColorLight, comment['comment'], 23);
				opinion.setPadding(11, 18, 14, 18);
				opinion.visible = true;
				opinion.x = 167;
				opinion.y = 60;
				
				commentRow.addChild(opinion);
				
				// Add the debate me button
				var debateButton:BalloonButton = new BalloonButton(110, 101, 0x000000, 'LET\u0027S\nDEBATE !', 15);
				debateButton.setBackgroundColor(stanceColorDark, true);
				debateButton.setDownColor(stanceColorMedium);				
				debateButton.setStrokeColor(Assets.COLOR_GRAY_15);				
				debateButton.visible = true;
				
				debateButton.x = 849;
				debateButton.y = 61; 
				
				commentRow.addChild(debateButton);				
				
				// TODO debate button functionality
				
				
				
				
				

				commentRow.x = 30;
				commentRow.y = yOffset;
				
				yOffset += Math.max(opinion.height + 60, portrait.height) + paddingBottom;
				
				scrollSheet.addChild(commentRow);
				
				
				index++;
				
				// generate the debate... move to class?
				
				
				
				
				
				
				
				
			}
			
			
		}
		
	}
}
package com.civildebatewall.elements {
	import com.civildebatewall.Assets;
	import com.civildebatewall.CDW;
	import com.civildebatewall.StringUtils;
	import com.civildebatewall.Utilities;
	import com.civildebatewall.blocks.BlockBase;
	import com.civildebatewall.blocks.BlockParagraph;
	import com.civildebatewall.data.Post;
	import com.civildebatewall.ui.BalloonButton;
	import com.greensock.TweenMax;
	
	import flash.display.Bitmap;
	import flash.display.Shape;
	import flash.events.Event;
	
	public class SuperlativesPortrait extends BlockBase {
		
		private var portrait:Portrait;
		private var leftQuote:QuotationMark;
		private var rightQuote:QuotationMark;		
		private var theMask:Shape;
		private var debateButton:BalloonButton;
		private var nametag:NameTag;
		private var opinion:BlockParagraph;
		
		public function SuperlativesPortrait() {
			super();
			
			theMask = new Shape();
			theMask.graphics.beginFill(0x000000);
			theMask.graphics.drawRect(0, 0, 503, 844);
			theMask.graphics.endFill();
						
			graphics.beginFill(0xffffff);
			graphics.drawRect(0, 0, 503, 844);
			graphics.endFill();
			
			portrait = new Portrait();
			portrait.visible = true;
			addChild(portrait);
			
			leftQuote = new QuotationMark();
			leftQuote.setStyle(QuotationMark.OPENING);
			leftQuote.setDefaultTweenIn(1, {x: 30, y: 368});
			leftQuote.setDefaultTweenOut(1, {x: -leftQuote.width - 10, y: 368});
			
			leftQuote.scaleX = 0.5;
			leftQuote.scaleY = 0.5;			
			addChild(leftQuote);
			
			rightQuote = new QuotationMark();
			rightQuote.setStyle(QuotationMark.CLOSING);
			rightQuote.setDefaultTweenIn(1, {x: 383, y: 727});
			rightQuote.setDefaultTweenOut(1, {x: width + 10, y: 727});
			
			rightQuote.scaleX = 0.5;
			rightQuote.scaleY = 0.5;			
			addChild(rightQuote);
			
			debateButton = new BalloonButton(152, 135, 0x000000, 'LET\u2019S\nDEBATE !', 22, 0xffffff, Assets.FONT_HEAVY);
			debateButton.setDefaultTweenIn(1, {x: 361, y: 368});
			debateButton.setDefaultTweenOut(1, {x: width + 10, y: 368});
			debateButton.scaleX = 0.75;
			debateButton.scaleY = 0.75;
			debateButton.setOnClick(onDebateClick);
			addChild(debateButton);			
			
			nametag = new NameTag('Name', 50, 0xffffff, 0x000000, Assets.FONT_HEAVY, true);	
			nametag.setPadding(33, 38, 24, 38);
			nametag.setDefaultTweenIn(1, {x: 30, y: 492});
			nametag.setDefaultTweenOut(1, {x: -300, y: 492});
			nametag.scaleX = 0.5;
			nametag.scaleY = 0.5;	
			addChild(nametag);			
			
			opinion = new BlockParagraph(915, 0x000000, '', 42);	
			opinion.setDefaultTweenIn(1, {x: 30, y: 552});
			opinion.setDefaultTweenOut(1, {x: -500, y: 552});
			opinion.scaleX = 0.5;
			opinion.scaleY = 0.5;				
			addChild(opinion);			
			
			
			// starting positions
			leftQuote.tweenOut();
			rightQuote.tweenOut();		
			debateButton.tweenOut();
			nametag.tweenOut();
			opinion.tweenOut();
			
			
			addChild(theMask);
			this.mask = theMask;
		}
		
		
		private var _post:Post;
		
		
		public function setPost(post:Post, instant:Boolean = false):void {
			_post = post;
			
			portrait.setImage(new Bitmap(Utilities.scaleToFill(_post.user.photo.bitmapData, 503, 844), "auto", true), instant);
			

			if (instant) {
				finishSettingPost(true);
			}
			else {
				// tween everything out, then finish
				leftQuote.tweenOut();
				rightQuote.tweenOut(-1, {onComplete: finishSettingPost});
				debateButton.tweenOut();
				nametag.tweenOut();
				opinion.tweenOut();
			}
		}
		
		private function onDebateClick(e:Event):void {
			// Respond to debate
			trace("Debate with post: " + _post);
			CDW.state.userIsResponding = true;
			CDW.state.userRespondingTo = _post;				
			CDW.view.pickStanceView();			
		}
		
		private function finishSettingPost(instant:Boolean = false):void {
			// mutations go here
			leftQuote.setColor(_post.stanceColorLight, true);
			rightQuote.setColor(_post.stanceColorLight, true);
			debateButton.setDownColor(_post.stanceColorMedium);
			debateButton.setBackgroundColor(_post.stanceColorDark, true);
			nametag.setBackgroundColor(_post.stanceColorMedium, true);
			nametag.setText(_post.user.usernameFormatted + ' Says : ', true);
			opinion.setBackgroundColor(_post.stanceColorLight, true);
			opinion.setText(_post.text);
			//rightQuote.y = opinion.y + opinion.height
			
			leftQuote.tweenIn();
			rightQuote.tweenIn();								
			debateButton.tweenIn();
			nametag.tweenIn();
			opinion.tweenIn();
		}		
	}
}
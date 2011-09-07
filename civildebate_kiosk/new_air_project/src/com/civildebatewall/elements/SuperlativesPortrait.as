package com.civildebatewall.elements {
	import com.greensock.TweenMax;
	
	import flash.display.Bitmap;
	import flash.display.Shape;
	
	import com.civildebatewall.Assets;
	import com.civildebatewall.CDW;
	import com.civildebatewall.StringUtils;
	import com.civildebatewall.Utilities;
	import com.civildebatewall.blocks.BlockBase;
	import com.civildebatewall.blocks.BlockParagraph;
	import com.civildebatewall.ui.BalloonButton;
	
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
		
		
		private var targetID:String;
		
		
		public function setPost(id:String, instant:Boolean = false):void {
			targetID = id;
			
			portrait.setImage(new Bitmap(Utilities.scaleToFill(CDW.database.getDebateAuthorPortrait(id).bitmapData, 503, 844), "auto", true), instant);
			
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
				///TweenMax.delayedCall(1, finishSettingPost);
			}
			
		}
		
		
		public var stanceColorLight:uint;
		public var stanceColorMedium:uint;
		public var stanceColorDark:uint;
		public var stanceColorOverlay:uint;
		public var stanceColorDisabled:uint;
		public var stanceColorExtraLight:uint; 				
		
		private function finishSettingPost(instant:Boolean = false):void {
			// mutations go here
			var debate:Object = CDW.database.debates[targetID];
			
			if (debate['stance'] == 'yes') {
				stanceColorLight = Assets.COLOR_YES_LIGHT;
				stanceColorMedium = Assets.COLOR_YES_MEDIUM;
				stanceColorDark = Assets.COLOR_YES_DARK;
				stanceColorOverlay = Assets.COLOR_YES_OVERLAY;
				stanceColorDisabled = Assets.COLOR_YES_DISABLED;
				stanceColorExtraLight = Utilities.color(190, 225, 250);
			}
			else {
				stanceColorLight = Assets.COLOR_NO_LIGHT;
				stanceColorMedium = Assets.COLOR_NO_MEDIUM;
				stanceColorDark = Assets.COLOR_NO_DARK;
				stanceColorOverlay = Assets.COLOR_NO_OVERLAY;
				stanceColorDisabled = Assets.COLOR_NO_DISABLED;
				stanceColorExtraLight = Utilities.color(247, 201, 181);				
			}
			
			leftQuote.setColor(stanceColorLight, true);
			rightQuote.setColor(stanceColorLight, true);
			debateButton.setBackgroundColor(stanceColorDark, true);
			nametag.setBackgroundColor(stanceColorMedium, true);
			nametag.setText(StringUtils.capitalize(debate['author']['firstName']) + ' Says : ', true);
			opinion.setBackgroundColor(stanceColorLight, true);
			opinion.setText(debate['opinion']);
			//rightQuote.y = opinion.y + opinion.height
			
			
			leftQuote.tweenIn();
			rightQuote.tweenIn();								
			debateButton.tweenIn();
			nametag.tweenIn();
			opinion.tweenIn();
			
			
		}
			


		
	}
}
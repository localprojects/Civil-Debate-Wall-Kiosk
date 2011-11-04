package com.civildebatewall.kiosk.elements {
	import com.civildebatewall.Assets;
	import com.civildebatewall.CivilDebateWall;
	import com.civildebatewall.Utilities;
	import com.civildebatewall.data.Post;
	import com.civildebatewall.kiosk.Kiosk;
	import com.civildebatewall.kiosk.blocks.OldBlockBase;
	import com.civildebatewall.kiosk.blocks.BlockBitmapPlus;
	import com.civildebatewall.kiosk.blocks.BlockParagraph;
	import com.civildebatewall.kiosk.ui.BalloonButtonOld;
	import com.greensock.TweenMax;
	import com.kitschpatrol.futil.utilitites.BitmapUtil;
	
	import flash.display.Bitmap;
	import flash.display.Shape;
	import flash.events.Event;
	
	public class SuperlativesPortrait extends OldBlockBase {
		
		private var portrait:Portrait;
		private var quoteLeft:BlockBitmapPlus;
		private var quoteRight:BlockBitmapPlus;		
		private var theMask:Shape;
		private var debateButton:BalloonButtonOld;
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
			
			quoteLeft = new BlockBitmapPlus(Assets.getQuoteLeft());
			quoteLeft.setDefaultTweenIn(1, {x: 30, y: 368});
			quoteLeft.setDefaultTweenOut(1, {x: -quoteLeft.width - 10, y: 368});
			
			quoteLeft.scaleX = 0.5;
			quoteLeft.scaleY = 0.5;			
			addChild(quoteLeft);
			
			quoteRight = new BlockBitmapPlus(Assets.getQuoteRight());
			quoteRight.setDefaultTweenIn(1, {x: 383, y: 727});
			quoteRight.setDefaultTweenOut(1, {x: width + 10, y: 727});
			
			quoteRight.scaleX = 0.5;
			quoteRight.scaleY = 0.5;			
			addChild(quoteRight);
			
			debateButton = new BalloonButtonOld(152, 135, 0x000000, 'LET\u2019S\nDEBATE !', 22, 0xffffff, Assets.FONT_HEAVY);
			debateButton.setDefaultTweenIn(1, {x: 361, y: 368});
			debateButton.setDefaultTweenOut(1, {x: width + 10, y: 368});
			debateButton.scaleX = 0.75;
			debateButton.scaleY = 0.75;
			debateButton.setOnClick(onDebateClick);
			addChild(debateButton);			
			
			nametag = new NameTag();	
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
			quoteLeft.tweenOut();
			quoteRight.tweenOut();		
			debateButton.tweenOut();
			nametag.tweenOut();
			opinion.tweenOut();
			
			
			addChild(theMask);
			this.mask = theMask;
		}
		
		
		private var _post:Post;
		
		
		public function setPost(post:Post, instant:Boolean = false):void {
			_post = post;
			
			portrait.setImage(new Bitmap(BitmapUtil.scaleDataToFill(_post.user.photo.bitmapData, 503, 844), "auto", true), instant);
			

			if (instant) {
				finishSettingPost(true);
			}
			else {
				// tween everything out, then finish
				quoteLeft.tweenOut();
				quoteRight.tweenOut(-1, {onComplete: finishSettingPost});
				debateButton.tweenOut();
				nametag.tweenOut();
				opinion.tweenOut();
			}
		}
		
		private function onDebateClick(e:Event):void {
			// Respond to debate
			trace("Debate with post: " + _post);
			CivilDebateWall.state.userIsDebating = true;
			CivilDebateWall.state.userRespondingTo = _post;				
		//	CivilDebateWall.kiosk.view.pickStanceView();			
		}
		
		private function finishSettingPost(instant:Boolean = false):void {
			// mutations go here
			quoteLeft.setColor(_post.stanceColorLight, true);
			quoteRight.setColor(_post.stanceColorLight, true);
			debateButton.setDownColor(_post.stanceColorMedium);
			debateButton.setBackgroundColor(_post.stanceColorDark, true);
			nametag.backgroundColor = _post.stanceColorMedium;
			nametag.text = _post.user.usernameFormatted + ' Says:';
			opinion.setBackgroundColor(_post.stanceColorLight, true);
			opinion.setText(_post.text);
			//rightQuote.y = opinion.y + opinion.height
			
			quoteLeft.tweenIn();
			quoteRight.tweenIn();								
			debateButton.tweenIn();
			nametag.tweenIn();
			opinion.tweenIn();
		}		
	}
}
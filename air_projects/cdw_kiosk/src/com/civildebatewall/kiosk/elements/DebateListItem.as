package com.civildebatewall.kiosk.elements {
	import com.civildebatewall.Assets;
	import com.civildebatewall.data.Post;

	import com.greensock.TweenMax;
	import com.greensock.easing.*;
	import com.kitschpatrol.futil.blocks.BlockBase;
	import com.kitschpatrol.futil.blocks.BlockText;
	import com.kitschpatrol.futil.constants.Alignment;
	import com.kitschpatrol.futil.utilitites.NumberUtil;
	import com.kitschpatrol.futil.utilitites.StringUtil;
	
	
	public class DebateListItem extends BlockBase {
		

		private var _post:Post;
		private var _itemIndex:int;		
		public var toggledOn:Boolean;
		

		private var numberLabel:BlockText;		
		private var author:BlockText;	
		private var horizontalRule:BlockBase;
		public var callout:BlockText;
		
		public function DebateListItem(post:Post, itemIndex:int = 0) {
			super();			
			_post = post;
			_itemIndex = itemIndex;
			toggledOn = false;
			
			width = 505;
			height = 157;
			backgroundRadius = 8;
			
			// rule
			horizontalRule = new BlockBase();
			horizontalRule.width = width;
			horizontalRule.height = 1;
			horizontalRule.y = 62;
			horizontalRule.visible = true;
			addChild(horizontalRule);
			
			// number
			numberLabel = new BlockText();
			numberLabel.textFont = Assets.FONT_HEAVY;
			numberLabel.textSize = 12;
			numberLabel.textAlignmentMode = Alignment.TEXT_RIGHT;
			numberLabel.width = 51;
			numberLabel.height = 12;
			numberLabel.text = _itemIndex +  ".";
			numberLabel.y = 26;
			numberLabel.visible = true;
			numberLabel.backgroundAlpha = 0;
			addChild(numberLabel);
			
			
			// author and date\
			var name:String = StringUtil.capitalize(_post.user.usernameFormatted, true);
			var date:String =  NumberUtil.zeroPad(_post.created.month, 2) + "/" + NumberUtil.zeroPad(_post.created.date, 2) + "/" + (_post.created.fullYear - 2000); 
			var ampm:String = (_post.created.hours < 12) ? "am" : "pm";
			var time:String = (_post.created.hours % 12) + "." + _post.created.minutes + ampm;			
			
			author = new BlockText();
			author.textFont = Assets.FONT_BOLD;
			author.textSize = 12;
			author.width = 418;
			author.height = 12;			
			author.x = 86;
			author.y = 26;
			author.text = name + " : " + date + ", " + time;
			author.visible = true;
			author.backgroundAlpha = 0;
			addChild(author);
			
			
			callout = new BlockText();
			callout.textFont = Assets.FONT_BOLD;
			callout.textSize = 34;
			callout.width = 418;
			callout.height = 34;			
			callout.x = 86;
			callout.y = 93;	
			callout.visible = true;
			callout.backgroundAlpha = 0;
			addChild(callout);
			
			
			buttonMode = true;
			
			//onButtonDown.push(onDown);
			onStageUp.push(onUp);

			
			onUp();
		}
		
		
		private var backTween:TweenMax = null;
		
		private function onDown(...args):void {
			trace("down " + _itemIndex);
			backgroundColor = _post.stanceColorMedium;
			horizontalRule.backgroundColor = 0xffffff;
			numberLabel.textColor = 0xffffff;
			author.textColor = 0xffffff;			
			callout.textColor = 0xffffff;				
		}
		
		private function onUp(...args):void {
			
			if (!toggledOn) {
				backTween = TweenMax.to(this, 0.3, {backgroundColor: Assets.COLOR_GRAY_5});
				TweenMax.to(horizontalRule, 0.3, {backgroundColor: Assets.COLOR_GRAY_15});
				TweenMax.to(numberLabel, 0.3, {textColor: Assets.COLOR_GRAY_15});
				TweenMax.to(author, 0.3, {textColor: Assets.COLOR_GRAY_15});
				TweenMax.to(callout, 0.3, {textColor: Assets.COLOR_GRAY_15});
			}
		}	

		
		public function activate():void {
			toggledOn = true;;
			TweenMax.killChildTweensOf(this, true);
			if (backTween != null) backTween.kill();
			onDown();
		}
		
		public function deactivate():void {
			toggledOn = false;
			onUp();
		}
		
		public function get post():Post { return _post; }
		
	}
}
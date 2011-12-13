package com.civildebatewall.kiosk.elements {

	import com.civildebatewall.Assets;
	import com.civildebatewall.data.containers.Post;
	import com.greensock.TweenMax;
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
			super({
				width: 505,
				height: 157,
				backgroundRadius: 8				
			});			
			
			_post = post;
			_itemIndex = itemIndex;
			toggledOn = false;
			
			// rule
			horizontalRule = new BlockBase({
				width: width,
				height: 1,
				y: 62,
				visible: true
			});
			addChild(horizontalRule);
			
			// number
			numberLabel = new BlockText({
				textFont: Assets.FONT_HEAVY,
				textSize: 12,
				textAlignmentMode: Alignment.TEXT_RIGHT,
				width: 51,
				height: 12,
				text: _itemIndex +  ".",
				y: 26,
				visible: true,
				backgroundAlpha: 0			
			});
			addChild(numberLabel);
			
			// author and date\
			var name:String = StringUtil.capitalize(_post.user.usernameFormatted, true);
			var date:String =  NumberUtil.zeroPad(_post.created.month, 2) + "/" + NumberUtil.zeroPad(_post.created.date, 2) + "/" + (_post.created.fullYear - 2000); 
			var ampm:String = (_post.created.hours < 12) ? "am" : "pm";
			var time:String = (_post.created.hours % 12) + "." + _post.created.minutes + ampm;			
			
			author = new BlockText({
				textFont: Assets.FONT_BOLD,
				textSize: 12,
				width: 418,
				height: 12,			
				x: 86,
				y: 26,
				text: name + " : " + date + ", " + time,
				visible: true,
				backgroundAlpha: 0			
			});
			addChild(author);
			
			callout = new BlockText({
				textFont: Assets.FONT_BOLD,
				textSize: 34,
				width: 418,
				height: 34,			
				x: 86,
				y: 93,	
				visible: true,
				backgroundAlpha: 0
			});
			addChild(callout);
			
			buttonMode = true;
			
			onStageUp.push(onUp);
			onUp();
		}
		
		
		private var backTween:TweenMax = null;
		
		private function onDown(...args):void {
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
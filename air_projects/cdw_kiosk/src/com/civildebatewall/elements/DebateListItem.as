package com.civildebatewall.elements {
	import com.civildebatewall.Assets;
	import com.civildebatewall.CDW;
	import com.civildebatewall.Utilities;
	import com.civildebatewall.blocks.BlockLabel;
	import com.civildebatewall.blocks.BlockLabelBar;
	import com.civildebatewall.blocks.BlockParagraph;
	import com.civildebatewall.data.Post;
	import com.civildebatewall.ui.ButtonBase;
	import com.greensock.TweenMax;
	import com.greensock.easing.*;
	import com.kitschpatrol.futil.utilitites.NumberUtil;
	import com.kitschpatrol.futil.utilitites.ObjectUtil;
	import com.kitschpatrol.futil.utilitites.StringUtil;
	
	import flash.display.Bitmap;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.MouseEvent;
	import flash.utils.Timer;
	
	import mx.states.AddChild;
	
	public class DebateListItem extends ButtonBase {
		
		private var _post:Post;
		private var _itemIndex:int;
		private var _foregroundColor:uint;		
		public var toggledOn:Boolean;

		
		private var tintGroup:Sprite;
		private var opinionExcerpt:BlockParagraph;
		private var byline:BlockLabel;
		private var circle:Bitmap;
		private var indexNumber:BlockLabelBar;		
		private var bubble:Bitmap;
		private var responseNumber:BlockLabelBar;		
		private var circleFill:Bitmap;
		private var bubbleFill:Bitmap;		
		

		private var horizontalRule:Shape;
		
		public function DebateListItem(post:Post, itemIndex:int = 0) {
			_post = post;
			_itemIndex = itemIndex;
			super();
			
			toggledOn = false;

			background.graphics.beginFill(0xffffff);
			background.graphics.drawRect(0, 0, 503, 157);
			background.graphics.endFill();
			addChild(background);
			
			tintGroup = new Sprite();
			
			horizontalRule = new Shape();
			horizontalRule.graphics.lineStyle(1, 0xffffff, 1.0, true);
			horizontalRule.graphics.lineTo(width, 0);
			horizontalRule.y = 95;
			tintGroup.addChild(horizontalRule);
			
			circleFill = Assets.getCircleBackground();
			circleFill.x = 23;
			circleFill.y = 33;
			addChild(circleFill);

			circle = Assets.getCirclePerimeter();
			circle.x = 23;
			circle.y = 33;
			tintGroup.addChild(circle);			
			
			// circle number...
			indexNumber = new BlockLabelBar(_itemIndex.toString(), 15, 0xffffff, 28, 28, 0x000000, Assets.FONT_BOLD);
			indexNumber.visible = true;
			indexNumber.bar.visible = false;
			indexNumber.x = 23 - 0.5;
			indexNumber.y = 33 - 1;
			tintGroup.addChild(indexNumber);
			
			opinionExcerpt = new BlockParagraph(406, 0x000000, StringUtil.truncate(_post.text,  100), 14);
			opinionExcerpt.background.visible = false;
			opinionExcerpt.setPadding(0, 0, 0, 0);
			opinionExcerpt.visible = true;
			opinionExcerpt.x = 73;
			opinionExcerpt.y = 30 - 6;			
			tintGroup.addChild(opinionExcerpt);
				
			
			bubbleFill = Assets.getBubbleBackground();
			bubbleFill.x = 23;
			bubbleFill.y = 110;
			addChild(bubbleFill);
			
			bubble = Assets.getBubblePerimeter();
			bubble.x = 23;
			bubble.y = 110;
			tintGroup.addChild(bubble);		
			
			var responseCount:int = ObjectUtil.objectLength(_post.thread.postCount - 1); // TODO, something better?
			
			responseNumber = new BlockLabelBar(responseCount.toString(), 11, 0xffffff, 28, 28, 0x000000, Assets.FONT_BOLD);
			responseNumber.visible = true;
			responseNumber.bar.visible = false;
			responseNumber.x = 23 - 0.5;
			responseNumber.y = 110 - 2;
			tintGroup.addChild(responseNumber);			
			
			

			var day:String =  NumberUtil.zeroPad(_post.created.month, 2) + '/' + NumberUtil.zeroPad(_post.created.date, 2) + '/' + (_post.created.fullYear - 2000); 
			var ampm:String = (_post.created.hours < 12) ? 'am' : 'pm';
			var time:String = (_post.created.hours % 12) + ':' + _post.created.minutes + ampm;
			var bylineText:String = _post.user.usernameFormatted + ' said this on ' + day + ' at ' + time;
			
			byline = new BlockLabel(bylineText, 14, 0xffffff, 0x000000, null, false);
			byline.visible = true;
			byline.x = 73;
			byline.y = 118 - 5;
			tintGroup.addChild(byline);

			addChild(tintGroup);

			setDownColor(_post.stanceColorMedium);
			setBackgroundColor(Assets.COLOR_GRAY_2, true);
			setForegroundColor(_post.stanceColorExtraLight, true);	
		}
		
		override protected function onMouseDown(e:MouseEvent):void {
			if (!locked) {
				if (onDown != null) onDown(e);
				CDW.self.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
				TweenMax.to(background, 0, {colorTransform: {tint: _backgroundDownColor, tintAmount: 1}});
				TweenMax.to(bubbleFill, 0, {alpha: 0});
				TweenMax.to(circleFill, 0, {alpha: 0});		
				onClick(e); // fire on down for this button				
			}
		}		
		
		
		override protected function onMouseUp(e:MouseEvent):void {

			
			if (!toggledOn) {
				TweenMax.to(bubbleFill, 0, {alpha: 1});
				TweenMax.to(circleFill, 0, {alpha: 1});					
			}
			
			
			if (timeout > 0) {
				locked = true;
				timer.reset();
				timer.start();
				
				
				
				
				TweenMax.to(background, 0.3, {ease: Quart.easeOut, colorTransform: {tint: _disabledColor, tintAmount: 1}});
				TweenMax.to(outline, 0.3, {ease: Quart.easeOut, alpha: 0});
			
			}
			else {
				TweenMax.to(background, 0.3, {ease: Quart.easeOut, colorTransform: {tint: _backgroundColor, tintAmount: 1}});
			}
			
			CDW.self.removeEventListener(MouseEvent.MOUSE_UP, onMouseUp);			
			
			
		}			
		
		public function activate():void {
			toggledOn = true;
			setBackgroundColor(_post.stanceColorLight, true);
			TweenMax.to(bubbleFill, 0.5, {alpha: 0});
			TweenMax.to(circleFill, 0.5, {alpha: 0});			
		}
		
		public function deactivate():void {
			toggledOn = false;
			setBackgroundColor(Assets.COLOR_GRAY_2, false);
			TweenMax.to(bubbleFill, 0.5, {alpha: 1});
			TweenMax.to(circleFill, 0.5, {alpha: 1});			
		}
		
		
		public function get post():Post { return _post; }
		
		
		public function setForegroundColor(c:uint, instant:Boolean = false):void {
			_foregroundColor = c;
			
			var duration:Number = instant ? 0 : 1;
			
			TweenMax.to(tintGroup, duration, {ease: Quart.easeOut, colorTransform: {tint: _foregroundColor, tintAmount: 1}});
		}		
		
		override public function setBackgroundColor(c:uint, instant:Boolean = false):void {
			_backgroundColor = c;
			
			var duration:Number = instant ? 0 : 1;
			
			TweenMax.to(background, duration, {ease: Quart.easeOut, colorTransform: {tint: _backgroundColor, tintAmount: 1}});
		}		
	}
}
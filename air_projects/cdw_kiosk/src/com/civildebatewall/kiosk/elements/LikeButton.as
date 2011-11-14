package com.civildebatewall.kiosk.elements {
	import com.civildebatewall.Assets;
	import com.civildebatewall.CivilDebateWall;
	import com.civildebatewall.State;
	import com.civildebatewall.data.Data;
	import com.civildebatewall.data.Post;
	import com.greensock.TweenMax;
	import com.greensock.easing.Back;
	import com.greensock.easing.Elastic;
	import com.kitschpatrol.futil.blocks.BlockBase;
	import com.kitschpatrol.futil.blocks.BlockText;
	import com.kitschpatrol.futil.constants.Alignment;
	import com.kitschpatrol.futil.utilitites.StringUtil;
	
	import flash.display.Bitmap;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	import flashx.textLayout.formats.TextAlign;
	
	public class LikeButton extends BlockBase {
		
		private var _targetPost:Post;		
		
		private var counter:BlockText;
		private var icon:Bitmap;		
		private var pipe:Shape;
		private var label:BlockText;
		
		public function LikeButton() {
			super({
				width: 174,
				height: 64,
				backgroundRadius: 8,
				buttonMode: true
			});
			

			// Numeric counter
			counter = new BlockText({
				text: '0',
				textFont: Assets.FONT_BOLD,
				textBold: true,
				textSize: 18,
				textAlignmentMode: TextAlign.RIGHT,
				textColor: 0xffffff,
				backgroundAlpha: 0,
				width: 50,
				height: 20,
				registrationPoint: Alignment.TOP_RIGHT,
				visible: true
			});
			
			counter.x = 50;
			counter.y = 23;
			counter.mouseEnabled = false;
			addChild(counter);
			
			// E> Icon
			icon = Assets.getLikeIcon();
			icon.x = 54;
			icon.y = 24;
			addChild(icon);			
			
			// Small divider pipe
			pipe = new Shape();
			pipe.graphics.beginFill(0xffffff);
			pipe.graphics.drawRect(0, 0, 1, 35);
			pipe.graphics.endFill();
			pipe.x = 86;
			pipe.y = 15;
			addChild(pipe);
			
			// "Like" label
			label = new BlockText({
				text: 'Like',
				textFont: Assets.FONT_REGULAR,
				textSize: 18,
				textColor: 0xffffff,
				backgroundAlpha: 0,
				width: 73,
				height: 20,
				visible: true
			});
			
			label.x = 100;
			label.y = 23;
			label.mouseEnabled = false;
			addChild(label);
			

			CivilDebateWall.data.addEventListener(Data.LIKE_UPDATE_LOCAL, onLike);
			CivilDebateWall.data.addEventListener(Data.LIKE_UPDATE_SERVER, onLike);
			
			buttonTimeout = 5000;
			onButtonDown.push(onDown);
			onStageUp.push(onUp);
			onButtonLock.push(onLock);
			onButtonUnlock.push(onUnlock);
		}
		
		private function onLike(e:Event):void {
			trace("got event");
			counter.text = _targetPost.likes.toString();
			label.text = StringUtil.plural("Like", _targetPost.likes);
		}
		
		public function get targetPost():Post {
			return _targetPost;
		}
		
		public function set targetPost(post:Post):void {
			_targetPost = post;
			counter.text =_targetPost.likes.toString();
			label.text = StringUtil.plural("Like", _targetPost.likes);
			unlock(); // Fires onUnlock() below.			
		}		
		
		private function onDown(e:MouseEvent):void {
			backgroundColor = _targetPost.stanceColorDark;
		}
		
		private function onLock(e:MouseEvent):void {
			backgroundColor = _targetPost.stanceColorDisabled;
		}
		
		private function onUnlock(e:MouseEvent):void {
			backgroundColor = _targetPost.stanceColorMedium;
		}
		
		private function onUp(e:MouseEvent):void {
			CivilDebateWall.data.like(_targetPost);
			
			// Thump
			TweenMax.to(icon, 0.25, {transformAroundCenter:{scaleX: 1.5, scaleY: 1.5}, alpha: 0.75, ease: Back.easeOut, yoyo: true, repeat: 1});
		}	
		
	}
}
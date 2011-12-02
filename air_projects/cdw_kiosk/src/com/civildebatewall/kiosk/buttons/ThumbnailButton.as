package com.civildebatewall.kiosk.buttons {
	import com.bit101.components.PushButton;
	import com.civildebatewall.*;
	import com.civildebatewall.Assets;
	import com.civildebatewall.data.Post;
	import com.civildebatewall.data.Thread;
	import com.civildebatewall.kiosk.legacy.OldBlockBase;
	import com.greensock.*;
	import com.greensock.easing.*;
	import com.kitschpatrol.futil.blocks.BlockBase;
	import com.kitschpatrol.futil.blocks.BlockText;
	import com.kitschpatrol.futil.utilitites.BitmapUtil;
	import com.kitschpatrol.futil.utilitites.GeomUtil;
	
	import flash.display.*;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.text.*;
	
	public class ThumbnailButton extends BlockBase {
	
		public var thread:Thread;
		private var _backgroundColor:uint;
		private var lines:Shape;
		private var roundedPortrait:Sprite;
		private var _selected:Boolean;
		private var stanceText:Bitmap;
		public var downBackgroundColor:uint = 0xffffff;		
		private var textBackground:Sprite;
		public var leftDot:Shape;
		public  var rightDot:Shape;
		
		
		public function updatePortrait():void {
			if (roundedPortrait != null) {
				var scaledPhotoData:BitmapData = BitmapUtil.scaleDataToFill(thread.firstPost.user.photo.bitmapData, 71, 96)
					
				roundedPortrait.graphics.clear();
				roundedPortrait.graphics.beginBitmapFill(scaledPhotoData, null, false, true);
				roundedPortrait.graphics.drawRoundRect(0, 0, 71, 96, 15, 15);
				roundedPortrait.graphics.endFill();							
			}
		}
		
		
		public function ThumbnailButton(thread:Thread) {
			this.thread = thread;
			
			super({
				width: 173,
				height: 141,
				backgroundColor: 0xffffff,
				visible: true			
			});

			roundedPortrait = new Sprite();
			var scaledPhotoData:BitmapData = BitmapUtil.scaleDataToFill(thread.firstPost.user.photo.bitmapData, 71, 96)
			
			roundedPortrait.graphics.beginBitmapFill(scaledPhotoData, null, false, true);
			roundedPortrait.graphics.drawRoundRect(0, 0, 71, 96, 15, 15);
			roundedPortrait.graphics.endFill();			
      // roundedPortrait.cacheAsBitmap = false;
			this.cacheAsBitmap = false;
			GeomUtil.centerWithin(roundedPortrait, this);			
						
			// text background
			textBackground = new Sprite();
			textBackground.graphics.beginFill(thread.firstPost.stanceColorLight);
			textBackground.graphics.drawRect(0, 0, 71, 24);
			textBackground.graphics.endFill();
			textBackground.x = roundedPortrait.x;
			textBackground.y = 85;				
			
			//  the text
			if (thread.firstPost.stance == Post.STANCE_YES) {
				stanceText = Assets.getThumbnailStanceTextYes();
			}
			else if (thread.firstPost.stance == Post.STANCE_NO) {
				stanceText = Assets.getThumbnailStanceTextNo();
			}
			else {
				throw new Error("Invalid stance type \"" + thread.firstPost.stance + "\"");
			}
			
			GeomUtil.centerWithin(stanceText, textBackground);
			
			// down background color: thread.firstPost.stanceColorWatermark;

			// top line
			lines = new Shape();
			
			lines.graphics.beginFill(thread.firstPost.stanceColorLight);
			lines.graphics.drawRect(2, 4, 169, 3);			
			lines.graphics.endFill();
			
			// bottom line
			lines.graphics.beginFill(thread.firstPost.stanceColorLight);
			lines.graphics.drawRect(2, 132, 169, 3);			
			lines.graphics.endFill();		
			
			addChild(lines);


			// dots
			leftDot = new Shape();
			rightDot = new Shape();			

			setDotColor(Assets.COLOR_GRAY_50);
			
			leftDot.y = 70;
			leftDot.x = 0;
						
			rightDot.y = 70;
			rightDot.x = width;			
			
				
			addChild(roundedPortrait);
			addChild(textBackground);
			textBackground.addChild(stanceText);
			addChild(leftDot);
			addChild(rightDot);

			// override blockbase hiding behavior
			visible = true;
			
			this.cacheAsBitmap = true;
			
			
			buttonMode = true;
			onStageUp.push(onUp);
			onButtonDown.push(onDown);
			onButtonCancel.push(onCancel);
			
			// clean up
			addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);

			// set initial saturation
			selected = false;
		}
		
		private function onRemovedFromStage(e:Event):void {
			this.buttonMode = false;
			this.removeEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
		}
		
		private function onDown(e:MouseEvent):void {
			if (!_selected)	drawDown();
		}
		
		private function onUp(e:MouseEvent):void {
			if (!_selected) CivilDebateWall.state.setActiveThread(thread);
		}		
		
		private function onCancel(e:Event):void {
			drawUp();
			removeStageUpListener();			
		}
		
		private function setDotColor(c:uint):void {
			leftDot.graphics.clear();
			leftDot.graphics.beginFill(c);
			leftDot.graphics.drawCircle(-1.5, -1.5, 3);
			leftDot.graphics.endFill();
			
			rightDot.graphics.clear();
			rightDot.graphics.beginFill(c);
			rightDot.graphics.drawCircle(-1.5, -1.5, 3);
			rightDot.graphics.endFill();			
		}
		
		public function get selected():Boolean {
			return _selected;
		}
		
		private function drawSelected():void {
			// saturate
			TweenMax.to(roundedPortrait, 1, {colorMatrixFilter:{saturation: 1}, ease: Quart.easeInOut});
			TweenMax.to(textBackground, 0.5, {y: this.height, alpha: 0, ease: Quart.easeOut});				
			setDotColor(thread.firstPost.stanceColorLight);
			drawDown();
		}
		
		private function drawDeselected():void {
			TweenMax.to(roundedPortrait, 1, {colorMatrixFilter:{saturation: 0}, ease: Quart.easeInOut});
			TweenMax.to(textBackground, 0.5, {y: 85, alpha: 1, ease: Quart.easeOut});				
			setDotColor(Assets.COLOR_GRAY_50);			
			drawUp();
		}
		
		private function drawDown():void {
			TweenMax.to(this, 0, {backgroundColor: thread.firstPost.stanceColorWatermark});
		}
		
		private function drawUp():void {
			TweenMax.to(this, 0.5, {backgroundColor: 0xffffff});
		}
		
		public function set selected(b:Boolean):void {
			_selected = b;
			
			if(_selected) {
				drawSelected();
			}
			else {
				drawDeselected();
			}
		}		
	}
}
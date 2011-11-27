package com.civildebatewall.kiosk.legacyBlocks {
	import com.civildebatewall.*;

	import com.greensock.*;
	import com.greensock.easing.*;
	import com.kitschpatrol.futil.blocks.BlockText;
	import com.kitschpatrol.futil.constants.Alignment;
	import com.kitschpatrol.futil.utilitites.GeomUtil;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.*;
	import flash.text.*;
	
	import flashx.textLayout.formats.TextAlign;
	
	public class BigButton extends ButtonBase	{
		
		public var label:BlockText;
		
		private var buttonWidth:Number;
		private var buttonHeight:Number;
		private var button:Sprite;		
		private var textPanelWidth:Number;
		private var textPanelHeight:Number;
		private var buttonMask:Shape;
		private var topPanel:Sprite;
		private var leftButtonEdge:Bitmap;
		private var leftEdgeMatrix:Matrix;
		private var bottomButtonEdge:Bitmap;
		private var bottomEdgeMatrix:Matrix;		
		private var barberPoleSpeed:Number; // pixels per frame
		public var leftEdgeOffset:Number;
		public var bottomEdgeOffset:Number;		
		
		
		public function BigButton() {
			super();
			init();
		}
		

		private function init():void {
			buttonMode = true;
			buttonWidth = 519;
			buttonHeight = 133;	
			
			// create the bounding box / mask
			buttonMask = new Shape();
			buttonMask.graphics.beginFill(0x000000);
			buttonMask.graphics.drawRect(0, 0, buttonWidth, buttonHeight);
			buttonMask.graphics.endFill();
			
			// create the actual button panel
			button = new Sprite();
			 
			barberPoleSpeed = 0.5 ;
			
			// bottom edge
			bottomEdgeOffset = 0;
			bottomButtonEdge = new Bitmap(new BitmapData(520, 35, true, 0xff0000));
			bottomEdgeMatrix = new Matrix();
			bottomButtonEdge.bitmapData.copyPixels(Assets.bottomButtonTile.bitmapData, Assets.bottomButtonTile.bitmapData.rect, new Point(0, bottomEdgeOffset), Assets.bottomEdgeMask.bitmapData, new Point(0, 0), true);
			bottomButtonEdge.y = 98;
			
			// left edge
			leftEdgeOffset = 3; // a little initial offset so the animation lines up with the bottom
			leftButtonEdge = new Bitmap(new BitmapData(35, 133, true, 0xff0000));			
			leftEdgeMatrix = new Matrix();
			leftButtonEdge.bitmapData.copyPixels(Assets.leftButtonTile.bitmapData, Assets.leftButtonTile.bitmapData.rect, new Point(leftEdgeOffset - Assets.leftEdgeMask.width, 0), Assets.leftEdgeMask.bitmapData, new Point(leftEdgeOffset - Assets.leftEdgeMask.width, 0), true);
			
			// top surface
			topPanel = new Sprite();
			topPanel.addChild(Assets.buttonBackground);
			topPanel.x = 35;
			
			// create the button text format
			label = new BlockText({
				textFont: Assets.FONT_BOLD, 
				textBold: true,
				textSize: 24,
				textAlignmentMode: TextAlign.CENTER,
				textColor: Assets.COLOR_GRAY_85,
				backgroundAlpha: 0,
				width: 484,
				height: 98,
				alignmentPoint: Alignment.CENTER,
				visible: true
			});
			

		

			// add children
			button.addChild(bottomButtonEdge);
			button.addChild(leftButtonEdge);
			button.addChild(topPanel);
			addChild(buttonMask);
			addChild(button);
			topPanel.addChild(label);
			
			button.mask = buttonMask;
			
			enable();
		}
		
		
		// pass through to the label
		override public function setText(s:String, instant:Boolean = false):void {
			label.text = s;
		}
		

		private function onEnterFrame(e:Event):void {
			// barber pole animation			
			leftEdgeOffset = ((leftEdgeOffset + barberPoleSpeed) % 22);
			bottomEdgeOffset = ((bottomEdgeOffset - barberPoleSpeed) % 22);
			
			updateBarberPole();
		}
		
		
		private var andFire:Boolean;
		override protected function onMouseDown(e:MouseEvent):void {
			// No mouse up event listener!
			TweenMax.to(background, 0, {colorTransform: {tint: _backgroundColor, tintAmount: 0.2}});			
			andFire = true;
			disable();
		}
		
		
		private function updateBarberPole():void {
			leftButtonEdge.bitmapData.copyPixels(Assets.leftButtonTile.bitmapData, Assets.leftButtonTile.bitmapData.rect, new Point(leftEdgeOffset - Assets.leftEdgeMask.width, 0), Assets.leftEdgeMask.bitmapData, new Point(leftEdgeOffset - Assets.leftEdgeMask.width, 0), true);			
			bottomButtonEdge.bitmapData.copyPixels(Assets.bottomButtonTile.bitmapData, Assets.bottomButtonTile.bitmapData.rect, new Point(0, bottomEdgeOffset), Assets.bottomEdgeMask.bitmapData, new Point(0, bottomEdgeOffset), true);
		}
		
		// move to parent?
		override public function disable():void {
			super.disable();
			
			// position the stripes
			this.removeEventListener(Event.ENTER_FRAME, onEnterFrame);			
			
			TweenMax.to(this, 0.25, {leftEdgeOffset: 3, bottomEdgeOffset: 0, onUpdate: updateBarberPole});			
			
			if (andFire) {
				// fire the mouse event once the animation is finished
				TweenMax.to(button, 0.25, {x: -24, y: 24, ease:Strong.easeOut, colorMatrixFilter:{saturation: 0}, onComplete: onBigButtonDisabled});
				andFire = false;
			}
			else {
				// just diable the button...
				TweenMax.to(button, 0.25, {x: -24, y: 24, ease:Strong.easeOut, colorMatrixFilter:{saturation: 0}});				
			}
			
									
		}
		

		private function onBigButtonDisabled():void {
			// don't wait for release
			onClick();
		}
		
		
		override public function enable():void {
			super.enable();
			TweenMax.to(button, 0.1, {x: 0, y: 0, ease:Strong.easeOut, colorMatrixFilter:{saturation: 1}});
			this.addEventListener(Event.ENTER_FRAME, onEnterFrame);			
		}

	}
}
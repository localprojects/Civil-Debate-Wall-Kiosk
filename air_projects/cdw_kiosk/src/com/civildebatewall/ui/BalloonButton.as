package com.civildebatewall.ui {
	import com.greensock.TweenMax;
	import com.greensock.easing.*;
	
	import flash.display.*;
	import flash.events.MouseEvent;
	
	import com.civildebatewall.kiosk.Kiosk;
	
	import com.civildebatewall.CivilDebateWall;
	
	public class BalloonButton extends BlockButton {

		private var tail:Shape;
		private var tailOutline:Shape;
		private var tailWidth:Number;
		private var tailHeight:Number;
		private var scaleMode:String;
		private var radius:Number;
		
		
		// block button with a tail
		public function BalloonButton(buttonWidth:Number, buttonHeight:Number, backgroundColor:uint, labelText:String, labelSize:Number, labelColor:uint = 0xffffff, labelFont:String = null)	{
			radius = 30;
			
			tail = new Shape();
			tailOutline = new Shape;
			addChild(tailOutline);
			
			if (CivilDebateWall.settings.halfSize) {
				scaleMode = LineScaleMode.NORMAL; 
			}
			else {
				// don't scale line at full res, keeps things cleaner
				scaleMode = LineScaleMode.NONE;				
			}
			
			super(buttonWidth, buttonHeight, backgroundColor, labelText, labelSize, labelColor, labelFont);			

			addChild(tail);	

			tail.y = buttonHeight - strokeWeight * 2;
			tailOutline.y = buttonHeight - strokeWeight * 2;
			
			tailWidth = 25;
			tailHeight = 22 + strokeWeight;
					
			draw();
		}
		
		override protected function draw():void {
			// draw the background
			background.graphics.clear();
			background.graphics.beginFill(0xffffff);
			background.graphics.drawRoundRect(0, 0, _buttonWidth, _buttonHeight, radius, radius);
			background.graphics.endFill();
			TweenMax.to(background, 0, {ease: Quart.easeOut, colorTransform: {tint: _backgroundColor, tintAmount: 1}});
			
			// y position is already accounted for in constructor
			tail.graphics.clear();
			tail.graphics.beginFill(0xffffff);
			tail.graphics.moveTo((_buttonWidth / 2) - (tailWidth / 2), 0);
			tail.graphics.lineTo((_buttonWidth / 2) + (tailWidth / 2), 0);
			tail.graphics.lineTo((_buttonWidth / 2), tailHeight);
			tail.graphics.endFill();
			TweenMax.to(tail, 0, {ease: Quart.easeOut, colorTransform: {tint: _backgroundColor, tintAmount: 1}});			
			
			// draw the outline
			outline.graphics.clear();
			outline.graphics.lineStyle(strokeWeight, strokeColor, 1, true, scaleMode);
			outline.graphics.drawRoundRect(0, 0, _buttonWidth, _buttonHeight, radius, radius);
			outline.graphics.endFill();
			
			// draw the tail outline
			tailOutline.graphics.clear();
			tailOutline.graphics.lineStyle(strokeWeight * 2, strokeColor, 1, true, scaleMode, CapsStyle.SQUARE, JointStyle.ROUND, 1);
			tailOutline.graphics.moveTo((_buttonWidth / 2) - (tailWidth / 2), 0);
			tailOutline.graphics.lineTo((_buttonWidth / 2) + (tailWidth / 2), 0);
			tailOutline.graphics.lineTo((_buttonWidth / 2), tailHeight);
			tailOutline.graphics.lineTo((_buttonWidth / 2) - (tailWidth / 2), 0);			
			tailOutline.graphics.endFill();			
		}
		
		override public function setBackgroundColor(c:uint, instant:Boolean = false):void {
			_backgroundColor = c;
			TweenMax.to(background, 0.5, {ease: Quart.easeOut, colorTransform: {tint: _backgroundColor, tintAmount: 1}});
			TweenMax.to(tail, 0.5, {ease: Quart.easeOut, colorTransform: {tint: _backgroundColor, tintAmount: 1}});			
		}
		
		
		override public function setStrokeColor(c:uint):void {
			if(strokeColor != c) {
				strokeColor = c;				
				TweenMax.to(outline, 0.5, {ease: Quart.easeOut, colorTransform: {tint: strokeColor, tintAmount: 1}});				
				TweenMax.to(tailOutline, 0.5, {ease: Quart.easeOut, colorTransform: {tint: strokeColor, tintAmount: 1}});			
			}
		}		
		
		override protected function onMouseDown(e:MouseEvent):void {
			super.onMouseDown(e);
			TweenMax.to(tail, 0, {colorTransform: {tint: _backgroundDownColor, tintAmount: 1}});
		}
		
		override protected function onMouseUp(e:MouseEvent):void {
			super.onMouseUp(e);			
			TweenMax.to(tail, 0.3, {ease: Quart.easeOut, colorTransform: {tint: _backgroundColor, tintAmount: 1}});
		}				
		
	}
}
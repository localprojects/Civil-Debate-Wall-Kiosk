package net.localprojects.ui {
	import com.greensock.TweenMax;
	import com.greensock.easing.*;
	
	import flash.display.Shape;
	import flash.events.MouseEvent;
	
	
	
	public class BalloonButton extends BlockButton {
	
		
		private var tail:Shape;
		private var tailOutline:Shape;
		private var tailWidth:Number;
		private var tailHeight:Number;
		
		
		// block button with a tail
		public function BalloonButton(buttonWidth:Number, buttonHeight:Number, labelText:String, labelSize:Number, backgroundColor:uint, arrow:Boolean, bold:Boolean=false)	{
			
						
			tail = new Shape();
			tailOutline = new Shape;


			addChild(tailOutline);
			
			super(buttonWidth, buttonHeight, labelText, labelSize, backgroundColor, arrow, bold);
			
			addChild(tail);	

			tail.y = buttonHeight - strokeWeight;
			tailOutline.y = buttonHeight - strokeWeight;
			
			
			tailWidth = 30;
			tailHeight = 30 + strokeWeight;
			
			
			draw();
		}
		
		override protected function draw():void {
			
			// draw the background
			background.graphics.clear();
			background.graphics.beginFill(0xffffff);
			background.graphics.drawRoundRect(0, 0, _buttonWidth, _buttonHeight, 20, 20);
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
			outline.graphics.lineStyle(strokeWeight, 0xffffff);
			outline.graphics.drawRoundRect(0, 0, _buttonWidth, _buttonHeight, 20, 20);
			outline.graphics.endFill();
			
			// draw the tail outline
			tailOutline.graphics.clear();
			tailOutline.graphics.lineStyle(strokeWeight * 2, 0xffffff);
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
		
		override protected function onMouseDown(e:MouseEvent):void {
			super.onMouseDown(e);
			TweenMax.to(tail, 0, {colorTransform: {tint: _backgroundColor, tintAmount: 0.2}});
		}
		
		override protected function onMouseUp(e:MouseEvent):void {
			super.onMouseUp(e);			
			TweenMax.to(tail, 0.3, {ease: Quart.easeOut, colorTransform: {tint: _backgroundColor, tintAmount: 1}});
		}				
		
	}
}
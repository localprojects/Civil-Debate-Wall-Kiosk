package net.localprojects.ui {
	import com.greensock.TweenMax;
	import com.greensock.easing.*;
	
	import flash.display.Bitmap;
	import flash.display.DisplayObject;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.text.*;
	import flash.utils.Timer;
	import flash.utils.getTimer;
	
	import net.localprojects.Assets;
	import net.localprojects.Utilities;
	
	public class Countdown extends ButtonBase {
		
		// time keeping
		private var duration:Number;		
		private var progress:Number; // normalized
		private var timer:Timer;
		private var startTime:int;
		
		// text
		private var countTextWrapper:Sprite;
		private var countText:TextField;
		
		// graphics
		private var progressRing:Shape;
		private var ringColor:uint;
		private var backgroundColor:uint;
		private var icon:Bitmap;
		
		// events
		public var onCountdownFinish:Function;	
		
		// constructor
		public function Countdown(timerDuration:Number) {
			duration = timerDuration;
			super();
			init();
		}

		private function init():void {
			// set up timer
			timer = new Timer(1000, duration);
			timer.addEventListener(TimerEvent.TIMER, onTimerSecond);
			timer.addEventListener(TimerEvent.TIMER_COMPLETE, onTimerComplete);
			
			// inner circle background		
			addChild(background);
			backgroundColor = Assets.COLOR_YES_MEDIUM;
			drawBackground();
			
			// set up the progress ring
			progress = 0;
			progressRing = new Shape();
			addChild(progressRing);
			ringColor = Assets.COLOR_YES_LIGHT;
			drawRing();
			
			// set up the wrapper, allows rotation around center
			countTextWrapper = new Sprite();
			countTextWrapper.x = width / 2;
			countTextWrapper.y = height / 2;
//			countTextWrapper.alpha = 0;
//			countTextWrapper.scaleX = 0;
//			countTextWrapper.scaleY = 0;			
			
			// set up the text
			var textFormat:TextFormat = new TextFormat();
			textFormat.bold = false;
			textFormat.font =  Assets.FONT_REGULAR;
			textFormat.align = TextFormatAlign.CENTER;
			textFormat.size = 76;
			
			countText = new TextField();
			countText.defaultTextFormat = textFormat;
			countText.embedFonts = true;
			countText.selectable = false;
			countText.multiline = false;
			countText.cacheAsBitmap = false;
			countText.mouseEnabled = false;			
			countText.gridFitType = GridFitType.NONE;
			countText.antiAliasType = AntiAliasType.NORMAL;
			countText.textColor = 0xffffff;
			countText.width = width / 2;
			countText.wordWrap = false;
			countText.text = duration.toString();
			countText.x = -width / 4;
			countText.y = -42;
			countText.visible = false;
			
			countTextWrapper.addChild(countText);
			
			// set up the icon
			icon = Assets.getCameraIcon();
			icon.x = -icon.width / 2;
			icon.y = (-icon.height / 2) - 3;			
			
			countTextWrapper.addChild(icon);
				
			addChild(countTextWrapper);
		}		
				
		// run the timer
		public function start():void {
			timer.reset();
			timer.start();
			
			startTime = getTimer();
			countText.text = duration.toString();
			
			TweenMax.to(countTextWrapper, 0.2, {ease: Quart.easeInOut, alpha: 0, rotation:getRotationChange(countTextWrapper, 180, true), scaleX: 0, scaleY: 0, onComplete: onSecondTweenComplete});			
			this.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}		
		
		// every second
		private function onTimerSecond(e:TimerEvent):void {
			// shrink and fade the counter text, then call the rest of the animation in onSecondTweenComplete
			TweenMax.to(countTextWrapper, 0.2, {ease: Quart.easeInOut, alpha: 0, rotation:getRotationChange(countTextWrapper, 180, true), scaleX: 0, scaleY: 0, onComplete: onSecondTweenComplete});			
		}
		
		private function onSecondTweenComplete():void {
			// update the count, then bring back the text
			icon.visible = false;
			countText.visible = true;
			countText.text = (duration - timer.currentCount).toString();
			TweenMax.to(countTextWrapper, 0.2, {ease: Quart.easeInOut, alpha: 1, rotation:getRotationChange(countTextWrapper, 0, true), scaleX: 1, scaleY: 1});			
		}
		
		private function onTimerComplete(e:TimerEvent):void {
			// timer's complete, forward the event
			this.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			
			TweenMax.to(countTextWrapper, 0.2, {ease: Quart.easeInOut, alpha: 0, rotation: 360, scaleX: 0, scaleY: 0, onComplete: onFinalTweenComplete});
			this.dispatchEvent(e);
			
			// call the function
			onCountdownFinish(e);
		}		
		
		private function onFinalTweenComplete():void {
			icon.visible = true;
			countText.visible = false;
			TweenMax.to(countTextWrapper, 0.2, {ease: Quart.easeInOut, alpha: 1, rotation:getRotationChange(countTextWrapper, 0, true), scaleX: 1, scaleY: 1});
			
			progress = 0;
			drawRing();			
		}
		
		// trace progress along the outer circle
		private function onEnterFrame(e:Event):void {
			progress = (getTimer() - startTime) / (duration * 1000);
			drawRing();
		}
		
		// helper for directional rotation via http://forums.greensock.com/viewtopic.php?f=1&t=3176
		private function getRotationChange(mc:DisplayObject, newRotation:Number, clockwise:Boolean):String {
			var dif:Number = newRotation - mc.rotation;
			if (Boolean(dif > 0) != clockwise) {
				dif += (clockwise) ? 360 : -360;
			}
			return String(dif);
		}			
		
		// drawing
		private function drawBackground():void {
			background.graphics.clear();
			background.graphics.beginFill(backgroundColor);
			background.graphics.drawCircle(0, 0, 58);
			background.graphics.endFill();
			background.x = 58 + 12;
			background.y = 58 + 12;
		}
		
		private function drawRing():void {
			var highlightDegrees:Number = progress * 360;
			var radius:Number = 70;
			var lineWeight:Number = 6;
			
			progressRing.graphics.clear();
			progressRing.graphics.lineStyle(lineWeight, 0xffffff);
			
			progressRing.graphics.moveTo(0, -radius);
			// TODO optimize by not clearing buffer? or taking bigger steps?
			for (var i:int = 0; i < 360; i++)	{
				var rad:Number = (i - 90) * Math.PI / 180;
				if (i > highlightDegrees) progressRing.graphics.lineStyle(lineWeight, Assets.COLOR_YES_LIGHT);
				progressRing.graphics.lineTo(Math.cos(rad) * radius, Math.sin(rad) * radius);
			}
			
			progressRing.x = radius;
			progressRing.y = radius;
		}		
		
		// mutations
		public function setBackgroundColor(c:uint):void {
			backgroundColor = c;
			drawBackground();
		}		
		
		public function setRingColor(c:uint):void {
			ringColor = c;
			drawRing();
		}
		
		// extra events		
		public function setOnFinish(f:Function):void {
			onCountdownFinish = f;			
		}		
		
		
		
		
		
	}
}
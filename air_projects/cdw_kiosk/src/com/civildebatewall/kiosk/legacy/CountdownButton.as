package com.civildebatewall.kiosk.legacy {

	import com.civildebatewall.Assets;
	import com.civildebatewall.CivilDebateWall;
	import com.civildebatewall.State;
	import com.greensock.TweenMax;
	import com.greensock.easing.Quart;
	import com.kitschpatrol.futil.blocks.BlockText;
	import com.kitschpatrol.futil.constants.Alignment;
	import com.kitschpatrol.futil.utilitites.GeomUtil;
	
	import flash.display.Bitmap;
	import flash.display.CapsStyle;
	import flash.display.DisplayObject;
	import flash.display.LineScaleMode;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.utils.Timer;
	import flash.utils.getTimer;

	public class CountdownButton extends ButtonBase {
		
		// time keeping
		private var duration:Number;		
		private var progress:Number; // normalized
		private var countdownTimer:Timer;
		private var startTime:int;
				
		// graphics
		public var progressRing:Shape;
		private var progressColor:uint;
		private var ringColor:uint;
		private var arrow:Bitmap;
		
		// events
		public var onCountdownFinish:Function;	
		private var onAlmostFinish:Function;
		
		private var innerCircleRadius:Number;
		private var outerRingRadius:Number;
		
		// text
		private var countLabel:BlockText;
		
		// constructor
		public function CountdownButton(timerDuration:Number) {
			duration = timerDuration;
			super();
			init();
		}
		
		public function isCountingDown():Boolean {
			return countdownTimer.running;
		}

		private function init():void {
			//dimensions
			innerCircleRadius = 47;
			outerRingRadius = 56;
			
			// set up timer
			countdownTimer = new Timer(1000, duration);
			countdownTimer.addEventListener(TimerEvent.TIMER, onTimerSecond);
			countdownTimer.addEventListener(TimerEvent.TIMER_COMPLETE, onTimerComplete);
			
			// inner circle background		
			addChild(background);
			_backgroundColor = Assets.COLOR_YES_MEDIUM;
			drawBackground();
			
			// set up the progress ring
			progress = 0;
			progressRing = new Shape();
			addChild(progressRing);
			ringColor = 0xffffff;
			drawRing();
			
			countLabel = new BlockText({
				text: "5",
				textFont: Assets.FONT_BOLD,
				textSize: 41,
				textColor: 0xffffff,
				alignmentPoint: Alignment.CENTER,
				textAlignmentMode: Alignment.TEXT_CENTER,
				registrationPoint: Alignment.CENTER,
				visible: true,
				width: outerRingRadius * 2,
				height: outerRingRadius * 2,
				backgroundAlpha: 0
			});
			countLabel.x = outerRingRadius - 2;
			countLabel.y = outerRingRadius - 2;
			addChild(countLabel);
						

			arrow = Assets.getCameraArrowSmall();
			addChild(arrow);
			resetArrow();
			
			CivilDebateWall.state.addEventListener(State.USER_STANCE_CHANGE, onUserStanceChange);
		}
		
		private function resetArrow():void {
			TweenMax.killTweensOf(arrow);			
			arrow.alpha = 0;
			GeomUtil.centerWithin(arrow, this);
			arrow.y += 5;
		}
		
		override protected function beforeTweenIn():void {
			super.beforeTweenIn();
			resetArrow();
			countLabel.text = duration.toString();			
		}
				
		// run the timer
		public function start():void {
			countdownTimer.reset();
			countdownTimer.start();
			
			startTime = getTimer();
			countLabel.text = duration.toString();
			
			// reset the arrow
			resetArrow();

			
			TweenMax.to(countLabel, 0.2, {ease: Quart.easeInOut, alpha: 0, rotation:getRotationChange(countLabel, 180, true), scaleX: 0, scaleY: 0, onComplete: onSecondTweenComplete});			
			this.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}		
		
		// every second
		private function onTimerSecond(e:TimerEvent):void {
			// shrink and fade the counter text, then call the rest of the animation in onSecondTweenComplete
			TweenMax.to(countLabel, 0.2, {ease: Quart.easeInOut, alpha: 0, rotation:getRotationChange(countLabel, 180, true), scaleX: 0, scaleY: 0, onComplete: onSecondTweenComplete});
		}
		
		private function onSecondTweenComplete():void {
			// update the count, then bring back the text
			countLabel.visible = true;
			countLabel.text = (duration - (countdownTimer.currentCount + 2)).toString();
			
			if (countdownTimer.currentCount < 4) {
				//onAlmostFinish();
				// spin up a new number
				TweenMax.to(countLabel, 0.2, {ease: Quart.easeInOut, alpha: 1, rotation:getRotationChange(countLabel, 0, true), scaleX: 1, scaleY: 1});	
			}
			else if (countdownTimer.currentCount == 4) {
				// stop spinning numbers, show the icon
				TweenMax.to(countLabel, 0.2, {ease: Quart.easeInOut, alpha: 0, rotation:getRotationChange(countLabel, 0, true), scaleX: 0, scaleY: 0});
				TweenMax.to(arrow, 0.2, {alpha: 1});
				TweenMax.to(arrow, 0.25, {y: "-20", yoyo: true, repeat: -1});				
			}
		}
		
		private function onTimerComplete(e:TimerEvent):void {
			// timer's complete, forward the event
			this.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			
			TweenMax.to(countLabel, 0.2, {ease: Quart.easeInOut, alpha: 0, rotation: 360, scaleX: 0, scaleY: 0, onComplete: onFinalTweenComplete});
			this.dispatchEvent(e);
			
			// call the function
			onCountdownFinish(e);
		}
		
		private function onFinalTweenComplete():void {
			
			countLabel.visible = false;
			TweenMax.to(countLabel, 0.2, {ease: Quart.easeInOut, alpha: 1, rotation:getRotationChange(countLabel, 0, true), scaleX: 1, scaleY: 1});
			
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
			background.graphics.beginFill(0xffffff);
			background.graphics.drawCircle(0, 0, innerCircleRadius);
			background.graphics.endFill();
			background.x = innerCircleRadius + (outerRingRadius - innerCircleRadius);
			background.y = innerCircleRadius + (outerRingRadius - innerCircleRadius);
		}
		
		private function drawRing():void {
			var highlightDegrees:Number = progress * 360;
			var radius:Number = outerRingRadius;;
			var lineWeight:Number = 6;
			
			progressRing.graphics.clear();
			progressRing.graphics.lineStyle(lineWeight, progressColor, 1, false, LineScaleMode.NORMAL, CapsStyle.SQUARE);
			
			progressRing.graphics.moveTo(0, -radius);
			// TODO optimize by not clearing buffer? or taking bigger steps?
			for (var i:int = 0; i < 360; i++)	{
				var rad:Number = (i - 90) * Math.PI / 180;
				
				if (i > highlightDegrees) progressRing.graphics.lineStyle(lineWeight, ringColor, 0, false, LineScaleMode.NORMAL, CapsStyle.SQUARE);
				progressRing.graphics.lineTo(Math.cos(rad) * radius, Math.sin(rad) * radius);
			}
			
			progressRing.x = radius;
			progressRing.y = radius;
		}		
		
		// mutations
		override public function setBackgroundColor(c:uint, instant:Boolean = false):void {
			_backgroundColor = c;
			
			var duration:Number = instant ? 0 : 1; 
			TweenMax.to(background, duration, {ease: Quart.easeInOut, colorTransform: {tint: _backgroundColor, tintAmount: 1}});			
		}		
		
		public function setRingColor(c:uint):void {
			ringColor = c;
			drawRing();
		}
		
		public function setProgressColor(c:uint):void {
			progressColor = c;
			drawRing();
		}		
		
		// extra events		
		public function setOnFinish(f:Function):void {
			onCountdownFinish = f;			
		}
		
		// extra events		
		public function setOnAlmostFinish(f:Function):void {
			onAlmostFinish = f;			
		}
		
		private function onUserStanceChange(e:Event):void {
			setBackgroundColor(CivilDebateWall.state.userStanceColorLight, true);	
			setRingColor(CivilDebateWall.state.userStanceColorLight);
			setProgressColor(0xffffff);			
		}
		
	}
}
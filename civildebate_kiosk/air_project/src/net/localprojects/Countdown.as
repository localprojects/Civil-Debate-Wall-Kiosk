package net.localprojects {
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.TimerEvent;
	import flash.text.engine.FontWeight;
	import flash.utils.Timer;
	
	import flashx.textLayout.formats.TextAlign;
	
	public class Countdown extends Sprite	{

		private var countdownTimer:Timer;
		private var countdownValue:int = 3;
		private var countdownText:FixedLabel;
		
		public static const COUNTER_FINISHED:String = "counterFinished";		

		public function Countdown()	{
			super();

			// set up countdown
			countdownTimer = new Timer(1000, 3);
			
			new Event ("projectIsFeatured", true, true)
			
			
			countdownTimer.addEventListener(TimerEvent.TIMER, countdownStep);
			countdownTimer.addEventListener(TimerEvent.TIMER_COMPLETE, countdownFinished);			
			countdownTimer.stop();
			countdownTimer.reset();
			
			// countdown display
			var format:TextBoxLayoutFormat = new TextBoxLayoutFormat();
			format.boundingWidth = 100;
			format.boundingHeight = 40;
			format.fontFamily = "Helvetica";
			format.fontSize = 40;
			format.color = 0xff0000;
			format.fontWeight = FontWeight.BOLD;
			format.textAlign = TextAlign.CENTER;
			format.showSpriteBackground = false;
			
			countdownText = new FixedLabel("3", format);
			countdownText.x = -50;
			countdownText.y = -20;
		}

		public function start():void {
			// start countdown
			countdownValue = 3;
			countdownText.setText(countdownValue.toString());
			
			countdownTimer.reset();
			countdownTimer.start();
			addChild(countdownText);
		}

		// todo move the timer into a class
		private function countdownStep(e:TimerEvent):void {
			trace("step");
			countdownValue--;
			countdownText.setText(countdownValue.toString());			
		}
		
		private function countdownFinished(e:TimerEvent):void {
			trace("finished");
			// pass through the countdown
			dispatchEvent(new Event(COUNTER_FINISHED));;
			
			this.removeChild(countdownText);
		}
	
	}
}
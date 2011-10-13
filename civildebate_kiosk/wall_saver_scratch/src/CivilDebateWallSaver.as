package {

	
	import com.bit101.components.FPSMeter;
	import com.bit101.components.Label;
	import com.bit101.components.PushButton;
	import com.bit101.components.Slider;
	import com.civildebatewall.wallsaver.sequences.*;
	import com.greensock.*;
	import com.greensock.easing.*;
	import com.greensock.plugins.*;
	import com.kitschpatrol.futil.Utilities;
	
	import flash.display.Bitmap;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	
	//TweenPlugin.activate([]);	
	
	[SWF(width="5720", height="1920", frameRate="60")]	
	public class CivilDebateWallSaver extends Sprite {
		
		private var canvas:Sprite;
		
		// These will come in from FlashSpan
		public static const screenWidth:int = 1080;
		public static const screenHeight:int = 1920;
		public static const screenCount:int = 5;
		public static const bezelPixelWidth:int = 40;
		public static const totalWidth:int = (screenWidth * screenCount) + (bezelPixelWidth * 2 * (screenCount - 1));
		public static const totalHeight:int = screenHeight;
		public static var screens:Vector.<Rectangle> = new Vector.<Rectangle>(screenCount);
		public static var bezels:Vector.<Rectangle> = new Vector.<Rectangle>;
		
		
		// Timeline
		private var timeline:TimelineMax;		
		
		// GUI
		private var timeSlider:Slider;
		private var frameCountLabel:Label;
		private var fpsMeter:FPSMeter;
		
		
		// Debug
		private const stageScaleFactor:Number = 4;		
		
		// Sample Content
		private var interactiveScreen1:Bitmap = Assets.getSampleKiosk1();
		private var interactiveScreen2:Bitmap = Assets.getSampleKiosk2();	
		private var interactiveScreen3:Bitmap = Assets.getSampleKiosk1();
		private var interactiveScreen4:Bitmap = Assets.getSampleKiosk2();
		private var interactiveScreen5:Bitmap = Assets.getSampleKiosk1();
		

		public function CivilDebateWallSaver() {
			
			// Start the MonsterDebugger
//			MonsterDebugger.initialize(this);
//			MonsterDebugger.trace(this, "Hello World!");
			
			// resize the window for development
			stage.scaleMode = StageScaleMode.EXACT_FIT;
			stage.align = StageAlign.TOP_LEFT;
			stage.nativeWindow.width = totalWidth / stageScaleFactor;
			stage.nativeWindow.height = (totalHeight / stageScaleFactor) + 20;
			
			// syncing is controlled with a tweenMax timeline
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		
				
		
		private function onAddedToStage(e:Event):void {
			
			// screen offsets, this comes in from FlashSpan
			for (var i:int = 0; i < screenCount; i++) {
				screens[i] = new Rectangle((i * screenWidth) + (i * 2 * bezelPixelWidth), 0, screenWidth, screenHeight);			
			}
			
			// bezels
			for (var j:int = 0; j < screens.length; j++) {
				var screen:Rectangle = screens[j];
				
				if (j > 0) {
					// left bezel
					bezels.push(new Rectangle(screen.x - bezelPixelWidth, 0, bezelPixelWidth, screenHeight));
				}
				
				if (j < (screens.length - 1)) {
					// right bezel
					bezels.push(new Rectangle(screen.x + screen.width, 0, bezelPixelWidth, screenHeight));
				}
			}			
			
			// Add static screens
			for (var k:int = 0; k < screenCount; k++) {			
				this['interactiveScreen' + (k + 1)].x = screens[k].x;
				this['interactiveScreen' + (k + 1)].y = screens[k].y;			
				addChild(this['interactiveScreen' + (k + 1)]);
			}
			
			// The wallsaver canvas
			canvas = new Sprite();
			addChild(canvas);
			
			// Draw the bezels (Debug)
			for each (var bezel:Rectangle in bezels) {
				var shape:Shape = new Shape();
				shape.graphics.beginFill(0x000000);
				shape.graphics.drawRect(0, 0, bezel.width, bezel.height);
				shape.graphics.endFill();
				shape.x = bezel.x;
				shape.y = bezel.y;
				addChild(shape);
			}

			// Timeline controls (debug)
			var dashboard:Sprite = new Sprite();
			timeSlider = new Slider("horizontal", dashboard, 5, 5, onTimeSlider);
			timeSlider.width = 300;
			timeSlider.minimum = 0;
			timeSlider.value = 0;
			
			fpsMeter =  new FPSMeter();
			fpsMeter.start();
			
			frameCountLabel = new Label(dashboard, 5, 15, "Frame: 0 / 0");
			
			var buttonPos:int = 5;
			
			new PushButton(dashboard, buttonPos, 30, "Play", onPlayButton);
			new PushButton(dashboard, buttonPos += 105, 30, "Pause", onPauseButton);
			new PushButton(dashboard, buttonPos += 105, 30, "Sequence A", function():void {playSequenceA();});
			new PushButton(dashboard, buttonPos += 105, 30, "Sequence B", function():void {playSequenceB();});
			new PushButton(dashboard, buttonPos += 105, 30, "Sequence C", function():void {playSequenceC();});
			
			
			
			addChild(dashboard);
			dashboard.scaleX = stageScaleFactor;
			dashboard.scaleY = stageScaleFactor;
			//buildTimeline();
		}
		
		
		// TODO put this into a big conditional?
		private function preAnimationTasks():void {
			if ((timeline != null) && timeline.active) timeline.stop();
			
			// Clean up
			Utilities.removeChildren(canvas);
			
			// Create timeline
			timeline = new TimelineMax({useFrames: true, onUpdate: onTimelineUpdate});			
		}
		
		private function postAnimationTasks():void {
			// make sure all of the froms are in position
			timeline.goto(timeline.totalDuration); 
			timeline.goto(0);			
			timeline.stop();
			
			// reconfigure gui
			timeSlider.value = 0;
			timeSlider.maximum = timeline.totalDuration;			
		}
		
		
		private function playSequenceA():void {
			preAnimationTasks();
			
			// Create display objects
			var buttonSequence:ButtonSequence = new ButtonSequence();
			canvas.addChild(buttonSequence);
			
			var titleSequence:TitleSequence = new TitleSequence();
			canvas.addChild(titleSequence);
			
			var questionSequence:QuestionSequence = new QuestionSequence();
			canvas.addChild(questionSequence);
			
			var opinionSequence:OpinionSequence = new OpinionSequence();
			canvas.addChild(opinionSequence);
			
			var callToActionSequence:CallToActionSequence = new CallToActionSequence();			
			canvas.addChild(callToActionSequence);
			
			// Assemble the timeline
			timeline.appendMultiple([
				buttonSequence.getTimelineIn(),
				titleSequence.getTimeline(),
				questionSequence.getTimeline(),
				opinionSequence.getTimeline(),
				callToActionSequence.getTimeline(),
				buttonSequence.getTimelineOut()				
			], 0, TweenAlign.SEQUENCE);
			
			postAnimationTasks();
		}
		
		private function playSequenceB():void {		
			preAnimationTasks();
			
			// Create display objects
			var buttonSequence:ButtonSequence = new ButtonSequence();
			canvas.addChild(buttonSequence);
			
			var questionSequence:QuestionSequence = new QuestionSequence();
			canvas.addChild(questionSequence);
			
			var barGraphSequence:BarGraphSequence = new BarGraphSequence();
			canvas.addChild(barGraphSequence);
			
			var callToActionSequence:CallToActionSequence = new CallToActionSequence();			
			canvas.addChild(callToActionSequence);
			
			// Assemble the timeline
			timeline.appendMultiple([
				buttonSequence.getTimelineIn(),
				questionSequence.getTimeline(),
				barGraphSequence.getTimeline(),
				callToActionSequence.getTimeline(),
				buttonSequence.getTimelineOut()				
			], 0, TweenAlign.SEQUENCE);
			
			postAnimationTasks();
		}
		
		private function playSequenceC():void {
			preAnimationTasks();
			
			// Create display objects
			var buttonSequence:ButtonSequence = new ButtonSequence();
			canvas.addChild(buttonSequence);
			
			var questionSequence:QuestionSequence = new QuestionSequence();
			canvas.addChild(questionSequence);
			
			var faceGridSequence:FaceGridSequence = new FaceGridSequence();
			canvas.addChild(faceGridSequence);
			
			var callToActionSequence:CallToActionSequence = new CallToActionSequence();
			canvas.addChild(callToActionSequence);
			
			var titleSequence:TitleSequence = new TitleSequence();
			canvas.addChild(titleSequence);
			
			// Assemble the timeline
			timeline.appendMultiple([
				buttonSequence.getTimelineIn(),
				questionSequence.getTimeline(),
				faceGridSequence.getTimeline(),
				callToActionSequence.getTimeline(),	
				titleSequence.getTimeline(),
				buttonSequence.getTimelineOut()				
			], 0, TweenAlign.SEQUENCE);
			
			postAnimationTasks();			
		}
		

		
		
		private function onTimeSlider(e:Event):void {
			if (timeline != null)	timeline.currentTime = Math.min(timeline.duration, Math.round(timeSlider.value)); 
			
		}
		
		private function onPlayButton(e:Event):void {
			if (timeline != null)	timeline.play();
		}
		
		private function onPauseButton(e:Event):void {
			if (timeline != null)	timeline.pause();
		}
				
		
		private function onTimelineUpdate():void {
			frameCountLabel.text = "Frame: " + timeline.currentTime + " / " + 	timeline.totalDuration + "\tFPS: " + fpsMeter.fps;
			
			if (timeline.active) {
				timeSlider.value = timeline.currentTime;
			}			
		}
		
		// TODO put this into FlashSpan, returns screen index, or -1 if it's in the gutter or off the screen
		public static function pointIsOnScreen(p:Point):int {
			for (var i:int = 0; i < screens.length; i++) {
				if (screens[i].containsPoint(p)) return i;
			}
			return -1;
		}
		
		// TODO put this in flashspan, too
		public static function pointIsNearScreen(p:Point):int {
			var onScreen:int = pointIsOnScreen(p);
			
			if (onScreen > -1) {
				return onScreen;
			}
			else {
				var minDistance:Number = Number.MAX_VALUE;
				var minDistanceIndex:int = -1;
				
				for (var i:int = 0; i < screens.length; i++) {
					var screenCenter:Point = new Point(screens[i].x + (screens[i].width / 2), screens[i].y + (screens[i].height / 2));
					var distance:Number = Point.distance(p, screenCenter);
					
					if (distance < minDistance) {
						minDistance = distance;
						minDistanceIndex = i;
					}
				}
				
				return minDistanceIndex;
			}
			
			// should never get here
			return -1;
		}		
		
		
		
	}
}
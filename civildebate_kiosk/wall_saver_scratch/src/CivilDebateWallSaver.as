package {

	import com.bit101.components.FPSMeter;
	import com.bit101.components.Label;
	import com.bit101.components.PushButton;
	import com.bit101.components.Slider;
	import com.greensock.*;
	import com.greensock.BlitMask;
	import com.greensock.TimelineMax;
	import com.greensock.TweenMax;
	import com.greensock.easing.*;
	
	import flash.display.Bitmap;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.geom.Rectangle;
	
	import org.osmf.events.TimeEvent;
	
	
	[SWF(width="5720", height="1920", frameRate="60")]	
	public class CivilDebateWallSaver extends Sprite {
		
		private var canvas:Sprite;
		
		private const screenWidth:int = 1080;
		private const screenHeight:int = 1920;
		private const screenCount:int = 5;
		private const bezelPixelWidth:int = 40;
		private const stageScaleFactor:Number = 4;
		private const totalWidth:int = (screenWidth * screenCount) + (bezelPixelWidth * 2 * (screenCount - 1));
		private const totalHeight:int = screenHeight;
		
		private var timeline:TimelineMax;
		
		// GUI
		private var timeSlider:Slider;
		private var frameCountLabel:Label;
		private var fpsMeter:FPSMeter;
		
		
		// Content		
		private var screens:Vector.<Rectangle> = new Vector.<Rectangle>(screenCount);
		private var bezels:Vector.<Rectangle> = new Vector.<Rectangle>;		

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
			//stage.align = StageAlign.TOP_LEFT;
			stage.nativeWindow.width = totalWidth / stageScaleFactor;
			stage.nativeWindow.height = (totalHeight / stageScaleFactor) + 20;
			
			// syncing is controlled with a tweenMax timeline
			
			//questionScroller();
			trace(totalWidth);
			
			
			
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}
		
		

		
		private function onAddedToStage(e:Event):void {
			// screen offsets
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
			
			for (var k:int = 0; k < screenCount; k++) {			
				this['interactiveScreen' + (k + 1)].x = screens[k].x;
				this['interactiveScreen' + (k + 1)].y = screens[k].y;			
				addChild(this['interactiveScreen' + (k + 1)]);
				
				// and the button
			}
			
			
			canvas = new Sprite();
			canvas.graphics.beginFill(0xffffff);
			canvas.graphics.drawRect(0, 0, totalWidth, totalHeight);
			canvas.graphics.endFill();
			addChild(canvas);
			
			for each (var bezel:Rectangle in bezels) {
				var shape:Shape = new Shape();
				shape.graphics.beginFill(0x000000);
				shape.graphics.drawRect(0, 0, bezel.width, bezel.height);
				shape.graphics.endFill();
				shape.x = bezel.x;
				shape.y = bezel.y;
				addChild(shape);
			}

			

			var dashboard:Sprite = new Sprite();
			timeSlider = new Slider("horizontal", dashboard, 5, 5, onTimeSlider);
			timeSlider.width = 300;
			timeSlider.minimum = 0;
			timeSlider.value = 0;
			
			fpsMeter =  new FPSMeter();
			fpsMeter.start();
			
			frameCountLabel = new Label(dashboard, 5, 15, "Frame: 0 / 0");
			
			new PushButton(dashboard, 5, 30, "Play", onPlayButton);
			new PushButton(dashboard, 110, 30, "Pause", onPauseButton);	
			
			
			addChild(dashboard);
			dashboard.scaleX = stageScaleFactor;
			dashboard.scaleY = stageScaleFactor;
				
			buildTimeline();
			
		}
		

		
		private function onTimeSlider(e:Event):void {	
			timeline.currentTime = Math.round(timeSlider.value); 
		}
		
		private function onPlayButton(e:Event):void {
			timeline.play();
		}
		
		private function onPauseButton(e:Event):void {
			timeline.pause();
		}
		
		
		private function generateScreenMask(screenNumber:int):Sprite {
			var maskSprite:Sprite = new Sprite();
			
			maskSprite.graphics.beginFill(0x000000);
			maskSprite.graphics.drawRect(0, 0, screens[screenNumber].width, screens[screenNumber].height);
			maskSprite.graphics.endFill();
			
			maskSprite.x = screens[screenNumber].x;
			maskSprite.y = screens[screenNumber].y;
			
			return maskSprite;
		}
		
		
		private function buildTimeline():void {
			

			// takes latest data, builds the timeline, TODO auto kill children for performance?
			timeline = new TimelineMax({useFrames: true, onUpdate: onTimelineUpdate});			
			
			//timeline.append(TweenMax.to(
			
			
			// clear the canvas
			// TODO
			
			// add assets to stage
			
			// title
			var title:Bitmap = Assets.getTitle();
			canvas.addChild(title);
			
			
			// add the join debate buttons
			var button1:Bitmap = Assets.getJoinDebateButton();
			var button2:Bitmap = Assets.getJoinDebateButton();
			var button3:Bitmap = Assets.getJoinDebateButton();
			var button4:Bitmap = Assets.getJoinDebateButton();
			var button5:Bitmap = Assets.getJoinDebateButton();
			
			canvas.addChild(button1);
			canvas.addChild(button2);
			canvas.addChild(button3);
			canvas.addChild(button4);
			canvas.addChild(button5);
			
			// build the question, text pending
			var questionHead:Bitmap = Assets.getQuestionArrowHead();
			var questionTail:Bitmap = Assets.getQuestionArrowTail();
			
			var question:Sprite = new Sprite();
			question.addChild(questionHead);
			
			question.graphics.beginFill(0x322f31);
			question.graphics.drawRect(questionHead.width, 0, 5000, questionHead.height);
			question.graphics.endFill();
			
			questionTail.x = question.width;
			question.addChild(questionTail);
			
			canvas.addChild(question);
			
			// build the banners and their masks (TODO use blit thing?)
			var joinBanner1:MessageBanner = new MessageBanner(Assets.getJoinTheDebateText(), MessageBanner.BLUE);
			var screen1Mask:Sprite = generateScreenMask(0);
			canvas.addChild(joinBanner1);
			canvas.addChild(screen1Mask);
			joinBanner1.mask = screen1Mask;
			
			var touchBanner1:MessageBanner = new MessageBanner(Assets.getTouchToBeginText(), MessageBanner.ORANGE);
			var screen2Mask:Sprite = generateScreenMask(1);
			canvas.addChild(touchBanner1);
			canvas.addChild(screen2Mask);
			touchBanner1.mask = screen2Mask;
			
			var joinBanner2:MessageBanner = new MessageBanner(Assets.getJoinTheDebateText(), MessageBanner.ORANGE);
			var screen3Mask:Sprite = generateScreenMask(2);
			canvas.addChild(joinBanner2);
			canvas.addChild(screen3Mask);
			joinBanner2.mask = screen3Mask;
			
			var touchBanner2:MessageBanner = new MessageBanner(Assets.getTouchToBeginText(), MessageBanner.BLUE);			
			var screen4Mask:Sprite = generateScreenMask(3);
			canvas.addChild(touchBanner2);
			canvas.addChild(screen4Mask);
			touchBanner2.mask = screen4Mask;			
			
			var joinBanner3:MessageBanner = new MessageBanner(Assets.getJoinTheDebateText(), MessageBanner.BLUE);
			var screen5Mask:Sprite = generateScreenMask(4);
			canvas.addChild(joinBanner3);
			canvas.addChild(screen5Mask);
			joinBanner3.mask = screen5Mask;			
			
			
			
			
			
			
			
			// build the timeline
			
			// tween in the canvas overlay
			timeline.append(TweenMax.fromTo(canvas, 60, {alpha: 0}, {alpha: 1}));
			
			// bring the buttons up
			var buttonXOffset:int = 567;
			var buttonYOffset:int = 1826;
			
			timeline.appendMultiple([TweenMax.fromTo(button1, 100, {x: screens[0].x + buttonXOffset, y: totalHeight}, {y: buttonYOffset}),
															 TweenMax.fromTo(button2, 100, {x: screens[1].x + buttonXOffset, y: totalHeight}, {y: buttonYOffset}),
															 TweenMax.fromTo(button3, 100, {x: screens[2].x + buttonXOffset, y: totalHeight}, {y: buttonYOffset}),
															 TweenMax.fromTo(button4, 100, {x: screens[3].x + buttonXOffset, y: totalHeight}, {y: buttonYOffset}),
															 TweenMax.fromTo(button5, 100, {x: screens[4].x + buttonXOffset, y: totalHeight}, {y: buttonYOffset})], 0, TweenAlign.START, 15);
			
			
			// title
			timeline.append(TweenMax.fromTo(title, 60 * 10, {x: totalWidth, y: 125, ease: Linear.easeNone}, {x: -title.width, ease: Linear.easeNone}));
			
			// question
			timeline.append(TweenMax.fromTo(question, 60 * 10, {x: totalWidth, y: 125, ease: Linear.easeNone}, {x: -question.width, ease: Linear.easeNone}));
			
			// join banners in
			timeline.appendMultiple([TweenMax.fromTo(joinBanner1, 100, {x: screens[0].x - joinBanner1.width, y: 125}, {x: "1372"}),
															 TweenMax.fromTo(joinBanner2, 100, {x: screens[2].x - joinBanner2.width, y: 125}, {x: "1372"}),
															 TweenMax.fromTo(joinBanner3, 100, {x: screens[4].x - joinBanner3.width, y: 125}, {x: "1372"})], 0, TweenAlign.START, 0);
			
			
			
			// join banners out, touch banners in
			timeline.appendMultiple([TweenMax.to(joinBanner1, 100, {x: screens[0].x + screens[0].width}),
															 TweenMax.fromTo(touchBanner1, 100, {x: screens[1].x - touchBanner1.width, y: 125}, {x: "1372"}),				
															 TweenMax.to(joinBanner2, 100, {x: screens[2].x + screens[2].width}),
															 TweenMax.fromTo(touchBanner2, 100, {x: screens[3].x - touchBanner1.width, y: 125}, {x: "1372"}),															 
															 TweenMax.to(joinBanner3, 100, {x: screens[4].x + screens[4].width})
															], 150, TweenAlign.START, 0);			
			
			
			// touch banners out
			timeline.appendMultiple([TweenMax.to(touchBanner1, 100, {x: screens[1].x + screens[1].width}),
															 TweenMax.to(touchBanner2, 100, {x: screens[3].x + screens[3].width}),
															], 150, TweenAlign.START, 0);			
			
			
			
			
			
			// reconfigure gui
			timeSlider.value = 0;
			timeSlider.maximum = timeline.totalDuration;
			
			
			timeline.goto(timeline.totalDuration); // make sure all of the froms are in position
			timeline.goto(0);			
			timeline.stop();
			
			//timeline.start();
			// sync server advances time (or just resyncs now and then?)
			
			// TODO tween to values to smooth differences?
			
			// TODO fill this up
		}
		
		private function onTimelineUpdate():void {
			frameCountLabel.text = "Frame: " + timeline.currentTime + " / " + 	timeline.totalDuration + "\tFPS: " + fpsMeter.fps;
			
			if (timeline.active) {
				timeSlider.value = timeline.currentTime;
			}			
		}
		
		
		
	}
}
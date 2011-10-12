package {

	
	import com.bit101.components.FPSMeter;
	import com.bit101.components.Label;
	import com.bit101.components.PushButton;
	import com.bit101.components.Slider;
	import com.greensock.*;
	import com.greensock.easing.*;
	import com.greensock.plugins.*;
	import com.kitschpatrol.futil.Math2;
	import com.kitschpatrol.futil.Utilities;
	import com.kitschpatrol.futil.utilitites.ArrayUtil;
	import com.kitschpatrol.futil.utilitites.NumberUtil;
	
	import flash.display.Bitmap;
	import flash.display.Shader;
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.display.StageAlign;
	import flash.display.StageScaleMode;
	import flash.events.Event;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
	import flashx.textLayout.elements.BreakElement;
	
	import sekati.layout.Arrange;
	
	
	//TweenPlugin.activate([]);	
	
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
			//stage.scaleMode = StageScaleMode.NO_SCALE;
			stage.align = StageAlign.TOP_LEFT;
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
			
			timeline.currentTime = Math.min(timeline.duration, Math.round(timeSlider.value)); 
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
		
		// TODO put this into FlashSpan, returns screen index, or -1 if it's in the gutter or off the screen
		private function pointIsOnScreen(p:Point):int {
			for (var i:int = 0; i < screens.length; i++) {
				if (screens[i].containsPoint(p)) return i;
			}
			return -1;
		}
		
		// TODO put this in flashspan, too
		private function pointIsNearScreen(p:Point):int {
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
		
		
		
		private function buildTimeline():void {
			

			// takes latest data, builds the timeline, TODO auto kill children for performance?
			timeline = new TimelineMax({useFrames: true, onUpdate: onTimelineUpdate});			
			
			
			var scrollVelocity:Number = 5; // used to calculate duration for variable-width screen crawlers
			
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
			var question:QuestionBanner = new QuestionBanner("Do you feel our public education provides our children with a thorough education these days?"); // TODO get form back end

			canvas.addChild(question);
			
			
			// build the graph
			var yesResponses:int = 215; // TODO get these from back end
			var noResponses:int = 15; // TODO get these from back end
			var totalResponses:int = yesResponses + noResponses;
			
			// raw width
			var yesWidth:int = Math.round((yesResponses / totalResponses) * totalWidth);
			var noWidth:int = Math.round((noResponses / totalResponses) * totalWidth);
			
			// text
			// Text in, where should text go?
			// get screenIndex
			
			// first, find where the division between the graphs falls
			var borderIndex:int = pointIsNearScreen(new Point(yesWidth, totalHeight / 2));
			var labelIndex:int;
			
			if (noWidth <= yesWidth) {
				// no is first, and no comes in from the right, so put it one screen to the left of the no border screen
				labelIndex = Math.max(Math.min(borderIndex - 1, 4), 0);
			}
			else {
				// yes is first, and yes comes in from the left, so put it one screen to the right of the yes border screen
				labelIndex = Math.max(Math.min(borderIndex + 1, 4), 0);
			}
			

			var yesGraphLabel:GraphLabel = new GraphLabel("yes");
			var noGraphLabel:GraphLabel = new GraphLabel("no");
			
			// Set text position
			yesGraphLabel.x = screens[labelIndex].x + 189;
			noGraphLabel.x = screens[labelIndex].x + 189;
			
			
			addChild(yesGraphLabel);
			addChild(noGraphLabel);
			
			// set text blending modes
			var yesShader:Shader = Assets.getMaskBlendFilter();
			yesShader.data.targetColor.value[0] = 50 / 255;
			yesShader.data.targetColor.value[1] = 182 / 255;
			yesShader.data.targetColor.value[2] = 255 / 255;
			yesGraphLabel.blendShader = yesShader;
			
			var noShader:Shader = Assets.getMaskBlendFilter();
			noShader.data.targetColor.value[0] = 247 / 255;
			noShader.data.targetColor.value[1] = 94 / 255;
			noShader.data.targetColor.value[2] = 0 / 255;
			noGraphLabel.blendShader = noShader;			
			
			 			
			// no points left
			var noBar:Sprite = new Sprite();
			var noHead:Bitmap = Assets.getOrangeArrowHead();
			noHead.scaleX = -1;
			noHead.x += noHead.width;
			var noTail:Bitmap = Assets.getOrangeArrowTail();
			noTail.scaleX = -1;
			noBar.addChild(noHead);
			noBar.graphics.beginFill(0xf75e00);
			noBar.graphics.drawRect(noHead.width, 0, noWidth, noHead.height);
			noBar.graphics.endFill();
			noTail.x = noTail.width + noBar.width;
			noBar.addChild(noTail);	
			
			
			
			// yes points right
			var yesBar:Sprite = new Sprite();
			var yesHead:Bitmap = Assets.getBlueArrowHead();
			var yesTail:Bitmap = Assets.getBlueArrowTail();
			yesBar.addChild(yesTail);
			yesBar.graphics.beginFill(0x32b6ff);
			yesBar.graphics.drawRect(yesTail.width, 0, yesWidth, yesTail.height);
			yesBar.graphics.endFill();
			yesHead.x = yesBar.width;
			yesBar.addChild(yesHead);
			
			
			
			// which one goes when? 
			// Put smaller one first!			
			var firstGraphText:GraphLabel;
			var secondGraphText:GraphLabel;
			var firstBar:Sprite;
			var firstBarCount:int;
			var secondBarCount:int;
			var secondBar:Sprite;
			var yesBarTweenIn:TweenMax;
			var noBarTweenIn:TweenMax; 
			var firstBarTweenIn:TweenMax; // gets overwritten later to keep all animation settings in one place
			var secondBarTweenIn:TweenMax; // gets overwritten later to keep all animation settings in one place			
			
			if (noResponses <= yesResponses) {
				firstGraphText = noGraphLabel;
				secondGraphText = yesGraphLabel;
				firstBar = noBar;
				secondBar = yesBar;
				firstBarCount = noResponses;
				secondBarCount = yesResponses;
			}
			else {
				firstGraphText = yesGraphLabel;
				secondGraphText = noGraphLabel;				
				firstBar = yesBar;
				secondBar = noBar;
				firstBarCount = yesResponses;
				secondBarCount = noResponses;				
			}
			
			
			canvas.addChild(firstBar);
			canvas.addChild(secondBar);			
			canvas.addChild(firstGraphText);
			canvas.addChild(secondGraphText);
			

			
			
			
			
			
			
			// Scrolling Quotes
			
			
			// TODO replace with backend
			var quotesDesired:int = 20;
			var quotes:Array = [];
			
			while (quotes.length < quotesDesired) {
				var dummyQuote:String = Utilities.dummyText(Utilities.randRange(20, 140));
				
				if (Math.random() > 0.5)
					quotes.push([dummyQuote,  "yes"]);
				else
					quotes.push([dummyQuote, "no"]);			
			}
			
			
			// generate the display quotes
			var yesQuotes:Array = [];
			var noQuotes:Array = [];
			for each (var quoteSource:Array in quotes) {
				if(quoteSource[1] == "yes") {
					yesQuotes.push(new QuotationBanner(quoteSource[0], quoteSource[1]));
				}
				else {
					noQuotes.push(new QuotationBanner(quoteSource[0], quoteSource[1]));
				}
			}
			
			
			
			// Generate the quote rows
			var quoteRows:Vector.<QuotationRow> = new Vector.<QuotationRow>(5);
			
			for (var i:int = 0; i < quoteRows.length; i++) {
				var quoteLine:QuotationRow = new QuotationRow();
				quoteLine.x = 0;
				quoteLine.y = 120 + (i * (240 + 120));
				canvas.addChild(quoteLine);
				
				// alternating stances
//				if (i % 1 == 0) {
//					quoteLine.lastStance = "yes";
//				}
//				else {
//					quoteLine.lastStance = "no"					
//				}
				
				quoteRows[i] = quoteLine;
			}			
			
			// add them to rows
			while ((yesQuotes.length > 0) && (noQuotes.length > 0)) {
				// find the shortest row
				var shortestRowIndex:int = 0;
				var minWidth:Number = Number.MAX_VALUE;
				for (var j:int = 0; j < quoteRows.length; j++) {
					if (quoteRows[j].width < minWidth) {
						minWidth = quoteRows[j].width;
						shortestRowIndex = j;
					}
				}
				
				// add to it
				
				// alternate stances
				var tempQuotationBanner:QuotationBanner;
				if (quoteRows[shortestRowIndex].lastStance == "yes") {
					 tempQuotationBanner = noQuotes.pop();
					 quoteRows[shortestRowIndex].lastStance = "no";
				}
				else {
					tempQuotationBanner = yesQuotes.pop();
					quoteRows[shortestRowIndex].lastStance = "yes";					
				}

				if (minWidth > 0) {
					tempQuotationBanner.x = minWidth + 130;
					tempQuotationBanner.y = 0;
				}
				
				
				
				quoteRows[shortestRowIndex].addChild(tempQuotationBanner);
				//quoteRows[shortestRowIndex].lastStance = tempQuotationBanner.stance;
			}

			
			
			
			// generate portraits, TODO get from back end

			
			
			
			
			
			// build the grid, fill randomly with faces 
			
						
			// build the grid
			var gridSpacing:Number = 30;
			var gridRows:int = 5;
			var gridCols:int = 20;
			var portraitWidth:int = 232;
			var portraitHeight:int = 310;
			
			var wallsaverPaddingTop:int = 123;
			
			
			// TODO get this part from back end
			var portraitData:Array = [Assets.getSamplePortrait1(),
														Assets.getSamplePortrait2(),
														Assets.getSamplePortrait3(),
														Assets.getSamplePortrait4()];
			
			var portraits:Array = [];			
			
			
			var borderColIndex:int = Math.round(Math2.map(yesResponses / totalResponses, 0, 1, 0, gridCols - 1));			
			var middleRowIndex:int = Math.floor(gridRows / 2);
			var centerArrowHeight:int = gridRows - middleRowIndex; // TODO test this
			
		
			for (var col:int = 0; col < gridCols; col++) {
				portraits[col] = [];
				
				var screen:Rectangle = screens[Math.floor(col / (gridCols / screens.length))];
				var screenCol:int = col % (gridCols / screens.length);
				var arrowHeight:int = Math2.clamp(centerArrowHeight + ((borderColIndex - col) * 2), 0, gridRows); // find out how high the arrow is in this column
				
				for (var row:int = 0; row < gridRows; row++) {
					
					// set stance based on border index, create an "arrow" shape
					var stance:String = "yes";
					
					if ((arrowHeight > 0) && (Math.abs(row - middleRowIndex) <= Math.floor(arrowHeight / 2))) {
						stance = "no";
					}
					
					var tempPortrait:GridPortrait = new GridPortrait(stance, ArrayUtil.getRandomElement(portraitData));
					tempPortrait.x = (gridSpacing * (screenCol + 1)) + (screenCol * portraitWidth) + screen.x;
					tempPortrait.y = (gridSpacing * (row + 1)) + (row * portraitHeight) + wallsaverPaddingTop;
					
					portraits[col][row] = canvas.addChild(tempPortrait);
				}
			}
		
		

			

			
			
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
			
			

			
			//  ==================================== // build the timeline // ========================================================================
			
			
			
			
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
			
			
			
			
			// Face Grid
			// TODO
			// get a flat array of portraits
			var gridCells:Array = ArrayUtil.flatten(portraits);
			
			// shuffle it
			gridCells = ArrayUtil.shuffle(gridCells);
			
			// build the tweens
			var gridTweenIn:Array = [];
			var gridTweenOut:Array = [];
			
			for each (var portrait:GridPortrait in gridCells) {
				gridTweenIn.push(TweenMax.fromTo(portrait, 750, {step: 0}, {step: 1, ease: Linear.easeNone}));
				gridTweenOut.push(TweenMax.fromTo(portrait, 800, {step: 1}, {step: 0, ease: Linear.easeNone}));
			}
			
			timeline.appendMultiple(gridTweenIn, 0, TweenAlign.START, 5); // compensate for steppiness
			timeline.appendMultiple(gridTweenOut, 100, TweenAlign.START, 5);
			
			
			// title
			var titleScrollDuration:int = (totalWidth + title.width)  / scrollVelocity;
			timeline.append(TweenMax.fromTo(title, titleScrollDuration, {x: totalWidth, y: 125, ease: Linear.easeNone}, {x: -title.width, ease: Linear.easeNone}));
			
			// question
			var questionScrollDuration:int = (totalWidth + question.width)  / scrollVelocity;
			timeline.append(TweenMax.fromTo(question, questionScrollDuration, {x: totalWidth, y: 125, ease: Linear.easeNone}, {x: -question.width, ease: Linear.easeNone}));
			
			// define the bar in animations, pick which one is first
			
			var yesBarScrollDuration:int = (yesBar.width - yesTail.width)  / scrollVelocity;			
			yesBarTweenIn = TweenMax.fromTo(yesBar, yesBarScrollDuration, {x: -yesBar.width, y: 125}, {x: -yesTail.width});
			
			var noBarScrollDuration:int = (totalWidth - noWidth - noHead.width)  / scrollVelocity;						
			noBarTweenIn = TweenMax.fromTo(noBar, noBarScrollDuration, {x: totalWidth, y: 125}, {x: totalWidth - noWidth - noHead.width});
			
			if (noResponses <= yesResponses) {			
				firstBarTweenIn = noBarTweenIn;
				secondBarTweenIn = yesBarTweenIn;
			}
			else {
				firstBarTweenIn = yesBarTweenIn;
				secondBarTweenIn = noBarTweenIn;				
			}
			
			// first graph in
			timeline.append(firstBarTweenIn);

			
			// first text in
			timeline.append(TweenMax.fromTo(firstGraphText, 100, {y: -firstGraphText.height, count: 0}, {y: 633, count: firstBarCount}), -20);
			
			// first text out, second text in
			timeline.appendMultiple([TweenMax.to(firstGraphText, 100, {y: screenHeight}),
															 TweenMax.fromTo(secondGraphText, 100, {y: -secondGraphText.height, count: 0}, {y: 633, count: firstBarCount})], 300, TweenAlign.START, 0);
			
			// second graph in
			timeline.append(secondBarTweenIn);
			
			
			
			
 
			
			// second text out
			timeline.append(TweenMax.to(secondGraphText, 100, {alpha: 0}), 100);
			
			// graphs out
			// var yesBarOutDuration:int = (yesBar.width - yesTail.width)  / scrollVelocity;			
			// var noBarOutDuration:int = (totalWidth - noWidth - noHead.width)  / scrollVelocity;				
			
			timeline.appendMultiple([TweenMax.to(secondGraphText, 100, {alpha: 0}),
															 TweenMax.to(noBar, 400, {x: -noBar.width}),
															 TweenMax.to(yesBar, 400, {x: totalWidth})], 100, TweenAlign.START, 100);			
			

			
			
			// Quotation field
			var quotationScrollDuration:int = (totalWidth + quoteRows[0].width)  / scrollVelocity;

			timeline.appendMultiple([TweenMax.fromTo(quoteRows[0], quotationScrollDuration, {x: -quoteRows[0].width}, {x: totalWidth + 100, 	 ease: QuotationRow.easeOutIn}),
															 TweenMax.fromTo(quoteRows[1], quotationScrollDuration, {x: totalWidth + 100},		{x: -quoteRows[1].width, ease: QuotationRow.easeOutIn}),
															 TweenMax.fromTo(quoteRows[2], quotationScrollDuration, {x: -quoteRows[2].width}, {x: totalWidth + 100,		 ease: QuotationRow.easeOutIn}),
															 TweenMax.fromTo(quoteRows[3], quotationScrollDuration, {x: totalWidth + 100},		{x: -quoteRows[3].width, ease: QuotationRow.easeOutIn}),
															 TweenMax.fromTo(quoteRows[4], quotationScrollDuration, {x: -quoteRows[4].width}, {x: totalWidth + 100,		 ease: QuotationRow.easeOutIn})], 0, TweenAlign.START, 0);			
			
//			timeline.appendMultiple([TweenMax.fromTo(quoteRows[0], quotationScrollDuration, {step: 0}, {step: 1, ease: Linear.easeNone}),
//															 TweenMax.fromTo(quoteRows[1], quotationScrollDuration, {step: 1}, {step: 0, ease: Linear.easeNone}),
//															 TweenMax.fromTo(quoteRows[2], quotationScrollDuration, {step: 0}, {step: 1, ease: Linear.easeNone}),
//															 TweenMax.fromTo(quoteRows[3], quotationScrollDuration, {step: 1}, {step: 0, ease: Linear.easeNone}),
//															 TweenMax.fromTo(quoteRows[4], quotationScrollDuration, {step: 0}, {step: 1, ease: Linear.easeNone})], 0, TweenAlign.START, 0);			

	

			
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
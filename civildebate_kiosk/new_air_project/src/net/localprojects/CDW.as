package net.localprojects {

	import com.bit101.components.FPSMeter;
	import com.greensock.*;
	import com.greensock.easing.*;
	import com.greensock.events.LoaderEvent;
	import com.greensock.events.TweenEvent;
	
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	import flash.ui.*;
	
	import jp.maaash.ObjectDetection.ObjectDetectorEvent;
	
	import net.localprojects.blocks.*;
	import net.localprojects.camera.*;
	import net.localprojects.elements.BlockLabel;
	import net.localprojects.elements.BlockParagraph;
	import net.localprojects.ui.*;

	public class CDW extends Sprite {
		
		public static var ref:CDW;
		public static var database:Database;
		public static var dashboard:Dashboard;
		public static var settings:Object;
		
		
		public function CDW() {
			ref = this;
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}

		private function onAddedToStage(event:Event):void {
			// load settings from a local JSON file
			settings = Settings.load();
			
			// set up the stage
			stage.quality = StageQuality.BEST;
			stage.scaleMode = StageScaleMode.EXACT_FIT;
			
			// temporarily squish screen for laptop development (half size)
			if (settings.halfSize) {
				stage.nativeWindow.width = 540;
				stage.nativeWindow.height = 960;
			}
			else {
				stage.nativeWindow.width = 1080;
				stage.nativeWindow.height = 1920;				
			}
			
			// load the wall state
			database = new Database();
			database.addEventListener(LoaderEvent.COMPLETE, onDatabaseLoaded);			
			database.load();
			
			// background
			graphics.beginFill(0xffffff);
			graphics.drawRect(0, 0, stage.stageWidth, stage.stageHeight);
			graphics.endFill();
			
			// set up gui overlay
			dashboard = new Dashboard(this.stage, 5, 5);
			
			if (settings.halfSize) {			
				dashboard.scaleX = 2;
				dashboard.scaleY = 2;
			}
			
			// set up a full screen option in the context menu
			var myContextMenu:ContextMenu = new ContextMenu();
			var item:ContextMenuItem = new ContextMenuItem("Toggle Full Screen");
			myContextMenu.customItems.push(item);
			item.addEventListener(ContextMenuEvent.MENU_ITEM_SELECT, onFullScreenContextMenuSelect);
			contextMenu = myContextMenu;
			
			if (settings.startFullScreen) {
				toggleFullScreen();
			}
		}
		
		
		// single copy, never changes
		private var header:Header;
		private var divider:Divider;
		private var answerPrompt:BlockLabel;
		private var smsDisclaimer:BlockParagraph;
		private var portraitOutline:PortraitOutline;
		
		// single copy, changes
		private var question:Question;
		private var stance:Stance;
		private var leftQuote:QuotationMark;
		private var rightQuote:QuotationMark;		
		private var portrait:Portrait; // TODO fading
		private var bigButton:BigButton; // TODO class wrap?		
		private var statsButton:IconButton; // TODO class wrap?
		private var likeButton:CounterButton; // TODO class wrap?
		private var debateButton:IconButton; // TODO class wrap?
		private var viewDebateButton:BlockButton; // TODO class wrap?		
		private var debatePicker:DebatePicker;
		private var debateOverlay:DebateOverlay;
		private var yesButton:BlockButton;
		private var noButton:BlockButton;
		private var backButton:BlockButton;
		private var smsInstructions:BlockParagraph;
		private var characterLimit:BlockLabel;
		private var photoBoothInstructions:BlockParagraph;
		private var countdown:Countdown;
		
		// multiples of these
		private var nametag:Nametag;
		private var opinion:Opinion;
		
		
		private function onDatabaseLoaded(e:LoaderEvent):void {
			trace("database loaded");
			
			// draw basic layout, wrap this up later
			portrait = new Portrait();
			portrait.setDefaultTweenIn(1, {alpha: 1});
			portrait.setDefaultTweenOut(1, {alpha: 0});			
			addChild(portrait);
			
			portraitOutline = new PortraitOutline();
			portraitOutline.setDefaultTweenIn(1, {alpha: 1});
			portraitOutline.setDefaultTweenOut(1, {alpha: 0});			
			addChild(portraitOutline);
			
			header = new Header();
			header.setDefaultTweenIn(1, {x: 30, y: 30});
			header.setDefaultTweenOut(1, {x: 30, y: -header.height});
			addChild(header);
			
			divider = new Divider();
			divider.setDefaultTweenIn(1, {x: 30, y: 250});
			divider.setDefaultTweenOut(1, {x: -divider.width, y: 250});			
			addChild(divider);
			
			question = new Question();
			question.setDefaultTweenIn(1, {x: 30, y: 140});
			question.setDefaultTweenOut(1, {x: -question.width, y: 140});
			question.setText(database.questions[database.activeQuestion].question); // TODO abstract out these ridiculous traversals...
			addChild(question);
						
			stance = new Stance();
			stance.setDefaultTweenIn(1, {x: 275, y: 280});
			stance.setDefaultTweenOut(1, {x: -stance.width, y: 280});			
			stance.setText(database.debates[database.activeDebate].stance);
			addChild(stance);			

			nametag = new Nametag();
			nametag.setDefaultTweenIn(1, {x: 275, y: 410});
			nametag.setDefaultTweenOut(1, {x: stage.stageWidth, y: 410});			
			nametag.setText(database.debates[database.activeDebate].author.firstName);
			addChild(nametag);
			
			leftQuote = new QuotationMark();
			leftQuote.setDefaultTweenIn(1, {x: 100, y: 545});
			leftQuote.setDefaultTweenOut(1, {x: -leftQuote.width, y: 545});	
			leftQuote.setStyle(QuotationMark.OPENING);
			leftQuote.setColor(Assets.COLOR_YES_LIGHT);
			addChild(leftQuote);
			
			rightQuote = new QuotationMark();
			rightQuote.setDefaultTweenIn(1, {x: 842, y: 1643});
			rightQuote.setDefaultTweenOut(1, {x: stage.stageWidth, y: 1643});				
			rightQuote.setStyle(QuotationMark.CLOSING);
			rightQuote.setColor(Assets.COLOR_YES_LIGHT);
			addChild(rightQuote);
			
			opinion = new Opinion();
			opinion.setDefaultTweenIn(1, {x: 100, y: 1095});
			opinion.setDefaultTweenOut(1, {x: -opinion.width, y: 1095});			
			opinion.setText(database.debates[database.activeDebate].opinion);
			addChild(opinion);
			
			bigButton = new BigButton('Add Your Opinion');
			bigButton.setDefaultTweenIn(1, {x: 438, y: 1470});
			bigButton.setDefaultTweenOut(1, {x: 438, y: 1470}); // TODO need to subclass and override tweenout and in methods because of weird animation???
			addChild(bigButton);
			
			statsButton = new IconButton(120, 110, 'STATS', 20, Assets.COLOR_YES_DARK, Assets.statsIcon());
			statsButton.setDefaultTweenIn(1, {x: 100, y: 1375});
			statsButton.setDefaultTweenOut(1, {x: -statsButton.width, y: 1375});			
			addChild(statsButton);
			
			likeButton = new CounterButton(120, 110, 'LIKE', 20, Assets.COLOR_YES_DARK, Assets.likeIcon());
			likeButton.setDefaultTweenIn(1, {x: 720, y: 955});
			likeButton.setDefaultTweenOut(1, {x: stage.stageWidth, y: 955});			
			addChild(likeButton);
			
			debateButton = new IconButton(150, 130, 'Let\u0027s Debate', 15, Assets.COLOR_YES_DARK, null, true);
			debateButton.setDefaultTweenIn(1, {x: 842, y: 807});
			debateButton.setDefaultTweenOut(1, {x: stage.stageWidth, y: 807});
			addChild(debateButton);
			
			viewDebateButton = new BlockButton(370, 63, '8 People Debated This', 25, Assets.COLOR_YES_DARK, true);
			viewDebateButton.setDefaultTweenIn(1, {x: 590, y: 1375});
			viewDebateButton.setDefaultTweenOut(1, {x: stage.stageWidth, y: 1375});			
			addChild(viewDebateButton)

			debateOverlay = new DebateOverlay();
			debateOverlay.setDefaultTweenIn(1, {x: 30, y: 813});
			debateOverlay.setDefaultTweenOut(1, {x: 30, y: stage.stageHeight});			
			addChild(debateOverlay);			
			
			debatePicker = new DebatePicker();
			debatePicker.setDefaultTweenIn(1, {x: 0, y: 1748});
			debatePicker.setDefaultTweenOut(1, {x: 0, y: stage.stageHeight});			
			debatePicker.update(); // syncs with state
			addChild(debatePicker);
			
			answerPrompt = new BlockLabel('Your Answer / Please Select One:', 20, 0xffffff, Assets.COLOR_INSTRUCTION_BACKGROUND, false, true);
			answerPrompt.setDefaultTweenIn(1, {x: 650, y: 1245});
			answerPrompt.setDefaultTweenOut(1, {x: stage.stageWidth, y: 1245});					
			addChild(answerPrompt);
			
			yesButton = new BlockButton(215, 100, 'YES!', 50, Assets.COLOR_YES_LIGHT, false);
			yesButton.setDefaultTweenIn(1, {x: 447, y: 1340});
			yesButton.setDefaultTweenOut(1, {x: 447, y: stage.stageHeight});
			addChild(yesButton);
			
			noButton = new BlockButton(185, 100, 'NO!', 50, Assets.COLOR_NO_LIGHT, false);			
			noButton.setDefaultTweenIn(1.2, {x: 677, y: 1340});
			noButton.setDefaultTweenOut(1.2, {x: 677, y: stage.stageHeight});
			addChild(noButton);
			
			var smsDisclaimerText:String = 'You will receive an SMS notifying you of any future opponents \nwho would like to enter into a debate with you based on your opinion. \nYou can opt out at any time by replying STOP.';
			smsDisclaimer = new BlockParagraph(872, smsDisclaimerText, 25, Assets.COLOR_INSTRUCTION_BACKGROUND, false);
			smsDisclaimer.setDefaultTweenIn(1, {x: 100, y: 1625});
			smsDisclaimer.setDefaultTweenOut(1, {x: 100, y: stage.stageHeight});
			addChild(smsDisclaimer);
			
			backButton = new BlockButton(135, 63, 'BACK', 25, Assets.COLOR_YES_DARK, true);
			backButton.setDefaultTweenIn(1, {x: 101, y: 1003});
			backButton.setDefaultTweenOut(1, {x: -backButton.width, y: 1003});			
			addChild(backButton);
			
			var smsInstructionText:String = 'What would you say to convince others of your opinion?\nText ' + settings.phoneNumber + ' with your statement.'; 	
			smsInstructions = new BlockParagraph(915, smsInstructionText, 30, Assets.COLOR_YES_LIGHT, false);
			smsInstructions.setDefaultTweenIn(1, {x: 101, y: 1096});
			smsInstructions.setDefaultTweenOut(1, {x: stage.stageWidth, y: 1096});
			addChild(smsInstructions);			
			
			characterLimit = new BlockLabel('Use no more than ' + settings.characterLimit + ' characters', 20, 0xffffff, Assets.COLOR_YES_MEDIUM);
			characterLimit.setDefaultTweenIn(1, {x: 648, y: 1246});
			characterLimit.setDefaultTweenOut(1, {x: stage.stageWidth, y: 1246});
			addChild(characterLimit);
			
			var photoBoothInstructionText:String = 'Thank you! Please align yourself with the silhouette in\norder to accurately take your photo for the debate.';
			photoBoothInstructions = new BlockParagraph(880, photoBoothInstructionText, 30, Assets.COLOR_YES_LIGHT, false);
			photoBoothInstructions.setDefaultTweenIn(1, {x: 100, y: 1096});
			photoBoothInstructions.setDefaultTweenOut(1, {x: stage.stageWidth, y: 1096});
			addChild(photoBoothInstructions);
			
			countdown = new Countdown(5);
			countdown.setDefaultTweenIn(1, {x: 470, y: 1496});
			countdown.setDefaultTweenOut(1, {x: 470, y: stage.stageHeight});
			addChild(countdown);
			
			
			// set view
			//homeView();

			
			// FPS meter
			var fps:FPSMeter = new FPSMeter(this, stage.stageWidth - 50, 0);		
			
			if (settings.halfSize) {
				fps.scaleX = 2;
				fps.scaleY = 2;			
				fps.x = stage.stageWidth - 100;
				fps.y = -5;	
			}
			
			
			
			
			
			
			
			
			var cameraFeed:ICameraFeed = new WebcamFeed();
			cameraFeed.start();
			cameraFeed.addEventListener(CameraFeedEvent.NEW_FRAME_EVENT, onNewFrame);
			
			cameraBitmap = new Bitmap();
			addChild(cameraBitmap);
			
			faceDetector= new FaceDetector();
			faceDetector.addEventListener(ObjectDetectorEvent.DETECTION_COMPLETE, onFaceFound);

			
		}
		
		public var cameraBitmap:Bitmap;		
		public var faceDetector:FaceDetector;
		
		private function onFaceFound(e:ObjectDetectorEvent):void {
			trace("Face!");
			trace(e.target.faceRect);
			
		}
		
		private function onNewFrame(e:CameraFeedEvent):void {
			cameraBitmap.bitmapData = Utilities.scaleToFit(e.target.frame, 200, 200);
			faceDetector.processBitmap(cameraBitmap.bitmapData);
		}
		
		
		// marks all FIRST LEVEL blocks as inactive
		private function markAllInactive():void {
			for (var i:int = 0; i < this.numChildren; i++) {
				if ((this.getChildAt(i) is BlockBase) && (this.getChildAt(i).visible)) {
					(this.getChildAt(i) as BlockBase).active = false;
				}
			}
		}
		
		private function tweenOutInactive():void {
			for (var i:int = 0; i < this.numChildren; i++) {
				if ((this.getChildAt(i) is BlockBase) && !(this.getChildAt(i) as BlockBase).active) {
					(this.getChildAt(i) as BlockBase).tweenOut();
				}
			}			
		}
		
		public function homeView(...args):void {
			markAllInactive();
			
			// mutations
			portrait.setImage(database.users[database.debates[database.activeDebate].author._id.$oid].portrait);
			
			// set behaviors
			viewDebateButton.setOnClick(debateOverlayView);	
			bigButton.setOnClick(pickStanceView);			
			
			// active blocks
			portrait.tweenIn();
			header.tweenIn();
			divider.tweenIn();
			question.tweenIn();
			stance.tweenIn();
			nametag.tweenIn();
			leftQuote.tweenIn();
			rightQuote.tweenIn();
			opinion.tweenIn();
			bigButton.tweenIn();
			statsButton.tweenIn();
			likeButton.tweenIn();
			debateButton.tweenIn();
			viewDebateButton.tweenIn();
			debatePicker.tweenIn();
			

			
			// override any tween outs here (flagging them as active means they won't get tweened out automatically)
			debateOverlay.tweenOut(1, {y: -debateOverlay.height}); // should overidden animations get re-positioned to their canonical 'out' location?

			// clean up the old based on what's not active
			tweenOutInactive();
		}
		

		
		public function debateOverlayView(...args):void {
			markAllInactive();			
			
			// mutations
			portrait.setImage(database.users[database.debates[database.activeDebate].author._id.$oid].portrait);
			
			// set behaviors
			viewDebateButton.setOnClick(homeView);
			
			// on
			portrait.tweenIn();
			header.tweenIn();
			divider.tweenIn();
			question.tweenIn();
			stance.tweenIn();
			nametag.tweenIn(1, {x: 590, y: 690});
			opinion.tweenIn(1, {y: 410});
			bigButton.tweenIn();
			statsButton.tweenIn(1, {x: -statsButton.width});
			likeButton.tweenIn(1, {x: stage.stageWidth});
			debateButton.tweenIn(1, {y: 660, scaleX: 0.75, scaleY: 0.75});
			viewDebateButton.tweenIn(1, {y: 1650});
			debatePicker.tweenIn();
			
			debateOverlay.tweenIn();

			tweenOutInactive();			
		}

		// move to control class?
		private function onYesButton(e:MouseEvent):void {
			database.userStance = 'yes';
			textPromptView();
		}
		
		private function onNoButton(e:MouseEvent):void {
			database.userStance = 'no';
			textPromptView();			
		}
		
		
		public function pickStanceView(...args):void {
			markAllInactive();		
			
			// mutations
			portrait.setImage(Assets.portraitPlaceholder);
			
			// set behaviors
			// TK
			yesButton.setOnClick(onYesButton);
			noButton.setOnClick(onNoButton);			
			
			// on
			portrait.tweenIn();
			header.tweenIn();
			divider.tweenIn();
			question.tweenIn();
			bigButton.tweenIn();
			answerPrompt.tweenIn();
			yesButton.tweenIn();
			noButton.tweenIn();
			smsDisclaimer.tweenIn();
			
			
			tweenOutInactive();		// disable behaviors as well?		
		}
		
		
		public function textPromptView(...args):void {
			markAllInactive();
			
			// mutations
			// Mutate according to stance state
			
			// behaviors
			// start polling web? TODO
			backButton.setOnClick(pickStanceView); // TODO do we need the back button
			
			// blocks
			portrait.tweenIn();
			header.tweenIn();
			divider.tweenIn();
			question.tweenIn();
			bigButton.tweenIn();
			yesButton.tweenIn();
			noButton.tweenIn();
			stance.tweenIn();
			backButton.tweenIn();
			smsInstructions.tweenIn();
			characterLimit.tweenIn();
			
			tweenOutInactive();			
		}
		
		
		public function photoBoothView(...args):void {
			markAllInactive();
			
			// mutations
			
			
			
			// behaviors
			countdown.setOnClick(onCameraClick);
			
			
			// blocks
			portrait.tweenIn();
			header.tweenIn();
			divider.tweenIn();
			question.tweenIn();
			stance.tweenIn();			
			portraitOutline.tweenIn();
			countdown.tweenIn();			
			
			tweenOutInactive();			
		}
		
		private function onCameraClick(e:MouseEvent):void {
			countdown.start()
		}
		
		
		
		

		private function onFullScreenContextMenuSelect(e:Event):void {
			toggleFullScreen();
		}
		
		private function toggleFullScreen():void {
			if (stage.displayState == StageDisplayState.NORMAL) {
				stage.displayState = StageDisplayState.FULL_SCREEN;
			}
			else {
				stage.displayState = StageDisplayState.NORMAL;
			}
		}		
		
		
		
		

		
		
		
		


	}
}
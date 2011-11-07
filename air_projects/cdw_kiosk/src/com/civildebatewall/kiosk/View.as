package com.civildebatewall.kiosk {
	import ObjectDetection.ObjectDetectorEvent;
	
	import com.adobe.serialization.json.*;
	import com.civildebatewall.Assets;
	import com.civildebatewall.CivilDebateWall;
	import com.civildebatewall.State;
	import com.civildebatewall.Utilities;
	import com.civildebatewall.data.*;
	import com.civildebatewall.kiosk.blocks.*;
	import com.civildebatewall.kiosk.camera.*;
	import com.civildebatewall.kiosk.elements.*;
	import com.civildebatewall.kiosk.keyboard.*;
	import com.civildebatewall.kiosk.ui.*;
	import com.civildebatewall.staging.elements.BalloonButton;
	import com.civildebatewall.staging.elements.DebateButton;
	import com.civildebatewall.staging.elements.NavArrow;
	import com.civildebatewall.staging.elements.QuestionHeader;
	import com.civildebatewall.staging.elements.RespondButton;
	import com.civildebatewall.staging.elements.SortLinks;
	import com.civildebatewall.staging.elements.StatsButton;
	import com.greensock.*;
	import com.greensock.easing.*;
	import com.greensock.plugins.*;
	import com.kitschpatrol.futil.Math2;
	import com.kitschpatrol.futil.blocks.BlockBase;
	import com.kitschpatrol.futil.blocks.BlockBitmap;
	import com.kitschpatrol.futil.constants.Alignment;
	import com.kitschpatrol.futil.utilitites.BitmapUtil;
	import com.kitschpatrol.futil.utilitites.FileUtil;
	import com.kitschpatrol.futil.utilitites.FunctionUtil;
	import com.kitschpatrol.futil.utilitites.GeomUtil;
	import com.kitschpatrol.futil.utilitites.NumberUtil;
	import com.kitschpatrol.futil.utilitites.StringUtil;
	
	import flash.display.*;
	import flash.events.*;
	import flash.filesystem.File;
	import flash.geom.Rectangle;
	import flash.net.*;
	import flash.text.TextFormat;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	import flash.utils.Timer;

	public class View extends Sprite {
		
		
		// convenience
		public var stageWidth:Number;
		public var stageHeight:Number;	
		
		// NEW STUFF
				
		// Home View
		public var portrait:Portrait;
		public var questionHeaderHome:QuestionHeader;		
		public var opinion:OpinionText;	
		private var likeButton:HomeLikeButton;
		private var viewCommentsButton:ViewCommentsButton;
		private var flagButton:HomeFlagButton;
		private var leftArrow:NavArrow;
		private var rightArrow:NavArrow;
		private var bigButton:BigButton; // TODO migrate to Futil?		
		
		private var opinionUnderlay:BlockBase;
		private var debateThisButton:BalloonButton;
		
		private var questionHeader:QuestionHeader;
		
		private var bigBackButton:BigBackButton;
		
		
		private var questionHeaderDecision:QuestionHeader;
		private var backButton:BackButton;
		private var respondButton:RespondButton;
		private var debateButton:DebateButton;
		private var orText:BlockBitmap;
		
		private var yesButton:YesButton;
		private var noButton:NoButton;
		
		private var opinionEntryOverlay:OpinionEntryOverlay;
		
		private var userOpinion:UserOpinionText;
		private var everythingOkText:BlockBitmap;
		private var cancelButton:CancelButton;
		private var retakePhotoButton:RetakePhotoButton;
		private var editNameOrOpinionButton:EditNameOrOpinionButton;
		
		
		// OLD STUFF
		
		// immutable
		private var smsDisclaimer:BlockParagraph;
		public var portraitCamera:PortraitCamera; // public for dashboard
		private var inactivityOverlay:BlockBitmap;
		private var inactivityTimerBar:ProgressBar;
		private var inactivityInstructions:BlockLabelBar;
		private var continueButton:BlockButton;
		private var flashOverlay:BlockBitmap;
		private var blackOverlay:BlockBitmap;
		public var skipTextButton:BlockButton; // debug only
		private var smsInstructions:BlockParagraph;
		private var dragLayer:DragLayer;
		private var flagOverlay:BlockBitmap;
		private var flagTimerBar:ProgressBar;
		private var flagInstructions:BlockLabelBar;
		private var flagYesButton:BlockButton;
		private var flagNoButton:BlockButton;
		private var submitOverlay:BlockBitmap;		
		private var letsDebateUnderlay:BlockBitmap;
		private var pickStanceInstructions:BlockLabelBar;
		private var characterLimitWarning:BlockLabel;
		private var usernameTakenWarning:BlockLabel;		
		private var cameraTimeoutWarning:BlockLabel;
		private var noNameWarning:BlockLabel;
		private var noOpinionWarning:BlockLabel;
		private var smsReceivedProfanityWarning:BlockParagraph;
		private var smsSubmittedProfanityWarning:BlockLabel;		
		private var sortLinks:SortLinks;
		
		// mutable (e.g. color changes)
		private var nameEntryInstructions:BlockLabel;		
		private var saveButton:BlockButton;		
		private var editTextButton:BlockButton;
		private var editTextInstructions:BlockLabel;
		private var cameraOverlay:CameraOverlay;
		private var statsButton:StatsButton;
				
		private var secondaryDebateButton:BalloonButtonOld;		

		private var exitButton:BlockButton;				
		private var characterLimit:BlockLabelBar;
		private var photoBoothNag:BlockLabel;
		private var photoBoothButton:BlockButton;
		private var countdownButton:CountdownButton;		
		private var keyboard:Keyboard;
		private var submitOverlayContinueButton:BlockButton;				
		private var submitOverlayMessage:BlockParagraph;
		
		private var nameEntryField:BlockInputLabel;
		

		
		private var editOpinion:BlockInputParagraph; // changes dimensions 
		private var byline:BlockLabel; // changes dimensions
		
		// containers, have lots of nested content
		public var statsOverlay:StatsOverlay;
		public var debateStrip:DebateStrip;
		public var threadOverlayBrowser:ThreadBrowser;		



		
		public function View() {
			super();
			init();
		}
		
		private function init():void {
			// for convenience
			stageWidth = 1080;
			stageHeight = 1920;
			
			// Work around for lack of mouse-down events
			// http://forums.adobe.com/message/2794098?tstart=0
			Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;
			
			// dump everything with just a single instance on the stage,
			// they'll get tweened in and out as necessary
			portrait = new Portrait();
			portrait.setDefaultTweenIn(1, {alpha: 1});
			portrait.setDefaultTweenOut(1, {alpha: 0});			
			addChild(portrait);
			
			portraitCamera = new PortraitCamera();
			portraitCamera.setDefaultTweenIn(1, {alpha: 1});
			portraitCamera.setDefaultTweenOut(1, {alpha: 0});
			addChild(portraitCamera);

			cameraOverlay = new CameraOverlay();
			cameraOverlay.setDefaultTweenIn(1, {alpha: 1});
			cameraOverlay.setDefaultTweenOut(1, {alpha: 0});			
			addChild(cameraOverlay);
			
			letsDebateUnderlay = new BlockBitmap({bitmap: new Bitmap(new BitmapData(1022, 577, false, 0xffffff))});
			letsDebateUnderlay.mouseEnabled = false; // let keystrokes through to the keyboard
			letsDebateUnderlay.x = 28;
			letsDebateUnderlay.y = 264;
			
			letsDebateUnderlay.setDefaultTweenIn(1, {alpha: 0.9, ease: Quart.easeOut});
			letsDebateUnderlay.setDefaultTweenOut(1, {alpha: 0, ease: Quart.easeOut});
			addChild(letsDebateUnderlay);				
			

			
			
			
			
			
			questionHeaderHome = new QuestionHeader({width: 1080, height: 313, textSizePixels: 39, leading: 29});
			questionHeaderHome.setDefaultTweenIn(1, { alpha: 1});
			questionHeaderHome.setDefaultTweenOut(1, { alpha: 0});
			addChild(questionHeaderHome);
			
			questionHeader = new QuestionHeader({width: 1024, height: 250, textSizePixels: 28,	leading: 22});
			questionHeader.setDefaultTweenIn(1, {x: 28, alpha: 1});
			questionHeader.setDefaultTweenOut(1, {x: 28, alpha: 0});
			addChild(questionHeader);
			
			questionHeaderDecision = new QuestionHeader({width: 880, height: 157, textSizePixels: 26, leading: 18});		
			questionHeaderDecision.setDefaultTweenIn(1, {x: 100, y: 1060});
			questionHeaderDecision.setDefaultTweenOut(1, {x: Alignment.OFF_STAGE_LEFT, y: 1060});
			addChild(questionHeaderDecision);			
			
			backButton = new BackButton();
			backButton.setDefaultTweenIn(1, {x: 100, y: 982});
			backButton.setDefaultTweenOut(1, {x: Alignment.OFF_STAGE_LEFT, y: 982});
			addChild(backButton);
			
			
			respondButton = new RespondButton();
			respondButton.setDefaultTweenIn(1, {x: 100, y: 1231});
			respondButton.setDefaultTweenOut(1, {x: Alignment.OFF_STAGE_LEFT, y: 1231});
			addChild(respondButton);			
			
			debateButton = new DebateButton();
			debateButton.setDefaultTweenIn(1, {x: 583, y: 1231});
			debateButton.setDefaultTweenOut(1, {x: Alignment.OFF_STAGE_RIGHT, y: 1231});
			addChild(debateButton);				
			
			orText = new BlockBitmap({bitmap: Assets.getOrText()});			
			orText.setDefaultTweenIn(1, {x: 524, y: 1294, alpha: 1});
			orText.setDefaultTweenOut(1, {x: 524, y: 1294, alpha: 0});
			addChild(orText);			
			
			
			yesButton = new YesButton();
			yesButton.setDefaultTweenIn(1, {x: 446, y: 1231});
			yesButton.setDefaultTweenOut(1, {x: Alignment.OFF_STAGE_LEFT, y: 1231});
			addChild(yesButton);
			
			noButton = new NoButton();
			noButton.setDefaultTweenIn(1, {x: 720, y: 1231});
			noButton.setDefaultTweenOut(1, {x: Alignment.OFF_STAGE_RIGHT, y: 1231});
			addChild(noButton);			
			
			// triple opinions
			
			opinionUnderlay = new BlockBase({backgroundColor: 0xffffff, backgroundAlpha: 0.85, width: 1024}); // height determined by opinion
			opinionUnderlay.setDefaultTweenIn(1, {x: 28, y: 264, alpha: 1});
			opinionUnderlay.setDefaultTweenOut(1, {x: 28, y: 264, alpha: 0});
			addChild(opinionUnderlay);
			
			opinion = new OpinionText();	
			opinion.setDefaultTweenIn(1, {x: 100, y: 1296});
			opinion.setDefaultTweenOut(1, {x: Alignment.OFF_STAGE_LEFT, y: 1296});
			addChild(opinion);
			
			userOpinion = new UserOpinionText();
			userOpinion.setDefaultTweenIn(1, {x: 100, y: 1296});
			userOpinion.setDefaultTweenOut(1, {x: Alignment.OFF_STAGE_LEFT, y: 1296});
			addChild(userOpinion);
			
			everythingOkText = new BlockBitmap({bitmap: Assets.getEverythingOkText()});
			everythingOkText.setDefaultTweenIn(1, {x: 100, y: 1341});
			everythingOkText.setDefaultTweenOut(1, {x: Alignment.OFF_STAGE_LEFT, y: 1341});
			addChild(everythingOkText);
			
			cancelButton = new CancelButton();
			cancelButton.setDefaultTweenIn(1, {x: 100, y: 1497});
			cancelButton.setDefaultTweenOut(1, {x: Alignment.OFF_STAGE_LEFT, y: 1497});
			addChild(cancelButton);
			
			retakePhotoButton = new RetakePhotoButton();
			retakePhotoButton.setDefaultTweenIn(1, {x: 294, y: 1497});
			retakePhotoButton.setDefaultTweenOut(1, {x: Alignment.OFF_STAGE_LEFT, y: 1497});
			addChild(retakePhotoButton);
			
			editNameOrOpinionButton = new EditNameOrOpinionButton();
			editNameOrOpinionButton.setDefaultTweenIn(1, {x: 591, y: 1497});
			editNameOrOpinionButton.setDefaultTweenOut(1, {x: Alignment.OFF_STAGE_LEFT, y: 1497});
			addChild(editNameOrOpinionButton);			
			
			
			debateThisButton = new BalloonButton();
			debateThisButton.setDefaultTweenIn(1, {x: 919});
			debateThisButton.setDefaultTweenOut(1, {x: Alignment.OFF_STAGE_RIGHT});
			addChild(debateThisButton);
			

			
			opinionEntryOverlay = new OpinionEntryOverlay();
			opinionEntryOverlay.setDefaultTweenIn(1, {x: 0, y: 0});
			opinionEntryOverlay.setDefaultTweenOut(1, {x: 0, y: Alignment.OFF_STAGE_BOTTOM});
			addChild(opinionEntryOverlay);
			
			
			
			
			
			
			// TODO is there always a drag layer?
			dragLayer = new DragLayer();
			dragLayer.setDefaultTweenIn(0, {});
			dragLayer.setDefaultTweenOut(0, {});
			addChild(dragLayer);			
			
			// dynamic y
			editOpinion = new BlockInputParagraph(915, 0x000000, '', 42);
			editOpinion.setDefaultTweenIn(0, {visible: true, x: 101});
			editOpinion.setDefaultTweenOut(0, {visible: false, x: 101});			
			addChild(editOpinion);
			
			bigButton = new BigButton();
			bigButton.setDefaultTweenIn(1, {x: 455, alpha: 1});
			bigButton.setDefaultTweenOut(1, {x: 455, alpha: 0}); // TODO possibly subclass for cooler in and out tweens
			addChild(bigButton);
			
			
			
			statsButton = new StatsButton();
			statsButton.setDefaultTweenIn(1, {x: 838, y: 796});
			statsButton.setDefaultTweenOut(1, {x: Alignment.OFF_STAGE_RIGHT, y: 796});
			addChild(statsButton);
			
			viewCommentsButton = new ViewCommentsButton();
			viewCommentsButton.setDefaultTweenIn(1, {x: 288, y: 1341});
			viewCommentsButton.setDefaultTweenOut(1, {x: Alignment.OFF_STAGE_LEFT, y: 1341});
			addChild(viewCommentsButton);

			
			
			

//			debateButton = new BalloonButton(152, 135, 0x000000, 'LET\u2019S\nDEBATE !', 22, 0xffffff, Assets.FONT_HEAVY);
//			debateButton.setDefaultTweenIn(1, {x: 813, scaleX: 1, scaleY: 1});
//			debateButton.setDefaultTweenOut(1, {x: BlockBase.OFF_RIGHT_EDGE, scaleX: 1, scaleY: 1});
//			addChild(debateButton);
			
			secondaryDebateButton = new BalloonButtonOld(152, 135, 0x000000, 'LET\u2019S\nDEBATE !', 22, 0xffffff, Assets.FONT_HEAVY);
			secondaryDebateButton.setStrokeColor(Assets.COLOR_GRAY_15);
			secondaryDebateButton.scaleX = 0.75;  
			secondaryDebateButton.scaleY = 0.75; 				
			secondaryDebateButton.setDefaultTweenIn(1, {x: 909});
			secondaryDebateButton.setDefaultTweenOut(1, {x: OldBlockBase.OFF_RIGHT_EDGE});
			addChild(secondaryDebateButton);	
			
			threadOverlayBrowser = new ThreadBrowser();
			threadOverlayBrowser.setDefaultTweenIn(1, {x: 28}); // y depends on opinion height
			threadOverlayBrowser.setDefaultTweenOut(1, {x: 28, y: Alignment.OFF_STAGE_BOTTOM});			
			addChild(threadOverlayBrowser);			
			
			debateStrip = new DebateStrip();
			debateStrip.setDefaultTweenIn(1, {x: 0, y: 1671});
			debateStrip.setDefaultTweenOut(1, {x: 0, y: Alignment.OFF_STAGE_BOTTOM});
			addChild(debateStrip);
			
			
			leftArrow = new NavArrow({bitmap: Assets.getLeftCaratBig()});
			leftArrow.setDefaultTweenIn(1, {x: 39, y: 1002});
			leftArrow.setDefaultTweenOut(1, {x: Alignment.OFF_STAGE_LEFT, y: 1002});
			addChild(leftArrow);
			
			rightArrow = new NavArrow({bitmap: Assets.getRightCaratBig()});
			rightArrow.setDefaultTweenIn(1, {x: 1019, y: 1002});
			rightArrow.setDefaultTweenOut(1, {x: Alignment.OFF_STAGE_RIGHT, y: 1002});
			addChild(rightArrow);
			
			
			pickStanceInstructions = new BlockLabelBar('Your Answer / Please Select One :', 19, 0xffffff, 367, 63, Assets.COLOR_GRAY_85, Assets.FONT_REGULAR);
			pickStanceInstructions.setDefaultTweenIn(1, {x: 670, y: 1243});
			pickStanceInstructions.setDefaultTweenOut(1, {x: OldBlockBase.OFF_RIGHT_EDGE, y: 1243});					
			addChild(pickStanceInstructions);
			

			
			// Temp debug button so we don't have to SMS every time
			skipTextButton = new BlockButton(200, 100, Assets.COLOR_GRAY_85, 'SIMULATE SMS', 20);
			skipTextButton.setDefaultTweenIn(1, {x: OldBlockBase.CENTER, y: 500});
			skipTextButton.setDefaultTweenOut(1, {x: OldBlockBase.OFF_RIGHT_EDGE, y: 500});
			skipTextButton.alpha = 1; // start hidden
			skipTextButton.setOnClick(simulateSMS);				
			//skipTextButton.setOnClick(null); // start off
			addChild(skipTextButton);

			// broken apart for easy measurability
			var smsInstrucitonPrefix:String = 'What would you say to convince others of your opinion?\nText ';
			var smsInstrucitonPostfix:String = ' with your statement.';			
			var smsPhoneNumber:String = NumberUtil.formatPhoneNumber(CivilDebateWall.data.smsNumber);
			var smsInstructionText:String = smsInstrucitonPrefix + smsPhoneNumber + smsInstrucitonPostfix;
			smsInstructions = new BlockParagraph(915, 0x000000, smsInstructionText, 30, 0xffffff, Assets.FONT_REGULAR);
			smsInstructions.textField.setTextFormat(new TextFormat(Assets.FONT_HEAVY), smsInstrucitonPrefix.length, smsInstrucitonPrefix.length + smsPhoneNumber.length);			
			smsInstructions.setDefaultTweenIn(1, {x: 101, y: 1096});
			smsInstructions.setDefaultTweenOut(1, {x: OldBlockBase.OFF_LEFT_EDGE, y: 1096});
			addChild(smsInstructions);
			
			var smsDisclaimerText:String = 'You will receive an SMS notifying you of any future opponents \nwho would like to enter into a debate with you based on your opinion. \nYou can opt out at any time by replying STOP.';
			smsDisclaimer = new BlockParagraph(915, Assets.COLOR_GRAY_75, smsDisclaimerText, 24);
			smsDisclaimer.textField.setTextFormat(new TextFormat(null, null, 0xc7c8ca), smsDisclaimerText.length -45, smsDisclaimerText.length);
			smsDisclaimer.setDefaultTweenIn(1, {x: 101, y: 1625});
			smsDisclaimer.setDefaultTweenOut(1, {x: OldBlockBase.OFF_LEFT_EDGE, y: 1625});
			addChild(smsDisclaimer);
			
			// y value is dynamic
			exitButton = new BlockButton(125, 63, 0x000000, 'EXIT', 26, 0xffffff, Assets.FONT_HEAVY);
			exitButton.setDefaultTweenIn(1, {x: 103});
			exitButton.setDefaultTweenOut(1, {x: OldBlockBase.OFF_LEFT_EDGE});			
			addChild(exitButton);
			

			characterLimit = new BlockLabelBar('Use No More than ' + CivilDebateWall.settings.characterLimit + ' characters', 19, 0xffffff, 367, 63, 0x000000, Assets.FONT_BOLD);			
			characterLimit.setDefaultTweenIn(1, {x: 670, y: 1243});
			characterLimit.setDefaultTweenOut(1, {x: OldBlockBase.OFF_RIGHT_EDGE, y: 1243});					
			addChild(characterLimit);			
			
			photoBoothNag = new BlockLabel('Please look into the Camera!', 33, 0xffffff, 0x000000, Assets.FONT_BOLD);
			photoBoothNag.setDefaultTweenIn(1.5, {alpha: 1, x: OldBlockBase.CENTER, y: 176}); // elastic easing was over-the-top
			photoBoothNag.setDefaultTweenOut(1, {alpha: 0, x: OldBlockBase.CENTER, y: 176});
			addChild(photoBoothNag);			
			
			photoBoothButton = new BlockButton(398, 63, 0x000000, 'TOUCH TO COUNTDOWN', 26, 0xffffff, Assets.FONT_HEAVY);
			photoBoothButton.setDefaultTweenIn(1, {alpha: 1, x: OldBlockBase.CENTER, y: 1628});
			photoBoothButton.setDefaultTweenOut(1, {alpha: 0, x: OldBlockBase.CENTER, y: 1628});
			addChild(photoBoothButton);
			
			countdownButton = new CountdownButton(6);
			countdownButton.setDefaultTweenIn(1, {x: Alignment.CENTER_STAGE, y: 30});
			countdownButton.setDefaultTweenOut(1, {x: Alignment.CENTER_STAGE, y: Alignment.OFF_STAGE_TOP});
			addChild(countdownButton);
			
			nameEntryInstructions = new BlockLabel('ENTER YOUR NAME', 26, 0xffffff, 0x000000, Assets.FONT_HEAVY)
			nameEntryInstructions.setPadding(20, 31, 20, 31);
			nameEntryInstructions.setDefaultTweenIn(1, {x: 101, y: 1000});
			nameEntryInstructions.setDefaultTweenOut(1, {x: OldBlockBase.OFF_LEFT_EDGE, y: 1003});
			addChild(nameEntryInstructions);
			
			nameEntryField = new BlockInputLabel('', 33, 0xffffff, 0x000000, Assets.FONT_REGULAR, true);
			nameEntryField.setPadding(24, 30, 20, 30);
			nameEntryField.setDefaultTweenIn(1, {x: 101, y: 1096});
			nameEntryField.setDefaultTweenOut(1, {x: OldBlockBase.OFF_LEFT_EDGE, y: 1096});
			addChild(nameEntryField);			
			
			// X and Y are dynamic
			saveButton = new BlockButton(335, 63, 0x000000, 'SAVE AND CONTINUE', 26, 0xffffff, Assets.FONT_HEAVY);			
			saveButton.setDefaultTweenIn(1, {});
			saveButton.setDefaultTweenOut(1, {x: OldBlockBase.OFF_LEFT_EDGE});
			addChild(saveButton);
			

			
			// y is dynamic
			editTextButton = new BlockButton(200, 63, 0x000000, 'EDIT TEXT', 26, 0xffffff, Assets.FONT_HEAVY);
			editTextButton.setDefaultTweenIn(1, {x: 528});
			editTextButton.setDefaultTweenOut(1, {x: OldBlockBase.OFF_RIGHT_EDGE});
			addChild(editTextButton);
			
			// y is dynamic
			// disabled per latest indesign file
			editTextInstructions = new BlockLabel('EDITING TEXT...', 26, 0xffffff, 0x000000, Assets.FONT_HEAVY);
			editTextInstructions.setDefaultTweenIn(1, {x: 525});
			editTextInstructions.setDefaultTweenOut(1, {x: OldBlockBase.OFF_LEFT_EDGE});
			addChild(editTextInstructions);			
			
			keyboard = new Keyboard();
			keyboard.setDefaultTweenIn(1, {x: 0, y: stageHeight - keyboard.height});
			keyboard.setDefaultTweenOut(1, {x: 0, y: OldBlockBase.OFF_BOTTOM_EDGE});
			addChild(keyboard);
			
			
			characterLimitWarning = new BlockLabel('You reached the character limit!', 26, 0xffffff, Assets.COLOR_GRAY_50, Assets.FONT_BOLD);
			characterLimitWarning.setDefaultTweenIn(1, {x: OldBlockBase.CENTER, y: 1562 - (characterLimitWarning.height / 2) - 10});	
			characterLimitWarning.setDefaultTweenOut(1, {x: OldBlockBase.OFF_LEFT_EDGE, y: 1562 - (characterLimitWarning.height / 2) - 10});
			addChild(characterLimitWarning);
			
			cameraTimeoutWarning = new BlockLabel('The camera could not focus, please try again!', 26, 0xffffff, Assets.COLOR_GRAY_50, Assets.FONT_BOLD);
			cameraTimeoutWarning.setDefaultTweenIn(1, {x: OldBlockBase.CENTER, y: OldBlockBase.CENTER});	
			cameraTimeoutWarning.setDefaultTweenOut(1, {x: OldBlockBase.OFF_LEFT_EDGE, y: OldBlockBase.CENTER});
			addChild(cameraTimeoutWarning);
				
			noNameWarning = new BlockLabel('Please enter a username!', 26, 0xffffff, Assets.COLOR_GRAY_50, Assets.FONT_BOLD);
			noNameWarning.setDefaultTweenIn(1, {x: OldBlockBase.CENTER, y: 1562 - (noNameWarning.height / 2) - 10});	
			noNameWarning.setDefaultTweenOut(1, {x: OldBlockBase.OFF_LEFT_EDGE, y: 1562 - (noNameWarning.height / 2) - 10});
			addChild(noNameWarning);
			
			usernameTakenWarning = new BlockLabel('That username is already taken!', 26, 0xffffff, Assets.COLOR_GRAY_50, Assets.FONT_BOLD);
			usernameTakenWarning.setDefaultTweenIn(1, {x: OldBlockBase.CENTER, y: 1562 - (noNameWarning.height / 2) - 10});	
			usernameTakenWarning.setDefaultTweenOut(1, {x: OldBlockBase.OFF_LEFT_EDGE, y: 1562 - (noNameWarning.height / 2) - 10});
			addChild(usernameTakenWarning);			
			
			noOpinionWarning = new BlockLabel('Please enter your opinion!', 26, 0xffffff, Assets.COLOR_GRAY_50, Assets.FONT_BOLD);
			noOpinionWarning.setDefaultTweenIn(1, {x: OldBlockBase.CENTER, y: 1562 - (noOpinionWarning.height / 2) - 10});	
			noOpinionWarning.setDefaultTweenOut(1, {x: OldBlockBase.OFF_LEFT_EDGE, y: 1562 - (noOpinionWarning.height / 2) - 10});
			addChild(noOpinionWarning);				
			
			
			var profanityNagIncoming:String = 'Please choose words that will encourage a civil debate and re-send your message!';
			smsReceivedProfanityWarning = new BlockParagraph(800, Assets.COLOR_GRAY_50, profanityNagIncoming, 26, 0xffffff, Assets.FONT_BOLD); 
			smsReceivedProfanityWarning.setDefaultTweenIn(1, {x: OldBlockBase.CENTER, y: 576});	
			smsReceivedProfanityWarning.setDefaultTweenOut(1, {x: OldBlockBase.OFF_LEFT_EDGE, y: 576});
			addChild(smsReceivedProfanityWarning);
			
			
			sortLinks = new SortLinks();
			sortLinks.setDefaultTweenIn(1, {y: 1811});	
			sortLinks.setDefaultTweenOut(1, {y: Alignment.OFF_STAGE_BOTTOM});			
			addChild(sortLinks);
			
			likeButton = new HomeLikeButton();
			likeButton.setDefaultTweenIn(1, {x: 100, y: 1341});
			likeButton.setDefaultTweenOut(1, {x: Alignment.OFF_STAGE_LEFT, y: 1341});
			addChild(likeButton);
			
			flagButton = new HomeFlagButton();
			flagButton.setDefaultTweenIn(1, {x: 916, y: 1341});
			flagButton.setDefaultTweenOut(1, {x: Alignment.OFF_STAGE_LEFT, y: 1341});
			addChild(flagButton);
			
			
			// TODO HOOK THIS UP?
			smsSubmittedProfanityWarning = new BlockLabel('Please choose words that will encourage a civil debate and re-submit your message!', 26, 0xffffff, Assets.COLOR_GRAY_50, Assets.FONT_BOLD);
			smsSubmittedProfanityWarning.setDefaultTweenIn(1, {x: OldBlockBase.CENTER, y: 576});	
			smsSubmittedProfanityWarning.setDefaultTweenOut(1, {x: OldBlockBase.OFF_LEFT_EDGE, y: 576});
			addChild(smsSubmittedProfanityWarning);			 
			
			
			// TODO update from database
			statsOverlay = new StatsOverlay();
			statsOverlay.setDefaultTweenIn(1, {x: 29, y: 264});
			statsOverlay.setDefaultTweenOut(1, {x: 29, y: OldBlockBase.OFF_BOTTOM_EDGE});
			addChild(statsOverlay);
			
			inactivityOverlay = new BlockBitmap({bitmap: new Bitmap(new BitmapData(stageWidth, stageHeight, false, 0x000000))});
			inactivityOverlay.setDefaultTweenIn(1, {alpha: 0.85});
			inactivityOverlay.setDefaultTweenOut(1, {alpha: 0});
			addChild(inactivityOverlay);
			
			inactivityTimerBar = new ProgressBar(735, 2, 20);		
			inactivityTimerBar.setDefaultTweenIn(1, {x: OldBlockBase.CENTER, y: 1002});
			inactivityTimerBar.setDefaultTweenOut(1, {x: OldBlockBase.CENTER, y: OldBlockBase.OFF_TOP_EDGE});			
			addChild(inactivityTimerBar);
			
			inactivityInstructions = new BlockLabelBar('ARE YOU STILL THERE ?', 23, 0xffffff, 735, 63, Assets.COLOR_GRAY_75, Assets.FONT_HEAVY);
			inactivityInstructions.setDefaultTweenIn(1, {x: OldBlockBase.CENTER, y: 1018});
			inactivityInstructions.setDefaultTweenOut(1, {x: OldBlockBase.CENTER, y: OldBlockBase.OFF_TOP_EDGE});			
			addChild(inactivityInstructions);
			
			continueButton = new BlockButton(735, 120, Assets.COLOR_GRAY_50, 'YES!', 92);
			continueButton.setDownColor(Assets.COLOR_GRAY_75);
			continueButton.setDefaultTweenIn(1, {alpha: 1, x: OldBlockBase.CENTER, y: 1098});
			continueButton.setDefaultTweenOut(1, {alpha: 1, x: OldBlockBase.OFF_LEFT_EDGE, y: 1098});					
			addChild(continueButton);
			
			// Flag overlay
			flagOverlay = new BlockBitmap({bitmap: new Bitmap(new BitmapData(stageWidth, stageHeight, false, 0x000000))});
			flagOverlay.setDefaultTweenIn(1, {alpha: 0.85});
			flagOverlay.setDefaultTweenOut(1, {alpha: 0});
			addChild(flagOverlay);
			
			flagTimerBar = new ProgressBar(735, 2, 20);		
			flagTimerBar.setDefaultTweenIn(1, {alpha: 1, x: OldBlockBase.CENTER, y: 1002});
			flagTimerBar.setDefaultTweenOut(1, {alpha: 1, x: OldBlockBase.CENTER, y: OldBlockBase.OFF_TOP_EDGE});			
			addChild(flagTimerBar);
			
			flagInstructions = new BlockLabelBar('FLAG AS INAPPROPRIATE ?', 23, 0xffffff, 735, 63, Assets.COLOR_GRAY_75, Assets.FONT_HEAVY);
			flagInstructions.setDefaultTweenIn(1, {x: OldBlockBase.CENTER, y: 1018});
			flagInstructions.setDefaultTweenOut(1, {x: OldBlockBase.CENTER, y: OldBlockBase.OFF_TOP_EDGE});			
			addChild(flagInstructions);
			
			flagYesButton = new BlockButton(360, 120, Assets.COLOR_GRAY_50, 'YES!', 92);
			flagYesButton.setDownColor(Assets.COLOR_GRAY_75);
			flagYesButton.setDefaultTweenIn(1, {x: 173, y: 1098});
			flagYesButton.setDefaultTweenOut(1, {x: OldBlockBase.OFF_LEFT_EDGE, y: 1098});					
			addChild(flagYesButton);
			
			flagNoButton = new BlockButton(360, 120, Assets.COLOR_GRAY_50, 'NO!', 92);
			flagNoButton.setDownColor(Assets.COLOR_GRAY_75);
			flagNoButton.setDefaultTweenIn(1, {x: 548, y: 1098});
			flagNoButton.setDefaultTweenOut(1, {x: OldBlockBase.OFF_RIGHT_EDGE, y: 1098});					
			addChild(flagNoButton);			
			

			bigBackButton = new BigBackButton();
			bigBackButton.setDefaultTweenIn(1, {x: 28, y: 1826});
			bigBackButton.setDefaultTweenOut(1, {x: 28, y: Alignment.OFF_STAGE_BOTTOM});
			addChild(bigBackButton);			
			
			// Submit overlay
			submitOverlay = new BlockBitmap({bitmap: new Bitmap(new BitmapData(stageWidth, stageHeight, false, 0x000000))});
			submitOverlay.setDefaultTweenIn(1, {alpha: 0.85});
			submitOverlay.setDefaultTweenOut(1, {alpha: 0});
			addChild(submitOverlay);
			
			submitOverlayMessage = new BlockParagraph(900, 0x000000, 'Thank you for your participation.\nKeep up with the latest at greatcivildebatewall.com', 31, 0xffffff, Assets.FONT_BOLD);
			submitOverlayMessage.setDefaultTweenIn(1, {x: 101, y: 993});
			submitOverlayMessage.setDefaultTweenOut(1, {x: OldBlockBase.OFF_LEFT_EDGE, y: 993});					
			addChild(submitOverlayMessage);			
			
			submitOverlayContinueButton = new BlockButton(202, 65, 0x000000, 'CONTINUE', 25, 0xffffff, Assets.FONT_HEAVY);
			submitOverlayContinueButton.setDefaultTweenIn(1, {alpha: 1, x: 779, y: 1243});
			submitOverlayContinueButton.setDefaultTweenOut(1, {alpha: 1, x: OldBlockBase.OFF_RIGHT_EDGE, y: 1243});					
			addChild(submitOverlayContinueButton);						

			// Camera Overlays
			blackOverlay = new BlockBitmap({bitmap: new Bitmap(new BitmapData(stageWidth, stageHeight, false, 0x000000))});
			blackOverlay.setDefaultTweenIn(0.1, {alpha: 1, immediateRender: true}); // duration of 0 doesn't work?
			blackOverlay.setDefaultTweenOut(0, {alpha: 0});
			addChild(blackOverlay);
			
			// Flash overlay
			flashOverlay = new BlockBitmap({bitmap: new Bitmap(new BitmapData(stageWidth, stageHeight, false, 0xffffff))});
			flashOverlay.setDefaultTweenIn(0.1, {alpha: 1, ease: Quart.easeOut, immediateRender: true});
			flashOverlay.setDefaultTweenOut(1, {alpha: 0, ease: Quart.easeOut});
			flashOverlay.name = 'Flash Overlay';
			addChild(flashOverlay);
			
			CivilDebateWall.state.addEventListener(State.ACTIVE_DEBATE_CHANGE, onActiveDebateChange);
			CivilDebateWall.state.addEventListener(State.VIEW_CHANGE, onViewChange);
		}
		
		private function onViewChange(e:Event):void {
			// refresh the view...
			CivilDebateWall.state.activeView();
		}		
		
		private function onActiveDebateChange(e:Event):void {
			// refresh the view... listen inside display objects, instead?
			//CivilDebateWall.state.activeView();
		}
		
		
		// =========================================================================
		
		
		// land here if there aren't yet opinions for the current question
		// TODO some kind of "be the first" message
		public function noOpinionView(...args):void {
			markAllInactive();
			
			// mutations
			CivilDebateWall.inactivityTimer.disarm();
			portrait.setImage(Assets.portraitPlaceholder);
			//question.setTextColor(CDW.state.questionTextColor);
			bigButton.y = 1470;
			bigButton.setText('ADD YOUR OPINION');
			CivilDebateWall.state.clearUser();

			// behaviors
			
			bigButton.setOnClick(function():void {
				CivilDebateWall.state.setView(debateTypePickerView);			
			});				
			
			
			
			// blocks
			portrait.tweenIn();
			questionHeaderHome.tweenIn();			
			bigButton.tweenIn();	

			tweenOutInactive();
		}
		
		// =========================================================================
		

		
		public function homeView(...args):void {
			markAllInactive();
			
			CivilDebateWall.inactivityTimer.disarm();
			CivilDebateWall.state.clearUser(); // Reset user info
						
			bigButton.y = 1470;
			bigButton.setText('JOIN THE DEBATE'); // TODO move to listener?
			bigButton.setOnClick(function():void {
				CivilDebateWall.state.userRespondingTo = CivilDebateWall.state.activeThread.firstPost;
				CivilDebateWall.state.setView(debateTypePickerView);			
			});							
			

			// blocks
			portrait.tweenIn();
			questionHeaderHome.tweenIn();
			leftArrow.tweenIn();
			rightArrow.tweenIn();
			opinion.tweenIn();			
			statsButton.tweenIn();
			likeButton.tweenIn();
			viewCommentsButton.tweenIn();			
			flagButton.tweenIn();			
			bigButton.tweenIn();
			debateStrip.tweenIn();
			sortLinks.tweenIn();
			
			
			// override any tween outs here (flagging them as active means they won't get tweened out automatically)
			// note that it's a one-time thing, when the block tweens back in, it will start from its canonical "tween out" location
			// and not this temporary override
			//debateOverlay.tweenOut(1, {y: -debateOverlay.height});
			
			// clean up the old based on what's not active
			tweenOutInactive();
		}
		
		// TODO these...
		public function nextDebate():void {
			if (CivilDebateWall.state.nextThread != null) { 	
				trace('Transition to next.');
				CivilDebateWall.state.setActiveThread(CivilDebateWall.state.nextThread);
				CivilDebateWall.kiosk.view.opinion.x += stageWidth;
			}
			homeView();
		}
		
		public function previousDebate():void {
			if (CivilDebateWall.state.previousThread != null) {
				trace('Transition to previous.');
				CivilDebateWall.state.setActiveThread(CivilDebateWall.state.previousThread);
				CivilDebateWall.kiosk.view.opinion.x -= stageWidth;
			}
			homeView();			
		}
		


		// =========================================================================
		
		
		public function threadView(...args):void {			
			markAllInactive();
			CivilDebateWall.inactivityTimer.disarm();
			
			// Do this on event callback instead?
			debateThisButton.targetPost = CivilDebateWall.state.activeThread.firstPost;
			
			// Alignment
			opinionUnderlay.height = opinion.contentHeight + 233;
			debateThisButton.y = 327 + opinion.contentHeight;
			threadOverlayBrowser.maxHeight = 1812 - (opinionUnderlay.y + opinionUnderlay.height + 14);

			
			//debateOverlay.setMaxHeight(stageHeight - (letsDebateUnderlay.y + letsDebateUnderlay.height + 30 + 300));
			portrait.tweenIn();
			questionHeader.tweenIn();
			opinionUnderlay.tweenIn();			
			opinion.tweenIn(1, {y: 327 + opinion.contentHeight});
			threadOverlayBrowser.tweenIn(1, {y: opinionUnderlay.y + opinionUnderlay.height + 14});
			debateThisButton.tweenIn();
			bigBackButton.tweenIn();
			
			//debateOverlay.tweenIn(-1, {y: letsDebateUnderlay.y + letsDebateUnderlay.height + 30});
			
			
			// resize question header...
			
							
			//debateOverlay.update();			

			tweenOutInactive();	
		}
		
		private function onCloseDebateOverlay(e:Event):void {
			CivilDebateWall.state.threadOverlayOpen = false;
			homeView();
		}
		
		private function onYesButton(e:MouseEvent):void {
			CivilDebateWall.state.setUserStance('yes');
			smsPromptView();
		}
		
		private function onNoButton(e:MouseEvent):void {
			CivilDebateWall.state.setUserStance('no');
			smsPromptView();			
		}
		
		
		// =========================================================================
		
		public function debateTypePickerView(...args):void {
			markAllInactive(); 
			CivilDebateWall.inactivityTimer.arm();
			
			CivilDebateWall.state.backDestination = homeView;  
			
			portrait.tweenIn(1, {alpha: 0.25});
			backButton.tweenIn();
			questionHeaderDecision.tweenIn();
			respondButton.tweenIn();
			orText.tweenIn();
			debateButton.tweenIn();
			
			// custom tween outs
			threadOverlayBrowser.tweenOut(1, {x: Alignment.OFF_STAGE_RIGHT, y: threadOverlayBrowser.y});
			opinion.tweenOut(1, {x: Alignment.OFF_STAGE_RIGHT, y: opinion.y});
			bigBackButton.tweenOut(1, {x: Alignment.OFF_STAGE_RIGHT, y: bigBackButton.y});
			
			tweenOutInactive();			
		}

		// =========================================================================
		
		public function debateStancePickerView(...args):void {
			markAllInactive();
			CivilDebateWall.inactivityTimer.arm();
			
			CivilDebateWall.state.backDestination = CivilDebateWall.state.lastView;
			
			portrait.tweenIn(1, {alpha: 0.25});
			backButton.tweenIn();
			questionHeaderDecision.tweenIn();
			yesButton.tweenIn();
			noButton.tweenIn();
			
			
			
			tweenOutInactive();			
		}
		
		
		public function opinionEntryView(...args):void {
			markAllInactive();			
			CivilDebateWall.inactivityTimer.arm();
			CivilDebateWall.state.backDestination = CivilDebateWall.state.lastView;
			
			opinionEntryOverlay.tweenIn();
			
			tweenOutInactive();			
		}
		
		
		
		
		private var faceDetector:FaceDetector = new FaceDetector();
		
		public function photoBoothView(...args):void {			
			markAllInactive();
			CivilDebateWall.inactivityTimer.arm();			
			
			
			// behaviors
			countdownButton.setOnFinish(onCountdownFinish);
			
			// blocks
			portraitCamera.tweenIn();
			cameraOverlay.tweenIn();
			countdownButton.tweenIn();
			
			// Start counting down automatically
			countdownButton.start();			
			
			
			// Todo update this
//			if (CivilDebateWall.state.lastView == photoBoothView) {
//				// we timed out! show the message for five seconds
//				cameraTimeoutWarning.tweenIn();
//				TweenMax.delayedCall(5, function():void { cameraTimeoutWarning.tweenOut(-1, {x: OldBlockBase.OFF_RIGHT_EDGE})});
//			}
//			
			tweenOutInactive();
		}
		
		
		private function onCountdownFinish(e:Event):void {			
			// go to black
			blackOverlay.tweenIn(-1, {onComplete: onScreenBlack});
		}
		
		private function onScreenBlack():void {
			trace('screen black');
			
			// Do this in portrait camera instead?
			if (CivilDebateWall.settings.webcamOnly) {
				// using webcam
				portraitCamera.takePhoto();
				CivilDebateWall.state.userImage = portraitCamera.cameraBitmap; // store here temporarily	
				detectFace(CivilDebateWall.state.userImage);
			}
			else {
				// using SLR
				portraitCamera.slr.setOnTimeout(onSLRTimeout);
				portraitCamera.slr.addEventListener(CameraFeedEvent.NEW_FRAME_EVENT, onPhotoCapture);
				portraitCamera.slr.takePhoto();
			}
		}
		
		private function onSLRTimeout(e:Event):void {
			// go back to photo page
			CivilDebateWall.dashboard.log("SLR timeout callback");
			portraitCamera.slr.removeEventListener(CameraFeedEvent.NEW_FRAME_EVENT, onPhotoCapture);
			photoBoothView();
		}
		
		
		private function onPhotoCapture(e:CameraFeedEvent):void {
			portraitCamera.slr.removeEventListener(CameraFeedEvent.NEW_FRAME_EVENT, onPhotoCapture);
			
			// process SLR image
			CivilDebateWall.state.userImage = portraitCamera.slr.image;
			detectFace(CivilDebateWall.state.userImage);
		}
		
		
		private function detectFace(b:Bitmap):void {
			trace('face detection started');
			// find the face closest to the center
			faceDetector.addEventListener(ObjectDetectorEvent.DETECTION_COMPLETE, onDetectionComplete);			
			faceDetector.searchBitmap(b.bitmapData);
		}
		
		
		private function onDetectionComplete(e:ObjectDetectorEvent):void {
			faceDetector.removeEventListener(ObjectDetectorEvent.DETECTION_COMPLETE, onDetectionComplete);
			trace('face detection complete');
			trace(faceDetector.faceRect);
			
			// save a copy of the original image, we'll write it to disk later
			CivilDebateWall.state.userImageFull = new Bitmap(CivilDebateWall.state.userImage.bitmapData.clone());
			
			if (faceDetector.faceRect != null) {
				trace('face found, cropping to it');
				
				// Scale the face detector rectangle
				var scaleFactor:Number = CivilDebateWall.state.userImage.height / faceDetector.maxSourceHeight; 
				var scaledFaceRect:Rectangle = GeomUtil.scaleRect(faceDetector.faceRect, scaleFactor);
				
				trace("Scaled face rect: " + scaledFaceRect);
				
				CivilDebateWall.state.userImage = Utilities.cropToFace(CivilDebateWall.state.userImage, scaledFaceRect, new Rectangle(294, 352, 494, 576));				
			}
			else {
				trace('no face found, saving as is');
				CivilDebateWall.state.userImage.bitmapData = BitmapUtil.scaleDataToFill(CivilDebateWall.state.userImage.bitmapData, stageWidth, stageHeight);
			}
			
			// NOW flash
			flashOverlay.tweenIn(-1, {onComplete: onFlashOn}); // use default tween in duration
		}
		
		
		private function onFlashOn():void {
			blackOverlay.tweenOut();
			CivilDebateWall.state.setView(opinionReviewView);
			flashOverlay.tweenOut();
		}
		
		
		// =========================================================================		
		

		public function opinionReviewView(...args):void {
			markAllInactive();
			CivilDebateWall.inactivityTimer.arm();
			CivilDebateWall.state.backDestination = CivilDebateWall.kiosk.view.opinionEntryView;			
			
			portrait.setImage(CivilDebateWall.state.userImage, true);
			bigButton.setText("SUBMIT MY OPINION", true);
			bigButton.enable();
			bigButton.y = 1607;			
			
			
			//portrait.tween
			portrait.tweenIn();
			questionHeaderHome.tweenIn();
			userOpinion.tweenIn();
			everythingOkText.tweenIn();
			cancelButton.tweenIn();
			retakePhotoButton.tweenIn();
			editNameOrOpinionButton.tweenIn();
			bigButton.tweenIn();
			
			tweenOutInactive();			
		}
			
			
			// ==============================================================================================================
			// Old views ====================================================================================================
			// ==============================================================================================================
		
		
		
		
		
		
		public function flagOverlayView(...args):void {
			CivilDebateWall.state.lastView = CivilDebateWall.state.activeView;
			CivilDebateWall.state.activeView = flagOverlayView;
			
			// mutations			
			CivilDebateWall.inactivityTimer.disarm();
			flagInstructions.setText("FLAG AS INAPPROPRIATE ?");			
			flagYesButton.enable();
			flagYesButton.showOutline(true, true);
			flagYesButton.setBackgroundColor(Assets.COLOR_GRAY_50, true);
						
			flagNoButton.disable();
			flagNoButton.showOutline(true, true);
			flagNoButton.setBackgroundColor(Assets.COLOR_GRAY_50, true);
			
			// behaviors
			flagYesButton.setOnClick(incrementFlags);
			flagNoButton.setOnClick(removeFlagOverlayView);			
			flagTimerBar.setOnComplete(removeFlagOverlayView);
			
			// blocks
			flagOverlay.tweenIn();
			flagTimerBar.tweenIn();			
			flagInstructions.tweenIn();
			flagYesButton.tweenIn();
			flagNoButton.tweenIn();			
		}
		
		private function removeFlagOverlayView(...args):void {
			CivilDebateWall.state.activeView = CivilDebateWall.state.lastView; // revert the view, since it was just an overlay
			CivilDebateWall.state.lastView = flagOverlayView;
						
			flagOverlay.tweenOut();
			flagTimerBar.tweenOut();			
			flagInstructions.tweenOut();
			flagYesButton.tweenOut();
			flagNoButton.tweenOut();			
		}
		
		private function incrementFlags(e:Event):void {
			// stop the bar
			flagInstructions.setText('FLAGGED FOR REVIEW. WE WILL LOOK INTO IT.');
			flagTimerBar.pause();
			flagTimerBar.tweenOut(-1, {alpha: 0, y: flagTimerBar.y}); // just fade out 
			
			// modify it on the server
			
			
			flagYesButton.disable();
			flagYesButton.showOutline(false);
			flagYesButton.setBackgroundColor(Assets.COLOR_GRAY_75);
			
			flagNoButton.disable();
			flagNoButton.showOutline(false);
			
			// Wait and then go back
			FunctionUtil.doAfterDelay(removeFlagOverlayView, 2000);
		}
				
		
		
		// =========================================================================
		
		
		// For inter-debate transitions initiated by the debate picker...
		// tweens everything out except the portrait, then tweens stuff back in
		// TODO get rid of this?
		public function transitionView(...args):void {
		//	markAllInactive();
			
			
			// are we going from debate to debate?
			if (CivilDebateWall.state.activeView == CivilDebateWall.state.lastView) {
				// are we going in the next direction?
				
				
				// 
				
				// are we going in the previous direction
//				nextDebate();
				
				
			}
			
			
//			portrait.setImage(CDW.database.getActivePortrait());
//			question.setTextColor(CDW.state.questionTextColor);			
//			
//			portrait.tweenIn(0.5, {delay: 0.5, onComplete: onViewTransitionComplete});

//			question.tweenIn();			
//			debateStrip.tweenIn();			
//			
//			leftQuote.tweenOut(0.25);
//			rightQuote.tweenOut(0.25);
//			opinion.tweenOut(0.25);
//			stance.tweenOut(0.25);
//			nametag.tweenOut(0.25);
//			bigButton.tweenOut(0.25);
//			statsButton.tweenOut(0.25);
//			likeButton.tweenOut(0.25);
//			debateButton.tweenOut(0.25);
//			flagButton.tweenOut(0.25);
//			viewDebateButton.tweenOut(0.25);			
			
			
			//tweenOutInactive();	
		}
		
		private function onViewTransitionComplete():void {
			// tween stuff back in
			homeView();
		}
		
		

		private var smsCheckTimer:Timer;
		
		public function smsPromptView(...args):void {
			CivilDebateWall.state.lastView = CivilDebateWall.state.activeView;
			CivilDebateWall.state.activeView = smsPromptView;
			markAllInactive();
			
			CivilDebateWall.inactivityTimer.arm();
			
			// mutations
			smsInstructions.setBackgroundColor(CivilDebateWall.state.userStanceColorLight, true);
			characterLimit.setBackgroundColor(CivilDebateWall.state.userStanceColorLight, true);
			
			exitButton.y = 1000;
			exitButton.setBackgroundColor(CivilDebateWall.state.userStanceColorDark, true);
			exitButton.setDownColor(CivilDebateWall.state.userStanceColorMedium);			
			

			
			if (CivilDebateWall.state.userIsDebating) {
				bigButton.setText('DEBATE ME', true);				
			}
			else {
				bigButton.setText('ADD YOUR OPINION', true);				
			}
			
			// behaviors
			exitButton.setOnClick(homeView); // TODO do we need the back button?
			portrait.setImage(Assets.portraitPlaceholder);
			//question.setTextColor(CDW.state.questionTextColor);			

			//
			
			// start polling to see if the user has sent their opinion yet
			CivilDebateWall.data.fetchLatestTextMessages(onLatestMessagesFetched);
			
			// blocks
			portrait.tweenIn();
			
			questionHeaderHome.tweenIn();
			bigButton.tweenIn();
			yesButton.tweenIn();
			noButton.tweenIn();
			exitButton.tweenIn();
			smsInstructions.tweenIn();
			characterLimit.tweenIn();
			smsDisclaimer.tweenIn();
			skipTextButton.tweenIn(); // TEMP for debug, TODO put on setting switch
			
			
			// push the character limit down
			pickStanceInstructions.tweenOut(-1, {x: OldBlockBase.OFF_LEFT_EDGE, y: pickStanceInstructions.y});
			
	
			tweenOutInactive();			
		}
		
		private function onLatestMessagesFetched():void {
			trace("latest baseline messages fetched...");
			
			if(CivilDebateWall.data.latestTextMessages.length > 0) {
				CivilDebateWall.state.lastTextMessageTime = CivilDebateWall.data.latestTextMessages[0].created;	
			}
			else {
				// edge case, no messages, anything will be newer
				trace("No messages yet.");
				CivilDebateWall.state.lastTextMessageTime = new Date(1900, 1, 1, 12, 0, 0, 0); // the distant past...
			}

			// start checking for new messages every second
			smsCheckTimer = new Timer(1000);
			smsCheckTimer.addEventListener(TimerEvent.TIMER, onSmsCheckTimer);
			smsCheckTimer.start();			
		}

		
		private function onSmsCheckTimer(e:TimerEvent):void {
			trace('fetcheding latest sms');
			CivilDebateWall.data.fetchLatestTextMessages(onSMSCheckResponse);
			smsCheckTimer.stop();
		}
		
		
		private function onSMSCheckResponse():void {
			trace('latest sms fetched');
			
			// Grab a newer message
			if ((CivilDebateWall.data.latestTextMessages.length > 0) && (CivilDebateWall.data.latestTextMessages[0].created > CivilDebateWall.state.lastTextMessageTime)) {
				trace("got SMS");		
				
				// check for profanity, TODO move this to check SMS
				if (CivilDebateWall.data.latestTextMessages[0].profane) {
					// scold for five seconds
					smsReceivedProfanityWarning.tweenIn();
					TweenMax.delayedCall(5, function():void { smsReceivedProfanityWarning.tweenOut(-1, {x: OldBlockBase.OFF_RIGHT_EDGE})});					
					
					// reset time baseline
					CivilDebateWall.state.lastTextMessageTime = CivilDebateWall.data.latestTextMessages[0].created; 
					
					// keep checking
					trace("Bad words! keep trying");
					smsCheckTimer.reset();
					smsCheckTimer.start();						
				}
				else {
					trace("it's clean");
					handleSMS(CivilDebateWall.data.latestTextMessages[0]);
				}
			}
			else {
				trace("no new SMS, keep trying");
				smsCheckTimer.reset();
				smsCheckTimer.start();						
			}
		}
		
		
		private function handleSMS(sms:TextMessage):void {
			// check for user
			CivilDebateWall.state.textMessage = sms; // save for later
			trace("Checking for " + sms.phoneNumber);
			
			CivilDebateWall.state.userOpinion = CivilDebateWall.state.textMessage.text; // TODO truncate this?			
			CivilDebateWall.state.userPhoneNumber = CivilDebateWall.state.textMessage.phoneNumber;
			
			var tempUser:User = CivilDebateWall.data.getUserByPhoneNumber(sms.phoneNumber); // TODO check server instead
			
			if (tempUser != null) {
				trace("user exists");
				// user exists...
				// they must have a username
				// but do they have a photo?
				CivilDebateWall.state.userName = tempUser.username;
				CivilDebateWall.state.userPhoneNumber = tempUser.phoneNumber;
				CivilDebateWall.state.userID = tempUser.id;
				
				var imageFile:File = new File(CivilDebateWall.settings.imagePath + CivilDebateWall.state.userID + '.jpg');
				
				if (imageFile.exists) {
					// have a photo, load it
					// TODO jsut pull it from user object...
					FileUtil.loadImageAsync(imageFile.url, onUserImageLoaded);					
				}
				else {
					// no photo, go take one
					photoBoothView();
				}
			}
			else {
				trace("no user");
				// no user, go to photo booth
				photoBoothView();
			}
		}
		

		
		private function onUserImageLoaded(b:Bitmap):void {
			CivilDebateWall.state.userImage = b;
			portrait.setImage(CivilDebateWall.state.userImage);
			//question.setTextColor(CDW.state.questionTextColor);
			//go straight to verification;
			//verifyOpinionView();
		}
		
		public function simulateSMS(e:Event):void {
			if(smsCheckTimer != null) smsCheckTimer.stop();
			//var testTextMessage:TextMessage = new TextMessage({'message': Utilities.dummyText(100), 'phoneNumber': '415' + Utilities.randRange(1000000, 9999999).toString(), 'created': '2011-09-07 17:31:44'});
			var testTextMessage:TextMessage = new TextMessage({'message': '', 'phoneNumber': '555' + Math2.randRange(1000000, 9999999).toString(), 'created': '2011-09-07 17:31:44'});			
			handleSMS(testTextMessage);
		}

		
		
		// =========================================================================		
		

		
		
		public function nameEntryView(...args):void {
			CivilDebateWall.state.lastView = CivilDebateWall.state.activeView;
			CivilDebateWall.state.activeView = nameEntryView;			
			markAllInactive();
			flashOverlay.active = true; // needs to tween out itself
			usernameTakenWarning.active = true;
			
			CivilDebateWall.inactivityTimer.arm();
			
			// mutations			
			nameEntryInstructions.setBackgroundColor(CivilDebateWall.state.userStanceColorLight, true);
			saveButton.setBackgroundColor(CivilDebateWall.state.userStanceColorDark, true);
			saveButton.setDownColor(CivilDebateWall.state.userStanceColorMedium);			
			keyboard.setColor(CivilDebateWall.state.userStanceColorLight, true);
			keyboard.showSpacebar(false);
			nameEntryField.setBackgroundColor(CivilDebateWall.state.userStanceColorLight, true);
			portrait.setImage(CivilDebateWall.state.userImage, true);
			//question.setTextColor(CDW.state.questionTextColor);			
			nameEntryField.setText('', true); // clear the name entry field			
			keyboard.target = nameEntryField.getTextField();
			
			nameEntryField.setOnLimitReached(onLimitReached);
			nameEntryField.setOnLimitUnreached(onLimitUnreached);			
			
			
			// behaviors
			saveButton.setOnClick(onSaveName);
			
			// blocks, no delay since it needs to happen during the flash!
			portrait.tweenIn(0);			
			
			
			questionHeaderHome.tweenIn(0);
			
			nameEntryInstructions.tweenIn(-1, {delay: 1});
			
			nameEntryField.tweenIn(-1, {delay: 1});
			
			saveButton.y = 1197;
			saveButton.tweenIn(-1, {delay: 1, x: 308});
			keyboard.tweenIn(-1, {delay: 1});
			
			tweenOutInactive(true);			
		}
		
		private function onLimitReached(e:Event):void {
			characterLimitWarning.tweenIn();			
		}
		
		private function onLimitUnreached(e:Event):void {
			characterLimitWarning.tweenOut(-1, {x: OldBlockBase.OFF_RIGHT_EDGE});			
		}		
		
		
		private function onNameNotEmpty(e:Event):void {
			noNameWarning.tweenOut(-1, {x: OldBlockBase.OFF_RIGHT_EDGE});
			nameEntryField.setOnNotEmpty(null);
		}
		
		private function onSaveName(e:Event):void {
			// trim white space
			nameEntryField.getTextField().text = StringUtil.trim(nameEntryField.getTextField().text);
			
			if (nameEntryField.getTextField().length == 0) {
				noNameWarning.tweenIn();
				nameEntryField.setOnNotEmpty(onNameNotEmpty);
			}
			else {
				// Validates
				// Save name to RAM
				CivilDebateWall.state.userName = nameEntryField.getTextField().text;
				
				// Try to create the user, check for existing username
				CivilDebateWall.data.createUser(CivilDebateWall.state.userName, CivilDebateWall.state.userPhoneNumber, onUserCreated);
				
			}
		}
		
		private function onUserCreated(r:Object):void {
			if (r['error'] == null) {
				// It worked!
				var tempUser:User = new User(r);
				CivilDebateWall.state.userID = tempUser.id;
				//verifyOpinionView();
			}
			else {
				// there was an error, the name probably already existed!
				usernameTakenWarning.tweenIn();
				TweenMax.delayedCall(5, function():void { usernameTakenWarning.tweenOut(-1, {x: OldBlockBase.OFF_RIGHT_EDGE}); });
				nameEntryView(); // make sure we stay here!
				
			}
		}
		
		
		// =========================================================================
		
		

	
		
		// =========================================================================
		
		
		public function submitOverlayView(...args):void {
			CivilDebateWall.state.lastView = CivilDebateWall.state.activeView;
			CivilDebateWall.state.activeView = submitOverlayView;
			
			// mutations			
			// TODO HOW TO HANDLE OVERLAYS ON OVERLAYS? IS IT ALREADY SUBMITTED AT THIS POINT/
			CivilDebateWall.inactivityTimer.arm();
			
			// mutations
			submitOverlayMessage.setBackgroundColor(CivilDebateWall.state.userStanceColorLight, true);
			//submitOverlayContinueButton.setBackgroundColor(CDW.state.userStanceColorDark, true);
			//submitOverlayContinueButton.setDownColor(CDW.state.userStanceColorMedium);			
			
			// behaviors
			//submitOverlayContinueButton.setOnClick(onSubmitContinue);
			
			// blocks
			submitOverlay.tweenIn();
			
			submitOverlayMessage.tweenIn(-1, {onComplete: submitDebate}); // submit it automatically after animation
			//submitOverlayContinueButton.tweenIn();
			
			

			
			bigButton.tweenOut();
			
			opinion.tweenOut();
			retakePhotoButton.tweenOut();
			editTextButton.tweenOut();
			exitButton.tweenOut();	
		}
		
		
		
		private function submitDebate():void {
			// Syncs state up to the cloud
			
			// save the images to disk, one full res and one scaled and cropped 
			if(CivilDebateWall.state.userImageFull != null) FileUtil.saveJpeg(CivilDebateWall.state.userImageFull, CivilDebateWall.settings.imagePath, CivilDebateWall.state.userID + '-full.jpg');			
			var imageName:String = FileUtil.saveJpeg(CivilDebateWall.state.userImage, CivilDebateWall.settings.imagePath, CivilDebateWall.state.userID + '.jpg');
			var payload:Object;
			
			if (CivilDebateWall.state.userIsDebating) {
				// create and upload new comment
				trace("Uploading response post");
				
				// TODO "userInProgress" and "postInProgress" objects in state
				// TODO need to set "CDW.state.userRespondingTo"
				
				trace("Responding to: " + CivilDebateWall.state.userRespondingTo.id);
				
				CivilDebateWall.data.uploadResponse(CivilDebateWall.state.activeThread.id, CivilDebateWall.state.userRespondingTo.id, CivilDebateWall.state.userID, CivilDebateWall.state.userOpinion, CivilDebateWall.state.userStance, Post.ORIGIN_KIOSK, onDebateUploaded);
			}
			else {
				// create and upload new debate
				trace("Uploading new thread");				
				CivilDebateWall.data.uploadThread(CivilDebateWall.data.question.id, CivilDebateWall.state.userID, CivilDebateWall.state.userOpinion, CivilDebateWall.state.userStance, Post.ORIGIN_KIOSK, onDebateUploaded);
			}			
		}
		
		
		private function onDebateUploaded(r:Object):void {
			trace("submitting");
			//submitOverlayContinueButton.tweenOut(-1, {alpha: 0, x: submitOverlayContinueButton.x, y: submitOverlayContinueButton.y});
			
			if (CivilDebateWall.state.activeThread != null) {
				CivilDebateWall.state.activeThreadID = CivilDebateWall.state.activeThread.id; // store the strings since objects will be wiped
				CivilDebateWall.state.activeThread = null;
			}
			
			if (CivilDebateWall.state.activePost != null) {			
				CivilDebateWall.state.activePostID = CivilDebateWall.state.activePost.id; // store the strings since objects will be wiped				
				CivilDebateWall.state.activePost = null;			
			}			
			
			CivilDebateWall.data.load();
		}
		
		
		// =========================================================================		
		
		
		public function editOpinionView(...args):void {
			CivilDebateWall.state.lastView = CivilDebateWall.state.activeView;
			CivilDebateWall.state.activeView = editOpinionView;			
			markAllInactive();
			
			CivilDebateWall.inactivityTimer.arm();
			
			// mutations
			editOpinion.setText(CivilDebateWall.state.userOpinion);

			keyboard.target = editOpinion.getTextField();
			keyboard.showSpacebar(true);
			
			editTextInstructions.setBackgroundColor(CivilDebateWall.state.userStanceColorDark, true);
			
			saveButton.setBackgroundColor(CivilDebateWall.state.userStanceColorDark, true);
			saveButton.setDownColor(CivilDebateWall.state.userStanceColorMedium);			
			
			editOpinion.setBackgroundColor(CivilDebateWall.state.userStanceColorLight);
			
			
			
			// behaviors
			saveButton.setOnClick(onSaveOpinionEdit);
			editOpinion.setOnLimitReached(onLimitReached);
			editOpinion.setOnLimitUnreached(onLimitUnreached);
			editOpinion.setOnNumLinesChange(onNumLinesChange);			
			
			//blocks		
			portrait.tweenIn();	

			//question.tweenIn();
			

			
			//opinion.tweenIn(); // TODO fade this out?
			editOpinion.y = stageHeight - 574 - opinion.height; 			
			editOpinion.tweenIn(); // instant
			
			saveButton.y = 1376;
			saveButton.tweenIn(-1, {x: 589});
			
			editTextInstructions.y = editOpinion.y - editTextInstructions.height - 30; 
			//editTextInstructions.tweenIn(); // disabled per latest design
			keyboard.tweenIn();
			
			opinion.tweenOut(0);
			
			tweenOutInactive();			
		}	
		
		private function onNumLinesChange(e:Event):void {
			// flow upwards
			TweenMax.to(editOpinion, 0.5, {y: stageHeight - 574 - editOpinion.height, ease: Quart.easeInOut});
			TweenMax.to(editTextInstructions, 0.5, {y: (stageHeight - 574 - editOpinion.height) - editTextInstructions.height - 30, ease: Quart.easeInOut});
		}
			
		
		private function onSaveOpinionEdit(e:Event):void {
			// Validate
			editOpinion.getTextField().text = StringUtil.trim(editOpinion.getTextField().text);
			CivilDebateWall.state.userOpinion = editOpinion.getTextField().text
			
			if (editOpinion.getTextField().length == 0) {
				noOpinionWarning.tweenIn();
				editOpinion.setOnNotEmpty(onOpinionNotEmpty);
			}
			else {
				// valid
				// move the opinion back
				opinion.tweenIn(0);
				//verifyOpinionView();				
			}
		}
		
		private function onOpinionNotEmpty(e:Event):void {
			noOpinionWarning.tweenOut(-1, {x: OldBlockBase.OFF_RIGHT_EDGE});
			nameEntryField.setOnNotEmpty(null);
		}
				
		
		
		// =========================================================================
		

		
		public function statsView(...args):void {
			CivilDebateWall.state.lastView = CivilDebateWall.state.activeView;
			CivilDebateWall.state.activeView = statsView;	
			markAllInactive();
			
			
			CivilDebateWall.inactivityTimer.disarm();
			
			// mutations
			portrait.setImage(Assets.statsUnderlay);
			//question.setTextColor(CDW.state.questionTextColor);			
			
			// behaviors
			statsOverlay.homeButton.setOnClick(homeView);
			
			// blocks
			portrait.tweenIn();	
		
			questionHeaderHome.tweenIn();
			statsOverlay.tweenIn();

			tweenOutInactive();			
		}
		
		
		// =========================================================================		
		
		
		public function inactivityOverlayView(...args):void {
			CivilDebateWall.state.lastView = CivilDebateWall.state.activeView;
			CivilDebateWall.state.activeView = inactivityOverlayView;			
			// mutations			
			CivilDebateWall.inactivityTimer.disarm();
			
			// behaviors
			continueButton.setOnClick(onContinue);
			inactivityTimerBar.setOnComplete(homeView);
			
			// blocks
			inactivityOverlay.tweenIn();
			inactivityTimerBar.tweenIn();			
			inactivityInstructions.tweenIn();
			continueButton.tweenIn();
		}
		
		
		private function onContinue(e:Event):void {
			CivilDebateWall.state.activeView = CivilDebateWall.state.lastView ;
			CivilDebateWall.state.lastView = inactivityOverlayView; // revert since it's an overlay
			
			CivilDebateWall.inactivityTimer.arm();
			inactivityOverlay.tweenOut();
			inactivityTimerBar.tweenOut();
			inactivityInstructions.tweenOut();
			continueButton.tweenOut();			
		}
		
		
		// =========================================================================
		
		// View utilities
		private function setTestOverlay(b:Bitmap):void {
			Kiosk.testOverlay.bitmapData = b.bitmapData.clone();						
		}	
		

		private function markAllInactive():void {
			// other housekeeping, TODO break this into its own function?
			if(smsCheckTimer != null) smsCheckTimer.stop();					

			// marks all FIRST LEVEL blocks as inactive
			for (var i:int = 0; i < this.numChildren; i++) {
				//if ((this.getChildAt(i) is BlockBase) && (this.getChildAt(i).visible)) {
				// attempt to fix blank screen issue....
				if (this.getChildAt(i) is OldBlockBase) {				
					(this.getChildAt(i) as OldBlockBase).active = false;
				}
								
				// Run on the new block base too, this is ugly...				
				if (this.getChildAt(i) is BlockBase) {				
					(this.getChildAt(i) as BlockBase).active = false;
				}
			}
		}
		
		
		private function tweenOutInactive(instant:Boolean = false):void {	
			for (var i:int = 0; i < this.numChildren; i++) {
				if ((this.getChildAt(i) is OldBlockBase) && !(this.getChildAt(i) as OldBlockBase).active) {
					if (instant)
						(this.getChildAt(i) as OldBlockBase).tweenOut(0);
					else
						(this.getChildAt(i) as OldBlockBase).tweenOut();
				}
			}
			
			
			// Run on the new block base too, this is ugly...
			for (i = 0; i < this.numChildren; i++) {
				if ((this.getChildAt(i) is BlockBase) && !(this.getChildAt(i) as BlockBase).active) {
					if (instant)
						(this.getChildAt(i) as BlockBase).tweenOut(0);
					else
						(this.getChildAt(i) as BlockBase).tweenOut();
				}
			}		
			

		}
		
	}
}
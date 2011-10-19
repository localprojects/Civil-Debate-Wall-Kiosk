package com.civildebatewall {
	import com.adobe.serialization.json.*;
	import com.civildebatewall.blocks.*;
	import com.civildebatewall.camera.*;
	import com.civildebatewall.data.*;
	import com.civildebatewall.elements.*;
	import com.civildebatewall.keyboard.*;
	import com.civildebatewall.ui.*;
	import com.greensock.*;
	import com.greensock.easing.*;
	import com.greensock.plugins.*;
	import com.kitschpatrol.futil.Math2;
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
	
	import jp.maaash.ObjectDetection.ObjectDetectorEvent;

	public class View extends Sprite {
				
		// immutable
		private var header:BlockBitmap;
		private var divider:BlockBitmap;
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
		
		// mutable (e.g. color changes)
		private var nameEntryInstructions:BlockLabel;		
		private var saveButton:BlockButton;		
		private var retakePhotoButton:BlockButton;
		private var editTextButton:BlockButton;
		private var editTextInstructions:BlockLabel;
		private var cameraOverlay:CameraOverlay;
		public var quoteLeft:BlockBitmapPlus;
		public var quoteRight:BlockBitmapPlus;
		public var statsButton:IconButton;
		public var flagButton:IconButton;		
		public var debateButton:BalloonButton;
		private var secondaryDebateButton:BalloonButton;		
		private var yesButton:BlockButton;
		private var noButton:BlockButton;
		private var exitButton:BlockButton;				
		private var characterLimit:BlockLabelBar;
		private var photoBoothNag:BlockLabel;
		private var photoBoothButton:BlockButton;
		private var countdownButton:CountdownButton;		
		private var keyboard:Keyboard;
		private var submitOverlayContinueButton:BlockButton;				
		private var submitOverlayMessage:BlockParagraph;
		
		// mutable, dynamic content (e.g. text changes based on database)
		private var nameEntryField:BlockInputLabel; // changes dimensions
		private var question:QuestionText; // changes dimensions
		public var portrait:Portrait;
		private var bigButton:BigButton;
		public var likeButton:CounterButton;
		public var viewDebateButton:BlockButton;
		private var editOpinion:BlockInputParagraph; // changes dimensions 
		private var byline:BlockLabel; // changes dimensions
		
		// containers, have lots of nested content
		public var statsOverlay:StatsOverlay;
		public var debateStrip:DebateStrip;
		public var debateOverlay:DebateOverlay;		

		// multiples of these for the drag transitions
		public var stance:BlockLabel;
		public var leftStance:BlockLabel;
		public var rightStance:BlockLabel;		
		public var nametag:NameTag;
		public var leftNametag:NameTag;
		public var rightNametag:NameTag;		
		public var opinion:BlockParagraph;
		public var leftOpinion:BlockParagraph;		
		public var rightOpinion:BlockParagraph;
		
		// mouse protection during tweens
		public var protection:Sprite;
		
		// convenience
		public var stageWidth:Number;
		public var stageHeight:Number;
		private var yesLetterSpacing:Number;
		private var noLetterSpacing:Number;		
		
		public function View() {
			super();
			init();
		}
		
		private function init():void {
			// for convenience
			stageWidth = 1080;
			stageHeight = 1920;
			yesLetterSpacing = -4;
			noLetterSpacing = -7;			
			
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
			
			letsDebateUnderlay = new BlockBitmap(new Bitmap(new BitmapData(1022, 577, false, 0xffffff)));
			letsDebateUnderlay.mouseEnabled = false; // let keystrokes through to the keyboard
			letsDebateUnderlay.x = 30;
			letsDebateUnderlay.y = 249;
			letsDebateUnderlay.setDefaultTweenIn(1, {alpha: 0.9, ease: Quart.easeOut});
			letsDebateUnderlay.setDefaultTweenOut(1, {alpha: 0, ease: Quart.easeOut});
			addChild(letsDebateUnderlay);				
			
			
			header = new BlockBitmap(Assets.getHeaderBackground());			
			header.setDefaultTweenIn(1, {x: BlockBase.CENTER, y: 30});
			header.setDefaultTweenOut(1, {x: BlockBase.CENTER, y: BlockBase.OFF_TOP_EDGE});
			addChild(header);
			
			divider = new BlockBitmap(Assets.divider);
			divider.setDefaultTweenIn(1, {alpha: 1, x: BlockBase.CENTER, y: 250});
			divider.setDefaultTweenOut(1, {alpha: 0, x: BlockBase.CENTER, y: 250});
			addChild(divider);
			
			question = new QuestionText();
			question.setDefaultTweenIn(1, {x: BlockBase.CENTER, y: 123});
			question.setDefaultTweenOut(1, {x: BlockBase.OFF_LEFT_EDGE});
			question.setText(CDW.data.question.text);
			addChild(question);
			
			// triple stances
			stance= new BlockLabel('', 92, 0xffffff, 0x000000);
			stance.setPadding(24, 36, 23, 30);
			
			stance.considerDescenders = false;
			stance.setDefaultTweenIn(1, {x: 238, y: 280});
			stance.setDefaultTweenOut(1, {x: BlockBase.OFF_LEFT_EDGE, y: 280});			
			addChild(stance);			
			
			leftStance = new BlockLabel('', 92, 0xffffff, 0x000000);
			leftStance.setPadding(24, 36, 23, 30);		
			leftStance.considerDescenders = false;
			leftStance.setDefaultTweenIn(1, {x: stance.defaultTweenInVars.x - stageWidth, y: stance.defaultTweenInVars.y});						
			addChild(leftStance);

			rightStance= new BlockLabel('', 92, 0xffffff, 0x000000);
			rightStance.setPadding(24, 36, 23, 30);
			rightStance.considerDescenders = false;			
			rightStance.setDefaultTweenIn(1, {x: stance.defaultTweenInVars.x + stageWidth, y: stance.defaultTweenInVars.y});						
			addChild(rightStance);			
			
			// triple nametags
			nametag = new NameTag('Name', 50, 0xffffff, 0x000000, Assets.FONT_HEAVY, true);	
			nametag.setPadding(33, 38, 24, 38);
			nametag.setDefaultTweenIn(1, {x: 238, y: 410});
			nametag.setDefaultTweenOut(1, {x: BlockBase.OFF_LEFT_EDGE, y: 410});
			addChild(nametag);
			
			leftNametag = new NameTag('Name', 50, 0xffffff, 0x000000, Assets.FONT_HEAVY, true);
			leftNametag.setPadding(33, 38, 24, 38);
			leftNametag.setDefaultTweenIn(1, {x: nametag.defaultTweenInVars.x - stageWidth, y: nametag.defaultTweenInVars.y});
			addChild(leftNametag);
			
			rightNametag = new NameTag('Name', 50, 0xffffff, 0x000000, Assets.FONT_HEAVY, true);
			rightNametag.setPadding(33, 38, 24, 38);
			rightNametag.setDefaultTweenIn(1, {x: nametag.defaultTweenInVars.x + stageWidth, y: nametag.defaultTweenInVars.y});
			addChild(rightNametag);

			byline = new BlockLabel('Byline', 22, 0xffffff, 0x000000, Assets.FONT_HEAVY, true);
			byline.setPadding(18, 32, 16, 32);
			byline.setDefaultTweenIn(1, {x: 586});
			byline.setDefaultTweenOut(1, {x: BlockBase.OFF_LEFT_EDGE	});			
			addChild(byline);
			
			quoteLeft = new BlockBitmapPlus(Assets.getQuoteLeft());
			quoteLeft.setDefaultTweenIn(1, {x: 114, y: 545});
			quoteLeft.setDefaultTweenOut(1, {x: BlockBase.OFF_LEFT_EDGE, y: 545});	
			addChild(quoteLeft);
			
			quoteRight = new BlockBitmapPlus(Assets.getQuoteRight());
			quoteRight.setDefaultTweenIn(1, {x: 660, y: 1636});
			quoteRight.setDefaultTweenOut(1, {x: BlockBase.OFF_RIGHT_EDGE, y: 1636});				
			addChild(quoteRight);
			
			// triple opinions
			opinion = new BlockParagraph(915, 0x000000, '', 42);	
			opinion.setDefaultTweenIn(1, {x: 101});
			opinion.setDefaultTweenOut(1, {x: BlockBase.OFF_LEFT_EDGE});
			addChild(opinion);
			
			rightOpinion = new BlockParagraph(915, 0x000000, '', 42);
			rightOpinion.setDefaultTweenIn(1, {x: opinion.defaultTweenInVars.x + stageWidth});
			rightOpinion.setDefaultTweenOut(1, {x: opinion.defaultTweenInVars.x + stageWidth});
			addChild(rightOpinion);
			
			leftOpinion = new BlockParagraph(915, 0x000000, '', 42);	
			leftOpinion.setDefaultTweenIn(1, {x: opinion.defaultTweenInVars.x - stageWidth});
			leftOpinion.setDefaultTweenOut(1, {x: opinion.defaultTweenInVars.x - stageWidth});
			addChild(leftOpinion);		
			
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
			
			bigButton = new BigButton('ADD YOUR OPINION');
			bigButton.setDefaultTweenIn(1, {x: 455, y: 1470, alpha: 1});
			bigButton.setDefaultTweenOut(1, {x: 455, y: 1470, alpha: 0}); // TODO possibly subclass for cooler in and out tweens
			addChild(bigButton);
			
			statsButton = new IconButton(119, 63, 0x000000, 'Stats', 20, 0xffffff, Assets.FONT_BOLD, Assets.statsIcon);
			statsButton.setDefaultTweenIn(1, {x: 101, y: 1376});
			statsButton.setDefaultTweenOut(1, {x: BlockBase.OFF_LEFT_EDGE, y: 1376});
			addChild(statsButton);
			
			likeButton = new CounterButton(148, 63, 0x000000, 'Like', 20, 0xffffff, Assets.FONT_BOLD);
			likeButton.setTimeout(15000);
			likeButton.setDefaultTweenIn(1, {x: 238, y: 1376});
			likeButton.setDefaultTweenOut(1, {x: BlockBase.OFF_LEFT_EDGE, y: 1376});			
			addChild(likeButton);
			
			viewDebateButton = new BlockButton(492, 63, 0x000000, '', 20, 0xffffff, Assets.FONT_BOLD);
			viewDebateButton.shiftBaseline(2);
			viewDebateButton.setDefaultTweenIn(1, {x: 404, y: 1376});
			viewDebateButton.setDefaultTweenOut(1, {x: BlockBase.OFF_RIGHT_EDGE, y: 1376});			
			addChild(viewDebateButton);
			
			flagButton = new IconButton(67, 63, 0x000000, '', 20, 0xffffff, null, Assets.flagIcon);
			flagButton.setTimeout(15000);			
			flagButton.setDefaultTweenIn(1, {x: 914, y: 1376});
			flagButton.setDefaultTweenOut(1, {x: BlockBase.OFF_RIGHT_EDGE, y: 1376});
			addChild(flagButton);			
			
//			debateButton = new BalloonButton(152, 135, 0x000000, 'LET\u2019S\nDEBATE !', 22, 0xffffff, Assets.FONT_HEAVY);
//			debateButton.setDefaultTweenIn(1, {x: 813, scaleX: 1, scaleY: 1});
//			debateButton.setDefaultTweenOut(1, {x: BlockBase.OFF_RIGHT_EDGE, scaleX: 1, scaleY: 1});
//			addChild(debateButton);
			
			debateButton = new BalloonButton(152, 135, 0x000000, 'LET\u2019S\nDEBATE !', 22, 0xffffff, Assets.FONT_HEAVY);
			debateButton.setDefaultTweenIn(1, {x: 813, scaleX: 1, scaleY: 1});
			debateButton.setDefaultTweenOut(1, {x: BlockBase.OFF_RIGHT_EDGE, scaleX: 1, scaleY: 1});
			addChild(debateButton);			
			
			secondaryDebateButton = new BalloonButton(152, 135, 0x000000, 'LET\u2019S\nDEBATE !', 22, 0xffffff, Assets.FONT_HEAVY);
			secondaryDebateButton.setStrokeColor(Assets.COLOR_GRAY_15);
			secondaryDebateButton.scaleX = 0.75;  
			secondaryDebateButton.scaleY = 0.75; 				
			secondaryDebateButton.setDefaultTweenIn(1, {x: 909});
			secondaryDebateButton.setDefaultTweenOut(1, {x: BlockBase.OFF_RIGHT_EDGE});
			addChild(secondaryDebateButton);	
			
			debateOverlay = new DebateOverlay();
			debateOverlay.setDefaultTweenIn(1, {x: 30, y: 813});
			debateOverlay.setDefaultTweenOut(1, {x: 30, y: BlockBase.OFF_BOTTOM_EDGE});			
			addChild(debateOverlay);			
			
			debateStrip = new DebateStrip();
			debateStrip.setDefaultTweenIn(1, {x: 0, y: 1714});
			debateStrip.setDefaultTweenOut(1, {x: 0, y: BlockBase.OFF_BOTTOM_EDGE});			
			debateStrip.update();
			addChild(debateStrip);
			
			pickStanceInstructions = new BlockLabelBar('Your Answer / Please Select One :', 19, 0xffffff, 367, 63, Assets.COLOR_GRAY_85, Assets.FONT_REGULAR);
			pickStanceInstructions.setDefaultTweenIn(1, {x: 670, y: 1243});
			pickStanceInstructions.setDefaultTweenOut(1, {x: BlockBase.OFF_RIGHT_EDGE, y: 1243});					
			addChild(pickStanceInstructions);
			
			yesButton = new BlockButton(215, 100, Assets.COLOR_YES_LIGHT, 'YES!', 80);
			yesButton.shiftBaseline(3);
			yesButton.setLetterSpacing(yesLetterSpacing);
			yesButton.setDefaultTweenIn(1, {x: 447, y: 1340});
			yesButton.setDefaultTweenOut(1, {x: BlockBase.OFF_LEFT_EDGE, y: 1340});
			addChild(yesButton);
			
			noButton = new BlockButton(185, 100, Assets.COLOR_NO_LIGHT, 'NO!', 80);
			noButton.shiftBaseline(3);			
			noButton.setLetterSpacing(noLetterSpacing);
			noButton.setDefaultTweenIn(1.2, {x: 677, y: 1340});
			noButton.setDefaultTweenOut(1.2, {x: BlockBase.OFF_RIGHT_EDGE, y: 1340});
			addChild(noButton);
			
			// Temp debug button so we don't have to SMS every time
			skipTextButton = new BlockButton(200, 100, Assets.COLOR_GRAY_85, 'SIMULATE SMS', 20);
			skipTextButton.setDefaultTweenIn(1, {x: BlockBase.CENTER, y: 500});
			skipTextButton.setDefaultTweenOut(1, {x: BlockBase.OFF_RIGHT_EDGE, y: 500});
			skipTextButton.alpha = 1; // start hidden
			skipTextButton.setOnClick(simulateSMS);				
			//skipTextButton.setOnClick(null); // start off
			addChild(skipTextButton);

			// broken apart for easy measurability
			var smsInstrucitonPrefix:String = 'What would you say to convince others of your opinion?\nText ';
			var smsInstrucitonPostfix:String = ' with your statement.';			
			var smsPhoneNumber:String = NumberUtil.formatPhoneNumber(CDW.data.smsNumber);
			var smsInstructionText:String = smsInstrucitonPrefix + smsPhoneNumber + smsInstrucitonPostfix;
			smsInstructions = new BlockParagraph(915, 0x000000, smsInstructionText, 30, 0xffffff, Assets.FONT_REGULAR);
			smsInstructions.textField.setTextFormat(new TextFormat(Assets.FONT_HEAVY), smsInstrucitonPrefix.length, smsInstrucitonPrefix.length + smsPhoneNumber.length);			
			smsInstructions.setDefaultTweenIn(1, {x: 101, y: 1096});
			smsInstructions.setDefaultTweenOut(1, {x: BlockBase.OFF_LEFT_EDGE, y: 1096});
			addChild(smsInstructions);
			
			var smsDisclaimerText:String = 'You will receive an SMS notifying you of any future opponents \nwho would like to enter into a debate with you based on your opinion. \nYou can opt out at any time by replying STOP.';
			smsDisclaimer = new BlockParagraph(915, Assets.COLOR_GRAY_75, smsDisclaimerText, 24);
			smsDisclaimer.textField.setTextFormat(new TextFormat(null, null, 0xc7c8ca), smsDisclaimerText.length -45, smsDisclaimerText.length);
			smsDisclaimer.setDefaultTweenIn(1, {x: 101, y: 1625});
			smsDisclaimer.setDefaultTweenOut(1, {x: BlockBase.OFF_LEFT_EDGE, y: 1625});
			addChild(smsDisclaimer);
			
			// y value is dynamic
			exitButton = new BlockButton(125, 63, 0x000000, 'EXIT', 26, 0xffffff, Assets.FONT_HEAVY);
			exitButton.setDefaultTweenIn(1, {x: 103});
			exitButton.setDefaultTweenOut(1, {x: BlockBase.OFF_LEFT_EDGE});			
			addChild(exitButton);
			

			characterLimit = new BlockLabelBar('Use No More than ' + CDW.settings.characterLimit + ' characters', 19, 0xffffff, 367, 63, 0x000000, Assets.FONT_BOLD);			
			characterLimit.setDefaultTweenIn(1, {x: 670, y: 1243});
			characterLimit.setDefaultTweenOut(1, {x: BlockBase.OFF_RIGHT_EDGE, y: 1243});					
			addChild(characterLimit);			
			
			photoBoothNag = new BlockLabel('Please look into the Camera!', 33, 0xffffff, 0x000000, Assets.FONT_BOLD);
			photoBoothNag.setDefaultTweenIn(1.5, {alpha: 1, x: BlockBase.CENTER, y: 176}); // elastic easing was over-the-top
			photoBoothNag.setDefaultTweenOut(1, {alpha: 0, x: BlockBase.CENTER, y: 176});
			addChild(photoBoothNag);			
			
			photoBoothButton = new BlockButton(398, 63, 0x000000, 'TOUCH TO COUNTDOWN', 26, 0xffffff, Assets.FONT_HEAVY);
			photoBoothButton.setDefaultTweenIn(1, {alpha: 1, x: BlockBase.CENTER, y: 1628});
			photoBoothButton.setDefaultTweenOut(1, {alpha: 0, x: BlockBase.CENTER, y: 1628});
			addChild(photoBoothButton);
			
			countdownButton = new CountdownButton(6);
			countdownButton.setDefaultTweenIn(1, {x: BlockBase.CENTER, y: 1438, scaleX: 1, scaleY: 1});
			countdownButton.setDefaultTweenOut(1, {x: BlockBase.CENTER, y: stageHeight});
			addChild(countdownButton);
			
			nameEntryInstructions = new BlockLabel('ENTER YOUR NAME', 26, 0xffffff, 0x000000, Assets.FONT_HEAVY)
			nameEntryInstructions.setPadding(20, 31, 20, 31);
			nameEntryInstructions.setDefaultTweenIn(1, {x: 101, y: 1000});
			nameEntryInstructions.setDefaultTweenOut(1, {x: BlockBase.OFF_LEFT_EDGE, y: 1003});
			addChild(nameEntryInstructions);
			
			nameEntryField = new BlockInputLabel('', 33, 0xffffff, 0x000000, Assets.FONT_REGULAR, true);
			nameEntryField.setPadding(24, 30, 20, 30);
			nameEntryField.setDefaultTweenIn(1, {x: 101, y: 1096});
			nameEntryField.setDefaultTweenOut(1, {x: BlockBase.OFF_LEFT_EDGE, y: 1096});
			addChild(nameEntryField);			
			
			// X and Y are dynamic
			saveButton = new BlockButton(335, 63, 0x000000, 'SAVE AND CONTINUE', 26, 0xffffff, Assets.FONT_HEAVY);			
			saveButton.setDefaultTweenIn(1, {});
			saveButton.setDefaultTweenOut(1, {x: BlockBase.OFF_LEFT_EDGE});
			addChild(saveButton);
			
			// Y is dynamic
			retakePhotoButton = new BlockButton(270, 63, 0x000000, 'RETAKE PHOTO', 26, 0xffffff, Assets.FONT_HEAVY);
			retakePhotoButton.setDefaultTweenIn(1, {x: 243});
			retakePhotoButton.setDefaultTweenOut(1, {x: BlockBase.OFF_LEFT_EDGE});
			addChild(retakePhotoButton);
			
			// y is dynamic
			editTextButton = new BlockButton(200, 63, 0x000000, 'EDIT TEXT', 26, 0xffffff, Assets.FONT_HEAVY);
			editTextButton.setDefaultTweenIn(1, {x: 528});
			editTextButton.setDefaultTweenOut(1, {x: BlockBase.OFF_RIGHT_EDGE});
			addChild(editTextButton);
			
			// y is dynamic
			// disabled per latest indesign file
			editTextInstructions = new BlockLabel('EDITING TEXT...', 26, 0xffffff, 0x000000, Assets.FONT_HEAVY);
			editTextInstructions.setDefaultTweenIn(1, {x: 525});
			editTextInstructions.setDefaultTweenOut(1, {x: BlockBase.OFF_LEFT_EDGE});
			addChild(editTextInstructions);			
			
			keyboard = new Keyboard();
			keyboard.setDefaultTweenIn(1, {x: 0, y: stageHeight - keyboard.height});
			keyboard.setDefaultTweenOut(1, {x: 0, y: BlockBase.OFF_BOTTOM_EDGE});
			addChild(keyboard);
			
			
			characterLimitWarning = new BlockLabel('You reached the character limit!', 26, 0xffffff, Assets.COLOR_GRAY_50, Assets.FONT_BOLD);
			characterLimitWarning.setDefaultTweenIn(1, {x: BlockBase.CENTER, y: 1562 - (characterLimitWarning.height / 2) - 10});	
			characterLimitWarning.setDefaultTweenOut(1, {x: BlockBase.OFF_LEFT_EDGE, y: 1562 - (characterLimitWarning.height / 2) - 10});
			addChild(characterLimitWarning);
			
			cameraTimeoutWarning = new BlockLabel('The camera could not focus, please try again!', 26, 0xffffff, Assets.COLOR_GRAY_50, Assets.FONT_BOLD);
			cameraTimeoutWarning.setDefaultTweenIn(1, {x: BlockBase.CENTER, y: BlockBase.CENTER});	
			cameraTimeoutWarning.setDefaultTweenOut(1, {x: BlockBase.OFF_LEFT_EDGE, y: BlockBase.CENTER});
			addChild(cameraTimeoutWarning);
			
			noNameWarning = new BlockLabel('Please enter a username!', 26, 0xffffff, Assets.COLOR_GRAY_50, Assets.FONT_BOLD);
			noNameWarning.setDefaultTweenIn(1, {x: BlockBase.CENTER, y: 1562 - (noNameWarning.height / 2) - 10});	
			noNameWarning.setDefaultTweenOut(1, {x: BlockBase.OFF_LEFT_EDGE, y: 1562 - (noNameWarning.height / 2) - 10});
			addChild(noNameWarning);
			
			usernameTakenWarning = new BlockLabel('That username is already taken!', 26, 0xffffff, Assets.COLOR_GRAY_50, Assets.FONT_BOLD);
			usernameTakenWarning.setDefaultTweenIn(1, {x: BlockBase.CENTER, y: 1562 - (noNameWarning.height / 2) - 10});	
			usernameTakenWarning.setDefaultTweenOut(1, {x: BlockBase.OFF_LEFT_EDGE, y: 1562 - (noNameWarning.height / 2) - 10});
			addChild(usernameTakenWarning);			
			
			noOpinionWarning = new BlockLabel('Please enter your opinion!', 26, 0xffffff, Assets.COLOR_GRAY_50, Assets.FONT_BOLD);
			noOpinionWarning.setDefaultTweenIn(1, {x: BlockBase.CENTER, y: 1562 - (noOpinionWarning.height / 2) - 10});	
			noOpinionWarning.setDefaultTweenOut(1, {x: BlockBase.OFF_LEFT_EDGE, y: 1562 - (noOpinionWarning.height / 2) - 10});
			addChild(noOpinionWarning);				
			
			
			var profanityNagIncoming:String = 'Please choose words that will encourage a civil debate and re-send your message!';
			smsReceivedProfanityWarning = new BlockParagraph(800, Assets.COLOR_GRAY_50, profanityNagIncoming, 26, 0xffffff, Assets.FONT_BOLD); 
			smsReceivedProfanityWarning.setDefaultTweenIn(1, {x: BlockBase.CENTER, y: 576});	
			smsReceivedProfanityWarning.setDefaultTweenOut(1, {x: BlockBase.OFF_LEFT_EDGE, y: 576});
			addChild(smsReceivedProfanityWarning);
			
			
			// TODO HOOK THIS UP?
			smsSubmittedProfanityWarning = new BlockLabel('Please choose words that will encourage a civil debate and re-submit your message!', 26, 0xffffff, Assets.COLOR_GRAY_50, Assets.FONT_BOLD);
			smsSubmittedProfanityWarning.setDefaultTweenIn(1, {x: BlockBase.CENTER, y: 576});	
			smsSubmittedProfanityWarning.setDefaultTweenOut(1, {x: BlockBase.OFF_LEFT_EDGE, y: 576});
			addChild(smsSubmittedProfanityWarning);			 
			
			
			// TODO update from database
			statsOverlay = new StatsOverlay();
			statsOverlay.setDefaultTweenIn(1, {x: 29, y: 264});
			statsOverlay.setDefaultTweenOut(1, {x: 29, y: BlockBase.OFF_BOTTOM_EDGE});
			addChild(statsOverlay);
			
			inactivityOverlay = new BlockBitmap(new Bitmap(new BitmapData(stageWidth, stageHeight, false, 0x000000)));
			inactivityOverlay.setDefaultTweenIn(1, {alpha: 0.85});
			inactivityOverlay.setDefaultTweenOut(1, {alpha: 0});
			addChild(inactivityOverlay);
			
			inactivityTimerBar = new ProgressBar(735, 2, 20);		
			inactivityTimerBar.setDefaultTweenIn(1, {x: BlockBase.CENTER, y: 1002});
			inactivityTimerBar.setDefaultTweenOut(1, {x: BlockBase.CENTER, y: BlockBase.OFF_TOP_EDGE});			
			addChild(inactivityTimerBar);
			
			inactivityInstructions = new BlockLabelBar('ARE YOU STILL THERE ?', 23, 0xffffff, 735, 63, Assets.COLOR_GRAY_75, Assets.FONT_HEAVY);
			inactivityInstructions.setDefaultTweenIn(1, {x: BlockBase.CENTER, y: 1018});
			inactivityInstructions.setDefaultTweenOut(1, {x: BlockBase.CENTER, y: BlockBase.OFF_TOP_EDGE});			
			addChild(inactivityInstructions);
			
			continueButton = new BlockButton(735, 120, Assets.COLOR_GRAY_50, 'YES!', 92);
			continueButton.setDownColor(Assets.COLOR_GRAY_75);
			continueButton.setDefaultTweenIn(1, {alpha: 1, x: BlockBase.CENTER, y: 1098});
			continueButton.setDefaultTweenOut(1, {alpha: 1, x: BlockBase.OFF_LEFT_EDGE, y: 1098});					
			addChild(continueButton);
			
			// Flag overlay
			flagOverlay = new BlockBitmap(new Bitmap(new BitmapData(stageWidth, stageHeight, false, 0x000000)));
			flagOverlay.setDefaultTweenIn(1, {alpha: 0.85});
			flagOverlay.setDefaultTweenOut(1, {alpha: 0});
			addChild(flagOverlay);
			
			flagTimerBar = new ProgressBar(735, 2, 20);		
			flagTimerBar.setDefaultTweenIn(1, {alpha: 1, x: BlockBase.CENTER, y: 1002});
			flagTimerBar.setDefaultTweenOut(1, {alpha: 1, x: BlockBase.CENTER, y: BlockBase.OFF_TOP_EDGE});			
			addChild(flagTimerBar);
			
			flagInstructions = new BlockLabelBar('FLAG AS INAPPROPRIATE ?', 23, 0xffffff, 735, 63, Assets.COLOR_GRAY_75, Assets.FONT_HEAVY);
			flagInstructions.setDefaultTweenIn(1, {x: BlockBase.CENTER, y: 1018});
			flagInstructions.setDefaultTweenOut(1, {x: BlockBase.CENTER, y: BlockBase.OFF_TOP_EDGE});			
			addChild(flagInstructions);
			
			flagYesButton = new BlockButton(360, 120, Assets.COLOR_GRAY_50, 'YES!', 92);
			flagYesButton.setDownColor(Assets.COLOR_GRAY_75);
			flagYesButton.setDefaultTweenIn(1, {x: 173, y: 1098});
			flagYesButton.setDefaultTweenOut(1, {x: BlockBase.OFF_LEFT_EDGE, y: 1098});					
			addChild(flagYesButton);
			
			flagNoButton = new BlockButton(360, 120, Assets.COLOR_GRAY_50, 'NO!', 92);
			flagNoButton.setDownColor(Assets.COLOR_GRAY_75);
			flagNoButton.setDefaultTweenIn(1, {x: 548, y: 1098});
			flagNoButton.setDefaultTweenOut(1, {x: BlockBase.OFF_RIGHT_EDGE, y: 1098});					
			addChild(flagNoButton);			
						
			// Submit overlay
			submitOverlay = new BlockBitmap(new Bitmap(new BitmapData(stageWidth, stageHeight, false, 0x000000)));
			submitOverlay.setDefaultTweenIn(1, {alpha: 0.85});
			submitOverlay.setDefaultTweenOut(1, {alpha: 0});
			addChild(submitOverlay);
			
			submitOverlayMessage = new BlockParagraph(900, 0x000000, 'Thank you for your participation.\nKeep up with the latest at greatcivildebatewall.com', 31, 0xffffff, Assets.FONT_BOLD);
			submitOverlayMessage.setDefaultTweenIn(1, {x: 101, y: 993});
			submitOverlayMessage.setDefaultTweenOut(1, {x: BlockBase.OFF_LEFT_EDGE, y: 993});					
			addChild(submitOverlayMessage);			
			
			submitOverlayContinueButton = new BlockButton(202, 65, 0x000000, 'CONTINUE', 25, 0xffffff, Assets.FONT_HEAVY);
			submitOverlayContinueButton.setDefaultTweenIn(1, {alpha: 1, x: 779, y: 1243});
			submitOverlayContinueButton.setDefaultTweenOut(1, {alpha: 1, x: BlockBase.OFF_RIGHT_EDGE, y: 1243});					
			addChild(submitOverlayContinueButton);						

			// Camera Overlays
			blackOverlay = new BlockBitmap(new Bitmap(new BitmapData(stageWidth, stageHeight, false, 0x000000)));
			blackOverlay.setDefaultTweenIn(0.1, {alpha: 1, immediateRender: true}); // duration of 0 doesn't work?
			blackOverlay.setDefaultTweenOut(0, {alpha: 0});
			addChild(blackOverlay);				
			
			// Flash overlay
			flashOverlay = new BlockBitmap(new Bitmap(new BitmapData(stageWidth, stageHeight, false, 0xffffff)));
			flashOverlay.setDefaultTweenIn(0.1, {alpha: 1, ease: Quart.easeOut, immediateRender: true});
			flashOverlay.setDefaultTweenOut(1, {alpha: 0, ease: Quart.easeOut});
			flashOverlay.name = 'Flash Overlay';
			addChild(flashOverlay);	
		}
		
		
		// =========================================================================
		
		
		// land here if there aren't yet opinions for the current question
		// TODO some kind of "be the first" message
		public function noOpinionView(...args):void {
			markAllInactive();
			
			// mutations
			CDW.inactivityTimer.disarm();
			portrait.setImage(Assets.portraitPlaceholder);
			question.setTextColor(CDW.state.questionTextColor);
			bigButton.setText('ADD YOUR OPINION', true);
			CDW.state.clearUser();

			// behaviors
			bigButton.setOnClick(pickStanceView);				
			
			// blocks
			portrait.tweenIn();
			header.tweenIn();
			divider.tweenIn();
			question.tweenIn();			
			bigButton.tweenIn();	

			tweenOutInactive();
		}
		
		// =========================================================================
		
		

		
		public function homeView(...args):void {
			CDW.state.lastView = CDW.state.activeView;
			CDW.state.activeView = homeView;
			markAllInactive();
			CDW.inactivityTimer.disarm();
			
			// content mutations
			portrait.setImage(CDW.state.activeThread.firstPost.user.photo); // TODO need to copy?
			question.setText(CDW.data.question.text, true);
			nametag.setText(CDW.state.activeThread.firstPost.user.usernameFormatted + ' Says :', true);
			stance.setText(CDW.state.activeThread.firstPost.stanceFormatted, true);
			opinion.setText(CDW.state.activeThread.firstPost.text);
			bigButton.setText('ADD YOUR OPINION', true);
			likeButton.setCount(CDW.state.activeThread.firstPost.likes);			
			
			
			// hilite
			trace("Hilite state: " + CDW.state.highlightWord);
			if (CDW.state.highlightWord != null) {
				trace("Hiliting!" + CDW.state.highlightWord);
				opinion.setHighlightColor(CDW.state.activeThread.firstPost.stanceColorHighlight);
				opinion.setHighlight(CDW.state.highlightWord);
			}
			else {
				// 
				trace("unhilite");
				opinion.clearHighlight();				
			}
			
			leftOpinion.clearHighlight();
			rightOpinion.clearHighlight();
			
			// hilite these to, if we need to
			debateOverlay.update();			
			
			CDW.state.highlightWord = null;
			
			
			// state mutations
			debateOverlay.scrollField.scrollTo(0, 0);			
			CDW.state.clearUser(); // Reset user info
			debateStrip.setActiveThumbnail(CDW.state.activeThread.id); // TODO just pass object?
			
			// aesthetic mutations
			question.setTextColor(CDW.state.questionTextColor);
			debateButton.setStrokeColor(0xffffff);
			CDW.state.activeThread.firstPost.stance == Post.STANCE_YES ? stance.setLetterSpacing(yesLetterSpacing) : stance.setLetterSpacing(noLetterSpacing);			
			
			// disabled colors
			likeButton.setDisabledColor(CDW.state.activeThread.firstPost.stanceColorDisabled);
			flagButton.setDisabledColor(CDW.state.activeThread.firstPost.stanceColorDisabled);
			viewDebateButton.setDisabledColor(CDW.state.activeThread.firstPost.stanceColorDisabled);
						
			
			// Set up previous and next overlay
			if (CDW.state.previousThread != null) {
				// set the previous debate				
				leftOpinion.y = 1347 - leftOpinion.height;
				
				leftOpinion.setText(CDW.state.previousThread.firstPost.text, true);				
				leftStance.setText(CDW.state.previousThread.firstPost.stanceFormatted, true);
				CDW.state.previousThread.firstPost.stance == Post.STANCE_YES ? leftStance.setLetterSpacing(yesLetterSpacing) : leftStance.setLetterSpacing(noLetterSpacing);				
				leftNametag.setText(CDW.state.previousThread.firstPost.user.usernameFormatted + ' Says :', true);				
				
				leftStance.setBackgroundColor(CDW.state.previousThread.firstPost.stanceColorLight, true);
				leftOpinion.setBackgroundColor(CDW.state.previousThread.firstPost.stanceColorLight, true);
				leftNametag.setBackgroundColor(CDW.state.previousThread.firstPost.stanceColorDark, true);				
			}
			
			if (CDW.state.nextThread != null) {
				// set the next debate
				rightOpinion.y = 1347 - rightOpinion.height;
				
				rightOpinion.setText(CDW.state.nextThread.firstPost.text, true);				
				rightStance.setText(CDW.state.nextThread.firstPost.stanceFormatted, true);
				CDW.state.nextThread.firstPost.stance == Post.STANCE_YES ? rightStance.setLetterSpacing(yesLetterSpacing) : rightStance.setLetterSpacing(noLetterSpacing);				
				rightNametag.setText(CDW.state.nextThread.firstPost.user.usernameFormatted + ' Says :', true);				
				
				rightStance.setBackgroundColor(CDW.state.nextThread.firstPost.stanceColorLight, true);
				rightOpinion.setBackgroundColor(CDW.state.nextThread.firstPost.stanceColorLight, true);
				rightNametag.setBackgroundColor(CDW.state.nextThread.firstPost.stanceColorDark, true);	
			}
			
			
			// ease if we're transitioning
			var instant:Boolean = true;
			if (CDW.state.activeView == CDW.state.lastView) instant = false;
			
			stance.setBackgroundColor(CDW.state.activeThread.firstPost.stanceColorLight, true);
			
			quoteLeft.setColor(CDW.state.activeThread.firstPost.stanceColorLight, instant);
			quoteRight.setColor(CDW.state.activeThread.firstPost.stanceColorLight, instant);				
			nametag.setBackgroundColor(CDW.state.activeThread.firstPost.stanceColorDark, true);
			opinion.setBackgroundColor(CDW.state.activeThread.firstPost.stanceColorLight, true);
			debateButton.setBackgroundColor(CDW.state.activeThread.firstPost.stanceColorDark, instant);
			debateButton.setDownColor(CDW.state.activeThread.firstPost.stanceColorMedium);
			statsButton.setBackgroundColor(CDW.state.activeThread.firstPost.stanceColorDark, instant);
			statsButton.setDownColor(CDW.state.activeThread.firstPost.stanceColorMedium);			
			
			
			
			
			// respect locked buttons
			likeButton.setBackgroundColor(CDW.state.activeThread.firstPost.stanceColorDark, instant);			
			//	if (likeButton.locked) likeButton.setBackgroundColor(CDW.state.activeStanceColorDisabled, instant); 
			likeButton.setDownColor(CDW.state.activeThread.firstPost.stanceColorMedium);			
			
			flagButton.setBackgroundColor(CDW.state.activeThread.firstPost.stanceColorDark), instant;
			if (flagButton.locked) flagButton.setBackgroundColor(CDW.state.activeThread.firstPost.stanceColorDisabled, instant);
			flagButton.setDownColor(CDW.state.activeThread.firstPost.stanceColorMedium);
						
			flagButton.unlock();
			likeButton.unlock();

			// view debate button
			viewDebateButton.setDownColor(CDW.state.activeThread.firstPost.stanceColorMedium);
			
			var responseCount:int = CDW.state.activeThread.postCount - 1;			
			
			if (responseCount == 0) {
				viewDebateButton.setFont(Assets.FONT_BOLD); // actually sets after call to set label
				viewDebateButton.setLabel('No responses yet. Be the first!', false);
				viewDebateButton.setBackgroundColor(CDW.state.activeThread.firstPost.stanceColorDisabled, true);				
				viewDebateButton.showOutline(false);				
			}
			else {
				// TODO embed this functionality in the button label itself?
				// viewDebateButton.fitLabel(text, maxWidth, prefix, postfix);
				
				// Show as much comment as possible... truncate what we can't
				viewDebateButton.setFont(Assets.FONT_BOLD);
				var firstCommentText:String = CDW.state.activeThread.posts[1].text;
				var newLabel:String = '\u201C' + firstCommentText + '\u201D + ' + responseCount + ' ' + StringUtil.plural('response', responseCount);				
				var commentLength:int = firstCommentText.length;
				var commentPreview:String = firstCommentText;				
				var previewWidth:Number = viewDebateButton.measureText(newLabel);
				
				while (previewWidth > 460) {
					commentLength--;
					commentPreview = StringUtil.truncate(firstCommentText, commentLength, '...');
					newLabel = '\u201C' + commentPreview + '\u201D + ' + responseCount + ' ' + StringUtil.plural('response', responseCount);					
					previewWidth = viewDebateButton.measureText(newLabel);
				}
				
				viewDebateButton.setLabel(newLabel); // finally, tween it in
				viewDebateButton.setBackgroundColor(CDW.state.activeThread.firstPost.stanceColorDark, true);
				viewDebateButton.showOutline(true);								
			}			
			
			
			// behaviors
			if (responseCount == 0) {			
				viewDebateButton.setOnClick(null);
				CDW.state.threadOverlayOpen = false;
			}
			else {
				viewDebateButton.setOnClick(onDebateViewButton);
				
				if (CDW.state.threadOverlayOpen) {
					TweenMax.delayedCall(1.0, debateOverlayView);
				}
			}
			
			bigButton.setOnClick(onAddOpinionButton);			
			statsButton.setOnClick(statsView);
			debateButton.setOnClick(onDebateButton);
			likeButton.setOnClick(incrementLikes);
			flagButton.setOnClick(onFlagClick);
			
			
			// blocks
			portrait.tweenIn();
			header.tweenIn();
			divider.tweenIn();
			question.tweenIn();
			dragLayer.tweenIn();
			stance.tweenIn();
			leftStance.tweenIn();
			rightStance.tweenIn();
			nametag.tweenIn();
			leftNametag.tweenIn();
			rightNametag.tweenIn();
			quoteLeft.tweenIn();
			quoteRight.tweenIn();
			
			rightOpinion.tweenIn();
			leftOpinion.tweenIn();
			bigButton.tweenIn();
			statsButton.tweenIn();
			likeButton.tweenIn();
			flagButton.tweenIn();
			viewDebateButton.tweenIn();
			debateStrip.tweenIn();
			
			// is it a transition?
			if (CDW.state.activeView == CDW.state.lastView) {
				// it's a transition

				debateButton.tweenIn(-1, {y: (1347 - opinion.height) - 195});
			}
			else {
				// we're landing here from somewhere else, snap to it
								
				debateButton.y = (1347 - opinion.height) - 195;
				debateButton.tweenIn();				
			}
			
			if (CDW.state.activeView == CDW.state.lastView) {
				opinion.y = 1347 - opinion.height;
				opinion.tweenIn();				
			}
			else {
				opinion.tweenIn(-1, {y: 1347 - opinion.height});				
			}
			
			
			
			// Fire the debate overlay?
						
			
			
			// override any tween outs here (flagging them as active means they won't get tweened out automatically)
			// note that it's a one-time thing, when the block tweens back in, it will start from its canonical "tween out" location
			// and not this temporary override
			//debateOverlay.tweenOut(1, {y: -debateOverlay.height});
			
			// clean up the old based on what's not active
			tweenOutInactive();
						
			setTestOverlay(TestAssets.CDW_082511_Kiosk_Design);
		}
		
		private function onFlagClick(e:Event):void {
			CDW.state.activePost = CDW.state.activeThread.firstPost;
			flagOverlayView();
		}
		
		private function onDebateViewButton(e:Event):void {
			CDW.state.threadOverlayOpen = true;
			debateOverlayView();			
		}
		
		
		public function nextDebate():void {
			if (CDW.state.nextThread != null) { 	
				trace('Transition to next.');
				CDW.state.setActiveDebate(CDW.state.nextThread);
				CDW.view.leftOpinion.x += stageWidth;
				CDW.view.opinion.x += stageWidth;
				CDW.view.rightOpinion.x += stageWidth;
				
				CDW.view.leftStance.x += stageWidth;
				CDW.view.rightStance.x += stageWidth;
				CDW.view.stance.x += stageWidth;
				
				CDW.view.leftNametag.x += stageWidth;
				CDW.view.rightNametag.x += stageWidth;
				CDW.view.nametag.x += stageWidth;
			}
			homeView();
		}
		
		public function previousDebate():void {
			if (CDW.state.previousThread != null) {
				trace('Transition to previous.');
				CDW.state.setActiveDebate(CDW.state.previousThread);
				CDW.view.leftOpinion.x -= stageWidth;
				CDW.view.opinion.x -= stageWidth;
				CDW.view.rightOpinion.x -= stageWidth;
				
				CDW.view.leftStance.x -= stageWidth;
				CDW.view.rightStance.x -= stageWidth;
				CDW.view.stance.x -= stageWidth;
				
				CDW.view.leftNametag.x -= stageWidth;
				CDW.view.rightNametag.x -= stageWidth;
				CDW.view.nametag.x -= stageWidth;
			}
			homeView();			
		}		
		
		private function onDebateButton(e:Event):void {
			CDW.state.userRespondingTo = CDW.state.activeThread.firstPost;
			CDW.state.userIsResponding = true;
			pickStanceView();
		}
		
		private function onAddOpinionButton():void {
			CDW.state.userRespondingTo = null;			
			CDW.state.userIsResponding = false;
			pickStanceView();
		}		
		
		private function incrementLikes(e:Event):void {
			// also uploads
			CDW.state.activeThread.firstPost.incrementLikes();
			CDW.state.activeThread.firstPost.likes = likeButton.getCount() + 1;
			likeButton.setCount(CDW.state.activeThread.firstPost.likes);			
		}

		// =========================================================================
		
		
		public function debateOverlayView(...args):void {
			CDW.state.lastView = CDW.state.activeView;
			CDW.state.activeView = debateOverlayView;			
			markAllInactive();			
			CDW.inactivityTimer.disarm();
			
							
			
			// mutations
			portrait.setImage(CDW.state.activeThread.firstPost.user.photo);
			stance.setText(CDW.state.activeThread.firstPost.stanceFormatted, true);
			opinion.setText(CDW.state.activeThread.firstPost.text);			
			question.setTextColor(CDW.state.questionTextColor);			
			byline.y = 410 + opinion.height + 38;
			byline.setBackgroundColor(CDW.state.activeThread.firstPost.stanceColorMedium, true);
			opinion.setBackgroundColor(CDW.state.activeThread.firstPost.stanceColorLight, true);			
			stance.setBackgroundColor(CDW.state.activeThread.firstPost.stanceColorLight, true);			
			
			secondaryDebateButton.setBackgroundColor(CDW.state.activeThread.firstPost.stanceColorDark, true);
			secondaryDebateButton.setDownColor(CDW.state.activeThread.firstPost.stanceColorMedium);
			
			debateButton.setBackgroundColor(CDW.state.activeThread.firstPost.stanceColorDark, true);
			debateButton.setDownColor(CDW.state.activeThread.firstPost.stanceColorMedium);
			
			viewDebateButton.setBackgroundColor(CDW.state.activeThread.firstPost.stanceColorDark, true);
			viewDebateButton.setDownColor(CDW.state.activeThread.firstPost.stanceColorMedium);			
			
			// use the full capitalize name for the byline
			byline.setText('Said by ' + CDW.state.activeThread.firstPost.user.usernameFormatted, true);
			viewDebateButton.setFont(Assets.FONT_HEAVY);
			viewDebateButton.setLabel('BACK TO HOME SCREEN', false);
			letsDebateUnderlay.height = 410 + opinion.height + 144 + 15 + 5 - letsDebateUnderlay.y; // height depends on opinion
			debateButton.setStrokeColor(Assets.COLOR_GRAY_15);
			
			
			letsDebateUnderlay.height = 410 + opinion.height + 144 + 15 + 5 - letsDebateUnderlay.y; // height depends on opinion				
			debateOverlay.setMaxHeight(stageHeight - (letsDebateUnderlay.y + letsDebateUnderlay.height + 30 + 300));				
			
					
			debateOverlay.update();
			
			// behaviors
			viewDebateButton.setOnClick(onCloseDebateOverlay);
			
			// blocks
			portrait.tweenIn();
			
			letsDebateUnderlay.tweenIn();
			header.tweenIn();
			question.tweenIn();
			stance.tweenIn();
			byline.tweenIn(-1, {x: 916 - byline.width - 39}); // dynamic based on opinion size
			opinion.tweenIn(1, {y: 410});
			//debateButton.tweenIn(1, {x: 916, y: 410 + opinion.height + 15, scaleX: 0.75, scaleY: 0.75});
			
			
			secondaryDebateButton.setOnClick(onDebateButton);
			

			
			secondaryDebateButton.y = 410 + opinion.height + 15;
			secondaryDebateButton.tweenIn();
			
			
			
			
			viewDebateButton.tweenIn(1, {y: 1650});	
			debateStrip.tweenIn();
			debateOverlay.tweenIn(-1, {y: letsDebateUnderlay.y + letsDebateUnderlay.height + 30});			
			
			tweenOutInactive();	
			
			setTestOverlay(TestAssets.CDW_082511_Kiosk_Design7);			
		}
		
		private function onCloseDebateOverlay(e:Event):void {
			CDW.state.threadOverlayOpen = false;
			homeView();
		}
		
		private function onYesButton(e:MouseEvent):void {
			CDW.state.setStance('yes');
			smsPromptView();
		}
		
		private function onNoButton(e:MouseEvent):void {
			CDW.state.setStance('no');
			smsPromptView();			
		}
		
		
		// =========================================================================
		
		
		public function flagOverlayView(...args):void {
			CDW.state.lastView = CDW.state.activeView;
			CDW.state.activeView = flagOverlayView;
			
			// mutations			
			CDW.inactivityTimer.disarm();
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
			
			this.setTestOverlay(TestAssets.CDW_082511_Kiosk_Design22);
		}
		
		private function removeFlagOverlayView(...args):void {
			CDW.state.activeView = CDW.state.lastView; // revert the view, since it was just an overlay
			CDW.state.lastView = flagOverlayView;
						
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
			CDW.state.activePost.incrementFlags();
			
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
			if (CDW.state.activeView == CDW.state.lastView) {
				// are we going in the next direction?
				
				
				// 
				
				// are we going in the previous direction
//				nextDebate();
				
				
			}
			
			
//			portrait.setImage(CDW.database.getActivePortrait());
//			question.setTextColor(CDW.state.questionTextColor);			
//			
//			portrait.tweenIn(0.5, {delay: 0.5, onComplete: onViewTransitionComplete});
//			header.tweenIn();
//			divider.tweenIn();
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
		
		
		// =========================================================================		
		
		
		public function pickStanceView(...args):void {
			CDW.state.lastView = CDW.state.activeView;
			CDW.state.activeView = pickStanceView;			
			markAllInactive();		
			
			CDW.inactivityTimer.arm();
			
			// mutations
			opinion.y = 1347 - opinion.height; // return opinion to starting location (for entry via "debate me" button)
			
			portrait.setImage(Assets.portraitPlaceholder);
			question.setTextColor(CDW.state.questionTextColor);
			
			noButton.setBackgroundColor(Assets.COLOR_NO_LIGHT);
			noButton.setDownColor(Assets.COLOR_NO_MEDIUM);
			
			yesButton.setBackgroundColor(Assets.COLOR_YES_LIGHT);
			yesButton.setDownColor(Assets.COLOR_YES_LIGHT);
			
			noButton.showOutline(true);
			yesButton.showOutline(true);			
			
			if (CDW.state.userIsResponding) {
				trace("User is responding!");
				// got here from the 'let's debate' button and not the 'add opinion button'
				bigButton.setText('DEBATE ME', true);
				bigButton.disable();
			}
			
			// behaviors
			yesButton.setOnClick(onYesButton);
			noButton.setOnClick(onNoButton);
			
			// blocks
			portrait.tweenIn();
			header.tweenIn();
			divider.tweenIn();
			question.tweenIn();
			bigButton.tweenIn();
			pickStanceInstructions.tweenIn();
			yesButton.tweenIn(-1, {delay: 0.5}); // side slide & delay per jonathan
			noButton.tweenIn(-1, {delay: 0.5}); // side slide & delay per jonathan
			
			
			tweenOutInactive();	// TODO disable behaviors as well? or let them ride? implications for mid-tween events
			
			setTestOverlay(TestAssets.CDW_082511_Kiosk_Design8);			
		}
		
		
		// =========================================================================		

		
		private var smsCheckTimer:Timer;
		
		public function smsPromptView(...args):void {
			CDW.state.lastView = CDW.state.activeView;
			CDW.state.activeView = smsPromptView;
			markAllInactive();
			
			CDW.inactivityTimer.arm();
			
			// mutations
			smsInstructions.setBackgroundColor(CDW.state.userStanceColorLight, true);
			characterLimit.setBackgroundColor(CDW.state.userStanceColorLight, true);
			
			exitButton.y = 1000;
			exitButton.setBackgroundColor(CDW.state.userStanceColorDark, true);
			exitButton.setDownColor(CDW.state.userStanceColorMedium);			
			
			noButton.showOutline(false);
			yesButton.showOutline(false);			
			
			if (CDW.state.userStance == 'yes') {
				noButton.setBackgroundColor(Assets.COLOR_GRAY_50, true);
			}
			else {	
				yesButton.setBackgroundColor(Assets.COLOR_GRAY_50, true);
			}
			
			if (CDW.state.userIsResponding) {
				bigButton.setText('DEBATE ME', true);				
			}
			else {
				bigButton.setText('ADD YOUR OPINION', true);				
			}
			
			// behaviors
			exitButton.setOnClick(homeView); // TODO do we need the back button?
			portrait.setImage(Assets.portraitPlaceholder);
			question.setTextColor(CDW.state.questionTextColor);			
			yesButton.setOnClick(null);
			noButton.setOnClick(null);
			//
			
			// start polling to see if the user has sent their opinion yet
			CDW.data.fetchLatestTextMessages(onLatestMessagesFetched);
			
			// blocks
			portrait.tweenIn();
			header.tweenIn();
			divider.tweenIn();
			question.tweenIn();
			bigButton.tweenIn();
			yesButton.tweenIn();
			noButton.tweenIn();
			exitButton.tweenIn();
			smsInstructions.tweenIn();
			characterLimit.tweenIn();
			smsDisclaimer.tweenIn();
			skipTextButton.tweenIn(); // TEMP for debug, TODO put on setting switch
			
			
			// push the character limit down
			pickStanceInstructions.tweenOut(-1, {x: BlockBase.OFF_LEFT_EDGE, y: pickStanceInstructions.y});
			
	
			tweenOutInactive();
			
			setTestOverlay(TestAssets.CDW_082511_Kiosk_Design10);			
		}
		
		private function onLatestMessagesFetched():void {
			trace("latest baseline messages fetched...");
			
			if(CDW.data.latestTextMessages.length > 0) {
				CDW.state.lastTextMessageTime = CDW.data.latestTextMessages[0].created;	
			}
			else {
				// edge case, no messages, anything will be newer
				trace("No messages yet.");
				CDW.state.lastTextMessageTime = new Date(1900, 1, 1, 12, 0, 0, 0); // the distant past...
			}

			// start checking for new messages every second
			smsCheckTimer = new Timer(1000);
			smsCheckTimer.addEventListener(TimerEvent.TIMER, onSmsCheckTimer);
			smsCheckTimer.start();			
		}

		
		private function onSmsCheckTimer(e:TimerEvent):void {
			trace('fetcheding latest sms');
			CDW.data.fetchLatestTextMessages(onSMSCheckResponse);
			smsCheckTimer.stop();
		}
		
		
		private function onSMSCheckResponse():void {
			trace('latest sms fetched');
			
			// Grab a newer message
			if ((CDW.data.latestTextMessages.length > 0) && (CDW.data.latestTextMessages[0].created > CDW.state.lastTextMessageTime)) {
				trace("got SMS");		
				
				// check for profanity, TODO move this to check SMS
				if (CDW.data.latestTextMessages[0].profane) {
					// scold for five seconds
					smsReceivedProfanityWarning.tweenIn();
					TweenMax.delayedCall(5, function():void { smsReceivedProfanityWarning.tweenOut(-1, {x: BlockBase.OFF_RIGHT_EDGE})});					
					
					// reset time baseline
					CDW.state.lastTextMessageTime = CDW.data.latestTextMessages[0].created; 
					
					// keep checking
					trace("Bad words! keep trying");
					smsCheckTimer.reset();
					smsCheckTimer.start();						
				}
				else {
					trace("it's clean");
					handleSMS(CDW.data.latestTextMessages[0]);
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
			CDW.state.textMessage = sms; // save for later
			trace("Checking for " + sms.phoneNumber);
			
			CDW.state.userOpinion = CDW.state.textMessage.text; // TODO truncate this?			
			CDW.state.userPhoneNumber = CDW.state.textMessage.phoneNumber;
			
			var tempUser:User = CDW.data.getUserByPhoneNumber(sms.phoneNumber); // TODO check server instead
			
			if (tempUser != null) {
				trace("user exists");
				// user exists...
				// they must have a username
				// but do they have a photo?
				CDW.state.userName = tempUser.username;
				CDW.state.userPhoneNumber = tempUser.phoneNumber;
				CDW.state.userID = tempUser.id;
				
				var imageFile:File = new File(CDW.settings.imagePath + CDW.state.userID + '.jpg');
				
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
			CDW.state.userImage = b;
			portrait.setImage(CDW.state.userImage);
			question.setTextColor(CDW.state.questionTextColor);
			//go straight to verification;
			verifyOpinionView();
		}
		
		public function simulateSMS(e:Event):void {
			if(smsCheckTimer != null) smsCheckTimer.stop();
			//var testTextMessage:TextMessage = new TextMessage({'message': Utilities.dummyText(100), 'phoneNumber': '415' + Utilities.randRange(1000000, 9999999).toString(), 'created': '2011-09-07 17:31:44'});
			var testTextMessage:TextMessage = new TextMessage({'message': '', 'phoneNumber': '555' + Math2.randRange(1000000, 9999999).toString(), 'created': '2011-09-07 17:31:44'});			
			handleSMS(testTextMessage);
		}

		
		
		// =========================================================================		
		
		private var faceDetector:FaceDetector = new FaceDetector();
		
		public function photoBoothView(...args):void {
			CDW.state.lastView = CDW.state.activeView;
			CDW.state.activeView = photoBoothView;			
			markAllInactive();
			
			CDW.inactivityTimer.arm();
			
			// mutations
			countdownButton.progressRing.alpha = 0; // starts transparent			
			stance.setText(CDW.state.userStanceText, true);
			stance.setBackgroundColor(CDW.state.userStanceColorLight, true);
			countdownButton.setBackgroundColor(CDW.state.userStanceColorLight, true);
			countdownButton.setDownColor(CDW.state.userStanceColorMedium);	
			countdownButton.setRingColor(CDW.state.userStanceColorLight);
			countdownButton.setProgressColor(0xffffff);				
			photoBoothButton.setBackgroundColor(CDW.state.userStanceColorDark, true);
			photoBoothButton.setDownColor(CDW.state.userStanceColorMedium);			
			photoBoothNag.setBackgroundColor(CDW.state.userStanceColorMedium, true);
			cameraOverlay.setColor(CDW.state.userStanceColorLight, CDW.state.userStanceColorOverlay);
			
			// behaviors
			countdownButton.setOnClick(onCameraClick);
			countdownButton.setOnAlmostFinish(onCountdownAlmostFinish);			
			countdownButton.setOnFinish(onCountdownFinish);
			photoBoothButton.setOnClick(onCameraClick);
			
			// blocks
			portraitCamera.tweenIn();
			header.tweenIn();
			cameraOverlay.tweenIn();
			photoBoothButton.tweenIn();
			countdownButton.tweenIn();			
			
			if (CDW.state.lastView == photoBoothView) {
				// we timed out! show the message for five seconds
				cameraTimeoutWarning.tweenIn();
				TweenMax.delayedCall(5, function():void { cameraTimeoutWarning.tweenOut(-1, {x: BlockBase.OFF_RIGHT_EDGE})});
			}
			
			tweenOutInactive();
			
			setTestOverlay(TestAssets.CDW_082511_Kiosk_Design11);
		}
		
		
		private function onCameraClick(e:Event):void {
			if (!countdownButton.isCountingDown()) {
				header.tweenOut();
				photoBoothButton.tweenOut();
				
				var scaleFactor:Number = 103 / 124;
				
				countdownButton.setBackgroundColor(CDW.state.userStanceColorMedium);
				countdownButton.tween(1, {x: countdownButton.x + 15, y: 30, scaleX: scaleFactor, scaleY: scaleFactor, ease: Quart.easeInOut, onComplete: onCountdownPositioned}); // move it up
				TweenMax.to(countdownButton.progressRing, 1, {alpha: 1, ease: Quart.easeInOut});
				photoBoothNag.tweenIn(-1, {delay: 1});
			}
		}
		
		
		private function onCountdownPositioned():void {
			countdownButton.start()	
		}
		
		
		private function onCountdownAlmostFinish():void {
			// nothing at the moment, could show cheese...
		}
		
		
		private function onCountdownFinish(e:Event):void {			
			// go to black
			blackOverlay.tweenIn(-1, {onComplete: onScreenBlack});
		}
		
		private function onScreenBlack():void {
			trace('screen black');
			
			// Do this in portrait camera instead?
			if (CDW.settings.webcamOnly) {
				// using webcam
				portraitCamera.takePhoto();
				CDW.state.userImage = portraitCamera.cameraBitmap; // store here temporarily	
				detectFace(CDW.state.userImage);
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
			CDW.dashboard.log("SLR timeout callback");
			portraitCamera.slr.removeEventListener(CameraFeedEvent.NEW_FRAME_EVENT, onPhotoCapture);
			photoBoothView();
		}
		
		
		private function onPhotoCapture(e:CameraFeedEvent):void {
			portraitCamera.slr.removeEventListener(CameraFeedEvent.NEW_FRAME_EVENT, onPhotoCapture);
			
			// process SLR image
			CDW.state.userImage = portraitCamera.slr.image;
			detectFace(CDW.state.userImage);
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
			CDW.state.userImageFull = new Bitmap(CDW.state.userImage.bitmapData.clone());
			
			if (faceDetector.faceRect != null) {
				trace('face found, cropping to it');
				
				// Scale the face detector rectangle
				var scaleFactor:Number = CDW.state.userImage.height / faceDetector.maxSourceHeight; 
				var scaledFaceRect:Rectangle = GeomUtil.scaleRect(faceDetector.faceRect, scaleFactor);
				
				trace("Scaled face rect: " + scaledFaceRect);
				
				CDW.state.userImage = Utilities.cropToFace(CDW.state.userImage, scaledFaceRect);				
			}
			else {
				trace('no face found, saving as is');
				CDW.state.userImage.bitmapData = BitmapUtil.scaleToFill(CDW.state.userImage.bitmapData, stageWidth, stageHeight);
			}
			
			// NOW flash
			flashOverlay.tweenIn(-1, {onComplete: onFlashOn}); // use default tween in duration
		}
		
		
		private function onFlashOn():void {
			blackOverlay.tweenOut();
			
			// skip name entry if we already have it
			if(CDW.state.userName == '') {			
				nameEntryView();
			}
			else {
				verifyOpinionView();
			}
			flashOverlay.tweenOut();
		}
		
		
		// =========================================================================
		
		
		public function nameEntryView(...args):void {
			CDW.state.lastView = CDW.state.activeView;
			CDW.state.activeView = nameEntryView;			
			markAllInactive();
			flashOverlay.active = true; // needs to tween out itself
			usernameTakenWarning.active = true;
			
			CDW.inactivityTimer.arm();
			
			// mutations
			stance.setText(CDW.state.userStanceText);
			stance.setBackgroundColor(CDW.state.userStanceColorLight);
			(CDW.state.userStanceText == 'YES!') ? stance.setLetterSpacing(yesLetterSpacing) : stance.setLetterSpacing(noLetterSpacing);			
			nameEntryInstructions.setBackgroundColor(CDW.state.userStanceColorLight, true);
			saveButton.setBackgroundColor(CDW.state.userStanceColorDark, true);
			saveButton.setDownColor(CDW.state.userStanceColorMedium);			
			keyboard.setColor(CDW.state.userStanceColorLight, true);
			keyboard.showSpacebar(false);
			nameEntryField.setBackgroundColor(CDW.state.userStanceColorLight, true);
			portrait.setImage(CDW.state.userImage, true);
			question.setTextColor(CDW.state.questionTextColor);			
			nameEntryField.setText('', true); // clear the name entry field			
			keyboard.target = nameEntryField.getTextField();
			
			nameEntryField.setOnLimitReached(onLimitReached);
			nameEntryField.setOnLimitUnreached(onLimitUnreached);			
			
			
			// behaviors
			saveButton.setOnClick(onSaveName);
			
			// blocks, no delay since it needs to happen during the flash!
			portrait.tweenIn(0);			
			header.tweenIn(0);
			divider.tweenIn(0);
			question.tweenIn(0);
			stance.tweenIn(-1, {delay: 1});
			nameEntryInstructions.tweenIn(-1, {delay: 1});
			
			nameEntryField.tweenIn(-1, {delay: 1});
			
			saveButton.y = 1197;
			saveButton.tweenIn(-1, {delay: 1, x: 308});
			keyboard.tweenIn(-1, {delay: 1});
			
			tweenOutInactive(true);
			
			this.setTestOverlay(TestAssets.CDW_082511_Kiosk_Design16);			
		}
		
		private function onLimitReached(e:Event):void {
			characterLimitWarning.tweenIn();			
		}
		
		private function onLimitUnreached(e:Event):void {
			characterLimitWarning.tweenOut(-1, {x: BlockBase.OFF_RIGHT_EDGE});			
		}		
		
		
		private function onNameNotEmpty(e:Event):void {
			noNameWarning.tweenOut(-1, {x: BlockBase.OFF_RIGHT_EDGE});
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
				CDW.state.userName = nameEntryField.getTextField().text;
				
				// Try to create the user, check for existing username
				CDW.data.createUser(CDW.state.userName, CDW.state.userPhoneNumber, onUserCreated);
				
			}
		}
		
		private function onUserCreated(r:Object):void {
			if (r['error'] == null) {
				// It worked!
				var tempUser:User = new User(r);
				CDW.state.userID = tempUser.id;
				verifyOpinionView();
			}
			else {
				// there was an error, the name probably already existed!
				usernameTakenWarning.tweenIn();
				TweenMax.delayedCall(5, function():void { usernameTakenWarning.tweenOut(-1, {x: BlockBase.OFF_RIGHT_EDGE}); });
				nameEntryView(); // make sure we stay here!
				
			}
		}
		
		
		// =========================================================================
		
		
		public function verifyOpinionView(...args):void {
			markAllInactive();
			CDW.state.lastView = CDW.state.activeView;
			CDW.state.activeView = verifyOpinionView;			
			
			CDW.inactivityTimer.arm();
			
			// mutations
			portrait.setImage(CDW.state.userImage, true);
			question.setTextColor(CDW.state.questionTextColor);			
			bigButton.setText('SUBMIT THIS DEBATE', true);
			bigButton.enable();
			nametag.setText(CDW.state.userName + ' Says:', true);
			opinion.setText(CDW.state.userOpinion);

			opinion.y = stageHeight - 574 - opinion.height; 
			
			nametag.setBackgroundColor(CDW.state.userStanceColorMedium, true); // make instant?
			opinion.setBackgroundColor(CDW.state.userStanceColorLight, true);
			
			
			var buttonRowY:Number = opinion.y - 30 - retakePhotoButton.height;			
			
			retakePhotoButton.y = buttonRowY;
			retakePhotoButton.setBackgroundColor(CDW.state.userStanceColorDark, true);
			retakePhotoButton.setDownColor(CDW.state.userStanceColorMedium);
			
			editTextButton.y = buttonRowY;
			editTextButton.setBackgroundColor(CDW.state.userStanceColorDark, true);
			editTextButton.setDownColor(CDW.state.userStanceColorMedium);			
			
			exitButton.y = buttonRowY;
			exitButton.setBackgroundColor(CDW.state.userStanceColorDark, true);
			exitButton.setDownColor(CDW.state.userStanceColorMedium);
			
			quoteLeft.setColor(CDW.state.userStanceColorLight, true);
			quoteRight.setColor(CDW.state.userStanceColorLight, true);				
			
			stance.setText(CDW.state.userStanceText);
			stance.setBackgroundColor(CDW.state.userStanceColorLight);
			(CDW.state.userStanceText == 'YES!') ? stance.setLetterSpacing(yesLetterSpacing) : stance.setLetterSpacing(noLetterSpacing);
			
			// behaviors
			retakePhotoButton.setOnClick(photoBoothView);
			editTextButton.setOnClick(editOpinionView);
			exitButton.setOnClick(homeView);
			bigButton.setOnClick(submitOverlayView);
			
			// blocks
			quoteLeft.tweenIn();
			quoteRight.tweenIn();			
			portrait.tweenIn();			
			header.tweenIn();
			divider.tweenIn();
			question.tweenIn();
			stance.tweenIn();
			bigButton.tweenIn();
			nametag.tweenIn();
			opinion.tweenIn();
			retakePhotoButton.tweenIn();
			editTextButton.tweenIn();
			exitButton.tweenIn();						
			

			tweenOutInactive();
			this.setTestOverlay(TestAssets.CDW_082511_Kiosk_Design17);			
		}
	
		
		// =========================================================================
		
		
		public function submitOverlayView(...args):void {
			CDW.state.lastView = CDW.state.activeView;
			CDW.state.activeView = submitOverlayView;
			
			// mutations			
			// TODO HOW TO HANDLE OVERLAYS ON OVERLAYS? IS IT ALREADY SUBMITTED AT THIS POINT/
			CDW.inactivityTimer.arm();
			
			// mutations
			submitOverlayMessage.setBackgroundColor(CDW.state.userStanceColorLight, true);
			//submitOverlayContinueButton.setBackgroundColor(CDW.state.userStanceColorDark, true);
			//submitOverlayContinueButton.setDownColor(CDW.state.userStanceColorMedium);			
			
			// behaviors
			//submitOverlayContinueButton.setOnClick(onSubmitContinue);
			
			// blocks
			submitOverlay.tweenIn();
			
			submitOverlayMessage.tweenIn(-1, {onComplete: submitDebate}); // submit it automatically after animation
			//submitOverlayContinueButton.tweenIn();
			
			
			quoteLeft.tweenOut();
			quoteRight.tweenOut();			
			stance.tweenOut();
			bigButton.tweenOut();
			nametag.tweenOut();
			opinion.tweenOut();
			retakePhotoButton.tweenOut();
			editTextButton.tweenOut();
			exitButton.tweenOut();	
			
			this.setTestOverlay(TestAssets.CDW_082511_Kiosk_Design22);
			
			
		}
		
		
		
		private function submitDebate():void {
			// Syncs state up to the cloud
			
			// save the images to disk, one full res and one scaled and cropped 
			if(CDW.state.userImageFull != null) FileUtil.saveJpeg(CDW.state.userImageFull, CDW.settings.imagePath, CDW.state.userID + '-full.jpg');			
			var imageName:String = FileUtil.saveJpeg(CDW.state.userImage, CDW.settings.imagePath, CDW.state.userID + '.jpg');
			var payload:Object;
			
			if (CDW.state.userIsResponding) {
				// create and upload new comment
				trace("Uploading response post");
				
				// TODO "userInProgress" and "postInProgress" objects in state
				// TODO need to set "CDW.state.userRespondingTo"
				
				trace("Responding to: " + CDW.state.userRespondingTo.id);
				
				CDW.data.uploadResponse(CDW.state.activeThread.id, CDW.state.userRespondingTo.id, CDW.state.userID, CDW.state.userOpinion, CDW.state.userStance, Post.ORIGIN_KIOSK, onDebateUploaded);
			}
			else {
				// create and upload new debate
				trace("Uploading new thread");				
				CDW.data.uploadThread(CDW.data.question.id, CDW.state.userID, CDW.state.userOpinion, CDW.state.userStance, Post.ORIGIN_KIOSK, onDebateUploaded);
			}			
		}
		
		
		private function onDebateUploaded(r:Object):void {
			trace("submitting");
			//submitOverlayContinueButton.tweenOut(-1, {alpha: 0, x: submitOverlayContinueButton.x, y: submitOverlayContinueButton.y});
			
			if (CDW.state.activeThread != null) {
				CDW.state.activeThreadID = CDW.state.activeThread.id; // store the strings since objects will be wiped
				CDW.state.activeThread = null;
			}
			
			if (CDW.state.activePost != null) {			
				CDW.state.activePostID = CDW.state.activePost.id; // store the strings since objects will be wiped				
				CDW.state.activePost = null;			
			}			
			
			CDW.data.load();			
		}
		
		
		// =========================================================================		
		
		
		public function editOpinionView(...args):void {
			CDW.state.lastView = CDW.state.activeView;
			CDW.state.activeView = editOpinionView;			
			markAllInactive();
			
			CDW.inactivityTimer.arm();
			
			// mutations
			editOpinion.setText(CDW.state.userOpinion);

			keyboard.target = editOpinion.getTextField();
			keyboard.showSpacebar(true);
			
			editTextInstructions.setBackgroundColor(CDW.state.userStanceColorDark, true);
			
			saveButton.setBackgroundColor(CDW.state.userStanceColorDark, true);
			saveButton.setDownColor(CDW.state.userStanceColorMedium);			
			
			editOpinion.setBackgroundColor(CDW.state.userStanceColorLight);
			
			stance.setText(CDW.state.userStanceText);
			stance.setBackgroundColor(CDW.state.userStanceColorLight);
			(CDW.state.userStanceText == 'YES!') ? stance.setLetterSpacing(yesLetterSpacing) : stance.setLetterSpacing(noLetterSpacing);			
			
			// behaviors
			saveButton.setOnClick(onSaveOpinionEdit);
			editOpinion.setOnLimitReached(onLimitReached);
			editOpinion.setOnLimitUnreached(onLimitUnreached);
			editOpinion.setOnNumLinesChange(onNumLinesChange);			
			
			
			//blocks
			quoteLeft.tweenIn();
			quoteRight.tweenIn(); // stays under keyboard		
			portrait.tweenIn();	
			header.tweenIn();
			divider.tweenIn();
			question.tweenIn();
			stance.tweenIn();
			nametag.tweenIn();
			
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
			
			this.setTestOverlay(TestAssets.CDW_082511_Kiosk_Design21);			
		}
		
		private function onNumLinesChange(e:Event):void {
			// flow upwards
			TweenMax.to(editOpinion, 0.5, {y: stageHeight - 574 - editOpinion.height, ease: Quart.easeInOut});
			TweenMax.to(editTextInstructions, 0.5, {y: (stageHeight - 574 - editOpinion.height) - editTextInstructions.height - 30, ease: Quart.easeInOut});
		}
			
		
		private function onSaveOpinionEdit(e:Event):void {
			// Validate
			editOpinion.getTextField().text = StringUtil.trim(editOpinion.getTextField().text);
			CDW.state.userOpinion = editOpinion.getTextField().text
			
			if (editOpinion.getTextField().length == 0) {
				noOpinionWarning.tweenIn();
				editOpinion.setOnNotEmpty(onOpinionNotEmpty);
			}
			else {
				// valid
				// move the opinion back
				opinion.tweenIn(0);
				verifyOpinionView();				
			}
		}
		
		private function onOpinionNotEmpty(e:Event):void {
			noOpinionWarning.tweenOut(-1, {x: BlockBase.OFF_RIGHT_EDGE});
			nameEntryField.setOnNotEmpty(null);
		}
				
		
		
		// =========================================================================
		

		
		public function statsView(...args):void {
			CDW.state.lastView = CDW.state.activeView;
			CDW.state.activeView = statsView;	
			markAllInactive();
			
			
			CDW.inactivityTimer.disarm();
			
			// mutations
			portrait.setImage(Assets.statsUnderlay);
			question.setTextColor(CDW.state.questionTextColor);			
			
			// behaviors
			statsOverlay.homeButton.setOnClick(homeView);
			
			// blocks
			portrait.tweenIn();	
			header.tweenIn();
			divider.tweenIn();
			question.tweenIn();
			statsOverlay.tweenIn();
			
			this.setTestOverlay(TestAssets.CDW_082511_Kiosk_Design25);
			
			tweenOutInactive();			
		}
		
		
		// =========================================================================		
		
		
		public function inactivityOverlayView(...args):void {
			CDW.state.lastView = CDW.state.activeView;
			CDW.state.activeView = inactivityOverlayView;			
			// mutations			
			CDW.inactivityTimer.disarm();
			
			// behaviors
			continueButton.setOnClick(onContinue);
			inactivityTimerBar.setOnComplete(homeView);
			
			// blocks
			inactivityOverlay.tweenIn();
			inactivityTimerBar.tweenIn();			
			inactivityInstructions.tweenIn();
			continueButton.tweenIn();
			
			this.setTestOverlay(TestAssets.CDW_082511_Kiosk_Design22);
		}
		
		
		private function onContinue(e:Event):void {
			CDW.state.activeView = CDW.state.lastView ;
			CDW.state.lastView = inactivityOverlayView; // revert since it's an overlay
			
			CDW.inactivityTimer.arm();
			inactivityOverlay.tweenOut();
			inactivityTimerBar.tweenOut();
			inactivityInstructions.tweenOut();
			continueButton.tweenOut();			
		}
		
		
		// =========================================================================
		
		
		// View utilities


		
		private function setTestOverlay(b:Bitmap):void {
			CDW.testOverlay.bitmapData = b.bitmapData.clone();						
		}	
		

		private function markAllInactive():void {
			
			// other housekeeping, TODO break this into its own function?
			if(smsCheckTimer != null) smsCheckTimer.stop();					
			
			
			// marks all FIRST LEVEL blocks as inactive
			for (var i:int = 0; i < this.numChildren; i++) {
				//if ((this.getChildAt(i) is BlockBase) && (this.getChildAt(i).visible)) {
				// attempt to fix blank screen issue....
				if (this.getChildAt(i) is BlockBase) {				
					(this.getChildAt(i) as BlockBase).active = false;
				}
			}
		}
		
		
		private function tweenOutInactive(instant:Boolean = false):void {	
			for (var i:int = 0; i < this.numChildren; i++) {
				
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
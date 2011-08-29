package net.localprojects {
	import com.adobe.serialization.json.*;
	import com.bit101.components.FPSMeter;
	import com.greensock.*;
	import com.greensock.easing.*;
	import com.greensock.events.LoaderEvent;
	import com.greensock.events.TweenEvent;
	
	import flash.display.*;
	import flash.events.*;
	import flash.geom.Matrix;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	import flash.net.*;
	import flash.text.TextFormat;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;
	import flash.utils.Timer;
	
	import jp.maaash.ObjectDetection.ObjectDetectorEvent;
	
	import net.localprojects.blocks.*;
	import net.localprojects.camera.*;
	import net.localprojects.elements.*;
	import net.localprojects.keyboard.*;
	import net.localprojects.ui.*;
	

	public class View extends Sprite {
				
		// immutable
		private var header:Header;
		private var divider:BlockBitmap;
		private var answerPrompt:BlockLabel;
		private var smsDisclaimer:BlockParagraph;
		public var portraitCamera:PortraitCamera; // public for dashboard
		private var inactivityOverlay:BlockBitmap;
		private var inactivityTimerBar:ProgressBar;
		private var inactivityInstructions:BlockLabelBar;
		private var continueButton:BlockButton;
		private var flashOverlay:BlockBitmap;
		private var blackOverlay:BlockBitmap;
		private var skipTextButton:BlockButton; // debug only
		private var smsInstructions:BlockParagraph;
		private var webPlug:BlockLabel;
		private var dragLayer:DragLayer;		
		
		
		private var letsDebateUnderlay:BlockBitmap;
		
		// mutable (e.g. color changes)
		private var nameEntryInstructions:BlockLabel;		
		private var saveButton:BlockButton;		
		private var retakePhotoButton:BlockButton;
		private var editTextButton:BlockButton;
		private var cancelButton:BlockButton;
		private var editTextInstructions:BlockLabel;
		private var cameraOverlay:CameraOverlay;
		public var leftQuote:QuotationMark;
		public var rightQuote:QuotationMark
		private var statsButton:IconButton;
		private var flagButton:IconButton;		
		private var debateButton:BalloonButton;		
		private var yesButton:BlockButton;
		private var noButton:BlockButton;
		private var exitButton:BlockButton;				
		private var characterLimit:BlockLabel;
		private var photoBoothNag:BlockLabel;
		private var photoBoothInstructions:BlockButton;
		private var countdownButton:CountdownButton;		
		private var keyboard:Keyboard;		
		
		// mutable, dynamic content (e.g. text changes based on database)
		private var nameEntryField:BlockInputLabel; // changes dimensions
		private var question:Question; // changes dimensions
		public var portrait:Portrait;
		private var bigButton:BigButton;
		private var likeButton:CounterButton;
		private var viewDebateButton:BlockButton;
		private var editOpinion:BlockInputParagraph; // changes dimensions 
		private var byline:BlockLabel; // changes dimensions
		
		// containers, have lots of nested content
		private var stats:StatsOverlay;
		public var debatePicker:DebatePicker;
		private var debateOverlay:DebateOverlay;		

		// multiples of these for the drag transitions
		public var stance:BlockLabel;
		public var leftStance:BlockLabel;
		public var rightStance:BlockLabel;		
		public var nametag:BlockLabel;
		public var leftNametag:BlockLabel;
		public var rightNametag:BlockLabel;		
		public var opinion:BlockParagraph;
		public var leftOpinion:BlockParagraph;		
		public var rightOpinion:BlockParagraph;
		
		// mouse protection during tweens
		public var protection:Sprite;
		
		// convenience
		private var stageWidth:Number;
		private var stageHeight:Number;
		
		public function View() {
			super();
			init();
		}
		
		private function init():void {
			// for convenience
			stageWidth = CDW.ref.stage.stageWidth;
			stageHeight = CDW.ref.stage.stageHeight;
			
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
			
			header = new Header();
			header.setDefaultTweenIn(1, {x: BlockBase.CENTER, y: 30});
			header.setDefaultTweenOut(1, {x: BlockBase.CENTER, y: BlockBase.OFF_TOP_EDGE});
			addChild(header);
			
			divider = new BlockBitmap(Assets.divider);
			divider.setDefaultTweenIn(1, {x: BlockBase.CENTER, y: 250});
			divider.setDefaultTweenOut(1, {x: BlockBase.OFF_LEFT_EDGE, y: 250});
			addChild(divider);
			
			question = new Question();
			question.setDefaultTweenIn(1, {x: BlockBase.CENTER, y: 123});
			question.setDefaultTweenOut(1, {x: BlockBase.OFF_LEFT_EDGE});
			question.setText(CDW.database.getQuestionText());
			addChild(question);
			
			// triple stances
			stance= new BlockLabel('', 92, 0xffffff, 0x000000);
			stance.setPadding(24, 31, 23, 30);
			stance.considerDescenders = false;
			stance.setDefaultTweenIn(1, {x: 238, y: 280});
			stance.setDefaultTweenOut(1, {x: BlockBase.OFF_LEFT_EDGE, y: 280});			
			addChild(stance);			
			
			leftStance= new BlockLabel('', 92, 0xffffff, 0x000000);
			leftStance.setPadding(24, 31, 23, 30);
			leftStance.considerDescenders = false;
			leftStance.setDefaultTweenIn(1, {x: stance.defaultTweenInVars.x - stageWidth, y: stance.defaultTweenInVars.y});						
			addChild(leftStance);

			rightStance= new BlockLabel('', 92, 0xffffff, 0x000000);
			rightStance.setPadding(24, 31, 23, 30);
			leftStance.considerDescenders = false;			
			rightStance.setDefaultTweenIn(1, {x: stance.defaultTweenInVars.x + stageWidth, y: stance.defaultTweenInVars.y});						
			addChild(rightStance);			
			
			// triple nametags
			nametag = new BlockLabel('Name', 50, 0xffffff, 0x000000, Assets.FONT_HEAVY, true);
			nametag.setPadding(33, 38, 24, 38);
			nametag.setDefaultTweenIn(1, {x: 238, y: 410});
			nametag.setDefaultTweenOut(1, {x: BlockBase.OFF_RIGHT_EDGE, y: 410});
			addChild(nametag);
			
			leftNametag = new BlockLabel('Name', 50, 0xffffff, 0x000000, Assets.FONT_HEAVY, true);
			leftNametag.setPadding(33, 38, 24, 38);
			leftNametag.setDefaultTweenIn(1, {x: nametag.defaultTweenInVars.x - stageWidth, y: nametag.defaultTweenInVars.y});
			addChild(leftNametag);
			
			rightNametag = new BlockLabel('Name', 50, 0xffffff, 0x000000, Assets.FONT_HEAVY, true);
			rightNametag.setPadding(33, 38, 24, 38);
			rightNametag.setDefaultTweenIn(1, {x: nametag.defaultTweenInVars.x + stageWidth, y: nametag.defaultTweenInVars.y});
			addChild(rightNametag);

			byline = new BlockLabel('Byline', 22, 0xffffff, 0x000000, Assets.FONT_HEAVY, true);
			byline.setPadding(18, 32, 16, 32);
			byline.setDefaultTweenIn(1, {x: 586, y: 694});
			byline.setDefaultTweenOut(1, {x: BlockBase.OFF_LEFT_EDGE, y: 694});			
			addChild(byline);
			
			leftQuote = new QuotationMark();
			leftQuote.setDefaultTweenIn(1, {x: 114, y: 545});
			leftQuote.setDefaultTweenOut(1, {x: BlockBase.OFF_LEFT_EDGE, y: 545});	
			leftQuote.setStyle(QuotationMark.OPENING);
			addChild(leftQuote);
			
			rightQuote = new QuotationMark();
			rightQuote.setDefaultTweenIn(1, {x: 660, y: 1639});
			rightQuote.setDefaultTweenOut(1, {x: BlockBase.OFF_RIGHT_EDGE, y: 1639});				
			rightQuote.setStyle(QuotationMark.CLOSING);
			addChild(rightQuote);
			
			// triple opinions
			opinion = new BlockParagraph(915, 0x000000, '', 42);	
			opinion.setDefaultTweenIn(1, {x: 100, y: 1095});
			opinion.setDefaultTweenOut(1, {x: BlockBase.OFF_LEFT_EDGE, y: 1095});
			addChild(opinion);
			
			rightOpinion = new BlockParagraph(915, 0x000000, '', 42);
			rightOpinion.setDefaultTweenIn(1, {x: opinion.defaultTweenInVars.x + stageWidth, y: opinion.defaultTweenInVars.y});
			rightOpinion.setDefaultTweenOut(1, {x: opinion.defaultTweenInVars.x + stageWidth, y: opinion.defaultTweenInVars.y});
			addChild(rightOpinion);
			
			leftOpinion = new BlockParagraph(915, 0x000000, '', 42);	
			leftOpinion.setDefaultTweenIn(1, {x: opinion.defaultTweenInVars.x - stageWidth, y: opinion.defaultTweenInVars.y});
			leftOpinion.setDefaultTweenOut(1, {x: opinion.defaultTweenInVars.x - stageWidth, y: opinion.defaultTweenInVars.y});
			addChild(leftOpinion);		
			
			// TODO is there always a drag layer?
			dragLayer = new DragLayer();
			dragLayer.setDefaultTweenIn(0, {});
			dragLayer.setDefaultTweenOut(0, {});
			addChild(dragLayer);			
			
			editOpinion = new BlockInputParagraph(915, 0x000000, '', 42);
			editOpinion.setDefaultTweenIn(1, {x: 100, y: 1095});
			editOpinion.setDefaultTweenOut(1, {x: BlockBase.OFF_RIGHT_EDGE, y: 1095});			
			addChild(editOpinion);
			
			bigButton = new BigButton('ADD YOUR OPINION');
			bigButton.setDefaultTweenIn(1, {x: 455, y: 1470, alpha: 1});
			bigButton.setDefaultTweenOut(1, {x: 455, y: 1470, alpha: 0}); // TODO possibly subclass for cooler in and out tweens
			addChild(bigButton);
			
			statsButton = new IconButton(111, 55, 0x000000, 'Stats', 20, 0xffffff, Assets.FONT_BOLD, Assets.statsIcon);
			statsButton.setDefaultTweenIn(1, {x: 104, y: 1379});
			statsButton.setDefaultTweenOut(1, {x: BlockBase.OFF_LEFT_EDGE, y: 1379});
			addChild(statsButton);
			
			likeButton = new CounterButton(111, 55, 0x000000, 'Like', 20, 0xffffff, Assets.FONT_BOLD);
			likeButton.setTimeout(5000);
			likeButton.setDefaultTweenIn(1, {x: 238, y: 1379});
			likeButton.setDefaultTweenOut(1, {x: BlockBase.OFF_LEFT_EDGE, y: 1379});			
			addChild(likeButton);
			
			viewDebateButton = new BlockButton(517, 55, 0x000000, '', 20, 0xffffff, Assets.FONT_BOLD);
			viewDebateButton.setDefaultTweenIn(1, {x: 373, y: 1379});
			viewDebateButton.setDefaultTweenOut(1, {x: BlockBase.OFF_RIGHT_EDGE, y: 1379});			
			addChild(viewDebateButton);
			
			flagButton = new IconButton(59, 55, 0x000000, '', 20, 0xffffff, null, Assets.flagIcon);
			flagButton.setTimeout(5000);			
			flagButton.setDefaultTweenIn(1, {x: 914, y: 1379});
			flagButton.setDefaultTweenOut(1, {x: BlockBase.OFF_RIGHT_EDGE, y: 1379});
			addChild(flagButton);			
			
			debateButton = new BalloonButton(152, 135, 0x000000, 'LET\u2019S\nDEBATE !', 22, 0xffffff, Assets.FONT_HEAVY);
			debateButton.setDefaultTweenIn(1, {x: 813, y: 902, scaleX: 1, scaleY: 1});
			debateButton.setDefaultTweenOut(1, {x: BlockBase.OFF_RIGHT_EDGE, y: 901, scaleX: 1, scaleY: 1});
			addChild(debateButton);
			
			debateOverlay = new DebateOverlay();
			debateOverlay.setDefaultTweenIn(1, {x: 30, y: 813});
			debateOverlay.setDefaultTweenOut(1, {x: 30, y: BlockBase.OFF_BOTTOM_EDGE});			
			addChild(debateOverlay);			
			
			debatePicker = new DebatePicker();
			debatePicker.setDefaultTweenIn(1, {x: 0, y: 1748});
			debatePicker.setDefaultTweenOut(1, {x: 0, y: BlockBase.OFF_BOTTOM_EDGE});			
			debatePicker.update();
			addChild(debatePicker);
			
			answerPrompt = new BlockLabel('Your Answer / Please Select One :', 19, 0xffffff, Assets.COLOR_INSTRUCTION_DARK, Assets.FONT_REGULAR, true);
			answerPrompt.setPadding(22, 32, 24, 32);
			answerPrompt.setDefaultTweenIn(1, {x: 650, y: 1245});
			answerPrompt.setDefaultTweenOut(1, {x: BlockBase.OFF_RIGHT_EDGE, y: 1245});					
			addChild(answerPrompt);
			
			yesButton = new BlockButton(215, 100, Assets.COLOR_YES_LIGHT, 'YES!', 80);
			yesButton.setLetterSpacing(-3);
			yesButton.setDefaultTweenIn(1, {x: 447, y: 1340});
			yesButton.setDefaultTweenOut(1, {x: 447, y: BlockBase.OFF_BOTTOM_EDGE});
			addChild(yesButton);
			
			noButton = new BlockButton(185, 100, Assets.COLOR_NO_LIGHT, 'NO!', 80);			
			noButton.setLetterSpacing(-5);
			noButton.setDefaultTweenIn(1.2, {x: 677, y: 1340});
			noButton.setDefaultTweenOut(1.2, {x: 677, y: BlockBase.OFF_BOTTOM_EDGE});
			addChild(noButton);
			
			// Temp debug button so we don't have to SMS every time
			skipTextButton = new BlockButton(200, 100, Assets.COLOR_INSTRUCTION_DARK, 'SIMULATE SMS', 20);
			skipTextButton.setDefaultTweenIn(1, {x: BlockBase.CENTER, y: 500});
			skipTextButton.setDefaultTweenOut(1, {x: BlockBase.OFF_RIGHT_EDGE, y: 500});
			addChild(skipTextButton);

			var smsInstructionText:String = 'What would you say to convince others of your opinion?\nText ' + Utilities.formatPhoneNumber(CDW.settings.phoneNumber) + ' with your statement.'; 	
			smsInstructions = new BlockParagraph(915, 0x000000, smsInstructionText, 30, 0xffffff, Assets.FONT_REGULAR);
			smsInstructions.setDefaultTweenIn(1, {x: BlockBase.CENTER, y: 1096});
			smsInstructions.setDefaultTweenOut(1, {x: BlockBase.OFF_LEFT_EDGE, y: 1096});
			addChild(smsInstructions);
			
			var smsDisclaimerText:String = 'You will receive an SMS notifying you of any future opponents \nwho would like to enter into a debate with you based on your opinion. \nYou can opt out at any time by replying STOP.';
			smsDisclaimer = new BlockParagraph(872, Assets.COLOR_INSTRUCTION_75, smsDisclaimerText, 25);
			smsDisclaimer.textField.setTextFormat(new TextFormat(null, null, 0xc7c8ca), smsDisclaimerText.length -45, smsDisclaimerText.length);
			smsDisclaimer.setDefaultTweenIn(1, {x: BlockBase.CENTER, y: 1625});
			smsDisclaimer.setDefaultTweenOut(1, {x: BlockBase.OFF_LEFT_EDGE, y: 1625});
			addChild(smsDisclaimer);
			
			webPlug = new BlockLabel('Check out your photo and opinion at civildebatewall.com', 25, 0xffffff, Assets.COLOR_INSTRUCTION_75);
			webPlug.considerDescenders = false;
			webPlug.setPadding(25, 30, 25, 33);
			webPlug.setDefaultTweenIn(1, {x: BlockBase.CENTER, y: 1772});
			webPlug.setDefaultTweenOut(1, {x: BlockBase.OFF_RIGHT_EDGE, y: 1772});
			addChild(webPlug);			
			
			exitButton = new BlockButton(120, 60, 0x000000, 'EXIT', 25, 0xffffff, Assets.FONT_HEAVY);
			exitButton.setDefaultTweenIn(1, {x: 101, y: 1003});
			exitButton.setDefaultTweenOut(1, {x: BlockBase.OFF_LEFT_EDGE, y: 1003});			
			addChild(exitButton);
			
			characterLimit = new BlockLabel('Use No More than ' + CDW.settings.characterLimit + ' characters', 18, 0xffffff, 0x000000, Assets.FONT_BOLD);
			characterLimit.setPadding(22, 34, 22, 32);
			characterLimit.setDefaultTweenIn(1, {x: 683, y: 1246});
			characterLimit.setDefaultTweenOut(1, {x: BlockBase.OFF_RIGHT_EDGE, y: 1246});
			addChild(characterLimit);
			
			photoBoothNag = new BlockLabel('Please look into the Camera!', 33, 0xffffff, 0x000000, Assets.FONT_BOLD);
			photoBoothNag.setDefaultTweenIn(1.5, {x: BlockBase.CENTER, y: 176}); // elastic easing was over-the-top
			photoBoothNag.setDefaultTweenOut(1, {x: BlockBase.OFF_LEFT_EDGE, y: 176});
			addChild(photoBoothNag);			
			
			photoBoothInstructions = new BlockButton(382, 73, 0x000000, 'Touch to Countdown', 33);
			photoBoothInstructions.setDefaultTweenIn(1, {x: BlockBase.CENTER, y: 1628});
			photoBoothInstructions.setDefaultTweenOut(1, {x: BlockBase.CENTER, y: BlockBase.OFF_BOTTOM_EDGE});
			addChild(photoBoothInstructions);
			
			countdownButton = new CountdownButton(5);
			countdownButton.setDefaultTweenIn(1, {x: BlockBase.CENTER, y: 1438, scaleX: 1, scaleY: 1});
			countdownButton.setDefaultTweenOut(1, {x: BlockBase.CENTER, y: stageHeight});
			addChild(countdownButton);
			
			nameEntryInstructions = new BlockLabel('ENTER A UNIQUE NAME', 26, 0xffffff, 0x000000, Assets.FONT_HEAVY)
			nameEntryInstructions.setPadding(20, 31, 20, 31);
			nameEntryInstructions.setDefaultTweenIn(1, {x: 101, y: 1000});
			nameEntryInstructions.setDefaultTweenOut(1, {x: BlockBase.OFF_LEFT_EDGE, y: 1003});
			addChild(nameEntryInstructions);
			
			nameEntryField = new BlockInputLabel('', 33, 0xffffff, 0x000000, Assets.FONT_REGULAR, true);
			nameEntryField.setPadding(24, 30, 20, 30);
			nameEntryField.setDefaultTweenIn(1, {x: 101, y: 1093});
			nameEntryField.setDefaultTweenOut(1, {x: BlockBase.OFF_LEFT_EDGE, y: 1096});
			addChild(nameEntryField);			
			
			saveButton = new BlockButton(335, 63, 0x000000, 'SAVE AND CONTINUE', 26, 0xffffff, Assets.FONT_HEAVY);			
			saveButton.setDefaultTweenIn(1, {x: 308, y: 1200});
			saveButton.setDefaultTweenOut(1, {x: BlockBase.OFF_LEFT_EDGE, y: 1200});
			addChild(saveButton);
			
			retakePhotoButton = new BlockButton(270, 63, 0x000000, 'RETAKE PHOTO', 20);
			retakePhotoButton.setDefaultTweenIn(1, {x: 101, y: 1003});
			retakePhotoButton.setDefaultTweenOut(1, {x: BlockBase.OFF_LEFT_EDGE, y: 1003});
			addChild(retakePhotoButton);
			
			editTextButton = new BlockButton(200, 63, 0x000000, 'EDIT TEXT', 20);
			editTextButton.setDefaultTweenIn(1, {x: 386, y: 1003});
			editTextButton.setDefaultTweenOut(1, {x: BlockBase.OFF_RIGHT_EDGE, y: 1003});
			addChild(editTextButton);
			
			cancelButton = new BlockButton(171, 63, 0x000000, 'CANCEL', 20);
			cancelButton.setDefaultTweenIn(1, {x: 789, y: 1376});
			cancelButton.setDefaultTweenOut(1, {x: BlockBase.OFF_RIGHT_EDGE, y: 1376});
			addChild(cancelButton);			
			
			editTextInstructions = new BlockLabel('EDITING TEXT...', 20);
			editTextInstructions.setDefaultTweenIn(1, {x: 386, y: 1003});
			editTextInstructions.setDefaultTweenOut(1, {x: BlockBase.OFF_LEFT_EDGE, y: 1003});
			addChild(editTextInstructions);			
			
			keyboard = new Keyboard();
			keyboard.setDefaultTweenIn(1, {x: 0, y: stageHeight - keyboard.height});
			keyboard.setDefaultTweenOut(1, {x: 0, y: BlockBase.OFF_BOTTOM_EDGE});
			addChild(keyboard);
			
			// TODO update from database
			stats = new StatsOverlay();
			stats.setDefaultTweenIn(1, {x: BlockBase.CENTER, y: 264});
			stats.setDefaultTweenOut(1, {x: BlockBase.CENTER, y: BlockBase.OFF_BOTTOM_EDGE});
			addChild(stats);
			
			inactivityOverlay = new BlockBitmap(new Bitmap(new BitmapData(stageWidth, stageHeight, false, 0x000000)));
			inactivityOverlay.setDefaultTweenIn(1, {alpha: 0.85});
			inactivityOverlay.setDefaultTweenOut(1, {alpha: 0});
			addChild(inactivityOverlay);
			
			inactivityTimerBar = new ProgressBar(735, 2, 20);		
			inactivityTimerBar.setDefaultTweenIn(1, {x: BlockBase.CENTER, y: 1002});
			inactivityTimerBar.setDefaultTweenOut(1, {x: BlockBase.CENTER, y: BlockBase.OFF_TOP_EDGE});			
			addChild(inactivityTimerBar);
			
			inactivityInstructions = new BlockLabelBar('ARE YOU STILL THERE ?', 23, 0xffffff, 735, 63, Assets.COLOR_INSTRUCTION_75, Assets.FONT_HEAVY);
			inactivityInstructions.setDefaultTweenIn(1, {x: BlockBase.CENTER, y: 1018});
			inactivityInstructions.setDefaultTweenOut(1, {x: BlockBase.CENTER, y: BlockBase.OFF_TOP_EDGE});			
			addChild(inactivityInstructions);
			
			continueButton = new BlockButton(735, 120, Assets.COLOR_INSTRUCTION_50, 'YES!', 92);
			continueButton.setDownColor(Assets.COLOR_INSTRUCTION_75);
			continueButton.setDefaultTweenIn(1, {x: BlockBase.CENTER, y: 1098});
			continueButton.setDefaultTweenOut(1, {x: BlockBase.OFF_LEFT_EDGE, y: 1098});					
			addChild(continueButton);
			
			blackOverlay = new BlockBitmap(new Bitmap(new BitmapData(stageWidth, stageHeight, false, 0x000000)));
			blackOverlay.setDefaultTweenIn(0.1, {alpha: 1, immediateRender: true}); // duration of 0 doesn't work?
			blackOverlay.setDefaultTweenOut(0, {alpha: 0});
		
			addChild(blackOverlay);				
			
			flashOverlay = new BlockBitmap(new Bitmap(new BitmapData(stageWidth, stageHeight, false, 0xffffff)));
			flashOverlay.mouseEnabled = false; // let keystrokes through to the keyboard
			flashOverlay.setDefaultTweenIn(0.1, {alpha: 1, ease: Quart.easeOut, immediateRender: true});
			flashOverlay.setDefaultTweenOut(5, {alpha: 0, ease: Quart.easeOut});
			flashOverlay.name = 'Flash Overlay';
			addChild(flashOverlay);	
			
			// Block input during tweens
			protection = new Sprite();
			protection.graphics.beginFill(0x000000);
			protection.graphics.drawRect(0, 0, stageWidth, stageHeight);
			protection.graphics.endFill();
			protection.alpha = 0.25;
			addChild(protection);
			protection.visible = false;
			
			this.addEventListener(Event.ENTER_FRAME, onEnterFrame);
		}
		

		// another attempt to fix the missing tween problem by blocking input during tweens
		// better way to do it? tween counting at start and end of view function?
		// this ignores the flash overlay and breaks the draglayer...
		private function onEnterFrame(e:Event):void {
			protection.visible = false;
			var tweens:Array = TweenMax.getAllTweens();
			

			for(var i:int = 0; i < tweens.length; i++) {
				if(tweens[i].target is BlockBase) {
					if(tweens[i].target.name !== 'Flash Overlay') {
						protection.visible = true;
					}
				}
			}
		}
	
		
		// =========================================================================
		
		
		
		
		// land here if there aren't yet opinions for the current question
		// TODO some kind of "be the first" message
		public function noOpinionView(...args):void {
			markAllInactive();
			
			// mutations
			CDW.inactivityTimer.disarm();
			portrait.setImage(Assets.portraitPlaceholder);
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
			markAllInactive();
			
			CDW.inactivityTimer.disarm();
			
			// mutations
			portrait.setImage(CDW.database.getActivePortrait());
			question.setText(CDW.database.getQuestionText(), true);
			nametag.setText(CDW.database.getDebateAuthorName(CDW.state.activeDebate) + ' Says :', true);
			stance.setText(CDW.state.activeStanceText, true);
			opinion.setText(CDW.database.getOpinion(CDW.state.activeDebate));
			bigButton.setText('ADD YOUR OPINION', true);
			
			var commentCount:int = CDW.database.getCommentCount(CDW.state.activeDebate);
			

			likeButton.setCount(CDW.database.debates[CDW.state.activeDebate].likes);
			CDW.state.clearUser(); // Reset user info
			
			if (CDW.state.previousDebate != null) {
				// set the previous debate				
				leftOpinion.setText(CDW.database.getOpinion(CDW.state.previousDebate));				
				leftStance.setText(CDW.state.previousStanceText, true);
				leftNametag.setText(CDW.database.getDebateAuthorName(CDW.state.previousDebate) + ' Says :', true);				
				
				leftStance.setBackgroundColor(CDW.state.previousStanceColorLight, true);
				leftOpinion.setBackgroundColor(CDW.state.previousStanceColorLight, true);
				leftNametag.setBackgroundColor(CDW.state.previousStanceColorDark, true);					
			}
			
			if (CDW.state.nextDebate != null) {
				// set the previous debate
				rightOpinion.setText(CDW.database.debates[CDW.state.nextDebate].opinion);				
				rightStance.setText(CDW.state.nextStanceText, true);
				rightNametag.setText(CDW.database.getDebateAuthorName(CDW.state.nextDebate) + ' Says :', true);				
				
				rightStance.setBackgroundColor(CDW.state.nextStanceColorLight, true);				
				rightOpinion.setBackgroundColor(CDW.state.nextStanceColorLight, true);
				rightNametag.setBackgroundColor(CDW.state.nextStanceColorDark, true);
			}
			
			// set the active debate
			stance.setBackgroundColor(CDW.state.activeStanceColorLight, true);
			leftQuote.setColor(CDW.state.activeStanceColorLight, true);
			rightQuote.setColor(CDW.state.activeStanceColorLight, true);				
			nametag.setBackgroundColor(CDW.state.activeStanceColorDark, true);
			debateButton.setBackgroundColor(CDW.state.activeStanceColorDark, true);
			opinion.setBackgroundColor(CDW.state.activeStanceColorLight, true);
			statsButton.setBackgroundColor(CDW.state.activeStanceColorDark, true);
			likeButton.setBackgroundColor(CDW.state.activeStanceColorDark, true);
			flagButton.setBackgroundColor(CDW.state.activeStanceColorDark), true;
			

			if (commentCount == 0) {
				viewDebateButton.setLabel('No responses yet. Be the first!');
				viewDebateButton.setBackgroundColor(Assets.COLOR_INSTRUCTION_50, true);				
			}
			else {
				// TODO comment preview
				
				
				// Show as much comment as possible... truncate what we can't
				var firstCommentText:String = CDW.database.debates[CDW.state.activeDebate]['comments'][0]['comment'];
				var newLabel:String = '\u201C' + firstCommentText + '\u201D + ' + commentCount + ' ' + Utilities.plural('response', commentCount);				
				var commentLength:int = firstCommentText.length;
				var commentPreview:String = firstCommentText;				
				var previewWidth:Number = viewDebateButton.measureText(newLabel);
				
				while (previewWidth > 470) {
					commentLength--;
					commentPreview = StringUtils.truncate(firstCommentText, commentLength, '...');
					newLabel = '\u201C' + commentPreview + '\u201D + ' + commentCount + ' ' + Utilities.plural('response', commentCount);					
					previewWidth = viewDebateButton.measureText(newLabel);
				}
				
				viewDebateButton.setLabel(newLabel); // finally, tween it in				
				

				viewDebateButton.setBackgroundColor(CDW.state.activeStanceColorDark, true);
				
				// update the comments TODO move this to "set active debate" so it only happens once per update?
				debateOverlay.update();
			}			
			
			
			// behaviors
			if (commentCount == 0) {			
				viewDebateButton.setOnClick(null);
			}
			else {
				viewDebateButton.setOnClick(debateOverlayView);				
			}
			
			bigButton.setOnClick(onAddOpinionButton);			
			statsButton.setOnClick(statsView);
			debateButton.setOnClick(onDebateButton);
			likeButton.setOnClick(incrementLikes);
			flagButton.setOnClick(incrementFlags);
			
			
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
			
			leftQuote.tweenIn();
			rightQuote.tweenIn();
			
			opinion.tweenIn();
			rightOpinion.tweenIn();
			leftOpinion.tweenIn();
			
			bigButton.tweenIn();
			statsButton.tweenIn();
			likeButton.tweenIn();
			debateButton.tweenIn();
			flagButton.tweenIn();
			viewDebateButton.tweenIn();
			debatePicker.tweenIn();
			
			
			// override any tween outs here (flagging them as active means they won't get tweened out automatically)
			// note that it's a one-time thing, when the block tweens back in, it will start from its canonical "tween out" location
			// and not this temporary override
			debateOverlay.tweenOut(1, {y: -debateOverlay.height});
			
			// clean up the old based on what's not active
			tweenOutInactive();
						
			setTestOverlay(TestAssets.CDW_082511_Kiosk_Design);
		}
		
		private function onDebateButton(e:Event):void {
			CDW.state.userIsResponding = true;
			pickStanceView();
		}
		
		private function onAddOpinionButton():void {
			CDW.state.userIsResponding = false;
			pickStanceView();
		}		
		
		
		private function incrementLikes(e:Event):void {
			Utilities.postRequest(CDW.settings.serverPath + '/api/debates/like', {'id': CDW.state.activeDebate, 'count': likeButton.getCount()}, onLikePosted);
		}
		
		
		private function onLikePosted(response:Object):void {
			likeButton.setCount(parseInt(response.toString()));
		}
		
		
		private function incrementFlags(e:Event):void {
			Utilities.postRequest(CDW.settings.serverPath + '/api/debates/flag', {'id': CDW.state.activeDebate}, onFlagPosted);
		}
		
		
		private function onFlagPosted(response:Object):void {
			trace('bumping flags to  ' + response.toString());
		}		
		

		// =========================================================================
		
		
		public function debateOverlayView(...args):void {
			markAllInactive();			
			
			// services
			CDW.inactivityTimer.disarm();
			
			// mutations
			portrait.setImage(CDW.database.getActivePortrait());
			byline.setBackgroundColor(CDW.state.activeStanceColorMedium, true);
			byline.setText('Said by ' + CDW.database.debates[CDW.state.activeDebate].author.firstName, true);			
			viewDebateButton.setLabel('BACK TO HOME SCREEN');
			letsDebateUnderlay.height = 410 + opinion.height + 144 + 15 - letsDebateUnderlay.y; // height depends on opinion
			debateOverlay.setHeight(stageHeight - (letsDebateUnderlay.y + letsDebateUnderlay.height + 30 + 300));
			
			// behaviors
			viewDebateButton.setOnClick(homeView);
			
			// blocks
			portrait.tweenIn();
			
			
			letsDebateUnderlay.tweenIn();
			header.tweenIn();
			question.tweenIn();
			stance.tweenIn();
			byline.tweenIn(-1, {x: 916 - byline.width - 39, y: 410 + opinion.height + 30}); // dynamic based on opinion size
			opinion.tweenIn(1, {y: 410});
			debateButton.tweenIn(1, {x: 916, y: 410 + opinion.height + 15, scaleX: 0.75, scaleY: 0.75});
			viewDebateButton.tweenIn(1, {y: 1650});	
			debatePicker.tweenIn();
			debateOverlay.tweenIn(-1, {y: letsDebateUnderlay.y + letsDebateUnderlay.height + 30});			
			
			tweenOutInactive();	
			
			setTestOverlay(TestAssets.CDW_082511_Kiosk_Design7);			
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
		
		
		// For inter-debate transitions initiated by the debate picker...
		// tweens everything out except the portrait, then tweens stuff back in
		public function transitionView(...args):void {
			markAllInactive();
			portrait.setImage(CDW.database.getActivePortrait());
			
			portrait.tweenIn(0.5, {delay: 0.5, onComplete: onViewTransitionComplete});
			header.tweenIn();
			divider.tweenIn();
			question.tweenIn();			
			debatePicker.tweenIn();			
			
			leftQuote.tweenOut(0.25);
			rightQuote.tweenOut(0.25);
			opinion.tweenOut(0.25);
			stance.tweenOut(0.25);
			nametag.tweenOut(0.25);
			bigButton.tweenOut(0.25);
			statsButton.tweenOut(0.25);
			likeButton.tweenOut(0.25);
			debateButton.tweenOut(0.25);
			flagButton.tweenOut(0.25);
			viewDebateButton.tweenOut(0.25);			
			
			
			tweenOutInactive();	
		}
		
		private function onViewTransitionComplete():void {
			// tween stuff back in
			homeView();
		}
		
		
		// =========================================================================		
		
		
		public function pickStanceView(...args):void {
			markAllInactive();		
			
			CDW.inactivityTimer.arm();
			
			// mutations
			portrait.setImage(Assets.portraitPlaceholder);
			noButton.setBackgroundColor(Assets.COLOR_NO_LIGHT);
			yesButton.setBackgroundColor(Assets.COLOR_YES_LIGHT);			
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
			answerPrompt.tweenIn();
			yesButton.tweenIn();
			noButton.tweenIn();
			
			
			tweenOutInactive();	// TODO disable behaviors as well? or let them ride? implications for mid-tween events
			
			setTestOverlay(TestAssets.CDW_082511_Kiosk_Design8);			
		}
		
		
		// =========================================================================		

		
		private var smsCheckTimer:Timer;
		
		public function smsPromptView(...args):void {
			markAllInactive();
			
			CDW.inactivityTimer.arm();
			
			// mutations
			smsInstructions.setBackgroundColor(CDW.state.userStanceColorLight, true);
			characterLimit.setBackgroundColor(CDW.state.userStanceColorMedium, true);
			exitButton.setBackgroundColor(CDW.state.userStanceColorDark, true);
			noButton.showOutline(false);
			yesButton.showOutline(false);			
			
			if (CDW.state.userStance == 'yes') {
				noButton.setBackgroundColor(Assets.COLOR_INSTRUCTION_50, true);
			}
			else {	
				yesButton.setBackgroundColor(Assets.COLOR_INSTRUCTION_50, true);
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
			yesButton.setOnClick(null);
			noButton.setOnClick(null);
			skipTextButton.setOnClick(simulateSMS);
			
			// start polling to see if the user has sent their opinion yet
			CDW.state.latestSMSID = null;
			smsCheckTimer = new Timer(1000);
			smsCheckTimer.addEventListener(TimerEvent.TIMER, onSmsCheckTimer);
			smsCheckTimer.start();
			
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
			answerPrompt.tweenOut(-1, {x: BlockBase.OFF_LEFT_EDGE, y: answerPrompt.y});
			
			
			tweenOutInactive();
			
			setTestOverlay(TestAssets.CDW_082511_Kiosk_Design10);			
		}
		
		
		private function onSmsCheckTimer(e:TimerEvent):void {
			trace('checking for SMS received');
			var latestMessageLoader:URLLoader = new URLLoader();
			latestMessageLoader.addEventListener(Event.COMPLETE, onSMSCheckResponse);
			latestMessageLoader.load(new URLRequest("http://ec2-50-19-25-31.compute-1.amazonaws.com/api/sms/latest"));			
			
			smsCheckTimer.stop();
		}
		
		
		private function onSMSCheckResponse(e:Event):void {
			trace('check sms response received');
			var response:* = JSON.decode(e.target.data);			
			
			// TODO handle nothing in SMS chain
			
			// first time? save the id so we can compare
			if (CDW.state.latestSMSID == null) {
				trace('first time, setting id');
				CDW.state.latestSMSID = response['_id']['$oid'];
				smsCheckTimer.reset();
				smsCheckTimer.start();
			}
			else if (CDW.state.latestSMSID != response['_id']['$oid'] &&
				(response['To'] == CDW.settings.phoneNumber)) {
				
				// write some stuff down	
				CDW.state.userPhoneNumber = response['From'];
				CDW.state.userOpinion = response['Body'];
				
				trace('got new SMS from number: ' + CDW.state.userPhoneNumber);				
				
				// create or find the user
				Utilities.postRequestJSON(CDW.settings.serverPath + '/api/users/add-or-update', {'phoneNumber': escape(CDW.state.userPhoneNumber)}, onAddOrUpdateUser); 
			}
			else {
				// For debug								
				trace('no new sms, keep trying');
				CDW.state.latestSMSID = response['_id']['$oid'];					
				smsCheckTimer.reset();
				smsCheckTimer.start();			
			}			
		}
		
		private function onAddOrUpdateUser(user:Object):void {
			trace('User added or updated');
			
			CDW.state.userID = user['_id']['$oid'];
			
			// does the user have a photo?
			if (user['photo'] == null) {
				// no photo
				trace('no photo! go take one!');
				photoBoothView();
			}
			else {
				// have a photo, load it // TODO handle missing file
				Utilities.loadImageFromDisk(CDW.settings.imagePath + CDW.state.userID + '-full.jpg', onUserImageLoaded);
				
				//how about a name?
				if (user['firstName'] == null) {
					// go get a name
					nameEntryView();
				}
				else {
					// you have a name and a photo! go to review page
					CDW.state.userName = user['firstName'];
					
					verifyOpinionView();
				}
			}
		}
		
		
		private function onUserImageLoaded(b:Bitmap):void {
			CDW.state.userImage = b;
			portrait.setImage(CDW.state.userImage);
		}
		
		
		public function simulateSMS(e:Event):void {
			smsCheckTimer.stop();			
			
			// write some stuff down	
			CDW.state.userPhoneNumber = '+1555' + Utilities.randRange(1000000, 9999999).toString();
			CDW.state.userOpinion = Utilities.dummyText(100);						
			
			// create or find the user
			Utilities.postRequestJSON(CDW.settings.serverPath + '/api/users/add-or-update', {'phoneNumber': escape(CDW.state.userPhoneNumber)}, onAddOrUpdateUser);			
		}
		
		
		// =========================================================================		
		
		private var faceDetector:FaceDetector = new FaceDetector();
		
		public function photoBoothView(...args):void {
			markAllInactive();
			
			CDW.inactivityTimer.arm();
			
			// mutations
			countdownButton.progressRing.alpha = 0; // starts transparent			
			stance.setText(CDW.state.userStanceText, true);
			stance.setBackgroundColor(CDW.state.userStanceColorLight, true);
			countdownButton.setBackgroundColor(CDW.state.userStanceColorLight, true);
			countdownButton.setRingColor(CDW.state.userStanceColorLight);
			countdownButton.setProgressColor(CDW.state.userStanceColorDark);				
			photoBoothInstructions.setBackgroundColor(CDW.state.userStanceColorMedium, true);
			photoBoothNag.setBackgroundColor(CDW.state.userStanceColorMedium, true);
			cameraOverlay.setColor(CDW.state.userStanceColorLight, CDW.state.userStanceColorOverlay);
			
			// behaviors
			countdownButton.setOnClick(onCameraClick);
			countdownButton.setOnAlmostFinish(onCountdownAlmostFinish);			
			countdownButton.setOnFinish(onCountdownFinish);
			photoBoothInstructions.setOnClick(onCameraClick);
			
			// blocks
			portraitCamera.tweenIn();
			header.tweenIn();
			cameraOverlay.tweenIn();
			photoBoothInstructions.tweenIn();
			countdownButton.tweenIn();			
			
			tweenOutInactive();
			
			setTestOverlay(TestAssets.CDW_082511_Kiosk_Design11);
		}
		
		
		private function onCameraClick(e:Event):void {
			if (!countdownButton.isCountingDown()) {
				header.tweenOut();
				photoBoothInstructions.tweenOut();
				
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
			// TODO Y U NO WORK?
			//blackOverlay.tweenIn(0, {alpha: 1, onComplete: onScreenBlack});
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
				portraitCamera.slr.addEventListener(CameraFeedEvent.NEW_FRAME_EVENT, onPhotoCapture);
				portraitCamera.slr.takePhoto();
			}
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
			
			if (faceDetector.faceRect != null) {
				trace('face found, cropping to it');
				
				// TODO move this to function
				var scaleFactor:Number = CDW.state.userImage.height / faceDetector.maxSourceHeight;
				var faceRect:Rectangle = faceDetector.faceRect;
				var scaledFaceRect:Rectangle = new Rectangle(faceRect.x * scaleFactor, faceRect.y * scaleFactor, faceRect.width * scaleFactor, faceRect.height * scaleFactor);
				var stageFactor:Number = CDW.state.userImage.height / stageHeight; // unused
				
				// first center it
				var idealFacePoint:Point = new Point(CDW.state.userImage.width / 2, CDW.state.userImage.height / 4);
				var facePoint:Point = Utilities.centerPoint(scaledFaceRect);
				
				// TODO add scale step
				
				// figure out how we need to move
				var shiftX:int = idealFacePoint.x - facePoint.x;
				var shiftY:int = idealFacePoint.y - facePoint.y;
				
				var cropRect:Rectangle = new Rectangle();
				
				if (shiftX < 0) {
					// cut from the left
					cropRect.x = Math.abs(shiftX);
					cropRect.width = CDW.state.userImage.bitmapData.width - cropRect.x;
				}
				else {
					// cut from the right
					cropRect.x = 0;
					cropRect.width = CDW.state.userImage.bitmapData.width - shiftX;					
				}
				
				if (shiftY < 0) {
					// cut from the top
					cropRect.y = Math.abs(shiftY);
					cropRect.height = CDW.state.userImage.bitmapData.height - cropRect.y;
				}
				else {
					// cut from the bottom
					cropRect.y = 0;
					cropRect.width = CDW.state.userImage.bitmapData.height - shiftY;					
				}				
				
				
				// crop off the side as necessarry
				var croppedImage:BitmapData = new BitmapData(cropRect.width, cropRect.height);
				
				//CDW.state.userImage.bitmapData.fillRect(scaledFaceRect, 0xcc000000);				
				croppedImage.copyPixels(CDW.state.userImage.bitmapData, cropRect, new Point(0,0));
				
				CDW.state.userImage.bitmapData = Utilities.scaleToFill(croppedImage, stageWidth, stageHeight);				
			}
			else {
				trace('no face found, saving as is');
				CDW.state.userImage.bitmapData = Utilities.scaleToFill(CDW.state.userImage.bitmapData, stageWidth, stageHeight);
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
			markAllInactive();
			flashOverlay.active = true; // needs to tween out itself
			
			CDW.inactivityTimer.arm();
			
			// mutations
			stance.setText(CDW.state.userStanceText);
			stance.setBackgroundColor(CDW.state.userStanceColorLight);			
			nameEntryInstructions.setBackgroundColor(CDW.state.userStanceColorLight, true);
			saveButton.setBackgroundColor(CDW.state.userStanceColorDark, true);
			keyboard.setColor(CDW.state.userStanceColorLight, true);
			nameEntryField.setBackgroundColor(CDW.state.userStanceColorLight, true);
			portrait.setImage(CDW.state.userImage, true);
			nameEntryField.setText('', true); // clear the name entry field			
			keyboard.target = nameEntryField.getTextField();
			
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
			saveButton.tweenIn(-1, {delay: 1});
			keyboard.tweenIn(-1, {delay: 1});
			
			tweenOutInactive(true);
			
			this.setTestOverlay(TestAssets.CDW_082511_Kiosk_Design16);			
		}
		
		private function onSaveName(e:Event):void {
			// TODO input validation
			
			// Save name to RAM
			CDW.state.userName = nameEntryField.getTextField().text;
			
			// Update the name on the server
			Utilities.postRequest(CDW.settings.serverPath + '/api/users/add-or-update', {'id': CDW.state.userID, 'firstName': CDW.state.userName}, onNameUpdated);
			
			verifyOpinionView();
		}
		
		private function onNameUpdated(r:Object):void {
			trace('Name updated on server:' + r);
		}
		
		
		// =========================================================================
		
		
		public function verifyOpinionView(...args):void {
			markAllInactive();
			
			CDW.inactivityTimer.arm();
			
			// mutations
			portrait.setImage(CDW.state.userImage, true);
			bigButton.setText('SUBMIT THIS DEBATE', true);
			bigButton.enable();
			nametag.setText(CDW.state.userName + ' Says:', true);
			opinion.setText(CDW.state.userOpinion);
			
			nametag.setBackgroundColor(CDW.state.userStanceColorMedium, true); // make instant?
			opinion.setBackgroundColor(CDW.state.userStanceColorLight, true);	
			retakePhotoButton.setBackgroundColor(CDW.state.userStanceColorDark, true);
			editTextButton.setBackgroundColor(CDW.state.userStanceColorDark, true);
			cancelButton.setBackgroundColor(CDW.state.userStanceColorDark, true);
			leftQuote.setColor(CDW.state.userStanceColorLight, true);
			rightQuote.setColor(CDW.state.userStanceColorLight, true);				
			
			// TODO stance?
			
			// behaviors
			retakePhotoButton.setOnClick(photoBoothView);
			editTextButton.setOnClick(editOpinionView);
			cancelButton.setOnClick(homeView);
			bigButton.setOnClick(onSubmitOpinion);
			
			// blocks
			leftQuote.tweenIn();
			rightQuote.tweenIn();			
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
			cancelButton.tweenIn();			
			webPlug.tweenIn();			
			
			trace("tweening out name entry");
			nameEntryField.tweenOut();
			
			tweenOutInactive();
			
			this.setTestOverlay(TestAssets.CDW_082511_Kiosk_Design17);			
		}
		
		private function onSubmitOpinion():void {
			
			// Syncs state up to the cloud
						
			// save the image to disk
			var imageName:String = Utilities.saveImageToDisk(CDW.state.userImage, CDW.settings.imagePath, CDW.state.userID + '-full.jpg');
			
			
			var payload:Object;
			
			if (CDW.state.userIsResponding) {
				// create and upload new comment
				trace("Uploading comment");
				payload = {'author': CDW.state.userID, 'question': CDW.state.activeQuestion, 'debate': CDW.state.activeDebate, 'comment': CDW.state.userOpinion, 'stance': CDW.state.userStance, 'origin': 'kiosk'};
				Utilities.postRequest(CDW.settings.serverPath + '/api/comments/add', payload, onDebateUploaded);				
			}
			else {
				// create and upload new debate
				trace("Uploading new debate");				
				payload = {'author': CDW.state.userID, 'question': CDW.state.activeQuestion, 'opinion': CDW.state.userOpinion, 'stance': CDW.state.userStance, 'origin': 'kiosk'};
				Utilities.postRequest(CDW.settings.serverPath + '/api/debates/add', payload, onDebateUploaded);
			}
		}
		
		private function onDebateUploaded(r:Object):void {
			
			if (CDW.state.userIsResponding) {
				trace('comment uploaded: ' + r);
			}
			else {
				trace('debate uploaded: ' + r);
				// set the current debate to the one that was just saved				
				CDW.state.activeDebate = r.toString();
			}
			
			// grab the latest from the db
			// this will go to home view
			// TODO fire a passed in callback function instead?
			CDW.database.load();
		}
		
		
		// =========================================================================		
		
		
		public function editOpinionView(...args):void {
			markAllInactive();
			
			CDW.inactivityTimer.arm();
			
			// mutations
			editOpinion.setText(CDW.state.userOpinion);

			keyboard.target = editOpinion.getTextField();
			
			editTextInstructions.setBackgroundColor(CDW.state.userStanceColorDark);
			saveButton.setBackgroundColor(CDW.state.userStanceColorDark);
			editOpinion.setBackgroundColor(CDW.state.userStanceColorLight);
			
			// behaviors
			saveButton.setOnClick(onSaveOpinionEdit);
			
			//blocks
			leftQuote.tweenIn();	
			rightQuote.tweenIn(); // stays under keyboard		
			portrait.tweenIn();	
			header.tweenIn();
			divider.tweenIn();
			question.tweenIn();
			stance.tweenIn();
			nametag.tweenIn();
			
			//opinion.tweenIn(); // TODO fade this out?
			editOpinion.tweenIn();
			saveButton.tweenIn(-1, {y: editOpinion.y + editOpinion.height + 30});
			editTextInstructions.tweenIn();
			keyboard.tweenIn();
			
			tweenOutInactive();
			
			this.setTestOverlay(TestAssets.CDW_082511_Kiosk_Design21);			
		}
		
		
		private function onSaveOpinionEdit(e:Event):void {
			// TODO validate opinion edit
			CDW.state.userOpinion = editOpinion.getTextField().text;
			verifyOpinionView();
		}
		
		
		// =========================================================================
		
		
		public function statsView(...args):void {
			CDW.inactivityTimer.disarm();
			
			// mutations
			portrait.setImage(Assets.statsUnderlay);
			
			// behaviors
			stats.homeButton.setOnClick(onStatsClose);
			
			// blocks
			portrait.tweenIn();	
			header.tweenIn();
			divider.tweenIn();
			question.tweenIn();
			stats.tweenIn();
			
			this.setTestOverlay(TestAssets.CDW_082511_Kiosk_Design25);			
		}
		
		private function onStatsClose(e:Event):void {
			// restore portrait
			portrait.setImage(CDW.database.getActivePortrait());
			stats.tweenOut();
		}
		
		
		// =========================================================================		
		
		
		public function inactivityView(...args):void {
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
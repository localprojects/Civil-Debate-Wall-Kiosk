package net.localprojects {
	import com.bit101.components.FPSMeter;
	import com.greensock.*;
	import com.greensock.easing.*;
	import com.greensock.events.LoaderEvent;
	import com.greensock.events.TweenEvent;
	
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
	
	import jp.maaash.ObjectDetection.ObjectDetectorEvent;
	
	import net.localprojects.blocks.*;
	import net.localprojects.camera.*;
	import net.localprojects.elements.*;
	import net.localprojects.keyboard.*;
	import net.localprojects.ui.*;
	

	public class View extends Sprite {
		
		// single copy, never changes
		private var header:Header;
		private var divider:Divider;
		private var answerPrompt:BlockLabel;
		private var smsDisclaimer:BlockParagraph;
		private var portraitOutline:PortraitOutline;
		private var portraitCamera:PortraitCamera;
		private var nameEntryInstructions:BlockLabel;
		private var nameEntryField:BlockInputLabel;		
		private var saveButton:BlockButton;
		private var retakePhotoButton:BlockButton;
		private var editTextButton:BlockButton;
		private var cancelButton:BlockButton;		
		private var editTextInstructions:BlockLabel;
		private var inactivityOverlay:InactivityOverlay;
		private var inactivityInstructions:BlockLabel;
		private var continueButton:BlockButton;
		private var restartButton:BlockButton;
		private var flashOverlay:FlashOverlay;
		
		// single copy, changes
		private var question:Question;
		private var leftQuote:QuotationMark;
		private var rightQuote:QuotationMark;		
		private var portrait:Portrait; // TODO fading
		private var bigButton:BigButton;		
		private var statsButton:IconButton;
		private var likeButton:CounterButton;
		private var debateButton:IconButton;
		private var viewDebateButton:BlockButton;		
		private var debatePicker:DebatePicker;
		private var debateOverlay:DebateOverlay;
		private var yesButton:BlockButton;
		private var noButton:BlockButton;
		private var backButton:BlockButton;
		private var smsInstructions:BlockParagraph;
		private var characterLimit:BlockLabel;
		private var photoBoothInstructions:BlockParagraph;
		private var countdown:Countdown;
		private var stats:Stats;
		private var keyboard:Keyboard;
		private var editOpinion:BlockInputParagraph;		
		
		// multiples of these
		private var stance:Stance;		
		private var nametag:BlockLabel;
		private var opinion:BlockParagraph;
		private var byline:BlockLabel;
		
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
			
			// dump everything with just a single instanceon the stage,
			// they'll get tweened in and out as necessary
			portrait = new Portrait();
			portrait.setDefaultTweenIn(1, {alpha: 1});
			portrait.setDefaultTweenOut(1, {alpha: 0});			
			addChild(portrait);
			
			portraitCamera = new PortraitCamera();
			portraitCamera.setDefaultTweenIn(1, {alpha: 1});
			portraitCamera.setDefaultTweenOut(1, {alpha: 0});
			addChild(portraitCamera);
			
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
			question.setDefaultTweenIn(1, {x: 30, y: 132});
			question.setDefaultTweenOut(1, {x: -question.width, y: 132});
			question.setText(CDW.database.questions[CDW.state.activeQuestion].question); // TODO abstract out these ridiculous traversals...
			addChild(question);
			
			stance = new Stance();
			stance.setText(CDW.database.debates[CDW.state.activeDebate].stance);			
			stance.setDefaultTweenIn(1, {x: 275, y: 280});
			stance.setDefaultTweenOut(1, {x: -280, y: 280});						
			addChild(stance);			

			nametag = new BlockLabel('Name', 50, 0xffffff, Assets.COLOR_YES_MEDIUM, true, true);
			nametag.setPadding(26, 28, 20, 30);
			nametag.setDefaultTweenIn(1, {x: 275, y: 410});
			nametag.setDefaultTweenOut(1, {x: stageWidth, y: 410});
			addChild(nametag);
			
			byline = new BlockLabel('Byline', 22, 0xffffff, Assets.COLOR_YES_MEDIUM, false, true);
			byline.setPadding(18, 32, 16, 32);
			byline.setDefaultTweenIn(1, {x: 586, y: 694});
			byline.setDefaultTweenOut(1, {x: -500, y: 694});			
			addChild(byline);
			
			leftQuote = new QuotationMark();
			leftQuote.setDefaultTweenIn(1, {x: 100, y: 545});
			leftQuote.setDefaultTweenOut(1, {x: -leftQuote.width, y: 545});	
			leftQuote.setStyle(QuotationMark.OPENING);
			leftQuote.setColor(Assets.COLOR_YES_LIGHT);
			addChild(leftQuote);
			
			rightQuote = new QuotationMark();
			rightQuote.setDefaultTweenIn(1, {x: 720, y: 1635});
			rightQuote.setDefaultTweenOut(1, {x: stageWidth, y: 1643});				
			rightQuote.setStyle(QuotationMark.CLOSING);
			rightQuote.setColor(Assets.COLOR_YES_LIGHT);
			addChild(rightQuote);
			
			opinion = new BlockParagraph(915, 'Opinion goes here', 44, Assets.COLOR_YES_LIGHT, false); 
			opinion.setDefaultTweenIn(1, {x: 100, y: 1095});
			opinion.setDefaultTweenOut(1, {x: -opinion.width, y: 1095});
			opinion.setText(CDW.database.debates[CDW.state.activeDebate].opinion);
			addChild(opinion);
			
			editOpinion = new BlockInputParagraph(915, '', 44, Assets.COLOR_YES_LIGHT, false);
			editOpinion.setDefaultTweenIn(1, {x: 100, y: 1095});
			editOpinion.setDefaultTweenOut(1, {x: -editOpinion.width, y: 1095});
			editOpinion.setText(CDW.database.debates[CDW.state.activeDebate].opinion);			
			addChild(editOpinion);
			
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
			likeButton.setDefaultTweenOut(1, {x: stageWidth, y: 955});			
			addChild(likeButton);
			
			debateButton = new IconButton(150, 130, 'Let\u0027s\nDebate', 20, Assets.COLOR_YES_DARK, null, true);
			debateButton.setDefaultTweenIn(1, {x: 842, y: 807, scaleX: 1, scaleY: 1});
			debateButton.setDefaultTweenOut(1, {x: stageWidth, y: 807, scaleX: 1, scaleY: 1});
			addChild(debateButton);
			
			viewDebateButton = new BlockButton(370, 63, '8 People Debated This', 25, Assets.COLOR_YES_DARK, true);
			viewDebateButton.setDefaultTweenIn(1, {x: 590, y: 1375});
			viewDebateButton.setDefaultTweenOut(1, {x: stageWidth, y: 1375});			
			addChild(viewDebateButton);
			
			debateOverlay = new DebateOverlay();
			debateOverlay.setDefaultTweenIn(1, {x: 30, y: 813});
			debateOverlay.setDefaultTweenOut(1, {x: 30, y: stageHeight});			
			addChild(debateOverlay);			
			
			debatePicker = new DebatePicker();
			debatePicker.setDefaultTweenIn(1, {x: 0, y: 1748});
			debatePicker.setDefaultTweenOut(1, {x: 0, y: stageHeight});			
			debatePicker.update(); // syncs with state, TODO same for stats
			addChild(debatePicker);
			
			answerPrompt = new BlockLabel('Your Answer / Please Select One :', 19, 0xffffff, Assets.COLOR_INSTRUCTION_DARK, false, true);
			answerPrompt.setPadding(20, 30, 18, 32);
			answerPrompt.setDefaultTweenIn(1, {x: 650, y: 1245});
			answerPrompt.setDefaultTweenOut(1, {x: stageWidth, y: 1245});					
			addChild(answerPrompt);
			
			yesButton = new BlockButton(215, 100, 'YES!', 80, Assets.COLOR_YES_LIGHT, false, false);
			yesButton.setDefaultTweenIn(1, {x: 447, y: 1340});
			yesButton.setDefaultTweenOut(1, {x: 447, y: stageHeight});
			addChild(yesButton);
			
			noButton = new BlockButton(185, 100, 'NO!', 80, Assets.COLOR_NO_LIGHT, false, false);			
			noButton.setDefaultTweenIn(1.2, {x: 677, y: 1340});
			noButton.setDefaultTweenOut(1.2, {x: 677, y: stageHeight});
			addChild(noButton);
			
			var smsDisclaimerText:String = 'You will receive an SMS notifying you of any future opponents \nwho would like to enter into a debate with you based on your opinion. \nYou can opt out at any time by replying STOP.';
			smsDisclaimer = new BlockParagraph(872, smsDisclaimerText, 25, Assets.COLOR_INSTRUCTION_DARK, false);
			smsDisclaimer.setDefaultTweenIn(1, {x: 100, y: 1625});
			smsDisclaimer.setDefaultTweenOut(1, {x: 100, y: stageHeight});
			addChild(smsDisclaimer);
			
			backButton = new BlockButton(135, 63, 'BACK', 25, Assets.COLOR_YES_DARK, true);
			backButton.setDefaultTweenIn(1, {x: 101, y: 1003});
			backButton.setDefaultTweenOut(1, {x: -backButton.width, y: 1003});			
			addChild(backButton);
			
			var smsInstructionText:String = 'What would you say to convince others of your opinion?\nText ' + CDW.settings.phoneNumber + ' with your statement.'; 	
			smsInstructions = new BlockParagraph(915, smsInstructionText, 33, Assets.COLOR_YES_LIGHT, false);
			smsInstructions.setDefaultTweenIn(1, {x: 101, y: 1096});
			smsInstructions.setDefaultTweenOut(1, {x: stageWidth, y: 1096});
			addChild(smsInstructions);			
			
			characterLimit = new BlockLabel('Use no more than ' + CDW.settings.characterLimit + ' characters', 20, 0xffffff, Assets.COLOR_YES_MEDIUM);
			characterLimit.setPadding(20, 30, 18, 32);
			characterLimit.setDefaultTweenIn(1, {x: 648, y: 1246});
			characterLimit.setDefaultTweenOut(1, {x: stageWidth, y: 1246});
			addChild(characterLimit);
			
			var photoBoothInstructionText:String = 'Thank you! Please align yourself with the silhouette in\norder to accurately take your photo for the debate.';
			photoBoothInstructions = new BlockParagraph(880, photoBoothInstructionText, 30, Assets.COLOR_YES_LIGHT, false);
			photoBoothInstructions.setDefaultTweenIn(1, {x: 100, y: 1096});
			photoBoothInstructions.setDefaultTweenOut(1, {x: stageWidth, y: 1096});
			addChild(photoBoothInstructions);
			
			countdown = new Countdown(5);
			countdown.setDefaultTweenIn(1, {x: 470, y: 1470});
			countdown.setDefaultTweenOut(1, {x: 470, y: stageHeight});
			addChild(countdown);
			
			nameEntryInstructions = new BlockLabel('TYPE IN YOUR NAME', 20, 0xffffff, Assets.COLOR_YES_LIGHT, false, true);
			nameEntryInstructions.setDefaultTweenIn(1, {x: 101, y: 1003});
			nameEntryInstructions.setDefaultTweenOut(1, {x: -nameEntryInstructions.width, y: 1096});
			addChild(nameEntryInstructions);
			
			// TODO fix the text entry field
			nameEntryField = new BlockInputLabel('', 30, 0xffffff, Assets.COLOR_YES_LIGHT, false, true);
			nameEntryField.setDefaultTweenIn(1, {x: 101, y: 1096});
			nameEntryField.setDefaultTweenOut(1, {x: -nameEntryField.width, y: 1196});
			addChild(nameEntryField);			
			
			saveButton = new BlockButton(335, 63, 'SAVE AND CONTINUE', 20, Assets.COLOR_YES_DARK, false);
			saveButton.setDefaultTweenIn(1, {x: 308, y: 1200});
			saveButton.setDefaultTweenOut(1, {x: -saveButton.width, y: 1200});
			addChild(saveButton);
			
			retakePhotoButton = new BlockButton(270, 63, 'RETAKE PHOTO', 20, Assets.COLOR_YES_DARK, false);
			retakePhotoButton.setDefaultTweenIn(1, {x: 101, y: 1003});
			retakePhotoButton.setDefaultTweenOut(1, {x: -retakePhotoButton.width, y: 1003});
			addChild(retakePhotoButton);
			
			editTextButton = new BlockButton(200, 63, 'EDIT TEXT', 20, Assets.COLOR_YES_DARK, false);
			editTextButton.setDefaultTweenIn(1, {x: 386, y: 1003});
			editTextButton.setDefaultTweenOut(1, {x: stageWidth, y: 1003});
			addChild(editTextButton);
			
			cancelButton = new BlockButton(171, 63, 'CANCEL', 20, Assets.COLOR_YES_DARK, false);
			cancelButton.setDefaultTweenIn(1, {x: 789, y: 1376});
			cancelButton.setDefaultTweenOut(1, {x: stageWidth, y: 1376});
			addChild(cancelButton);			
			
			editTextInstructions = new BlockLabel('EDITING TEXT...', 20, 0xffffff, Assets.COLOR_YES_LIGHT, false, true);
			editTextInstructions.setDefaultTweenIn(1, {x: 386, y: 1096});
			editTextInstructions.setDefaultTweenOut(1, {x: -editTextInstructions.width, y: 1096});
			addChild(editTextInstructions);			
			
			keyboard = new Keyboard();
			keyboard.setDefaultTweenIn(1, {x: 0, y: stageHeight - keyboard.height});
			keyboard.setDefaultTweenOut(1, {x: 0, y: stageHeight});
			addChild(keyboard);
			
			stats = new Stats();
			stats.setDefaultTweenIn(1, {x: 30, y: 264});
			stats.setDefaultTweenOut(1, {x: 30, y: stageHeight});
			addChild(stats);
			
			inactivityOverlay = new InactivityOverlay();
			inactivityOverlay.setDefaultTweenIn(1, {alpha: 1});
			inactivityOverlay.setDefaultTweenOut(1, {alpha: 0});			
			addChild(inactivityOverlay);
			
			inactivityInstructions = new BlockLabel('ARE YOU STILL THERE?', 30, 0xffffff, Assets.COLOR_INSTRUCTION_DARK);
			inactivityInstructions.setDefaultTweenIn(1, {x: 168, y: 1038});
			inactivityInstructions.setDefaultTweenOut(1, {x: 168, y: -inactivityInstructions.height});			
			inactivityInstructions.width = 735; 
			addChild(inactivityInstructions);
			
			continueButton = new BlockButton(259, 120, 'YES!', 50, Assets.COLOR_INSTRUCTION_MEDIUM, false);
			continueButton.setDefaultTweenIn(1, {x: 168, y: 1116});
			continueButton.setDefaultTweenOut(1, {x: -continueButton.width, y: 1116});					
			addChild(continueButton);
			
			restartButton = new BlockButton(461, 120, 'RESTART!', 50, Assets.COLOR_INSTRUCTION_MEDIUM, false);
			restartButton.setDefaultTweenIn(1, {x: 443, y: 1116});
			restartButton.setDefaultTweenOut(1, {x: stageWidth, y: 1116});					
			addChild(restartButton);
			
			flashOverlay = new FlashOverlay();
			flashOverlay.setDefaultTweenIn(0.1, {alpha: 1, ease: Quart.easeOut});
			flashOverlay.setDefaultTweenOut(5, {alpha: 0, ease: Quart.easeOut});
			addChild(flashOverlay);
			
		}
		
		
		public function homeView(...args):void {
			markAllInactive();
			
			// mutations
			portrait.setImage(CDW.database.users[CDW.database.debates[CDW.state.activeDebate].author._id.$oid].portrait);
			nametag.setText(CDW.database.debates[CDW.state.activeDebate].author.firstName + ' ' + CDW.database.debates[CDW.state.activeDebate].author.lastName + ' Says :');
			stance.setStance(CDW.database.debates[CDW.state.activeDebate].stance);
			
			// behaviors
			viewDebateButton.setOnClick(debateOverlayView);	
			bigButton.setOnClick(pickStanceView);			
			statsButton.setOnClick(statsView);
			debateButton.setOnClick(pickStanceView);
			
			// blocks
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
			// note that it's a one-time thing, when the block tweens back in, it will start from its canonical "tween out" location
			// and not this temporary override
			debateOverlay.tweenOut(1, {y: -debateOverlay.height});
			
			// clean up the old based on what's not active
			tweenOutInactive();
		}
		
		
		public function debateOverlayView(...args):void {
			markAllInactive();			
			
			// mutations
			portrait.setImage(CDW.database.users[CDW.database.debates[CDW.state.activeDebate].author._id.$oid].portrait);
			byline.setText('Said by ' + CDW.database.debates[CDW.state.activeDebate].author.firstName + ' ' + CDW.database.debates[CDW.state.activeDebate].author.lastName);			
			
			// behaviors
			viewDebateButton.setOnClick(homeView);
			
			// blocks
			portrait.tweenIn();
			header.tweenIn();
			divider.tweenIn();
			question.tweenIn();
			stance.tweenIn();
			byline.tweenIn();
			opinion.tweenIn(1, {y: 410});
			debateButton.tweenIn(1, {x: 916, y: 660, scaleX: 0.75, scaleY: 0.75});
			viewDebateButton.tweenIn(1, {y: 1650});
			debatePicker.tweenIn();
			debateOverlay.tweenIn();			
			// show the big button or not?

			tweenOutInactive();			
		}
		
		// move to control class?
		private function onYesButton(e:MouseEvent):void {
			CDW.state.userStance = 'yes';
			textPromptView();
		}
		
		private function onNoButton(e:MouseEvent):void {
			trace("no button");
			CDW.state.userStance = 'no';
			textPromptView();			
		}
		
		
		public function pickStanceView(...args):void {
			markAllInactive();		
			
			// mutations
			portrait.setImage(Assets.portraitPlaceholder);
			
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
			smsDisclaimer.tweenIn();
			
			tweenOutInactive();	// TODO disable behaviors as well? or let them ride? implications for mid-tween events		
		}
		
		
		public function textPromptView(...args):void {
			markAllInactive();
			
			// mutations
			// TODO Mutate according to stance state
			
			// behaviors
			backButton.setOnClick(pickStanceView); // TODO do we need the back button?
			portrait.setImage(Assets.portraitPlaceholder);
			stance.setStance(CDW.state.userStance);
			CDW.state.userStance == 'yes' ? smsInstructions.setBackgroundColor(Assets.COLOR_YES_LIGHT) : smsInstructions.setBackgroundColor(Assets.COLOR_NO_LIGHT);
			CDW.state.userStance == 'yes' ? characterLimit.setBackgroundColor(Assets.COLOR_YES_MEDIUM) : characterLimit.setBackgroundColor(Assets.COLOR_NO_MEDIUM);			
			yesButton.setOnClick(null);
			noButton.setOnClick(null);
			
			// start polling web? TODO
			
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
			smsDisclaimer.tweenIn();
			
			tweenOutInactive();
		}
		
		
		public function photoBoothView(...args):void {
			markAllInactive();
			
			// mutations
			
			// behaviors
			countdown.setOnClick(onCameraClick);
			countdown.setOnFinish(onCountdownFinish);
			
			// blocks
			portraitCamera.tweenIn();
			header.tweenIn();
			divider.tweenIn();
			question.tweenIn();
			stance.tweenIn();
			portraitOutline.tweenIn();
			photoBoothInstructions.tweenIn();			
			countdown.tweenIn();			
			
			tweenOutInactive();
		}
		
		private function onCameraClick(e:MouseEvent):void {
			countdown.start()
		}
		
		private function onCountdownFinish(e:Event):void {
			portraitCamera.takePhoto();
			
			flashOverlay.tweenIn(-1, {onComplete: onFlashOn});
		}
		
		private function onFlashOn():void {
			// TODO take, save and upload photo
			nameEntryView();
			flashOverlay.tweenOut();
		}
		
		
		public function nameEntryView(...args):void {
			markAllInactive();
			flashOverlay.active = true; // needs to tween out itself
			
			// mutations
			portrait.setImage(Assets.portraitPlaceholder, true); // TODO use latest photo
			keyboard.target = nameEntryField.getTextField();
			
			// behaviors
			saveButton.setOnClick(onSaveName);
			
			
			// blocks, no delay since it needs to happen during the flash!
			portrait.tweenIn(0);			
			header.tweenIn(0);
			divider.tweenIn(0);
			question.tweenIn(0);
			stance.tweenIn(0);
			nameEntryInstructions.tweenIn(-1, {delay: 1});
			nameEntryField.tweenIn(-1, {delay: 1});
			saveButton.tweenIn(-1, {delay: 1});
			keyboard.tweenIn(-1, {delay: 1});
			
			tweenOutInactive(true);
		}
		
		private function onSaveName(e:Event):void {
			// TODO input validation
			
			// TODO save name to disk
			
			verifyOpinionView();
		}
		
		
		public function verifyOpinionView(...args):void {
			markAllInactive();
			
			// mutations
			// portrair photo
			// submit button text
			// opinoin text
			// name
			// stance
			
			
			// behaviors
			retakePhotoButton.setOnClick(onRetakePhoto);
			editTextButton.setOnClick(onEditText);
			cancelButton.setOnClick(onCancel);
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
			
			tweenOutInactive();
		}
		
		private function onRetakePhoto(e:Event):void {
			photoBoothView();
		}
		
		private function onEditText(e:Event):void {
			// TODO
			editOpinionView();
		}		
		
		private function onCancel(e:Event):void {
			homeView();
		}
		
		private function onSubmitOpinion(e:Event):void {
			// TODO validate opinion
			
			// TODO upload opinion
			// TODO go to what you just submitted
			homeView();
		}
		
		
		public function editOpinionView(...args):void {
			markAllInactive();
			
			// mutations
			keyboard.target = editOpinion.getTextField();			
			
			// behaviors
			saveButton.setOnClick(onSaveOpinionEdit);
			
			//blocks
			leftQuote.tweenIn();	
			portrait.tweenIn();	
			header.tweenIn();
			divider.tweenIn();
			question.tweenIn();
			stance.tweenIn();
			nametag.tweenIn();
			
			//opinion.tweenIn(); // TODO fade this out?
			editOpinion.tweenIn();
			saveButton.tweenIn();
			editTextInstructions.tweenIn();
			keyboard.tweenIn();
			
			tweenOutInactive();			
		}
		
		private function onSaveOpinionEdit(e:Event):void {
			// TODO validate opinion
			verifyOpinionView();
		}
		
		
		public function statsView(...args):void {
			//markAllInactive();
			
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

			//tweenOutInactive();			
		}
		
		private function onStatsClose(e:Event):void {
			// restore portrait
			portrait.setImage(CDW.database.users[CDW.database.debates[CDW.state.activeDebate].author._id.$oid].portrait);
			
			stats.tweenOut();
		}
		
		public function inactivityView(...args):void {
			// mutations
			
			// behaviors
			continueButton.setOnClick(onContinue);
			restartButton.setOnClick(onRestart);
			
			// blocks
			inactivityOverlay.tweenIn();
			inactivityInstructions.tweenIn();
			continueButton.tweenIn();
			restartButton.tweenIn();
		}
		
		private function onRestart(e:Event):void {
			homeView();
		}
		
		private function onContinue(e:Event):void {
			inactivityOverlay.tweenOut();
			inactivityInstructions.tweenOut();
			continueButton.tweenOut();
			restartButton.tweenOut();			
		}
		
		
		// View utilities
		private function markAllInactive():void {
			// marks all FIRST LEVEL blocks as inactive
			for (var i:int = 0; i < this.numChildren; i++) {
				if ((this.getChildAt(i) is BlockBase) && (this.getChildAt(i).visible)) {
					(this.getChildAt(i) as BlockBase).active = false;
				}
			}
		}
		
		
		private function tweenOutInactive(instant:Boolean = false):void {
			for (var i:int = 0; i < this.numChildren; i++) {
				if ((this.getChildAt(i) is BlockBase) && !(this.getChildAt(i) as BlockBase).active) {
					
					if (instant) {
						// no animation!
						(this.getChildAt(i) as BlockBase).tweenOut(0);
					}
					else {
						(this.getChildAt(i) as BlockBase).tweenOut();						
					}
				}
			}			
		}		
		
	}
}
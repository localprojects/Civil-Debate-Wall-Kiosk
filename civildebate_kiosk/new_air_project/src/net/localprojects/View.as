package net.localprojects {
	import com.adobe.serialization.json.*;
	import com.bit101.components.FPSMeter;
	import com.greensock.*;
	import com.greensock.easing.*;
	import com.greensock.events.LoaderEvent;
	import com.greensock.events.TweenEvent;
	
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;
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
		private var skipTextButton:BlockButton;		
		
		// single copy, changes
		private var question:Question;
		private var leftQuote:QuotationMark;
		private var rightQuote:QuotationMark;		
		private var portrait:Portrait; // TODO fading
		private var bigButton:BigButton;		
		private var statsButton:IconButton;
		private var likeButton:CounterButton;
		private var debateButton:BalloonButton;
		private var flagButton:IconButton;
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
			
			// Work around for lack of mouse-down events
			// http://forums.adobe.com/message/2794098?tstart=0
			Multitouch.inputMode = MultitouchInputMode.TOUCH_POINT;			
			
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
			question.setDefaultTweenIn(1, {x: 30, y: 126});
			question.setDefaultTweenOut(1, {x: -question.width});
			question.setText(CDW.database.getQuestionText()); // TODO abstract out these ridiculous traversals...
			addChild(question);
			
			stance = new Stance();
			stance.setText(CDW.database.debates[CDW.state.activeDebate].stance);			
			stance.setDefaultTweenIn(1, {x: 235, y: 280});
			stance.setDefaultTweenOut(1, {x: -280, y: 280});						
			addChild(stance);			

			nametag = new BlockLabel('Name', 50, 0xffffff, Assets.COLOR_YES_MEDIUM, true, true);
			nametag.setPadding(26, 28, 20, 30);
			nametag.setDefaultTweenIn(1, {x: 235, y: 410});
			nametag.setDefaultTweenOut(1, {x: stageWidth, y: 410});
			addChild(nametag);
			
			byline = new BlockLabel('Byline', 22, 0xffffff, Assets.COLOR_YES_MEDIUM, false, true);
			byline.setPadding(18, 32, 16, 32);
			byline.setDefaultTweenIn(1, {x: 586, y: 694});
			byline.setDefaultTweenOut(1, {x: -500, y: 694});			
			addChild(byline);
			
			leftQuote = new QuotationMark();
			leftQuote.setDefaultTweenIn(1, {x: 114, y: 545});
			leftQuote.setDefaultTweenOut(1, {x: -leftQuote.width});	
			leftQuote.setStyle(QuotationMark.OPENING);
			leftQuote.setColor(Assets.COLOR_YES_LIGHT);
			addChild(leftQuote);
			
			rightQuote = new QuotationMark();
			rightQuote.setDefaultTweenIn(1, {x: 660, y: 1639});
			rightQuote.setDefaultTweenOut(1, {x: stageWidth});				
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
			
			bigButton = new BigButton('ADD YOUR OPINION');
			bigButton.setDefaultTweenIn(1, {x: 455, y: 1470, alpha: 1});
			bigButton.setDefaultTweenOut(1, {x: 455, y: 1470, alpha: 0}); // TODO need to subclass and override tweenout and in methods because of weird animation???
			addChild(bigButton);
			
			statsButton = new IconButton(111, 55, 'Stats', 20, Assets.COLOR_YES_DARK, Assets.statsIcon);
			statsButton.setDefaultTweenIn(1, {x: 104, y: 1379});
			statsButton.setDefaultTweenOut(1, {x: -statsButton.width});
			addChild(statsButton);
			
			likeButton = new CounterButton(111, 55, 'Like', 20, Assets.COLOR_YES_DARK, 0);
			likeButton.setDefaultTweenIn(1, {x: 238, y: 1379});
			likeButton.setDefaultTweenOut(1, {x: -likeButton.width});			
			addChild(likeButton);
				
			viewDebateButton = new BlockButton(517, 55, '"The reality is that a decision…" +8 other responses', 20, Assets.COLOR_YES_DARK, false);
			viewDebateButton.setDefaultTweenIn(1, {x: 373, y: 1379});
			viewDebateButton.setDefaultTweenOut(1, {x: stageWidth});			
			addChild(viewDebateButton);
			
			flagButton = new IconButton(59, 55, '', 20, Assets.COLOR_YES_DARK, Assets.flagIcon);
			flagButton.setDefaultTweenIn(1, {x: 914, y: 1379});
			flagButton.setDefaultTweenOut(1, {x: stageWidth});
			addChild(flagButton);			
			
			debateButton = new BalloonButton(145, 130, 'LET\u0027S\nDEBATE !', 20, Assets.COLOR_YES_DARK, false, true);
			debateButton.setDefaultTweenIn(1, {x: 828, y: 901, scaleX: 1, scaleY: 1});
			debateButton.setDefaultTweenOut(1, {x: stageWidth, y: 901, scaleX: 1, scaleY: 1});
			addChild(debateButton);
			
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
			
			// Temp debug button so we don't have to SMS every time
			skipTextButton = new BlockButton(200, 100, 'SIMULATE SMS', 20, Assets.COLOR_INSTRUCTION_DARK, false, false);
			skipTextButton.setDefaultTweenIn(1, {x: (stageWidth - 200) / 2, y: 500});
			skipTextButton.setDefaultTweenOut(1, {x: stageWidth, y: 500});
			addChild(skipTextButton);
			
			var smsDisclaimerText:String = 'You will receive an SMS notifying you of any future opponents \nwho would like to enter into a debate with you based on your opinion. \nYou can opt out at any time by replying STOP.';
			smsDisclaimer = new BlockParagraph(872, smsDisclaimerText, 25, Assets.COLOR_INSTRUCTION_DARK, false);
			smsDisclaimer.setDefaultTweenIn(1, {x: 100, y: 1625});
			smsDisclaimer.setDefaultTweenOut(1, {x: 100, y: stageHeight});
			addChild(smsDisclaimer);
			
			backButton = new BlockButton(135, 63, 'BACK', 25, Assets.COLOR_YES_DARK, true);
			backButton.setDefaultTweenIn(1, {x: 101, y: 1003});
			backButton.setDefaultTweenOut(1, {x: -backButton.width, y: 1003});			
			addChild(backButton);
			
			var smsInstructionText:String = 'What would you say to convince others of your opinion?\nText ' + Utilities.formatPhoneNumber(CDW.settings.phoneNumber) + ' with your statement.'; 	
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
			editTextInstructions.setDefaultTweenIn(1, {x: 386, y: 1003});
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
			
			
			
			
			
			
			// cross dragging, move to overlay block!? only in home view?
			this.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			this.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			this.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			mouseDown = false;
		}
		
		private var mouseDown:Boolean;		
		private var startX:int;
		private var lastX:int;
		private var currentX:int;
		private function onMouseDown(e:MouseEvent):void {
			mouseDown = true;
			// refactor startX based on tween progress, for portrait and other things
			startX = this.mouseX + (nametag.x - nametag.defaultTweenInVars.x);
			currentX = startX;
			trace("down");
			
			
			
			
			
			
			
			
			TweenMax.killTweensOf(nametag);
			TweenMax.killTweensOf(stance);
			TweenMax.killTweensOf(opinion);
			TweenMax.killChildTweensOf(portrait);
			TweenMax.killChildTweensOf(leftQuote);
			TweenMax.killChildTweensOf(rightQuote);			
			
		}
		
		private function onMouseUp(e:MouseEvent):void {
			mouseDown = false;
			trace("up");			
			
			// put everything back into place
			homeView();
		}		
		
		private function onMouseMove(e:Event):void {
			if (mouseDown) {
				lastX = currentX;
				currentX = this.mouseX;
			
				
				nametag.x += currentX - lastX;
				stance.x += currentX - lastX;
				opinion.x += currentX - lastX;
				
				var difference:int = startX - currentX;
				
				
				var targetColorDark:uint;

				
				if (difference > 1) {
					// moving left
				}
				else {
					// moving right					
				}
				
				portrait.setIntermediateImage(CDW.database.portraits['4e4ae39a0f2e4243f7000004'], Utilities.mapClamp(Math.abs(difference), 0, stageWidth, 0, 1));
				leftQuote.setIntermediateColor(Assets.COLOR_YES_LIGHT, Assets.COLOR_NO_LIGHT, Utilities.mapClamp(Math.abs(difference), 0, stageWidth, 0, 1));
				rightQuote.setIntermediateColor(Assets.COLOR_YES_LIGHT, Assets.COLOR_NO_LIGHT, Utilities.mapClamp(Math.abs(difference), 0, stageWidth, 0, 1));				
			}
			
		}
		

		
		public function homeView(...args):void {
			markAllInactive();

			
			CDW.inactivityTimer.disarm();
			
			// mutations
			portrait.setImage(CDW.database.getActivePortrait());
			nametag.setText(CDW.database.debates[CDW.state.activeDebate].author.firstName + ' ' + CDW.database.debates[CDW.state.activeDebate].author.lastName + ' Says :');
			stance.setStance(CDW.database.debates[CDW.state.activeDebate].stance);
			opinion.setText(CDW.database.debates[CDW.state.activeDebate].opinion);
			bigButton.setText('ADD YOUR OPINION');
			viewDebateButton.setLabel('"The reality is that a decision…" +8 other responses');
			
			// Reset user info
			CDW.state.clearUser();
			
			
			if (CDW.database.debates[CDW.state.activeDebate].stance == 'yes') {
				leftQuote.setColor(Assets.COLOR_YES_LIGHT);
				rightQuote.setColor(Assets.COLOR_YES_LIGHT);				
				nametag.setBackgroundColor(Assets.COLOR_YES_DARK);
				debateButton.setBackgroundColor(Assets.COLOR_YES_DARK);
				opinion.setBackgroundColor(Assets.COLOR_YES_LIGHT);
				statsButton.setBackgroundColor(Assets.COLOR_YES_DARK);
				likeButton.setBackgroundColor(Assets.COLOR_YES_DARK);
				viewDebateButton.setBackgroundColor(Assets.COLOR_YES_DARK);
				flagButton.setBackgroundColor(Assets.COLOR_YES_DARK);
			}
			else {
				leftQuote.setColor(Assets.COLOR_NO_LIGHT);
				rightQuote.setColor(Assets.COLOR_NO_LIGHT);				
				nametag.setBackgroundColor(Assets.COLOR_NO_DARK);
				debateButton.setBackgroundColor(Assets.COLOR_NO_DARK);
				opinion.setBackgroundColor(Assets.COLOR_NO_LIGHT);
				statsButton.setBackgroundColor(Assets.COLOR_NO_DARK);
				likeButton.setBackgroundColor(Assets.COLOR_NO_DARK);
				viewDebateButton.setBackgroundColor(Assets.COLOR_NO_DARK);
				flagButton.setBackgroundColor(Assets.COLOR_NO_DARK);			
			}			
			
			
			// behaviors
			viewDebateButton.setOnClick(debateOverlayView);	
			bigButton.setOnClick(pickStanceView);			
			statsButton.setOnClick(statsView);
			debateButton.setOnClick(pickStanceView);
			likeButton.setOnClick(incrementLikes);
			flagButton.setOnClick(incrementFlags);
			
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
			flagButton.tweenIn();
			viewDebateButton.tweenIn();
			debatePicker.tweenIn();
			
			// override any tween outs here (flagging them as active means they won't get tweened out automatically)
			// note that it's a one-time thing, when the block tweens back in, it will start from its canonical "tween out" location
			// and not this temporary override
			debateOverlay.tweenOut(1, {y: -debateOverlay.height});
			
			// clean up the old based on what's not active
			tweenOutInactive();
			
			if (CDW.database.debates[CDW.state.activeDebate].stance == 'yes') {			
				setTestOverlay(TestAssets.CDW_08_15_11_Kiosk_Design);
			}
			else {
				setTestOverlay(TestAssets.CDW_08_15_11_Kiosk_Design3);				
			}
		}
		
		private function incrementLikes(e:Event):void {
			Utilities.postRequest(CDW.settings.serverPath + '/api/debates/like', {'id': CDW.state.activeDebate, 'count': likeButton.count}, onLikePosted);
		}
		
		private function onLikePosted(response:Object):void {
			trace('bumping likes');
			likeButton.count = parseInt(response.toString());
		}
		
		private function incrementFlags(e:Event):void {
			Utilities.postRequest(CDW.settings.serverPath + '/api/debates/flag', {'id': CDW.state.activeDebate, 'count': likeButton.count}, onFlagPosted);
		}
		
		private function onFlagPosted(response:Object):void {
			trace('bumping flags to  ' + response.toString());
		}		
		
		
		
		
		
		
		
		
		
		
		
		
		
		public function debateOverlayView(...args):void {
			markAllInactive();			
			
			// services
			CDW.inactivityTimer.disarm();
			
			// mutations
			portrait.setImage(CDW.database.getActivePortrait());
			byline.setText('Said by ' + CDW.database.debates[CDW.state.activeDebate].author.firstName + ' ' + CDW.database.debates[CDW.state.activeDebate].author.lastName);			
			viewDebateButton.setLabel('BACK TO HOME SCREEN');
			
			
			
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
			
			CDW.inactivityTimer.arm();
			
			// mutations
			portrait.setImage(Assets.portraitPlaceholder);
			noButton.setBackgroundColor(Assets.COLOR_NO_LIGHT);
			yesButton.setBackgroundColor(Assets.COLOR_YES_LIGHT);			
			
			
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
		
		
		
		
		
		
		
		
		
		
		
		private var smsCheckTimer:Timer;
		
		public function textPromptView(...args):void {
			markAllInactive();
			
			CDW.inactivityTimer.arm();
			
			// mutations
			if (CDW.state.userStance == 'yes') {
				smsInstructions.setBackgroundColor(Assets.COLOR_YES_LIGHT);
				characterLimit.setBackgroundColor(Assets.COLOR_YES_MEDIUM);
				backButton.setBackgroundColor(Assets.COLOR_YES_DARK);
				noButton.setBackgroundColor(Assets.COLOR_INSTRUCTION_MEDIUM);
			}
			else {
				smsInstructions.setBackgroundColor(Assets.COLOR_NO_LIGHT);
				characterLimit.setBackgroundColor(Assets.COLOR_NO_MEDIUM);
				backButton.setBackgroundColor(Assets.COLOR_NO_DARK);				
				yesButton.setBackgroundColor(Assets.COLOR_INSTRUCTION_MEDIUM);
			}

			// behaviors
			backButton.setOnClick(pickStanceView); // TODO do we need the back button?
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
			backButton.tweenIn();
			smsInstructions.tweenIn();
			characterLimit.tweenIn();
			smsDisclaimer.tweenIn();
			skipTextButton.tweenIn(); // TEMP for debug, TODO put on setting switch
			
			tweenOutInactive();
		}
		

		private function onSmsCheckTimer(e:TimerEvent):void {
			trace("checking for SMS received");
			var latestMessageLoader:URLLoader = new URLLoader();
			latestMessageLoader.addEventListener(Event.COMPLETE, onSMSCheckResponse);
			latestMessageLoader.load(new URLRequest("http://ec2-50-19-25-31.compute-1.amazonaws.com/api/sms/latest"));			

			smsCheckTimer.stop();
		}
		
		
		private function onSMSCheckResponse(e:Event):void {
			trace('check sms response received');
			var response:* = JSON.decode(e.target.data);			
			
			// first time? save the id so we can compare
			if (CDW.state.latestSMSID == null) {
				trace(" first time, setting id");
				CDW.state.latestSMSID = response['_id']['$oid'];
				smsCheckTimer.reset();
				smsCheckTimer.start();
			}
			else if (CDW.state.latestSMSID != response['_id']['$oid'] &&
							(response['To'] == CDW.settings.phoneNumber)) {

				trace("NEW SMS!!! from number:" + CDW.state.userPhoneNumber);
						
				// write some stuff down	
				CDW.state.userPhoneNumber = response['From'];
				CDW.state.userOpinion = response['Body'];						
						
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
				trace("no photo! go take one!");
				photoBoothView();
			}
			else {
				// have a photo, load it
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

		
		
		
		
		public function photoBoothView(...args):void {
			markAllInactive();
			
			CDW.inactivityTimer.arm();
			
			// mutations
			stance.setStance(CDW.state.userStance);
			if (CDW.state.userStance == 'yes') {
				countdown.setBackgroundColor(Assets.COLOR_YES_MEDIUM);
				countdown.setRingColor(Assets.COLOR_YES_LIGHT);
				photoBoothInstructions.setBackgroundColor(Assets.COLOR_YES_MEDIUM);
			}
			else {
				countdown.setBackgroundColor(Assets.COLOR_NO_MEDIUM);
				countdown.setRingColor(Assets.COLOR_NO_LIGHT);
				photoBoothInstructions.setBackgroundColor(Assets.COLOR_NO_MEDIUM);				
			}
			
			// behaviors
			countdown.setOnClick(onCameraClick);
			countdown.setOnFinish(onCountdownFinish);
			portraitCamera.setOnFaceShutter(onCameraClick);
			
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

		
		private function onCameraClick(e:Event):void {
			if (!countdown.isCountingDown()) {
				portraitCamera.detectFaces = false; // turn off face detection
				countdown.start()
			}
		}
		
		private function onCountdownFinish(e:Event):void {
			flashOverlay.tweenIn(-1, {onComplete: onFlashOn}); // use default tween in duration
			
			// image is held in RAM for now, in case it's edited later
			
			// Do this in portrait camera instead?
			if (CDW.settings.webcamOnly) {
				// nothing to see here...
				CDW.state.userImage = portraitCamera.cameraBitmap;				
			}
			else {
				// using SLR
				// TODO
			}
			
			
		}
		
		private function onFlashOn():void {
			// skip name entry if we already have it
			if(CDW.state.userName == '') {			
				nameEntryView();
			}
			else {
				verifyOpinionView();
			}
			flashOverlay.tweenOut();
		}
		
		
		public function nameEntryView(...args):void {
			markAllInactive();
			flashOverlay.active = true; // needs to tween out itself
			
			CDW.inactivityTimer.arm();
			
			
			// mutations
			stance.setStance(CDW.state.userStance);
			if (CDW.state.userStance == 'yes') {
				nameEntryInstructions.setBackgroundColor(Assets.COLOR_YES_LIGHT);
				saveButton.setBackgroundColor(Assets.COLOR_YES_DARK);
				keyboard.setColor(Assets.COLOR_YES_LIGHT);
				nameEntryField.setBackgroundColor(Assets.COLOR_YES_LIGHT);
			}
			else {
				nameEntryInstructions.setBackgroundColor(Assets.COLOR_NO_LIGHT);
				saveButton.setBackgroundColor(Assets.COLOR_NO_DARK);
				keyboard.setColor(Assets.COLOR_NO_LIGHT);				
				nameEntryField.setBackgroundColor(Assets.COLOR_NO_LIGHT);				
			}
			
			portrait.setImage(CDW.state.userImage, true);
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
			
			// Save name to RAM
			CDW.state.userName = nameEntryField.getTextField().text;
			
			// Update the name on the server
			Utilities.postRequest(CDW.settings.serverPath + '/api/users/add-or-update', {'id': CDW.state.userID, 'firstName': CDW.state.userName}, onNameUpdated);
			
			verifyOpinionView();
		}
		
		private function onNameUpdated(r:Object):void {
			trace("Name updated on server");
			trace(r);
		}
		
		
		
		
		public function verifyOpinionView(...args):void {
			markAllInactive();
			
			CDW.inactivityTimer.arm();
			
			// mutations
			portrait.setImage(CDW.state.userImage, true);
			bigButton.setText('SUBMIT THIS DEBATE');
			bigButton.enable();
			nametag.setText(CDW.state.userName + 'Says:', true);
			opinion.setText(CDW.state.userOpinion);
			
			
			if (CDW.state.userStance == 'yes') {
				nametag.setBackgroundColor(Assets.COLOR_YES_MEDIUM); // make instant?
				opinion.setBackgroundColor(Assets.COLOR_YES_LIGHT);	
				retakePhotoButton.setBackgroundColor(Assets.COLOR_YES_DARK);
				editTextButton.setBackgroundColor(Assets.COLOR_YES_DARK);
				cancelButton.setBackgroundColor(Assets.COLOR_YES_DARK);
				leftQuote.setColor(Assets.COLOR_YES_LIGHT);
				rightQuote.setColor(Assets.COLOR_YES_LIGHT);				
			}
			else {
				nametag.setBackgroundColor(Assets.COLOR_NO_MEDIUM);
				opinion.setBackgroundColor(Assets.COLOR_NO_LIGHT);
				retakePhotoButton.setBackgroundColor(Assets.COLOR_NO_DARK);
				editTextButton.setBackgroundColor(Assets.COLOR_NO_DARK);
				cancelButton.setBackgroundColor(Assets.COLOR_NO_DARK);
				leftQuote.setColor(Assets.COLOR_NO_LIGHT);
				rightQuote.setColor(Assets.COLOR_NO_LIGHT);				
			}
			
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
			editOpinionView();
		}		
		
		private function onCancel(e:Event):void {
			homeView();
		}
		
		private function onSubmitOpinion(e:Event):void {
			trace("Submitting opinion!");
			// Syncs state up to the cloud
			
			// save the image to disk
			// TODO handle overwrites?
			// TEMP OFF FOR DEMO
			
			
			// only if the image is fresh!
			var imageName:String = Utilities.saveImageToDisk(portraitCamera.cameraBitmap, CDW.settings.imagePath, CDW.state.userID + '-full.jpg');
			
			// upload opinion
			
			
			
						
			
			var payload:Object = {'author': CDW.state.userID, 'question': CDW.state.activeQuestion, 'opinion': CDW.state.userOpinion, 'stance': CDW.state.userStance, 'origin': 'kiosk'};
			Utilities.postRequest(CDW.settings.serverPath + '/api/debates/add', payload, onDebateUploaded);

			// refresh db?
		}
		
		private function onDebateUploaded(r:Object):void {
			trace("debate uploaded");
			
			// go home and see what you just submitted			
			homeView();
		}
		
		
		public function editOpinionView(...args):void {
			markAllInactive();
			
			CDW.inactivityTimer.arm();
			
			// mutations
			editOpinion.setText(CDW.state.userOpinion);
			
			keyboard.target = editOpinion.getTextField();
			
			if (CDW.state.userStance == 'yes') {
				editTextInstructions.setBackgroundColor(Assets.COLOR_YES_DARK);
				saveButton.setBackgroundColor(Assets.COLOR_YES_DARK);
				editOpinion.setBackgroundColor(Assets.COLOR_YES_LIGHT);
			}
			else {
				editTextInstructions.setBackgroundColor(Assets.COLOR_NO_DARK);
				saveButton.setBackgroundColor(Assets.COLOR_NO_DARK);
				editOpinion.setBackgroundColor(Assets.COLOR_NO_LIGHT);				
			}
			
			
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
		}
		
		private function onSaveOpinionEdit(e:Event):void {
			// TODO validate opinion edit
			
			CDW.state.userOpinion = editOpinion.getTextField().text;
			
			verifyOpinionView();
		}
		
		
		public function statsView(...args):void {
			//markAllInactive();
			
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

			//tweenOutInactive();			
		}
		
		private function onStatsClose(e:Event):void {
			// restore portrait
			portrait.setImage(CDW.database.getActivePortrait());
			
			stats.tweenOut();
		}
		
		public function inactivityView(...args):void {
			// mutations
			if (portraitCamera.active) portraitCamera.detectFaces = false;			
			CDW.inactivityTimer.disarm();
			
			
			
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
			if (portraitCamera.active) portraitCamera.detectFaces = true;			
		}
		

		private function setTestOverlay(b:Bitmap):void {
			CDW.testOverlay.bitmapData = b.bitmapData.clone();						
		}	
		
		
		// View utilities
		private function markAllInactive():void {
			// other housekeeping, TODO break this into its own function?
			if(smsCheckTimer != null) smsCheckTimer.stop();					
			
			
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
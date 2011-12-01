package com.civildebatewall.kiosk.overlays {
	import com.civildebatewall.Assets;
	import com.civildebatewall.CivilDebateWall;
	import com.civildebatewall.data.Data;
	import com.civildebatewall.kiosk.BlockInertialScroll;
	import com.civildebatewall.kiosk.buttons.BackButton;
	import com.civildebatewall.kiosk.buttons.BigGrayButton;
	import com.civildebatewall.kiosk.buttons.StanceToggle;
	import com.civildebatewall.kiosk.keyboard.Keyboard;
	import com.demonsters.debugger.MonsterDebugger;
	import com.greensock.TweenMax;
	import com.kitschpatrol.futil.blocks.BlockBase;
	import com.kitschpatrol.futil.blocks.BlockShape;
	import com.kitschpatrol.futil.blocks.BlockText;
	import com.kitschpatrol.futil.constants.Alignment;
	import com.kitschpatrol.futil.constants.Char;
	import com.kitschpatrol.futil.utilitites.BitmapUtil;
	import com.kitschpatrol.futil.utilitites.ColorUtil;
	import com.kitschpatrol.futil.utilitites.GraphicsUtil;
	import com.kitschpatrol.futil.utilitites.StringUtil;
	
	import flash.display.Bitmap;
	import flash.display.Shape;
	import flash.events.Event;
	import flash.events.FocusEvent;
	import flash.events.MouseEvent;
	import flash.ui.Mouse;

	public class OpinionEntryOverlay extends BlockInertialScroll {
		
		private var question:BlockText;
		private var nameCharacterCount:BlockText;		
		private var nameField:BlockText;
		private var formContainer:BlockBase;
		private var opinionLabel:BlockText;
		private var opinionCharacterCount:BlockText;
		private var opinionField:BlockText;
		private var stanceToggle:StanceToggle;
		private var backButton:BackButton;
		private var submitButton:BigGrayButton;
		private var keyboardContainer:BlockBase;
		private var keyboard:Keyboard;
		private var errorMessage:BlockText;
		private var respondingToContainer:BlockBase;
		private var respondingToPortrait:BlockShape;
		private var respondingToName:BlockText;
		private var respondingToOpinion:BlockText;
		private var errors:Boolean;		
		
		public function OpinionEntryOverlay()	{
			super({
				width: 1080,
				height: 1920,
				backgroundAlpha: 0,
				paddingLeft: 29,
				paddingTop: 30,
				scrollAxis: SCROLL_Y,
				scrollLimitMode: SCROLL_LIMIT_MANUAL
			});
			
			question = new BlockText({
				paddingTop: 65,
				paddingRight: 100,
				paddingBottom: 65,
				paddingLeft: 100,
				backgroundColor: 0xffffff,
				textSize: 28,
				leading: 22,
				paddingLeft: 30,
				paddingRight: 30,
				textFont: Assets.FONT_BOLD,
				textBold: true,
				textColor: 0x000000,
				alignmentPoint: Alignment.CENTER,
				backgroundRadiusTopLeft: 12,
				backgroundRadiusTopRight: 12,
				width: 1022,
				height: 188,
				visible: true
			});

			addChild(question);
			
			
			
			respondingToContainer = new BlockBase({
				minHeight: 311,
				width: 1022,
				backgroundColor: ColorUtil.gray(211),
				paddingTop: 46,
				paddingLeft: 30,
				visible: true
			});
			
			addChild(respondingToContainer);
			
			respondingToPortrait = new BlockShape();
			respondingToPortrait.backgroundImage = null,
			respondingToPortrait.width = 192;
			respondingToPortrait.height = 267;
			respondingToPortrait.radius = 4;
			respondingToContainer.addChild(respondingToPortrait);
			
			respondingToName = new BlockText({
				textFont: Assets.FONT_BOLD,
				textBold: true,
				textColor: 0xffffff,
				textSize: 18,
				paddingLeft: 22,
				paddingRight: 22,				
				alignmentPoint: Alignment.LEFT,
				maxWidth: 742,
				height: 54,
				visible: true
			});
			respondingToName.x = 221;
			respondingToContainer.addChild(respondingToName);
			
			respondingToOpinion = new BlockText({
				textFont: Assets.FONT_BOLD,
				textBold: true,
				textColor: 0xffffff,
				textSize: 23,
				leading: 15,
				paddingLeft: 22,
				paddingRight: 22,
				paddingTop: 20,
				paddingBottom: 27,
				maxWidth: 742,
				visible: true
			});
			respondingToOpinion.x = 221;
			respondingToOpinion.y = 83;
			respondingToContainer.addChild(respondingToOpinion);
			
			
			
			
			formContainer = new BlockBase({
				backgroundColor: ColorUtil.gray(211),
				width: 1022,
				maxSizeBehavior: BlockBase.MAX_SIZE_CLIPS,
				height: 929,
				visible: true
			});
			
			formContainer.y = question.bottom;
			addChild(formContainer);

			
			var errorStyle:Object = {
				textFont: Assets.FONT_BOLD,
					textColor: 0xffffff,
					letterSpacing: -1,
					backgroundColor: Assets.COLOR_RED_SELECTION,
					textBold: true,				
					textSize: 16,
					paddingLeft: 42,
					alignmentPoint: Alignment.LEFT,
					width: 963, 
					height: 64		
			};
			
			// Errors
			errorMessage = new BlockText(errorStyle);
			errorMessage.setDefaultTweenIn(1, {x: 30, y: 46});
			errorMessage.setDefaultTweenOut(1, {x: Alignment.OFF_STAGE_LEFT, y: 46});
			formContainer.addChild(errorMessage);

			errors = false;
			
			
			
			
			// The form
			var nameLabel:BlockText = new BlockText({
				text: "WHAT IS YOUR NAME? ",
				textFont: Assets.FONT_BOLD,
				textBold: true,
				backgroundAlpha: 0,
				textColor: ColorUtil.gray(79),
				textSize: 16,
				letterSpacing: -1,
				width: 370,
				visible: true
			});
			nameLabel.x = 72;
			nameLabel.y = 134;
			formContainer.addChild(nameLabel);
			
			nameField = new BlockText({
				text: "",
				textFont: Assets.FONT_BOLD,				
				textColor: ColorUtil.gray(79),
				textSize: 18,
				backgroundColor: 0xffffff,
				borderColor: Assets.COLOR_RED_SELECTION,
				borderThickness: 5,
				borderAlpha: 0,
				showBorder: true,
				maxChars: 18,
				width: 530,
				height: 141,
				paddingLeft: 42,
				paddingRight: 42,
				alignmentY: 0.5,
				input: true,
				visible: true
			});
			nameField.x = 30;
			nameField.y = 173;
			formContainer.addChild(nameField);
			
			nameCharacterCount = new BlockText({
				text: nameField.maxChars + " Chars",
				textFont: Assets.FONT_BOLD,				
				backgroundAlpha: 0,
				textColor: ColorUtil.gray(79),
				textSize: 16,
				letterSpacing: -1,
				textAlignmentMode: Alignment.TEXT_RIGHT,
				registrationPoint: Alignment.TOP_RIGHT,
				visible: true
			});
			nameCharacterCount.x = 560;
			nameCharacterCount.y = 134;
			formContainer.addChild(nameCharacterCount);			

			// Opinion
			opinionLabel = new BlockText({
				textFont: Assets.FONT_BOLD,
				textBold: true,
				backgroundAlpha: 0,
				textColor: ColorUtil.gray(79),
				textSize: 16,
				letterSpacing: -1,
				width: 750,
				visible: true
			});
			opinionLabel.x = 72;
			opinionLabel.y = 338;
			formContainer.addChild(opinionLabel);
			
			opinionField = new BlockText({
				text: "",
				textFont: Assets.FONT_BOLD,				
				textColor: ColorUtil.gray(79),
				textSize: 18,
				backgroundColor: 0xffffff,
				borderColor: Assets.COLOR_RED_SELECTION,
				borderThickness: 5,
				borderAlpha: 0,
				showBorder: true,
				maxChars: 140,
				width: 962,
				height: 213,
				paddingLeft: 42,
				paddingRight: 42,
				paddingTop: 42,
				input: true,
				visible: true
			});			
			opinionField.x = 30;
			opinionField.y = 377;
			formContainer.addChild(opinionField);
			
			opinionCharacterCount = new BlockText({
				text: opinionField.maxChars + " Chars",
				textFont: Assets.FONT_BOLD,		
				backgroundAlpha: 0,
				textColor: ColorUtil.gray(79),
				textSize: 16,
				letterSpacing: -1,
				textAlignmentMode: Alignment.TEXT_RIGHT,
				registrationPoint: Alignment.TOP_RIGHT,
				visible: true
			});
			opinionCharacterCount.x = 952;
			opinionCharacterCount.y = 338;
			formContainer..addChild(opinionCharacterCount);			
			
			
			var saysText:Bitmap = Assets.getSaysText();
			saysText.x = 590;
			saysText.y = 230;
			formContainer.addChild(saysText);
			
			
			// Stance button instructions
			// Opinion
			var stanceInstructions:BlockText = new BlockText({
				text: "TAP TO CHANGE",
				textFont: Assets.FONT_BOLD,
				backgroundAlpha: 0,
				textColor: ColorUtil.gray(79),
				textSize: 16,
				letterSpacing: -1,
				width: 260,
				textAlignmentMode: Alignment.TEXT_CENTER,
				alignmentX: 0.5,
				visible: true
			});
			stanceInstructions.x = 732;
			stanceInstructions.y = 134;
			formContainer.addChild(stanceInstructions);	
		
			
			stanceToggle = new StanceToggle();
			stanceToggle.x = 732;
			stanceToggle.y = 173;
			stanceToggle.visible = true;
			formContainer.addChild(stanceToggle);
			
			// Back Button
			backButton = new BackButton();
			backButton.x = 30;
			backButton.y = 653;
			backButton.visible = true;
			formContainer.addChild(backButton);
			
			// Drag handles
			var leftHandle:Bitmap = Assets.getDragHandle();
			leftHandle.x = 30;
			leftHandle.y = 857;
			formContainer.addChild(leftHandle);
			
			var rightHandle:Bitmap = Assets.getDragHandle();
			rightHandle.x = 954;
			rightHandle.y = 857;
			formContainer.addChild(rightHandle);
			
			// Drag instructions
			var dragInstructions:BlockText = new BlockText({
				text: "Drag to Raise and Lower Keyboard",
				textFont: Assets.FONT_BOLD,
				backgroundAlpha: 0,
				textColor: ColorUtil.gray(79),
				textSize: 12,
				letterSpacing: -1,
				width: 260,
				textAlignmentMode: Alignment.TEXT_RIGHT,
				registrationPoint: Alignment.TOP_RIGHT,
				visible: true
			});
			dragInstructions.x = 938;
			dragInstructions.y = 872;
			formContainer.addChild(dragInstructions);

			var submitButton:BigGrayButton = new BigGrayButton();
			submitButton.x = 560;
			submitButton.y = 653;
			submitButton.visible = true;
			formContainer.addChild(submitButton);			
			

			
			keyboardContainer = new BlockBase({
				backgroundColor: 0xffffff,
				backgroundRadiusBottomLeft: 12,
				backgroundRadiusBottomRight: 12,
				padding: 30,
				width: 1022,
				height: 495,
				visible: true
			});

			keyboardContainer.x = 0;
			keyboardContainer.y = formContainer.bottom + 14;
			addChild(keyboardContainer);
			

			keyboard = new Keyboard();			
			keyboard.setColor(ColorUtil.gray(77));
			keyboard.setBackgroundColor(ColorUtil.gray(77));
			keyboard.visible = true;
			keyboard.x = -7; // compensate for key padding
			keyboardContainer.addChild(keyboard);
			

			// Events
			nameField.onInput.push(onNameFieldInput);
			nameField.onInput.push(onInput);
			nameField.onFocus.push(onFieldFocus);
			nameField.onBlur.push(onFieldBlur);
			opinionField.onInput.push(onOpinionFieldInput);
			opinionField.onInput.push(onInput);
			opinionField.onFocus.push(onFieldFocus);
			opinionField.onBlur.push(onFieldBlur);
			submitButton.onButtonUp.push(onSubmit);
			
			CivilDebateWall.data.addEventListener(Data.DATA_UPDATE_EVENT, onDataUpdate);
		}
		
		private function onInput(e:Event):void {
			// check for profanity
			
			MonsterDebugger.trace(this, "INPUT!");
			
			if (StringUtil.isProfane(nameField.text) || StringUtil.isProfane(opinionField.text)) {
				
				errors = true;
				
				if (!errorMessage.visible) {
					errorMessage.x = 1022; // come in from right					
				}
				
				errorMessage.text = "PLEASE KEEP THE DEBATE CIVIL.";
				errorMessage.tweenIn();
			}
			else {
				errorMessage.tweenOut();
				
				errors = false;
			}
			
		}
		
		private function onNameFieldInput(e:Event):void {
			// update the character countdown
			nameCharacterCount.text = nameField.charsLeft + StringUtil.plural(" Char", nameField.charsLeft);
		}
		
		private function onOpinionFieldInput(e:Event):void {
			// update the character countdown
			opinionCharacterCount.text = opinionField.charsLeft + StringUtil.plural(" Char", opinionField.charsLeft);
		}		
		
		private function onFieldFocus(e:FocusEvent):void {
			TweenMax.to(e.target.parent.parent, 0, {borderAlpha: 1});
			
			// keyboard follows focus
			
			MonsterDebugger.trace(this, "focus");
			MonsterDebugger.trace(this, stage.focus);
			
			if (stage.focus is BlockText) {
				keyboard.target = (stage.focus as BlockText).textField;
				MonsterDebugger.trace(this, "Keyboard target: " + keyboard.target);
			}
		}
		
		private function onFieldBlur(e:FocusEvent):void {
			TweenMax.to(e.target.parent.parent, 0.5, {borderAlpha: 0});
		}		
		
		private function onDataUpdate(e:Event):void {
			question.text = CivilDebateWall.state.question.text;
		}
		
		private function onSubmit(e:MouseEvent):void {
			MonsterDebugger.trace(this, "submit");
			
			nameField.text = StringUtil.trim(nameField.text);
			opinionField.text = StringUtil.trim(opinionField.text);
			
			// clear messages
						

			if (!errorMessage.visible) {
				errorMessage.x = 1022; // come in from right
			}

			
			if ((nameField.text.length == 0) && (opinionField.text.length == 0)) {
				errorMessage.text = "PLEASE FILL IN BOTH FIELDS BEFORE CONTINUING."
				errorMessage.tweenIn();
				errors = true;
			}
			else if (nameField.text.length == 0) {
				errorMessage.text = "PLEASE FILL IN YOUR NAME."
				errorMessage.tweenIn();
				errors = true;
			}
			else if (opinionField.text.length == 0) {
				errorMessage.text = "PLEASE ADD YOUR OPINION."
				errorMessage.tweenIn();
				errors = true;				
			}
			
			// TODO username taken?			
			
			
			if (errors) {
				MonsterDebugger.trace(this, "Errors! Won't submit");
			}
			else {
				MonsterDebugger.trace(this, "Looks OK! Will submit.");
				CivilDebateWall.state.userOpinion = opinionField.text;
				CivilDebateWall.state.userName = nameField.text;
				
				if (CivilDebateWall.state.userImage == null) { 
					CivilDebateWall.state.setView(CivilDebateWall.kiosk.view.photoBoothView);
				}
				else {
					CivilDebateWall.state.setView(CivilDebateWall.kiosk.view.opinionReviewView);					
				}
			}

			
		}
		
		
		// Try to create the user, check for existing username
//		CivilDebateWall.data.createUser(CivilDebateWall.state.userName, CivilDebateWall.state.userPhoneNumber, onUserCreated);
//		
//		private function onUserCreated(r:Object):void {
//			if (r['error'] == null) {
//				// It worked!
//				var tempUser:User = new User(r);
//				CivilDebateWall.state.userID = tempUser.id;
//				//verifyOpinionView();
//			}
//			else {
//				// there was an error, the name probably already existed!
//				MonsterDebugger.trace(this, "TODO handle name error");
//			}
//		}		
		
		
		override protected function beforeTweenIn():void {
			super.beforeTweenIn();
			CivilDebateWall.state.backDestination = CivilDebateWall.state.lastView;
			stage.focus = nameField.textField;
			
			// Prepopulate fields
			nameField.text = CivilDebateWall.state.userName;
			opinionField.text = CivilDebateWall.state.userOpinion;
			// stance toggle taken care of automatically
			// the others really should be too
			
			// Make sure the text fields counts are fresh
			nameField.executeAll(nameField.onInput);
			opinionField.executeAll(opinionField.onInput);
			
			// Show the respondent?
			if (CivilDebateWall.state.userIsDebating) {
				respondingToPortrait.backgroundImage = BitmapUtil.scaleToFill(CivilDebateWall.state.userRespondingTo.user.photo, respondingToPortrait.width, respondingToPortrait.height);
				respondingToName.text = (CivilDebateWall.state.userRespondingTo.user.username + " SAYS: " + CivilDebateWall.state.userRespondingTo.stance + "!").toUpperCase();
				respondingToName.backgroundColor = CivilDebateWall.state.userRespondingTo.stanceColorDark;
				respondingToOpinion.text = Char.LEFT_QUOTE + " " + CivilDebateWall.state.userRespondingTo.text + " " + Char.RIGHT_QUOTE;
				respondingToOpinion.backgroundColor = CivilDebateWall.state.userRespondingTo.stanceColorMedium;
				opinionLabel.text = "WHAT IS YOUR RESPONSE TO " + CivilDebateWall.state.userRespondingTo.user.username.toUpperCase() + "? ";
				
				respondingToContainer.visible = true;
				respondingToContainer.y = question.bottom;
				formContainer.y = respondingToContainer.bottom;
				keyboardContainer.y = formContainer.bottom + 14;
				
				// allow overscroll
				minScrollY = 0;
				maxScrollY = question.height + respondingToContainer.height + (paddingTop * 2);
				
			}
			else {
				opinionLabel.text = "WHAT IS YOUR OPINION? ";			
				respondingToContainer.visible = false;
				
				formContainer.y = question.bottom;
				keyboardContainer.y = formContainer.bottom + 14;
				
				// allow overscroll
				minScrollY = 0;
				maxScrollY = question.height + (paddingTop * 2);				
			}

		}
				
	}
}
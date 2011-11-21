package com.civildebatewall.kiosk {
	import ObjectDetection.ObjectDetectorEvent;
	
	import com.adobe.serialization.json.*;
	import com.civildebatewall.Assets;
	import com.civildebatewall.CivilDebateWall;
	import com.civildebatewall.SMSOverlay;
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
	import com.kitschpatrol.futil.blocks.BlockBase;
	import com.kitschpatrol.futil.blocks.BlockBitmap;
	import com.kitschpatrol.futil.constants.Alignment;
	import com.kitschpatrol.futil.utilitites.BitmapUtil;
	import com.kitschpatrol.futil.utilitites.FileUtil;
	import com.kitschpatrol.futil.utilitites.FunctionUtil;
	import com.kitschpatrol.futil.utilitites.GeomUtil;
	
	import flash.display.*;
	import flash.events.*;
	import flash.geom.Rectangle;
	import flash.net.*;
	import flash.ui.Multitouch;
	import flash.ui.MultitouchInputMode;

	public class View extends Sprite {
		// convenience
		public const stageWidth:Number = 1080;
		public const stageHeight:Number = 1920;	
		
		// home view		
		private var portrait:Portrait;
		private var questionHeaderHome:QuestionHeader;		
		private var opinion:OpinionText;	
		private var likeButton:HomeLikeButton;
		private var viewCommentsButton:ViewCommentsButton;
		private var flagButton:HomeFlagButton;
		private var leftArrow:NavArrow;
		private var rightArrow:NavArrow;
		private var bigButton:BigButton; // TODO migrate to Futil?
		private var statsButton:StatsButton;
		private var debateStrip:DebateStrip;		
		private var sortLinks:SortLinks;
		private var dragLayer:DragLayer;		

		// comment thread view
		private var questionHeader:QuestionHeader;
		private var opinionUnderlay:BlockBase;
		private var debateThisButton:BalloonButton;
		private var bigBackButton:BigBackButton;
		private var threadOverlayBrowser:ThreadBrowser;
		
		// stats view
		public var statsOverlay:StatsOverlay;		
		
		// pick debate type view
		private var questionHeaderDecision:QuestionHeader;
		private var backButton:BackButton;
		private var respondButton:RespondButton;
		private var debateButton:DebateButton;
		private var orText:BlockBitmap;
		
		// pick stance view
		private var yesButton:YesButton;
		private var noButton:NoButton;
		
		// opinion entry view
		private var opinionEntryOverlay:OpinionEntryOverlay;
		
		// photo booth view (move to its own container?)
		public var portraitCamera:PortraitCamera; // public for dashboard		
		private var countdownButton:CountdownButton;
		private var cameraTimeoutWarning:BlockLabel;
		private var cameraOverlay:CameraOverlay;		
		private var flashOverlay:BlockBitmap;
		private var blackOverlay:BlockBitmap;		
		
		// opinion review view
		private var userOpinion:UserOpinionText;
		private var everythingOkText:BlockBitmap;
		private var cancelButton:CancelButton;
		private var retakePhotoButton:RetakePhotoButton;
		private var editNameOrOpinionButton:EditNameOrOpinionButton;
		
		// terms and conditions overlay
		private var termsAndConditionsButton:TermsAndConditionsButton;
		private var termsAndConditionsUnderlay:BlockBase;
		private var termsAndConditionsText:BlockBitmap;
		private var closeTermsButton:CloseTermsButton;
		
		// sms prompt view
		public var smsOverlay:SMSOverlay; // public for dashboard testing

		// inactivity overlay (Updates TODO!)
		private var inactivityOverlay:BlockBitmap;
		private var inactivityTimerBar:ProgressBar;
		private var inactivityInstructions:BlockLabelBar;
		private var continueButton:BlockButton;
		
		// flag overlay (Updates TODO!)
		private var flagOverlay:FlagOverlay;
		

		// ================================================================================================================================================

		// Constructor
		public function View() {
			super();
			init();
		}
		
		private function init():void {
			// dump everything with just a single instance on the stage,
			// they'll get tweened in and out as necessary
			
			// home view
			portrait = new Portrait();
			portrait.setDefaultTweenIn(1, {alpha: 1});
			portrait.setDefaultTweenOut(1, {alpha: 0});			
			addChild(portrait);
			
			questionHeaderHome = new QuestionHeader({width: 1080, height: 313, textSize: 39, leading: 29});
			questionHeaderHome.setDefaultTweenIn(1, { alpha: 1});
			questionHeaderHome.setDefaultTweenOut(1, { alpha: 0});
			addChild(questionHeaderHome);			
			
			// opinion added in "comment thread view" section for draw order
			
			likeButton = new HomeLikeButton();
			likeButton.setDefaultTweenIn(1, {x: 100, y: 1341});
			likeButton.setDefaultTweenOut(1, {x: Alignment.OFF_STAGE_LEFT, y: 1341});
			addChild(likeButton);
			
			viewCommentsButton = new ViewCommentsButton();
			viewCommentsButton.setDefaultTweenIn(1, {x: 288, y: 1341});
			viewCommentsButton.setDefaultTweenOut(1, {x: Alignment.OFF_STAGE_LEFT, y: 1341});
			addChild(viewCommentsButton);			
			
			flagButton = new HomeFlagButton();
			flagButton.setDefaultTweenIn(1, {x: 916, y: 1341});
			flagButton.setDefaultTweenOut(1, {x: Alignment.OFF_STAGE_LEFT, y: 1341});
			addChild(flagButton);

			leftArrow = new NavArrow({bitmap: Assets.getLeftCaratBig()});
			leftArrow.setDefaultTweenIn(1, {x: 39, y: 1002});
			leftArrow.setDefaultTweenOut(1, {x: Alignment.OFF_STAGE_LEFT, y: 1002});
			addChild(leftArrow);
			
			rightArrow = new NavArrow({bitmap: Assets.getRightCaratBig()});
			rightArrow.setDefaultTweenIn(1, {x: 1019, y: 1002});
			rightArrow.setDefaultTweenOut(1, {x: Alignment.OFF_STAGE_RIGHT, y: 1002});
			addChild(rightArrow);
			
			bigButton = new BigButton();
			bigButton.setDefaultTweenIn(1, {x: 455, alpha: 1});
			bigButton.setDefaultTweenOut(1, {x: 455, alpha: 0}); // TODO possibly subclass for cooler in and out tweens
			addChild(bigButton);
			
			statsButton = new StatsButton();
			statsButton.setDefaultTweenIn(1, {x: 838, y: 796});
			statsButton.setDefaultTweenOut(1, {x: Alignment.OFF_STAGE_RIGHT, y: 796});
			addChild(statsButton);			
			
			debateStrip = new DebateStrip();
			debateStrip.setDefaultTweenIn(1, {x: 0, y: 1671});
			debateStrip.setDefaultTweenOut(1, {x: 0, y: Alignment.OFF_STAGE_BOTTOM});
			addChild(debateStrip);			
			
			sortLinks = new SortLinks();
			sortLinks.setDefaultTweenIn(1, {y: 1811});	
			sortLinks.setDefaultTweenOut(1, {y: Alignment.OFF_STAGE_BOTTOM});			
			addChild(sortLinks);			
			
			dragLayer = new DragLayer(); // TODO is there always a drag layer?
			dragLayer.setDefaultTweenIn(0, {});
			dragLayer.setDefaultTweenOut(0, {});
			addChild(dragLayer);			
						
			
			// comment thread view
			questionHeader = new QuestionHeader({width: 1024, height: 250, textSize: 28,	leading: 22});
			questionHeader.setDefaultTweenIn(1, {x: 28, alpha: 1});
			questionHeader.setDefaultTweenOut(1, {x: 28, alpha: 0});
			addChild(questionHeader);
			
			opinionUnderlay = new BlockBase({backgroundColor: 0xffffff, backgroundAlpha: 0.85, width: 1024}); // height determined by opinion
			opinionUnderlay.setDefaultTweenIn(1, {x: 28, y: 264, alpha: 1});
			opinionUnderlay.setDefaultTweenOut(1, {x: 28, y: 264, alpha: 0});
			addChild(opinionUnderlay);
			
			opinion = new OpinionText();	
			opinion.setDefaultTweenIn(1, {x: 100, y: 1296});
			opinion.setDefaultTweenOut(1, {x: Alignment.OFF_STAGE_LEFT, y: 1296});
			addChild(opinion);			
			
			debateThisButton = new BalloonButton();
			debateThisButton.setDefaultTweenIn(1, {x: 919});
			debateThisButton.setDefaultTweenOut(1, {x: Alignment.OFF_STAGE_RIGHT});
			addChild(debateThisButton);
			
			bigBackButton = new BigBackButton();
			bigBackButton.setDefaultTweenIn(1, {x: 28, y: 1826});
			bigBackButton.setDefaultTweenOut(1, {x: 28, y: Alignment.OFF_STAGE_BOTTOM});
			addChild(bigBackButton);
			
			threadOverlayBrowser = new ThreadBrowser();
			threadOverlayBrowser.setDefaultTweenIn(1, {x: 28}); // y depends on opinion height
			threadOverlayBrowser.setDefaultTweenOut(1, {x: 28, y: Alignment.OFF_STAGE_BOTTOM});			
			addChild(threadOverlayBrowser);
			

			// stats view
			statsOverlay = new StatsOverlay();
			statsOverlay.setDefaultTweenIn(1, {x: 29, y: 264});
			statsOverlay.setDefaultTweenOut(1, {x: 29, y: OldBlockBase.OFF_BOTTOM_EDGE});
			addChild(statsOverlay);		
			
			
			// pick debate type view
			questionHeaderDecision = new QuestionHeader({width: 880, height: 157, textSize: 26, leading: 18});		
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
			
			
			// pick stance view
			yesButton = new YesButton();
			yesButton.setDefaultTweenIn(1, {x: 446, y: 1231});
			yesButton.setDefaultTweenOut(1, {x: Alignment.OFF_STAGE_LEFT, y: 1231});
			addChild(yesButton);
			
			noButton = new NoButton();
			noButton.setDefaultTweenIn(1, {x: 720, y: 1231});
			noButton.setDefaultTweenOut(1, {x: Alignment.OFF_STAGE_RIGHT, y: 1231});
			addChild(noButton);			
			
			
			// opinion entry view
			opinionEntryOverlay = new OpinionEntryOverlay();
			opinionEntryOverlay.setDefaultTweenIn(1, {x: 0, y: 0});
			opinionEntryOverlay.setDefaultTweenOut(1, {x: 0, y: Alignment.OFF_STAGE_BOTTOM});
			addChild(opinionEntryOverlay);
			
			
			// photo booth view (move to its own container?)
			portraitCamera = new PortraitCamera();
			portraitCamera.setDefaultTweenIn(1, {alpha: 1});
			portraitCamera.setDefaultTweenOut(1, {alpha: 0});
			addChild(portraitCamera);
			
			cameraOverlay = new CameraOverlay();
			cameraOverlay.setDefaultTweenIn(1, {alpha: 1});
			cameraOverlay.setDefaultTweenOut(1, {alpha: 0});			
			addChild(cameraOverlay);
			
			countdownButton = new CountdownButton(6);
			countdownButton.setDefaultTweenIn(1, {x: Alignment.CENTER_STAGE, y: 30});
			countdownButton.setDefaultTweenOut(1, {x: Alignment.CENTER_STAGE, y: Alignment.OFF_STAGE_TOP});
			addChild(countdownButton);			
			
			cameraTimeoutWarning = new BlockLabel('The camera could not focus, please try again!', 26, 0xffffff, Assets.COLOR_GRAY_50, Assets.FONT_BOLD);
			cameraTimeoutWarning.setDefaultTweenIn(1, {x: OldBlockBase.CENTER, y: OldBlockBase.CENTER});	
			cameraTimeoutWarning.setDefaultTweenOut(1, {x: OldBlockBase.OFF_LEFT_EDGE, y: OldBlockBase.CENTER});
			addChild(cameraTimeoutWarning);			
			
			blackOverlay = new BlockBitmap({bitmap: new Bitmap(new BitmapData(stageWidth, stageHeight, false, 0x000000))});
			blackOverlay.setDefaultTweenIn(0.1, {alpha: 1, immediateRender: true}); // duration of 0 doesn't work?
			blackOverlay.setDefaultTweenOut(0, {alpha: 0});
			addChild(blackOverlay);
			
			flashOverlay = new BlockBitmap({bitmap: new Bitmap(new BitmapData(stageWidth, stageHeight, false, 0xffffff))});
			flashOverlay.setDefaultTweenIn(0.1, {alpha: 1, ease: Quart.easeOut, immediateRender: true});
			flashOverlay.setDefaultTweenOut(1, {alpha: 0, ease: Quart.easeOut});
			addChild(flashOverlay);
			
			
			// opinion review view
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
			
			
			// terms and conditions overlay
			termsAndConditionsButton = new TermsAndConditionsButton();
			termsAndConditionsButton.setDefaultTweenIn(1, {x: 791, y: 1864});
			termsAndConditionsButton.setDefaultTweenOut(1, {x: 791, y: Alignment.OFF_STAGE_BOTTOM});
			addChild(termsAndConditionsButton);
			
			termsAndConditionsUnderlay = new BlockBase({
				width: 1080,
				height: 1920,
				backgroundColor: 0x000000,
				backgroundAlpha: 0.85
			});
			
			termsAndConditionsUnderlay.setDefaultTweenIn(1, {alpha: 1});
			termsAndConditionsUnderlay.setDefaultTweenOut(1, {alpha: 0});			
			addChild(termsAndConditionsUnderlay);
			
			termsAndConditionsText = new BlockBitmap({
				bitmap: Assets.getTermsAndConditions()
			});
			termsAndConditionsText.setDefaultTweenIn(1, {x: 100, y: 982});
			termsAndConditionsText.setDefaultTweenOut(1, {x: 100, y: Alignment.OFF_STAGE_BOTTOM});
			addChild(termsAndConditionsText);
			
			closeTermsButton = new CloseTermsButton();
			closeTermsButton.setDefaultTweenIn(1, {x: 845, y: 1849});
			closeTermsButton.setDefaultTweenOut(1, {x: 845, y: Alignment.OFF_STAGE_BOTTOM});
			addChild(closeTermsButton);

			
			// sms prompt view
			smsOverlay = new SMSOverlay();
			smsOverlay.setDefaultTweenIn(0, {});
			smsOverlay.setDefaultTweenOut(1, {});
			addChild(smsOverlay);
			
			
			// inactivity overlay (Updates TODO!)
//			inactivityOverlay = new BlockBitmap({bitmap: new Bitmap(new BitmapData(stageWidth, stageHeight, false, 0x000000))});
//			inactivityOverlay.setDefaultTweenIn(1, {alpha: 0.85});
//			inactivityOverlay.setDefaultTweenOut(1, {alpha: 0});
//			addChild(inactivityOverlay);
//			
//			inactivityTimerBar = new ProgressBar(735, 2, 20);		
//			inactivityTimerBar.setDefaultTweenIn(1, {x: OldBlockBase.CENTER, y: 1002});
//			inactivityTimerBar.setDefaultTweenOut(1, {x: OldBlockBase.CENTER, y: OldBlockBase.OFF_TOP_EDGE});			
//			addChild(inactivityTimerBar);
//			
//			inactivityInstructions = new BlockLabelBar('ARE YOU STILL THERE ?', 23, 0xffffff, 735, 63, Assets.COLOR_GRAY_75, Assets.FONT_HEAVY);
//			inactivityInstructions.setDefaultTweenIn(1, {x: OldBlockBase.CENTER, y: 1018});
//			inactivityInstructions.setDefaultTweenOut(1, {x: OldBlockBase.CENTER, y: OldBlockBase.OFF_TOP_EDGE});			
//			addChild(inactivityInstructions);
//			
//			continueButton = new BlockButton(735, 120, Assets.COLOR_GRAY_50, 'YES!', 92);
//			continueButton.setDownColor(Assets.COLOR_GRAY_75);
//			continueButton.setDefaultTweenIn(1, {alpha: 1, x: OldBlockBase.CENTER, y: 1098});
//			continueButton.setDefaultTweenOut(1, {alpha: 1, x: OldBlockBase.OFF_LEFT_EDGE, y: 1098});					
//			addChild(continueButton);
			
			
			// flag overlay
			flagOverlay = new FlagOverlay();
			flagOverlay.setDefaultTweenIn(0, {}); // internal
			flagOverlay.setDefaultTweenOut(1, {});  // internal
			addChild(flagOverlay);

			// Watch state for changes
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
		
		// ================================================================================================================================================

		public function noOpinionView(...args):void {
			// land here if there aren't yet opinions for the current question
			// TODO some kind of "be the first" message
			
			markAllInactive();
			
			// mutations
			CivilDebateWall.inactivityTimer.disarm();
			portrait.setImage(Assets.portraitPlaceholder);
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
		
		// ================================================================================================================================================
		
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
		
		// ================================================================================================================================================
		
		public function threadView(...args):void {			
			markAllInactive();
			CivilDebateWall.inactivityTimer.disarm();
			
			// Do this on event callback instead?
			debateThisButton.targetPost = CivilDebateWall.state.activeThread.firstPost;
			
			// Alignment
			opinionUnderlay.height = opinion.contentHeight + 233;
			debateThisButton.y = 327 + opinion.contentHeight;
			threadOverlayBrowser.maxHeight = 1812 - (opinionUnderlay.y + opinionUnderlay.height + 14);

			portrait.tweenIn();
			questionHeader.tweenIn();
			opinionUnderlay.tweenIn();			
			opinion.tweenIn(1, {y: 327 + opinion.contentHeight});
			threadOverlayBrowser.tweenIn(1, {y: opinionUnderlay.y + opinionUnderlay.height + 14});
			debateThisButton.tweenIn();
			bigBackButton.tweenIn();
								
			tweenOutInactive();	
		}
		
		// ================================================================================================================================================
		
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
			
			// custom tween outs TODO these don't handle fast clicking very well
			// threadOverlayBrowser.tweenOut(1, {x: Alignment.OFF_STAGE_RIGHT, y: threadOverlayBrowser.y});
			// opinion.tweenOut(1, {x: Alignment.OFF_STAGE_RIGHT, y: opinion.y});
			// bigBackButton.tweenOut(1, {x: Alignment.OFF_STAGE_RIGHT, y: bigBackButton.y});
			
			tweenOutInactive();			
		}

		// ================================================================================================================================================
		
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
		
		// ================================================================================================================================================		
		
		public function opinionEntryView(...args):void {
			markAllInactive();			
			CivilDebateWall.inactivityTimer.arm();
			CivilDebateWall.state.backDestination = CivilDebateWall.state.lastView;
			
			opinionEntryOverlay.tweenIn();
			
			tweenOutInactive();			
		}
		
		// ================================================================================================================================================		
		
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
		
		// ================================================================================================================================================		
		
		public function opinionReviewView(...args):void {
			markAllInactive();
			CivilDebateWall.inactivityTimer.arm();
			CivilDebateWall.state.backDestination = CivilDebateWall.kiosk.view.opinionEntryView;			
			
			bigButton.setOnClick(function():void {
				CivilDebateWall.state.setView(smsPromptView);			
			});							
			
			portrait.setImage(CivilDebateWall.state.userImage, true);
			bigButton.setText("SUBMIT MY OPINION", true);
			bigButton.enable();
			bigButton.y = 1607;			
			
			portrait.tweenIn();
			questionHeaderHome.tweenIn();
			userOpinion.tweenIn();
			everythingOkText.tweenIn();
			cancelButton.tweenIn();
			retakePhotoButton.tweenIn();
			editNameOrOpinionButton.tweenIn();
			bigButton.tweenIn();
			termsAndConditionsButton.tweenIn();
			
			tweenOutInactive();			
		}
		
		// ================================================================================================================================================		
		
		public function termsAndConditionsView(...args):void {
			termsAndConditionsUnderlay.tweenIn();
			termsAndConditionsText.tweenIn();
			closeTermsButton.tweenIn();
		}
		
		// ================================================================================================================================================		
		
		public function smsPromptView(...args):void {
			markAllInactive();
			CivilDebateWall.inactivityTimer.arm();	
			
			smsOverlay.tweenIn();
			
			tweenOutInactive();
		}
		
		// ================================================================================================================================================		
		
		
			// ==============================================================================================================
			// Old views ====================================================================================================
			// ==============================================================================================================
		
		

		public function flagOverlayView(...args):void {
			CivilDebateWall.state.lastView = CivilDebateWall.state.activeView;
			CivilDebateWall.state.activeView = flagOverlayView;
			flagOverlay.tweenIn();		
		}
		
		public function removeFlagOverlayView(...args):void {
			CivilDebateWall.state.activeView = CivilDebateWall.state.lastView; // revert the view, since it was just an overlay
			CivilDebateWall.state.lastView = flagOverlayView;
			flagOverlay.tweenOut();	
		}
		

		
		
		

		

	
		
		// =========================================================================
		

		
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
			//inactivityTimerBar.setOnComplete(homeView);
			
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

		private function markAllInactive():void {
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
/*--------------------------------------------------------------------
Civil Debate Wall Kiosk
Copyright (c) 2012 Local Projects. All rights reserved.

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as
published by the Free Software Foundation, either version 2 of the
License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public
License along with this program. 

If not, see <http://www.gnu.org/licenses/>.
--------------------------------------------------------------------*/

package com.civildebatewall.kiosk.core {
	
	import ObjectDetection.ObjectDetectorEvent;
	
	import com.civildebatewall.Assets;
	import com.civildebatewall.CivilDebateWall;
	import com.civildebatewall.State;
	import com.civildebatewall.Utilities;
	import com.civildebatewall.kiosk.DragLayer;
	import com.civildebatewall.kiosk.buttons.BackButton;
	import com.civildebatewall.kiosk.buttons.BigBackButton;
	import com.civildebatewall.kiosk.buttons.CancelButton;
	import com.civildebatewall.kiosk.buttons.CloseTermsButton;
	import com.civildebatewall.kiosk.buttons.DebateButton;
	import com.civildebatewall.kiosk.buttons.DebateStripNavArrow;
	import com.civildebatewall.kiosk.buttons.DebateThisButton;
	import com.civildebatewall.kiosk.buttons.EditNameOrOpinionButton;
	import com.civildebatewall.kiosk.buttons.HomeFlagButton;
	import com.civildebatewall.kiosk.buttons.HomeLikeButton;
	import com.civildebatewall.kiosk.buttons.LowerMenuButton;
	import com.civildebatewall.kiosk.buttons.NavArrowLeft;
	import com.civildebatewall.kiosk.buttons.NavArrowRight;
	import com.civildebatewall.kiosk.buttons.NoButton;
	import com.civildebatewall.kiosk.buttons.RespondButton;
	import com.civildebatewall.kiosk.buttons.RetakePhotoButton;
	import com.civildebatewall.kiosk.buttons.SortLinks;
	import com.civildebatewall.kiosk.buttons.StatsButton;
	import com.civildebatewall.kiosk.buttons.TermsAndConditionsButton;
	import com.civildebatewall.kiosk.buttons.ViewCommentsButton;
	import com.civildebatewall.kiosk.buttons.YesButton;
	import com.civildebatewall.kiosk.camera.CameraFeedEvent;
	import com.civildebatewall.kiosk.camera.FaceDetector;
	import com.civildebatewall.kiosk.camera.PortraitCamera;
	import com.civildebatewall.kiosk.elements.CameraOverlay;
	import com.civildebatewall.kiosk.elements.DebateStrip;
	import com.civildebatewall.kiosk.elements.PortraitMain;
	import com.civildebatewall.kiosk.elements.ThreadBrowser;
	import com.civildebatewall.kiosk.elements.opinion_text.OpinionTextHome;
	import com.civildebatewall.kiosk.elements.opinion_text.UserOpinionText;
	import com.civildebatewall.kiosk.elements.question_text.QuestionHeaderDecision;
	import com.civildebatewall.kiosk.elements.question_text.QuestionHeaderHome;
	import com.civildebatewall.kiosk.elements.question_text.QuestionHeaderThread;
	import com.civildebatewall.kiosk.legacy.BigButton;
	import com.civildebatewall.kiosk.legacy.CountdownButton;
	import com.civildebatewall.kiosk.legacy.OldBlockBase;
	import com.civildebatewall.kiosk.overlays.CameraCalibrationOverlay;
	import com.civildebatewall.kiosk.overlays.FlagOverlay;
	import com.civildebatewall.kiosk.overlays.InactivityOverlay;
	import com.civildebatewall.kiosk.overlays.OpinionEntryOverlay;
	import com.civildebatewall.kiosk.overlays.StatsOverlay;
	import com.civildebatewall.kiosk.overlays.smsfun.SMSOverlay;
	import com.greensock.TweenMax;
	import com.greensock.easing.Quart;
	import com.greensock.loading.LoaderStatus;
	import com.kitschpatrol.futil.blocks.BlockBase;
	import com.kitschpatrol.futil.blocks.BlockBitmap;
	import com.kitschpatrol.futil.blocks.BlockText;
	import com.kitschpatrol.futil.constants.Alignment;
	import com.kitschpatrol.futil.utilitites.BitmapUtil;
	import com.kitschpatrol.futil.utilitites.GeomUtil;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.PixelSnapping;
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Rectangle;
	
	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.getLogger;

	public class Kiosk extends Sprite {
		
		private static var logger:ILogger = getLogger(Kiosk);
		
		
		// convenience
		public const stageWidth:Number = 1080;
		public const stageHeight:Number = 1920;
		
		// home view
		public var portrait:PortraitMain;
		public var questionHeaderHome:QuestionHeaderHome;
		private var opinionHome:OpinionTextHome;
		private var likeButton:HomeLikeButton;
		private var viewCommentsButton:ViewCommentsButton;
		private var flagButton:HomeFlagButton;
		private var leftArrow:NavArrowLeft;
		private var rightArrow:NavArrowRight;
		private var bigButton:BigButton; // TODO migrate to Futil?
		private var statsButton:StatsButton;
		private var debateStripUnderlay:BlockBase;
		private var debateStripLeftButton:DebateStripNavArrow;
		private var debateStripRightButton:DebateStripNavArrow;		
		public var debateStrip:DebateStrip;
		private var sortLinks:SortLinks;
		private var dragLayer:DragLayer;

		// comment thread view
		private var questionHeaderThread:QuestionHeaderThread;
		private var opinionUnderlay:BlockBase;
		private var debateThisButton:DebateThisButton;
		private var bigBackButton:BigBackButton;
		public var threadOverlayBrowser:ThreadBrowser;
		
		// stats view
		private var statsUnderlay:BlockBase;		
		public var statsOverlay:StatsOverlay;
		public var lowerMenuButton:LowerMenuButton;
		
		// pick debate type view
		public var questionHeaderDecision:QuestionHeaderDecision;
		private var backButton:BackButton;
		private var respondButton:RespondButton;
		private var debateButton:DebateButton;
		private var orText:BlockBitmap;
		
		// pick stance view
		private var yesButton:YesButton;
		private var noButton:NoButton;
		
		// opinion entry view
		public var opinionEntryOverlay:OpinionEntryOverlay;
		
		// photo booth view (move to its own container?)
		public var portraitCamera:PortraitCamera; // public for dashboard		
		private var countdownButton:CountdownButton;
		private var cameraTimeoutWarning:BlockText;
		private var cameraOverlay:CameraOverlay;		
		private var flashOverlay:BlockBitmap;
		private var blackOverlay:BlockBitmap;		
		
		// opinion review view
		private var userOpinionReview:UserOpinionText;
		private var everythingOkText:BlockBitmap;
		private var cancelButton:CancelButton;
		private var retakePhotoButton:RetakePhotoButton;
		private var editNameOrOpinionButton:EditNameOrOpinionButton;
		
		// terms and conditions overlay (put in overlay?)
		private var termsAndConditionsButton:TermsAndConditionsButton;
		private var termsAndConditionsUnderlay:BlockBase;
		private var termsAndConditionsText:BlockBitmap;
		private var closeTermsButton:CloseTermsButton;
		
		// sms prompt view // TODO?
		public var smsOverlay:SMSOverlay;

		// flag overlay
		public var flagOverlay:FlagOverlay;
		
		// inactivity overlay
		private var inactivityOverlay:InactivityOverlay;		
		
		// camera calibration
		private var cameraCalibrationOverlay:CameraCalibrationOverlay; 
		
		
		// ================================================================================================================================================

		
		// Constructor
		public function Kiosk() {
			super();
			init();
		}
		
		private function init():void {
			// dump everything with just a single instance on the stage,
			// they'll get tweened in and out as necessary
			
			// home view
			portrait = new PortraitMain();
			portrait.setDefaultTweenIn(1, {alpha: 1, overlayAlpha: 0});
			portrait.setDefaultTweenOut(1, {alpha: 0, overlayAlpha: 0});			
			addChild(portrait);
			
			questionHeaderHome = new QuestionHeaderHome();
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

			leftArrow = new NavArrowLeft();
			leftArrow.setDefaultTweenIn(1, {x: 0, y: 907});
			leftArrow.setDefaultTweenOut(1, {x: -100, y: 907});
			addChild(leftArrow);
			
			rightArrow = new NavArrowRight();
			rightArrow.setDefaultTweenIn(1, {x: 980, y: 907});
			rightArrow.setDefaultTweenOut(1, {x: Alignment.OFF_STAGE_RIGHT, y: 907});
			addChild(rightArrow);
			
			bigButton = new BigButton();
			bigButton.setDefaultTweenIn(1, {x: 455, alpha: 1});
			bigButton.setDefaultTweenOut(1, {x: 455, alpha: 0}); // TODO possibly subclass for cooler in and out tweens
			addChild(bigButton);
			
			statsButton = new StatsButton();
			statsButton.setDefaultTweenIn(1, {x: 838, y: 796});
			statsButton.setDefaultTweenOut(1, {x: Alignment.OFF_STAGE_RIGHT, y: 796});
			addChild(statsButton);			
			
			debateStripUnderlay = new BlockBase({width: 1080, height: 141, backgroundColor: 0xffffff});
			debateStripUnderlay.setDefaultTweenIn(1, {x: 0, y: 1670});
			debateStripUnderlay.setDefaultTweenOut(1, {x: 0, y: Alignment.OFF_STAGE_BOTTOM});
			addChild(debateStripUnderlay);
			
			// buttons
			debateStripLeftButton = new DebateStripNavArrow({bitmap: Assets.getLeftCarat()});
			debateStripLeftButton.setDefaultTweenIn(1, {x: 0, y: 1670});
			debateStripLeftButton.setDefaultTweenOut(1, {x: -50, y: 1670});
			addChild(debateStripLeftButton);
			
			debateStripRightButton = new DebateStripNavArrow({bitmap: Assets.getRightCarat()});
			debateStripRightButton.setDefaultTweenIn(1, {x: 1030, y: 1670});
			debateStripRightButton.setDefaultTweenOut(1, {x: Alignment.OFF_STAGE_RIGHT, y: 1670});
			addChild(debateStripRightButton);	
			
			debateStrip = new DebateStrip();
			debateStrip.setDefaultTweenIn(1, {x: 50, y: 1670});
			debateStrip.setDefaultTweenOut(1, {x: 50, y: Alignment.OFF_STAGE_BOTTOM});
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
			questionHeaderThread = new QuestionHeaderThread();
			questionHeaderThread.setDefaultTweenIn(1, {x: 28, alpha: 1});
			questionHeaderThread.setDefaultTweenOut(1, {x: 28, alpha: 0});
			// defer adding to stage so it's over the stats underlay
			
			opinionUnderlay = new BlockBase({backgroundColor: 0xffffff, backgroundAlpha: 0.85, width: 1024}); // height determined by opinion
			opinionUnderlay.setDefaultTweenIn(1, {x: 28, y: 264, alpha: 1});
			opinionUnderlay.setDefaultTweenOut(1, {x: 28, y: 264, alpha: 0});
			addChild(opinionUnderlay);
			
			opinionHome = new OpinionTextHome();	
			opinionHome.setDefaultTweenIn(1, {x: 100, y: 945});
			opinionHome.setDefaultTweenOut(1, {x: Alignment.OFF_STAGE_LEFT, y: 945});
			addChild(opinionHome);			
			
			debateThisButton = new DebateThisButton();
			debateThisButton.setDefaultTweenIn(1, {x: 919});
			debateThisButton.setDefaultTweenOut(1, {x: Alignment.OFF_STAGE_RIGHT});
			addChild(debateThisButton);
			
			bigBackButton = new BigBackButton();
			bigBackButton.setDefaultTweenIn(1, {x: 28, y: 1826});
			bigBackButton.setDefaultTweenOut(1, {x: Alignment.OFF_STAGE_LEFT, y: 1826});
			// added later so it can go over stats
			
			threadOverlayBrowser = new ThreadBrowser();
			threadOverlayBrowser.setDefaultTweenIn(1, {x: 28}); // y depends on opinion height
			threadOverlayBrowser.setDefaultTweenOut(1, {x: 28, y: Alignment.OFF_STAGE_BOTTOM});			
			addChild(threadOverlayBrowser);

			// stats view
			statsUnderlay = new BlockBase({width: 1080, height: 1920,	backgroundColor: 0xffffff});
			statsUnderlay.setDefaultTweenIn(1, {alpha: 1});
			statsUnderlay.setDefaultTweenOut(1, {alpha: 0});
			addChild(statsUnderlay);		
			
			statsOverlay = new StatsOverlay();
			statsOverlay.setDefaultTweenIn(1, {x: 0, y: 264});
			statsOverlay.setDefaultTweenOut(1, {x: 0, y: Alignment.OFF_STAGE_BOTTOM});
			addChild(statsOverlay);	

			addChild(bigBackButton);	// deferred for draw order over the stats		
			addChild(questionHeaderThread); // deferred for draw order over the stats			
			
			lowerMenuButton = new LowerMenuButton();
			lowerMenuButton.setDefaultTweenIn(1, {x: 813, y: 1826});
			lowerMenuButton.setDefaultTweenOut(1, {x: Alignment.OFF_STAGE_RIGHT, y: 1826});	
			addChild(lowerMenuButton);
			
			// pick debate type view
			questionHeaderDecision = new QuestionHeaderDecision();
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
			
			orText = new BlockBitmap({bitmap: Assets.getOrText(), backgroundAlpha: 0});			
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
			
			// TODO make this work! Add event listener!
			cameraTimeoutWarning = new BlockText({
				textFont: Assets.FONT_BOLD,
				textSize: 26,
				textColor: 0xffffff,
				backgroundColor: Assets.COLOR_GRAY_50,
				padding: 40,
				text: "The camera could not focus, please try again!"
			});
			cameraTimeoutWarning.setDefaultTweenIn(1, {x: Alignment.CENTER_STAGE, y: Alignment.CENTER_STAGE});	
			cameraTimeoutWarning.setDefaultTweenOut(1, {x: Alignment.OFF_STAGE_LEFT, y: Alignment.CENTER_STAGE});
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
			userOpinionReview = new UserOpinionText();
			userOpinionReview.setDefaultTweenIn(1, {x: 100});
			userOpinionReview.setDefaultTweenOut(1, {x: Alignment.OFF_STAGE_LEFT});
			addChild(userOpinionReview);
			
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

			// flag overlay
			flagOverlay = new FlagOverlay();
			flagOverlay.setDefaultTweenIn(0, {}); // internal
			flagOverlay.setDefaultTweenOut(1, {});  // internal
			addChild(flagOverlay);
			
			// Inactivity Overlay
			inactivityOverlay = new InactivityOverlay();
			inactivityOverlay.setDefaultTweenIn(0, {}); // internal
			inactivityOverlay.setDefaultTweenOut(1, {});  // internal
			addChild(inactivityOverlay);			

			// Set up global unchanging events...
			debateStripLeftButton.onStageUp.push(onDebateStripLeftButton);
			debateStripRightButton.onStageUp.push(onDebateStripRightButton);
			
			// Watch state for changes
			CivilDebateWall.state.addEventListener(State.ACTIVE_THREAD_CHANGE, onActiveDebateChange);
			CivilDebateWall.state.addEventListener(State.VIEW_CHANGE, onViewChange);
		}
		
		private function onViewChange(e:Event):void {
			// refresh the view...
			CivilDebateWall.state.activeView();
		}		
		
		private function onActiveDebateChange(e:Event):void {
			// nothing to see here, display objects listen and handle themselves
		}
		
		// ================================================================================================================================================

		public function noOpinionView(...args):void {
			// land here if there aren't yet opinions for the current question
			// TODO some kind of "be the first" message
			markAllInactive();
			
			// mutations
			
			CivilDebateWall.state.inactivityOverlayArmed = false;
			portrait.setImage(Assets.portraitPlaceholder);
			bigButton.y = 1470;
			bigButton.setText("ADD YOUR OPINION");
			CivilDebateWall.state.clearUser();

			// behaviors
			bigButton.setOnClick(function():void {
				CivilDebateWall.state.setView(debateStancePickerView);			
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
			
			if (CivilDebateWall.data.photoQueue.paused) {
				logger.info("...resuming photo queue loading");
				TweenMax.delayedCall(3, CivilDebateWall.data.photoQueue.resume);
			}
			
			CivilDebateWall.state.inactivityOverlayArmed = false;
						
			bigButton.y = 1470;			
			bigButton.setText("JOIN THE DEBATE"); // TODO move to listener?
			bigButton.setOnClick(function():void {
				CivilDebateWall.state.userRespondingTo = CivilDebateWall.state.activeThread.firstPost;
				CivilDebateWall.state.setView(debateTypePickerView);			
			});

			portrait.setImage(CivilDebateWall.state.activeThread.firstPost.user.photo);
			
			// blocks
			portrait.tweenIn();
			questionHeaderHome.tweenIn();
			leftArrow.tweenIn();
			rightArrow.tweenIn();
			opinionHome.tweenIn();			
			statsButton.tweenIn();
			likeButton.tweenIn();
			viewCommentsButton.tweenIn();			
			flagButton.tweenIn();			
			bigButton.tweenIn();
			debateStripUnderlay.tweenIn();
			debateStripLeftButton.tweenIn();
			debateStripRightButton.tweenIn();
			debateStrip.tweenIn();
			sortLinks.tweenIn();
			
			// override any tween outs here (flagging them as active means they won't get tweened out automatically)
			// note that it's a one-time thing, when the block tweens back in, it will start from its canonical "tween out" location
			// and not this temporary override
			//debateOverlay.tweenOut(1, {y: -debateOverlay.height});
			
			// clean up the old based on what's not active
			tweenOutInactive();
		}
		
		private function onDebateStripLeftButton(e:MouseEvent):void {
			debateStrip.scrollLeft();
		}
		
		private function onDebateStripRightButton(e:MouseEvent):void {
			debateStrip.scrollRight();
		}		
		
		//-----------------
		
		// TODO update these...
		public function nextDebate():void {
			if (CivilDebateWall.state.nextThread != null) { 	
				logger.info("Tansitioning to next debate TOTO");
				CivilDebateWall.state.setActiveThread(CivilDebateWall.state.nextThread);
				CivilDebateWall.kiosk.opinionHome.x += stageWidth;
			}
		}
		
		public function previousDebate():void {
			if (CivilDebateWall.state.previousThread != null) {
				logger.info("Tansitioning to previos debate TOTO");
				CivilDebateWall.state.setActiveThread(CivilDebateWall.state.previousThread);
				CivilDebateWall.kiosk.opinionHome.x -= stageWidth;
			}			
		}
		
		// ================================================================================================================================================
		
		public function threadView(...args):void {			
			markAllInactive();
			CivilDebateWall.state.inactivityOverlayArmed = true;
			
			// Do this on event callback instead?
			debateThisButton.targetPost = CivilDebateWall.state.activeThread.firstPost;
			
			// position the main opinion for a non-diagonal tween in
			if ((CivilDebateWall.state.lastView == CivilDebateWall.kiosk.statsView) ||
					(CivilDebateWall.state.lastView == CivilDebateWall.kiosk.opinionEntryView)) {
				opinionHome.y = 327;
			}
			
			// Alignment
			opinionUnderlay.height = opinionHome.contentHeight + 233;
			debateThisButton.y = 327 + opinionHome.contentHeight;
			threadOverlayBrowser.maxHeight = 1812 - (opinionUnderlay.y + opinionUnderlay.height + 14);

			bigBackButton.width = 1022;
			
			portrait.tweenIn();
			questionHeaderThread.tweenIn();
			opinionUnderlay.tweenIn();			
			opinionHome.tweenIn(1, {y: 327});
			threadOverlayBrowser.tweenIn(1, {y: opinionUnderlay.y + opinionUnderlay.height + 14});
			debateThisButton.tweenIn();
			bigBackButton.tweenIn();
								
			tweenOutInactive();	
		}
		
		// ================================================================================================================================================
		
		public function debateTypePickerView(...args):void {
			markAllInactive(); 
			CivilDebateWall.state.inactivityOverlayArmed = true;
			
			portrait.active = true;
			
			CivilDebateWall.kiosk.portrait.setImage(CivilDebateWall.state.userRespondingTo.user.photo);			
			
			portrait.tweenIn(-1, {overlayAlpha: 0.65});
			backButton.tweenIn();
			questionHeaderDecision.tweenIn();
			respondButton.tweenIn();
			orText.tweenIn();
			debateButton.tweenIn();
			
			tweenOutInactive();			
		}

		// ================================================================================================================================================
		
		public function debateStancePickerView(...args):void {
			markAllInactive();
			CivilDebateWall.state.inactivityOverlayArmed = true;			
			
			portrait.active = true;
			
			
			CivilDebateWall.kiosk.portrait.setImage(Assets.portraitPlaceholder);			
			

			
			portrait.tweenIn(-1, {overlayAlpha: 0.85});
			backButton.tweenIn();
			questionHeaderDecision.tweenIn();
			yesButton.tweenIn();
			noButton.tweenIn();

			tweenOutInactive();			
		}
		
		// ================================================================================================================================================		
		
		public function opinionEntryView(...args):void {
			
			CivilDebateWall.data.photoQueue.pause(); // does this mess with the picture taking process?			
			
			markAllInactive();
			
			if (CivilDebateWall.data.photoQueue.status == LoaderStatus.LOADING) {
				logger.info("Pausing photo queue loading...");
				CivilDebateWall.data.photoQueue.pause();
			}			
			
			CivilDebateWall.state.inactivityOverlayArmed = true;
			
			if (CivilDebateWall.state.lastView == debateStancePickerView) {
				portrait.tweenIn(-1, {overlayAlpha: 1});				
			}
			else {
				portrait.tweenIn(-1, {alpha: 0, overlayAlpha: 1});				
			}
						
			opinionEntryOverlay.tweenIn();
			
			// make sure opinion does not tween out diagonally
			opinionHome.tweenOut(-1, {y: opinionHome.y});			
			
			
			

			tweenOutInactive();			
		}
		
		
		// ================================================================================================================================================		
		
		private var faceDetector:FaceDetector = new FaceDetector();
		
		public function photoBoothView(...args):void {			
			markAllInactive();
			CivilDebateWall.state.inactivityOverlayArmed = true;			
			
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
//				TweenMax.delayedCall(5, function():void { cameraTimeoutWarning.tweenOut(-1, {x: Alignment.OFF_STAGE_RIGHT})});
//			}
			
			tweenOutInactive();
		}
		
		private function onCountdownFinish(e:Event):void {			
			// go to black
			blackOverlay.tweenIn(-1, {onComplete: onScreenBlack});
		}
		
		private function onScreenBlack():void {
			if (CivilDebateWall.settings.useSLR) {
				// using SLR
				portraitCamera.slr.addEventListener(CameraFeedEvent.NEW_FRAME_EVENT, onPhotoCapture);
				portraitCamera.slr.addEventListener(CameraFeedEvent.CAMERA_TIMEOUT_EVENT, onSLRTimeout);
				portraitCamera.slr.takePhoto();
			}
			else {
				// using webcam or pseudocam
				portraitCamera.takePhoto();
				CivilDebateWall.state.userImage = new Bitmap(portraitCamera.cameraBitmap.bitmapData.clone(), PixelSnapping.AUTO, true); // store here temporarily				
				detectFace(CivilDebateWall.state.userImage);				
			}
		}
		
		private function onSLRTimeout(e:Event):void {
			portraitCamera.slr.removeEventListener(CameraFeedEvent.NEW_FRAME_EVENT, onPhotoCapture);
			portraitCamera.slr.removeEventListener(CameraFeedEvent.CAMERA_TIMEOUT_EVENT, onSLRTimeout);
			
			logger.warn("Got SLR Timeout Event");
			
			// go back to photo page
			//photoBoothView();
		}
		
		private function onPhotoCapture(e:CameraFeedEvent):void {
			portraitCamera.slr.removeEventListener(CameraFeedEvent.NEW_FRAME_EVENT, onPhotoCapture);
			portraitCamera.slr.removeEventListener(CameraFeedEvent.CAMERA_TIMEOUT_EVENT, onSLRTimeout);			
			
			// process SLR image
			logger.info("Got SLR Photo Event");
			CivilDebateWall.state.userImage = new Bitmap(portraitCamera.slr.image.bitmapData.clone(), PixelSnapping.AUTO, true);
			detectFace(CivilDebateWall.state.userImage);
		}
		
		private function detectFace(b:Bitmap):void {
			logger.info("Face detection started...");
			// find the face closest to the center
			// TODO find biggest face
			faceDetector.addEventListener(ObjectDetectorEvent.DETECTION_COMPLETE, onDetectionComplete);			
			faceDetector.searchBitmap(b.bitmapData);
		}
		
		private function onDetectionComplete(e:ObjectDetectorEvent):void {
			logger.info("...Face detection complete");
			
			faceDetector.removeEventListener(ObjectDetectorEvent.DETECTION_COMPLETE, onDetectionComplete);
			
			// copy of the original image, we'll write it to disk later
			CivilDebateWall.state.userImageFull = new Bitmap(CivilDebateWall.state.userImage.bitmapData.clone());
			
			if (faceDetector.faceRect != null) {
				logger.info("Cropping to face found at: " + faceDetector.faceRect);				
				
				// Scale the face detector rectangle
				var scaleFactor:Number = CivilDebateWall.state.userImage.height / faceDetector.maxSourceHeight; 
				var scaledFaceRect:Rectangle = GeomUtil.scaleRect(faceDetector.faceRect, scaleFactor);
				
				CivilDebateWall.state.userImage = Utilities.cropToFace(CivilDebateWall.state.userImage, scaledFaceRect, CivilDebateWall.settings.targetFaceRectangle);				
			}
			else {
				logger.warn("No face found, scaling to fill");
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
			CivilDebateWall.state.inactivityOverlayArmed = true;			
			
			bigButton.setOnClick(function():void {
				CivilDebateWall.state.setView(smsPromptView);			
			});							
			
			if (CivilDebateWall.state.userImage != null) {
				portrait.setImage(CivilDebateWall.state.userImage, true);
			}
			else {
				portrait.setImage(Assets.portraitPlaceholder, true);				
			}
			
			userOpinionReview.y = 1341 - 45 - userOpinionReview.height; // position changes based on height
			
			bigButton.setText("SUBMIT MY OPINION", true);
			bigButton.enable();
			bigButton.y = 1607;
			
			portrait.tweenIn();
			questionHeaderHome.tweenIn();
			userOpinionReview.tweenIn();
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
			markAllInactive();
			
			portrait.tweenIn();
			questionHeaderHome.tweenIn()			
			CivilDebateWall.state.inactivityOverlayArmed = true;
			termsAndConditionsUnderlay.tweenIn();
			termsAndConditionsText.tweenIn();
			closeTermsButton.tweenIn();
			
			tweenOutInactive();				
		}
		
		// ================================================================================================================================================		
		
		public function smsPromptView(...args):void {
			CivilDebateWall.state.inactivityOverlayArmed = true;
			markAllInactive();
			portrait.tweenIn(); // TODO, just use black?	
			smsOverlay.tweenIn();
			tweenOutInactive();	
		}

		// ================================================================================================================================================
		
		public function flagOverlayView(...args):void {
			CivilDebateWall.state.inactivityOverlayArmed = false;			
			flagOverlay.tweenIn();
		}
		
		
		// ================================================================================================================================================		

		
		public function inactivityOverlayView(...args):void {
			// tween a bunch of stuff out	
			CivilDebateWall.state.inactivityOverlayArmed = false;			
			inactivityOverlay.tweenIn();
		}
		
		
		// ================================================================================================================================================		
		
		// the camera calibration view is the only exception to the state-based view management system
		public function cameraCalibrationOverlayView(...args):void {
			CivilDebateWall.state.inactivityOverlayArmed = false;
			cameraCalibrationOverlay= new CameraCalibrationOverlay();
			addChild(cameraCalibrationOverlay);
		}
		
		public function removeCameraCalibrationOverlayView(...args):void {
			if (contains(cameraCalibrationOverlay)) {
				cameraCalibrationOverlay.close();
				removeChild(cameraCalibrationOverlay);
				cameraCalibrationOverlay = null;
			}
		}
		
		
		// =========================================================================
		
		public function statsView(...args):void {
			CivilDebateWall.state.inactivityOverlayArmed = true;			
			markAllInactive();
			
			bigBackButton.width = 770;
			bigBackButton.tweenIn();
			
			statsUnderlay.tweenIn();
			questionHeaderThread.tweenIn();			
			lowerMenuButton.tweenIn();
			statsOverlay.tweenIn();
			tweenOutInactive();
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

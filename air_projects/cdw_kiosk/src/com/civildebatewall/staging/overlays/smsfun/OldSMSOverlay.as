package com.civildebatewall.staging.overlays.smsfun
{
	import com.civildebatewall.data.TextMessage;
	import com.civildebatewall.kiosk.blocks.OldBlockBase;
	import com.civildebatewall.kiosk.blocks.PhoneHeader;
	import com.civildebatewall.kiosk.elements.WhiteButton;
	import com.kitschpatrol.futil.Math2;
	import com.kitschpatrol.futil.Random;
	import com.kitschpatrol.futil.blocks.BlockBase;
	import com.kitschpatrol.futil.blocks.BlockBitmap;
	import com.kitschpatrol.futil.blocks.BlockText;
	import com.kitschpatrol.futil.constants.Alignment;
	import com.kitschpatrol.futil.utilitites.StringUtil;
	
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.ui.Mouse;
	import flash.utils.Timer;
	
	import flashx.textLayout.formats.TextAlign;
	import com.civildebatewall.Assets;
	import com.civildebatewall.CivilDebateWall;
	
	public class OldSMSOverlay extends BlockBase	{
		
		private var skipCountdownDuration:Number = 5; // TODO move to settings?
		private var skipCountdownCounter:Number = skipCountdownDuration;
		private var skipTimer:Timer;
		private var smsCheckTimer:Timer;		
		
		private var smsUnderlay:BlockBase;
		private var smsSkipButton:WhiteButton;
		private var smsSubscribeHeader:BlockBitmap;
		private var smsPhoneHeader:PhoneHeader;
		private var smsSuccessText:BlockBitmap;
		private var smsSuccessNote:BlockBitmap;
		private var smsCountdownText:BlockText;		
		
		public function OldSMSOverlay(params:Object=null) {
			super({
				width: 1080,
				height: 1920,
				backgroundAlpha: 0
			});
			
			smsUnderlay = new BlockBase({
				width: 1080,
				height: 1920,
				backgroundColor: 0x000000,
				backgroundAlpha: 0.85
			});
			
			smsUnderlay.setDefaultTweenIn(1, {alpha: 1});
			smsUnderlay.setDefaultTweenOut(1, {alpha: 0});			
			addChild(smsUnderlay);
			
			smsSubscribeHeader = new BlockBitmap({bitmap: Assets.getSmsSubscribeHeader()});
			smsSubscribeHeader.setDefaultTweenIn(1, {x: 100, y: 982});
			smsSubscribeHeader.setDefaultTweenOut(1, {x: Alignment.OFF_STAGE_LEFT, y: 982});
			addChild(smsSubscribeHeader);
			
			smsPhoneHeader = new PhoneHeader();
			smsPhoneHeader.setDefaultTweenIn(1, {x: 100, y: 1060});
			smsPhoneHeader.setDefaultTweenOut(1, {x: Alignment.OFF_STAGE_LEFT, y: 1060});
			addChild(smsPhoneHeader);
			
			smsSuccessText = new BlockBitmap({bitmap: Assets.getSmsSuccessText()});
			smsSuccessText.setDefaultTweenIn(1, {x: 100, y: 1060});
			smsSuccessText.setDefaultTweenOut(1, {x: Alignment.OFF_STAGE_RIGHT, y: 1060});
			addChild(smsSuccessText);
			
			smsSuccessNote = new BlockBitmap({bitmap: Assets.getSmsSuccessNote()});
			smsSuccessNote.setDefaultTweenIn(1, {x: 100, y: 1261});
			smsSuccessNote.setDefaultTweenOut(1, {x: Alignment.OFF_STAGE_RIGHT, y: 1261});
			addChild(smsSuccessNote);			
			
			smsSkipButton = new WhiteButton({
				text: "SKIP",
				width: 188,
				height: 64
			});
			
			smsSkipButton.onButtonUp.push(onSkipButtonUp);
			smsSkipButton.setDefaultTweenIn(1, {x: 446, y: 1826});
			smsSkipButton.setDefaultTweenOut(1, {x: 446, y: Alignment.OFF_STAGE_BOTTOM});
			addChild(smsSkipButton);
			
			smsCountdownText = new BlockText({
				text: "Going back to Home Screen in " + skipCountdownDuration + " " + StringUtil.plural("Second", skipCountdownDuration),
				width: 1080,				
				textFont: Assets.FONT_BOLD,
				textBold: true,
				textSize: 14,
				textColor: 0xffffff,
				backgroundAlpha: 0,
				textAlignmentMode: TextAlign.CENTER,
				alignmentPoint: Alignment.CENTER
			});
			
			smsCountdownText.x = 0;
			smsCountdownText.y = 1848;
			
			smsCountdownText.setDefaultTweenIn(1, {alpha: 1});
			smsCountdownText.setDefaultTweenOut(1, {alpha: 0});
			addChild(smsCountdownText);
			
			skipTimer = new Timer(1000, skipCountdownDuration);
			skipTimer.addEventListener(TimerEvent.TIMER, onSkipTimer);
			skipTimer.addEventListener(TimerEvent.TIMER_COMPLETE, onSkipTimerComplete);
			skipTimer.stop();
		}

		// =========================================================================		
		
		
		// Views....
		override protected function beforeTweenIn():void {
			super.beforeTweenIn();
			homeView();
		}
		
		override protected function beforeTweenOut():void {
			markAllInactive();
			tweenOutInactive();
			super.beforeTweenOut();
		}		
		
		private function homeView():void {
			markAllInactive();
			
			// start polling to see if the user has sent their opinion yet
			CivilDebateWall.data.fetchLatestTextMessages(onLatestMessagesFetched);			
			
			smsUnderlay.tweenIn();
			smsSubscribeHeader.tweenIn();
			smsPhoneHeader.tweenIn();
			smsSkipButton.tweenIn();
			
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
			trace('Fetching latest SMS');
			CivilDebateWall.data.fetchLatestTextMessages(onSMSCheckResponse);
			smsCheckTimer.stop();
		}
		
		
		private function onSMSCheckResponse():void {
			// Grab a newer message
			if ((CivilDebateWall.data.latestTextMessages.length > 0) && (CivilDebateWall.data.latestTextMessages[0].created > CivilDebateWall.state.lastTextMessageTime)) {
				trace('Got new SMS!');		
				
				// TODO handle it
				handleSMS(CivilDebateWall.data.latestTextMessages[0]);
			}
			else {
				trace("No new SMS, keep trying");
				smsCheckTimer.reset();
				smsCheckTimer.start();						
			}
		}
		
		public function simulateSMS():void {
			var testTextMessage:TextMessage = new TextMessage({'message': '', 'phoneNumber': '555' + int(Random.range(1000000, 9999999).toString()), 'created': '2011-09-07 17:31:44'});			
			handleSMS(testTextMessage);
		}
		
		private function handleSMS(message:TextMessage):void {
			if (smsCheckTimer != null) {			
				smsCheckTimer.stop();			
				smsCheckTimer.removeEventListener(TimerEvent.TIMER, onSmsCheckTimer);
			}
			trace("Handling text message");
			
			successView();
		}
		
		private function successView():void {
			markAllInactive();
						
			smsUnderlay.tweenIn();
			smsSubscribeHeader.tweenIn();
			smsSuccessText.tweenIn();
			smsSuccessNote.tweenIn();
			smsCountdownText.tweenIn();
			
			tweenOutInactive();
			
			skipTimer.reset();
			skipTimer.start();
			skipCountdownCounter = skipCountdownDuration;
		}
		
		
		private function skipView():void {
			markAllInactive();
			
			smsUnderlay.tweenIn();
			smsSubscribeHeader.tweenIn();
			smsPhoneHeader.tweenIn();
			smsCountdownText.tweenIn();
			
			tweenOutInactive();
			
			skipTimer.reset();
			skipTimer.start();
			skipCountdownCounter = skipCountdownDuration;
		}
		
		
		private function onSkipButtonUp(e:MouseEvent):void {
			skipView();
		}
		
		
		private function onSkipTimer(e:TimerEvent):void {
			skipCountdownCounter--;
			smsCountdownText.text =  "Going back to Home Screen in " + skipCountdownCounter + " " + StringUtil.plural("Second", skipCountdownCounter);
		}
		
		private function onSkipTimerComplete(e:TimerEvent):void {
			trace("Skip timer complete...");
			
			// Finally give up on SMS
			if (smsCheckTimer != null) {			
				smsCheckTimer.stop();			
				
				if (smsCheckTimer.hasEventListener(TimerEvent.TIMER)) {
					smsCheckTimer.removeEventListener(TimerEvent.TIMER, onSmsCheckTimer);
				}
			}
			
			// go home
			CivilDebateWall.state.setView(CivilDebateWall.kiosk.view.homeView);
		}
		
		
		
		// Move these to block base?
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
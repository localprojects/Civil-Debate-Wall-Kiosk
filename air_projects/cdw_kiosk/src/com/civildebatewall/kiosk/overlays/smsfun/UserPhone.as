package com.civildebatewall.kiosk.overlays.smsfun {
	import com.civildebatewall.Assets;
	import com.civildebatewall.CivilDebateWall;
	import com.civildebatewall.data.Post;
	import com.greensock.TimelineMax;
	import com.greensock.TweenAlign;
	import com.greensock.TweenMax;
	import com.greensock.easing.Quart;
	import com.kitschpatrol.futil.blocks.BlockText;
	import com.kitschpatrol.futil.constants.Alignment;
	import com.kitschpatrol.futil.utilitites.GraphicsUtil;
	import com.kitschpatrol.futil.utilitites.NumberUtil;
	
	import flash.display.Shape;
	import flash.display.Sprite;
	import flash.events.Event;
	
	
	public class UserPhone extends Phone {
		
		public static var NUMBER_SUBMITTED_EVENT:String = "numberSubmittedEvent";
		
		private var instructions:BlockText;
		private var numberRequest:BlockText;
		private var numberField:BlockText;
		private var keypad:Keypad;
		private var horizontalRule:Shape;
		private var errorMessage:BlockText;
		private var successBubble:Sprite;
		private var followingBubble:Sprite;
		private var stopBubble:Sprite;	
		private var formerActiveBubble:Sprite; // pointer		
		private var invalid:Boolean;		
		public var phoneNumber:String;
		
		public function UserPhone()	{
			// temp set color
			var type:int = Phone.YES;
			CivilDebateWall.state.userStanceColorLight = Assets.COLOR_YES_LIGHT;
			CivilDebateWall.state.userStanceColorDark = Assets.COLOR_YES_DARK;				
			
			//var type:int = (CivilDebateWall.state.userStance == Post.STANCE_YES) ? YES : NO;			
			super(type);
			
			
			
			// special success bubble
			// TODO why are these backwards?
			successBubble = (!type) ? Assets.getYesSuccessBubble() : Assets.getNoSuccessBubble();
			successBubble.scaleX = 4;
			successBubble.scaleY = 4;
			successBubble.x = (screenWidth / 2) - ((successBubble.width * 4) / 2);	
			successBubble.y = screenHeight;
			screen.addChild(successBubble);			
			
			followingBubble = (!type) ? Assets.getYesFollowingBubble() : Assets.getNoFollowingBubble();
			followingBubble.scaleX = 4;
			followingBubble.scaleY = 4;
			followingBubble.x = (screenWidth / 2) - ((followingBubble.width * 4) / 2);	
			followingBubble.y = screenHeight;
			screen.addChild(followingBubble);			
			
			stopBubble = (!type) ? Assets.getYesStopBubble() : Assets.getNoStopBubble();
			stopBubble.scaleX = 4;
			stopBubble.scaleY = 4;
			stopBubble.x = (screenWidth / 2) - ((stopBubble.width * 4) / 2);	
			stopBubble.y = screenHeight;
			screen.addChild(stopBubble);						
			
			// keep active bubble out of the way
			activeBubble.y = screenHeight;
			
			instructions = new BlockText({
				width: screenWidth,
				height: screenHeight,
				padding: 30,				
				textFont: Assets.FONT_BOLD,
				textBold: true,
				textSize: 33, // TODO  auto
				leading: 16,
				textAlignmentMode: Alignment.TEXT_LEFT,	
				text: "GET REPLIES TO YOUR OPINION AND CONTINUE YOUR DEBATE VIA SMS",				
				textColor: Assets.COLOR_GRAY_85,
				backgroundAlpha: 0,
				alignmentPoint: Alignment.CENTER,
				visible:true,
				y: screenHeight
			});
			screen.addChild(instructions);
			
			numberRequest = new BlockText({
				width: screenWidth,
				padding: 30,				
				textFont: Assets.FONT_BOLD,
				textBold: true,
				textSize: 24, // TODO  auto
				leading: 16,
				textAlignmentMode: Alignment.TEXT_CENTER,	
				text: "PLEASE ENTER YOUR PHONE NUMBER",				
				textColor: Assets.COLOR_GRAY_85,
				backgroundAlpha: 0,
				alignmentPoint: Alignment.CENTER,
				visible:true,
				y: screenHeight
			});
			screen.addChild(numberRequest);				

			errorMessage = new BlockText({
				width: screenWidth - 60,
				height: 64,
				textFont: Assets.FONT_BOLD,
				textBold: true,
				textSize: 16,
				leading: 64,
				letterSpacing: -1,	
				textAlignmentMode: Alignment.TEXT_CENTER,	
				text: "INVALID NUMBER",				
				textColor: 0xffffff,
				backgroundColor: Assets.COLOR_RED_SELECTION,
				alignmentPoint: Alignment.CENTER,
				visible:true,
				x: screenWidth,
				y: 210
			});
			screen.addChild(errorMessage);
			
			horizontalRule = new Shape();
			GraphicsUtil.fillRect(horizontalRule.graphics, screenWidth, 3, CivilDebateWall.state.userStanceColorLight);
			horizontalRule.y = numberRequest.height;
			horizontalRule.alpha = 0;
			screen.addChild(horizontalRule);
			
			numberField = new BlockText({
				width: screenWidth,
				padding: 30,				
				textFont: Assets.FONT_BOLD,
				textBold: true,
				textSize: 24, // TODO  auto
				leading: 24,				
				textAlignmentMode: Alignment.TEXT_CENTER,		
				textAlignmentMode: Alignment.TEXT_CENTER,	
				backgroundAlpha: 0,
				textColor: Assets.COLOR_GRAY_85,
				visible: true,
				text: "",				
				y: numberRequest.height
			});
			
			screen.addChild(numberField);
			
	
			keypad = new Keypad();
			keypad.y = screenHeight;
			keypad.x = -3; // compensate for border width
			keypad.addEventListener(NumberKey.KEY_PRESSED_EVENT, onKeyPressed);
			screen.addChild(keypad);
			
			// flip these? why?Screen Mimic TODO
			var temp:Sprite = activeBubble;
			activeBubble = inactiveBubble;
			inactiveBubble = temp;			
			
		}
		
		
		public function showKeypad():void {
			// show instructions
			TweenMax.to(instructions, 0.5, {y: 0});
			TweenMax.to(instructions, 0.5, {y: -screenHeight, delay: 4});	
			TweenMax.to(numberRequest, 0.5, {y: (screenHeight / 2) - (numberRequest.height / 2), delay: 4});
			TweenMax.to(numberRequest, 0.5, {y: 0, delay: 6});
			TweenMax.to(keypad, 0.5, {y: (screenHeight - keypad.height) + 3, delay: 6});
			TweenMax.to(horizontalRule, 0.5, {alpha: 1, delay: 6.5});		
		}
		
		public function clearKeypad():void {
			TweenMax.to(keypad, 0.5, {y: screenHeight});
			TweenMax.to(horizontalRule, 0.5, {alpha: 0});
			TweenMax.to(numberRequest, 0.5, {y: -numberRequest.height});
			TweenMax.to(numberField, 0.5, {alpha: 0});			
		}		

		private function onKeyPressed(e:Event):void {
			var key:String = e.target.text;			
						
			if (key == "SUBMIT") {
				// check for validity
				if (isValid(numberField.text)) {
					onSubmit();
				}
				else {
					onSubmitInvalid();
				}
			}
			else {
				numberField.lockUpdates = true;				
				
				// clear the error message
				if (invalid) {
					TweenMax.to(errorMessage, 0.5, {x: -errorMessage.width});
					invalid = false;
				}
			
				if (key == "BACK") {
					numberField.text = numberField.text.substring(0, numberField.text.length - 1);
				}
				else {
					if (numberField.text.length <= 13) {
						numberField.text += key;
					}
				}
				
				numberField.lockUpdates = false;	
				numberField.text = NumberUtil.formatDynamicPhoneNumber(numberField.text);				
			}
		}	
		
		public function isValid(number:String):Boolean {
			// TODO some more serious validation...
			// for now just make sure it's the right length
			var bareNumber:String = number.replace(/[^\d]/gs, '');
			return (bareNumber.length == 10);
		}
				
		
		public function onSubmit():void {
			// TODO save to DB

			clearKeypad();

			// play the bubble sequence
			var timeline:TimelineMax = new TimelineMax({onComplete: onBubbleSequenceComplete});
			timeline.append(new TweenMax(successBubble, .5, {y: centerY, ease: Quart.easeInOut}));
			timeline.appendMultiple([
				new TweenMax(successBubble, .25, {y: -successBubble.height, ease: Quart.easeInOut}),
				new TweenMax(followingBubble, .25, {y: centerY, ease: Quart.easeInOut}),	
			], 1, TweenAlign.START);
			timeline.appendMultiple([
				new TweenMax(followingBubble, .25, {y: -successBubble.height, ease: Quart.easeInOut}),
				new TweenMax(stopBubble, .25, {y: centerY, ease: Quart.easeInOut}),	
			], 2.5, TweenAlign.START);			
			timeline.append(new TweenMax(stopBubble, 2.75, {})); // pause for three seconds before continuing
			
			formerActiveBubble = activeBubble;			
			activeBubble = stopBubble; // mark it for removal on the next pop
		}
		
		public function onBubbleSequenceComplete():void {
									
			// keep the animation going

			phoneNumber = numberField.text.replace(/[^\d]/g, "");

			
			dispatchEvent(new Event(NUMBER_SUBMITTED_EVENT));
			
			
		}
		
		
		
		
		private function onSubmitInvalid():void {
			TweenMax.fromTo(errorMessage, 0.5, {x: screenWidth}, {x: 30});
			invalid = true;
		}
		
		// in case the user hits the skip button...
		public function onSkip():void {
			clearKeypad();
		}		
		
		override public function popMessage():void {
			super.popMessage();
			
			// restore the normal bubble cycle if we submitted			
			if (formerActiveBubble != null) {
				inactiveBubble = formerActiveBubble;
				formerActiveBubble = null;
			}			
		}
		
	}
}
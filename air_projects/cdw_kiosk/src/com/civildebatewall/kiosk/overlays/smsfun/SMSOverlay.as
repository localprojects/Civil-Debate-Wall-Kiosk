package com.civildebatewall.kiosk.overlays.smsfun {
	
	
	import com.civildebatewall.Assets;
	import com.civildebatewall.CivilDebateWall;
	import com.civildebatewall.kiosk.buttons.WhiteButton;
	import com.civildebatewall.kiosk.legacy.OldBlockBase;
	import com.greensock.TimelineMax;
	import com.greensock.TweenAlign;
	import com.greensock.TweenMax;
	import com.greensock.easing.Linear;
	import com.greensock.easing.Quart;
	import com.kitschpatrol.futil.blocks.BlockBase;
	import com.kitschpatrol.futil.blocks.BlockText;
	import com.kitschpatrol.futil.constants.Alignment;
	import com.kitschpatrol.futil.drawing.Path;
	import com.kitschpatrol.futil.utilitites.GraphicsUtil;
	import com.kitschpatrol.futil.utilitites.StringUtil;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.events.TimerEvent;
	import flash.geom.Point;
	
	public class SMSOverlay extends BlockBase	{		
		
		private var smsUnderlay:BlockBase;
		private var smsSkipButton:WhiteButton;

		private var connections:Connection; // holds the dashed line
		private var phones:Vector.<Phone>; 		
		private var userPhone:UserPhone;		
		private var northPhone:Phone; // just above the user, needs to fade out?
		private var distanceThreshold:Number = 30; // when to fire a phone when the dashed line moves past
		private var phoneGrid:Sprite; // contains phones (so skip button doesn't zoom out of view)
		private var timeline:TimelineMax;
		
		public function SMSOverlay(params:Object=null) {
			super({
				width: 1080,
				height: 1920,
				backgroundAlpha: 0
			});
			
			// TODO really needed?
			smsUnderlay = new BlockBase({
				width: 1080,
				height: 1920,
				backgroundColor: 0x000000
			});
			
			smsUnderlay.setDefaultTweenIn(1, {alpha: 1});
			smsUnderlay.setDefaultTweenOut(1, {alpha: 0});			
			addChild(smsUnderlay);
			
			// happy fun visualization
			phoneGrid = new Sprite();
			GraphicsUtil.fillRect(phoneGrid.graphics, width, height, 0, 0);
			addChild(phoneGrid);
			
			// add the skip button (over the visualization)
			smsSkipButton = new WhiteButton({
				text: "SKIP",
				width: 188,
				height: 64
			});
			
			smsSkipButton.onButtonUp.push(onSkipButtonUp);
			smsSkipButton.setDefaultTweenIn(1, {x: 446, y: 1826});
			smsSkipButton.setDefaultTweenOut(1, {x: 446, y: Alignment.OFF_STAGE_BOTTOM});
			addChild(smsSkipButton);			
		}
		
		private function init():void {
			
			// TODO set color?

			GraphicsUtil.removeChildren(phoneGrid);
			
			connections = new Connection();
			phones = new Vector.<Phone>(0);			
			
			// build the grid
			var gridCols:int = 3;
			var gridRows:int = 5;

			var cellWidth:int = 158;
			var cellHeight:int = 298; // - 20; // pad it a bit
			
			var gridStepX:Number = (cellWidth) + ((width - (cellWidth * gridCols)) / (gridCols + 1));
			var gridStepY:Number = (cellHeight) + ((height - (cellHeight * gridRows)) / (gridRows + 1));	
			
			var gridYOffset:Number = 0; //-55; // zoomed in phone is not perfectly centered... but no need since the skip button disappears?
			var centerPoint:Point;
			
			for (var y:Number = 0; y < gridRows; y++) {
				for (var x:Number = 0; x < gridCols; x++) {
					// fill the grid with phones (center is special);					
					var tempPhone:*;
					
					if ((y == Math.floor(gridRows / 2)) && (x == Math.floor(gridCols / 2))) {
						// center
						tempPhone = new UserPhone();
						userPhone = tempPhone;
					}
					else {
						// other
						tempPhone = new Phone(phones.length % 2);
						
						if (y == (Math.floor(gridRows / 2) - 1) && (x == Math.floor(gridCols / 2))) {
							// north phone, just above user center
							northPhone = tempPhone;
						}
						
					}
					
					tempPhone.position = new Point(((x + 1) * gridStepX) - (cellWidth / 2), ((y + 1) * gridStepY) - (cellHeight / 2) + gridYOffset);
					tempPhone.scaleX = 0;
					tempPhone.scaleY = 0;
					phoneGrid.addChild(tempPhone);
					phones.push(tempPhone); 
				}
			}
			
			// curve settings
			var curveOvershoot:Number = 70; // how far past the end of the phone row to go
			var curveRadius:Number = 90;	
			
			// describe dashed line path
			connections.path.moveTo(0, phones[0].position.y);
			connections.path.lineToPoint(phones[2].position);
			turnRight(connections.path, phones[2].position, phones[5].position, curveOvershoot, curveRadius);	
			connections.path.lineToPoint(phones[3].position);
			turnLeft(connections.path, phones[3].position, phones[6].position, curveOvershoot, curveRadius);
			connections.path.lineToPoint(phones[8].position);
			turnRight(connections.path, phones[8].position, phones[11].position, curveOvershoot, curveRadius);				
			connections.path.lineToPoint(phones[9].position);
			turnLeft(connections.path, phones[9].position, phones[12].position, curveOvershoot, curveRadius);			
			connections.path.lineTo(width, phones[14].position.y);			
			
			connections.visible = false;
			
			phoneGrid.addChildAt(connections, 0); // lines go below phones

			
			// animation
			timeline = new TimelineMax({onComplete: onTimelineComplete});			
			timeline.append(new TweenMax(connections, 4.5, {step: 0.5, ease: Linear.easeNone, delay: 0}));
			
			
			timeline.appendMultiple([
				new TweenMax(northPhone, 1, {alpha: 0, ease: Quart.easeInOut}),
				new TweenMax(phoneGrid, 1.5, {transformAroundPoint: {point: new Point(userPhone.position.x, userPhone.position.y - 30), scale: 4}, ease: Quart.easeInOut})				
			], -.25, TweenAlign.START);
			
			timeline.addLabel("userPhonePause", timeline.duration);
			
			timeline.appendMultiple([
				new TweenMax(northPhone, 0.5, {alpha: 1, ease: Quart.easeInOut}),										
				new TweenMax(phoneGrid, 1.5, {transformAroundPoint:{point: userPhone.position, scale: 1}, ease: Quart.easeInOut})
			], 0, TweenAlign.START);
			

			timeline.append(new TweenMax(connections, 4.5, {step: 1, ease: Linear.easeNone, delay: -.5}));						
			
			var phoneTweens:Array = new Array();
			for (var i:int = 0; i < phones.length; i++) {
				phoneTweens.push(new TweenMax(phones[i], 0.5, {scaleX: 0, scaleY: 0}));
			}
			
			timeline.append(new TweenMax(connections, 0.5, {alpha: 0}), .5);
			timeline.appendMultiple(phoneTweens, -0.5, TweenAlign.START, 0);

			timeline.stop();		
			
			userPhone.addEventListener(UserPhone.NUMBER_SUBMITTED_EVENT, onNumberSubmitted);
		}
		
		
		

		// Views....
		override protected function beforeTweenIn():void {
			super.beforeTweenIn();
			addEventListener(Event.ENTER_FRAME, onEnterFrame);			
			homeView();
		}
		
		override protected function beforeTweenOut():void {
			
			
			
			
			markAllInactive();
			tweenOutInactive();
			removeEventListener(Event.ENTER_FRAME, onEnterFrame);
			
			if ((userPhone != null) && userPhone.hasEventListener(UserPhone.NUMBER_SUBMITTED_EVENT)) {
				userPhone.removeEventListener(UserPhone.NUMBER_SUBMITTED_EVENT, onNumberSubmitted);
			}
			super.beforeTweenOut();
		}	
		
		override protected  function afterTweenIn():void {
			connections.visible = true;
			timeline.tweenFromTo(0, "userPhonePause");			
		}
		
		
		private function homeView():void {
			init();
			
			markAllInactive();
			smsUnderlay.tweenIn();
			smsSkipButton.tweenIn();
			tweenOutInactive();
		}
		
		private function onTestButton(e:MouseEvent):void {
			connections.visible = true;
			//timeline.goto("userPhonePause");
			//timeline.tweenFromTo(0, "userPhonePause");
			timeline.tweenFromTo(0, "userPhonePause");
			//timeline.play();
		}
		
		private function onNumberSubmitted(e:Event):void {
			// finish animation
			
			trace("save and submit");
			trace("User phone: " + userPhone.phoneNumber);			
			
			CivilDebateWall.state.userPhoneNumber = userPhone.phoneNumber;
			
			
			smsSkipButton.tweenOut();
			timeline.tweenFromTo("userPhonePause", timeline.duration);			
		}
		

		private function skippedPhone():void {
			// skip the rest of the animation
			timeline.tweenFromTo("userPhonePause", timeline.duration);
			//CivilDebateWall.state.setView(CivilDebateWall.kiosk.view.homeView);
			
			CivilDebateWall.state.userPhoneNumber = null;		
		}
		
		
		private function submitPost():void {
			
			CivilDebateWall.data.submitDebate();
			// create user
			
			
			// save image
			
			// save DB
			
			// reload data
			
			// go home
			//CivilDebateWall.state.setView(CivilDebateWall.kiosk.view.homeView);			
			
		}
		
		
		
		private function onSkipButtonUp(e:MouseEvent):void {
			skippedPhone();
		}
		
		private function onTimelineComplete():void {
			submitPost();
		}
		

		private function onEnterFrame(e:Event):void {
			// phones tweening in is triggered by proximity to the dashed line's pen
			for (var i:int = 0; i < phones.length; i++) {
				if (!phones[i].popped && (Point.distance(phones[i].position, connections.penPosition) < distanceThreshold)) {
					
					// pop everyone else's message bubble
					for (var j:int = 0; j < phones.length; j++) {
						if (phones[j].popped) {
							phones[j].popMessage();
						}
					}
					
					// bring in the phone
					TweenMax.to(phones[i], 0.5, {scaleX: .25, scaleY: .25});
					phones[i].popped = true;
					
					if (phones[i] == userPhone) userPhone.showKeypad();					
					
					break;
				}
			}
		}			
		
		
		// helper for turning between rows
		private function turnRight(targetPath:Path, start:Point, end:Point, curveOvershoot:Number, curveRadius:Number):void {
			targetPath.lineTo(start.x + curveOvershoot, start.y);
			targetPath.curveTo(start.x + curveOvershoot + curveRadius, start.y, start.x + curveOvershoot + curveRadius, start.y + curveRadius);
			targetPath.lineTo(end.x + curveOvershoot + curveRadius, end.y - curveRadius);
			targetPath.curveTo(end.x + curveOvershoot + curveRadius, end.y, end.x + curveOvershoot, end.y);			
		}
		
		private function turnLeft(targetPath:Path, start:Point, end:Point, curveOvershoot:Number, curveRadius:Number):void {
			targetPath.lineTo(start.x - curveOvershoot, start.y);
			targetPath.curveTo(start.x - curveOvershoot - curveRadius, start.y, start.x - curveOvershoot - curveRadius, start.y + curveRadius);
			targetPath.lineTo(end.x - curveOvershoot - curveRadius, end.y - curveRadius);
			targetPath.curveTo(end.x - curveOvershoot - curveRadius, end.y, end.x - curveOvershoot, end.y);			
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
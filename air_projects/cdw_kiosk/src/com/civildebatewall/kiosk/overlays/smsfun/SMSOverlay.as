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

package com.civildebatewall.kiosk.overlays.smsfun {
	
	import com.civildebatewall.Assets;
	import com.civildebatewall.CivilDebateWall;
	import com.civildebatewall.data.containers.Post;
	import com.civildebatewall.kiosk.buttons.WhiteButton;
	import com.civildebatewall.kiosk.overlays.smsfun.Phone;
	import com.greensock.TimelineMax;
	import com.greensock.TweenAlign;
	import com.greensock.TweenMax;
	import com.greensock.easing.Linear;
	import com.greensock.easing.Quart;
	import com.kitschpatrol.futil.blocks.BlockBase;
	import com.kitschpatrol.futil.constants.Alignment;
	import com.kitschpatrol.futil.drawing.Path;
	import com.kitschpatrol.futil.utilitites.GraphicsUtil;
	
	import flash.display.Sprite;
	import flash.events.Event;
	import flash.events.MouseEvent;
	import flash.geom.Point;
	
	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.getLogger;
	
	public class SMSOverlay extends BlockBase	{		

		private static const logger:ILogger = getLogger(SMSOverlay);
		
		private var smsUnderlay:BlockBase;
		private var smsSkipButton:WhiteButton;

		private var connections:Connection; // holds the dashed line
		private var phones:Vector.<Phone>; 		
		private var userPhone:UserPhone;		
		private var northPhone:Phone; // just above the user, needs to fade out?
		private var distanceThreshold:Number = 60; // when to fire a phone when the dashed line moves past
		private var phoneGrid:Sprite; // contains phones (so skip button doesn't zoom out of view)
		private var timeline:TimelineMax;
		
		public function SMSOverlay(params:Object = null) {
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
			
			smsSkipButton.onStageUp.push(onSkipButtonUp);
			smsSkipButton.setDefaultTweenIn(1, {x: 446, y: 1826});
			smsSkipButton.setDefaultTweenOut(1, {x: 446, y: Alignment.OFF_STAGE_BOTTOM});
			addChild(smsSkipButton);
		}
		
		
		// Helper for grid creation, flips phone type back and forth based on starting type
		private var startingPhoneType:int;
		
		private function get alternatingPhoneType():int {
			startingPhoneType = (startingPhoneType + 1) % 2;
			return startingPhoneType;
		}
		
		

		
		private const cellWidth:int = 158;
		private const cellHeight:int = 298;
		private const cols:int = 3;
		private const rows:int = 5;
		private const stepX:int = cellWidth + ((1080 - (cellWidth * cols)) / (cols + 1)); // round this for crisp pixels
		private const stepY:int = cellHeight + ((1920 - (cellHeight * rows)) / (rows + 1)); // round this for crisp pixels		
		
		private function gridToPoint(col:int, row:int):Point {
			return new Point((col * stepX) - (cellWidth / 2), (row * stepY) - (cellHeight / 2));
		}
		
		private function init():void {
			GraphicsUtil.removeChildren(phoneGrid);
			
			
			
			connections = new Connection();
			phones = new Vector.<Phone>(0);			
			
			startingPhoneType = (CivilDebateWall.state.userStance == Post.STANCE_YES) ? Phone.YES : Phone.NO;
			
			// a "Z" pattern
			phones.push(phoneGrid.addChild(new Phone(alternatingPhoneType).setPosition(gridToPoint(1, 1)).setScale(0)));
			phones.push(phoneGrid.addChild(new Phone(alternatingPhoneType).setPosition(gridToPoint(2, 1)).setScale(0)));
			northPhone = phones[phones.push(phoneGrid.addChild(new Phone(alternatingPhoneType).setPosition(gridToPoint(2, 2)).setScale(0))) - 1]; // North phone (needs to fade on zoom)
			userPhone = phones[phones.push(phoneGrid.addChild(new UserPhone(alternatingPhoneType).setPosition(gridToPoint(2, 3)).setScale(0))) - 1] as UserPhone; // User phone
			phones.push(phoneGrid.addChild(new Phone(alternatingPhoneType).setPosition(gridToPoint(2, 4)).setScale(0)));
			phones.push(phoneGrid.addChild(new Phone(alternatingPhoneType).setPosition(gridToPoint(2, 5)).setScale(0)));
			phones.push(phoneGrid.addChild(new Phone(alternatingPhoneType).setPosition(gridToPoint(3, 5)).setScale(0)));
			
			// curve settings
			var curveOvershoot:Number = 120; // how far past the end of the phone row to go
			var curveRadius:Number = 90;	
			
			var evenColorA:uint = (CivilDebateWall.state.userStance == Post.STANCE_YES) ? Assets.COLOR_NO_LIGHT : Assets.COLOR_YES_LIGHT;
			var evenColorB:uint = (CivilDebateWall.state.userStance == Post.STANCE_YES) ? Assets.COLOR_NO_DARK : Assets.COLOR_YES_DARK;
			var oddColorA:uint  = (CivilDebateWall.state.userStance == Post.STANCE_YES) ? Assets.COLOR_YES_LIGHT : Assets.COLOR_NO_LIGHT;
			var oddColorB:uint  = (CivilDebateWall.state.userStance == Post.STANCE_YES) ? Assets.COLOR_YES_DARK : Assets.COLOR_NO_DARK;
			
			
			// describe dashed line path
			connections.setColors(oddColorA, oddColorB);
			connections.path.moveTo(0, phones[0].position.y);
			connections.path.lineToPoint(phones[0].position);
			
			connections.setColors(evenColorA, evenColorB);
			connections.path.lineToPoint(phones[1].position);			
			
			connections.setColors(oddColorA, oddColorB);
			turnRight(connections.path, phones[1].position, phones[2].position, curveOvershoot, curveRadius);
			connections.path.lineToPoint(phones[2].position);
			
			connections.setColors(evenColorA, evenColorB);			
			turnLeft(connections.path, phones[2].position, phones[3].position, curveOvershoot, curveRadius);
			connections.path.lineToPoint(phones[3].position);
			
			connections.setColors(oddColorA, oddColorB);
			turnRight(connections.path, phones[3].position, phones[4].position, curveOvershoot, curveRadius);
			connections.path.lineToPoint(phones[4].position);
			
			connections.setColors(evenColorA, evenColorB);		
			turnLeft(connections.path, phones[4].position, phones[5].position, curveOvershoot, curveRadius);
			connections.path.lineToPoint(phones[5].position);
			
			connections.setColors(oddColorA, oddColorB);			
			connections.path.lineTo(width, phones[6].position.y);			
			
			connections.visible = false;
			phoneGrid.addChildAt(connections, 0); // lines go below phones
			
			// animation
			timeline = new TimelineMax({onComplete: submitPost, onReverseComplete: submitPost});			
			timeline.append(new TweenMax(connections, 3.5, {step: 0.49285714285714327, ease: Linear.easeNone, delay: 0})); // 0.49285714285714327 derrived from looking at the connections step when the user phone pops 
			
			timeline.appendMultiple([
				new TweenMax(northPhone, 1, {alpha: 0, ease: Quart.easeInOut}),
				new TweenMax(phoneGrid, 1.5, {transformAroundPoint: {point: new Point(userPhone.position.x, userPhone.position.y - 30), scale: 4}, ease: Quart.easeInOut})				
			], -.25, TweenAlign.START);
			
			timeline.addLabel("userPhonePause", timeline.duration);
			
			timeline.appendMultiple([
				new TweenMax(northPhone, 0.5, {alpha: 1, ease: Quart.easeInOut}),										
				new TweenMax(phoneGrid, 1.5, {transformAroundPoint:{point: userPhone.position, scale: 1}, ease: Quart.easeInOut})
			], 0, TweenAlign.START);
			
			timeline.append(new TweenMax(connections, 3.5, {step: 1, ease: Linear.easeNone, delay: -.5}));						
			
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
			logger.info("Save and submitting phone number " + userPhone.phoneNumber);
			
			CivilDebateWall.state.userPhoneNumber = userPhone.phoneNumber;			
			
			smsSkipButton.tweenOut();
			timeline.tweenFromTo("userPhonePause", timeline.duration);			
		}

		private function skippedPhone():void {
			smsSkipButton.tweenOut();
			
			logger.info("Skipped phone number entry");
			// roll back the animation
			// unpop
			//for each (var phone:Phone in phones) phone.popped = false;
			
			TweenMax.killTweensOf(timeline);
			timeline.stop();
			timeline.pause();
			timeline = new TimelineMax({onComplete: submitPost});
			
			var phoneTweens:Array = new Array();
			for (var i:int = 0; i < phones.length; i++) {
				phoneTweens.push(new TweenMax(phones[i], 1, {scaleX: 0, scaleY: 0, ease: Quart.easeOut}));
			}
			
			// zoomed in?
			var delay:Number = 0;
			if (phoneGrid.scaleX != 1) {
				timeline.insert(new TweenMax(phoneGrid, 1, {transformAroundPoint:{point: userPhone.position, scale: 1}, ease: Quart.easeInOut})); // zoom out
				delay = 1;
			}

			timeline.insert(new TweenMax(connections, 1.5, {alpha: 0}), delay);	// fade lines
			timeline.insertMultiple(phoneTweens, delay, TweenAlign.START); // shrink phones
			timeline.goto(0);
			timeline.play();
			
			// zoom out, fade everything out
//			timeline.pause();
//			timeline.reverse();
//			TweenMax.to(timeline, 1, {timeScale: 5});
//			CivilDebateWall.state.userPhoneNumber = null;
			// fires submit post once it's finished
		}

		private function submitPost():void {
			CivilDebateWall.data.submitDebate();
		}
		
		private function onSkipButtonUp(e:MouseEvent):void {
			skippedPhone();
		}
		
		private function onEnterFrame(e:Event):void {
			// phones tweening in is triggered by proximity to the dashed line's pen
			for (var i:int = 0; i < phones.length; i++) {
				if (!phones[i].popped && (Point.distance(phones[i].position, connections.penPosition) < distanceThreshold)) {

					// see which step we are on, useful for setting up the timeline for the connections
					logger.debug("Pop Step: " + connections.step);					
					
					// pop everyone else's message bubble
					for (var j:int = 0; j < phones.length; j++) {
						if (phones[j].popped) {
							phones[j].popMessage();
						}
					}
					
					// phones in and out
					if (timeline != null) {
						if (!timeline.reversed) {
							// tweening forward, bring in the phone						
							TweenMax.to(phones[i], 0.5, {scaleX: .25, scaleY: .25});
							phones[i].popped = true;						
							if (phones[i] == userPhone) userPhone.showKeypad();						
						}
						else {
							// tweening backward (canceled), send out the phone
							if (phones[i] == userPhone) userPhone.clearKeypad();												
							TweenMax.to(phones[i], 0.5, {scaleX: 0, scaleY: 0, alpha: 0});
						}
					}
					
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
				if (this.getChildAt(i) is BlockBase) {				
					(this.getChildAt(i) as BlockBase).active = false;
				}
			}
		}
		
		private function tweenOutInactive(instant:Boolean = false):void {	
			// Run on the new block base too, this is ugly...
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

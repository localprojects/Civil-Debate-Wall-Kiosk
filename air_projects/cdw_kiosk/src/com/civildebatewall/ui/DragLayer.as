package com.civildebatewall.ui {
	
	import com.civildebatewall.*;
	import com.civildebatewall.kiosk.blocks.BlockBase;
	import com.greensock.TweenMax;
	import com.kitschpatrol.futil.Math2;
	import com.kitschpatrol.futil.utilitites.ArrayUtil;
	
	import fl.motion.Color;
	
	import flash.events.*;

	
	public class DragLayer extends BlockBase {
		private var mouseDown:Boolean;		
		private var startX:int;
		private var lastX:int;
		private var currentX:int;
		private var difference:int;
		private var leftEdge:int;		
		
		public function DragLayer()	{
			super();
			init();
			
		}
		
		// velocity based push-over
		
		private function init():void {
			graphics.beginFill(0x000000, 0);
			graphics.drawRect(0, 0, 1080, 1920);
			graphics.endFill();
			
			this.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			//this.addEventListener(TouchEvent.TOUCH_BEGIN, onMouseDown);			
			this.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			this.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			mouseDown = false;
			
			vxSampleDepth = 2;
			vxThreshold = 20;
		}
		

		private function onMouseDown(e:MouseEvent):void {
			
			//if(!TweenMax.isTweening(CDW.view.nametag)) {
			
			mouseDown = true;
			vxSamples = new Array(); // clear the history
			
			// refactor startX based on tween progress, for portrait and other things
			startX = this.mouseX - (CivilDebateWall.kiosk.view.nametag.x - CivilDebateWall.kiosk.view.nametag.defaultTweenInVars.x);
			currentX = startX;
			leftEdge = 0;			
			
			// Stop tweens
			// TweenMax.killAll();
			TweenMax.killTweensOf(CivilDebateWall.kiosk.view.nametag);
			TweenMax.killTweensOf(CivilDebateWall.kiosk.view.leftNametag);
			TweenMax.killTweensOf(CivilDebateWall.kiosk.view.rightNametag);			
			TweenMax.killTweensOf(CivilDebateWall.kiosk.view.opinion);
			TweenMax.killTweensOf(CivilDebateWall.kiosk.view.leftOpinion);
			TweenMax.killTweensOf(CivilDebateWall.kiosk.view.rightOpinion);			
			TweenMax.killChildTweensOf(CivilDebateWall.kiosk.view.portrait);
			
			this.addEventListener(Event.ENTER_FRAME, onEnterFrame);
			//}

			
		}
		
		
		
		private var vxSamples:Array;
		private var vxSampleDepth:int;
		private var vxThreshold:Number; // velocity required until a flick is a transition
		
		
		private function onEnterFrame(e:Event):void {
			lastX = currentX;
			currentX = this.mouseX;
			leftEdge += currentX - lastX;
			difference =  startX - currentX;							
			
			// track velocity
			vxSamples.unshift(currentX - lastX);
			
			while (vxSamples.length > vxSampleDepth) {
				vxSamples.pop();
			}
			

						
		}
		
		private function onMouseMove(e:Event):void {
			if (mouseDown) {
				
				// edge limits
				if ((leftEdge < 0) && (CivilDebateWall.state.nextThread == null)) {
					leftEdge = 0;
					difference = 0;
				}
				else if ((leftEdge > 0) && (CivilDebateWall.state.previousThread == null)) {
					leftEdge = 0;
					difference = 0;
				}
				
				trace("leftEdge: " + leftEdge + " difference: " + difference);
				
				
				difference = Math2.clamp(difference, -stage.stageWidth, stage.stageWidth);
				leftEdge = Math2.clamp(leftEdge, -stage.stageWidth, stage.stageWidth);				
				
				
				
				var amount:Number = Math2.map(Math.abs(leftEdge), 0, stage.stageWidth, 0, 1);
				
				// drag blocks
				CivilDebateWall.kiosk.view.nametag.x = CivilDebateWall.kiosk.view.nametag.defaultTweenInVars.x - difference;

				
				CivilDebateWall.kiosk.view.opinion.x = CivilDebateWall.kiosk.view.opinion.defaultTweenInVars.x - difference;
				CivilDebateWall.kiosk.view.leftOpinion.x = CivilDebateWall.kiosk.view.leftOpinion.defaultTweenInVars.x - difference;
				CivilDebateWall.kiosk.view.rightOpinion.x = CivilDebateWall.kiosk.view.rightOpinion.defaultTweenInVars.x - difference;
				

				
				CivilDebateWall.kiosk.view.leftNametag.x = CivilDebateWall.kiosk.view.leftNametag.defaultTweenInVars.x - difference;
				CivilDebateWall.kiosk.view.nametag.x = CivilDebateWall.kiosk.view.nametag.defaultTweenInVars.x - difference;
				CivilDebateWall.kiosk.view.rightNametag.x = CivilDebateWall.kiosk.view.rightNametag.defaultTweenInVars.x - difference;					
				
				
				// TODO tween debate overlay
				
				
				// TODO tween label text?				
				

				if (leftEdge < 0) {
					// going to next
					CivilDebateWall.kiosk.view.portrait.setIntermediateImage(CivilDebateWall.state.nextThread.firstPost.user.photo, Math2.mapClamp(Math.abs(leftEdge), 0, stage.stageWidth, 0, 1));
					
					// No tween if no change!
					if (CivilDebateWall.state.nextThread.firstPost.stance != CivilDebateWall.state.activeThread.firstPost.stance) {


						CivilDebateWall.kiosk.view.flagButton.setBackgroundColor(Color.interpolateColor(CivilDebateWall.state.activeThread.firstPost.stanceColorDark, CivilDebateWall.state.nextThread.firstPost.stanceColorDark, amount), true);
						
						CivilDebateWall.kiosk.view.likeButton.setBackgroundColor(Color.interpolateColor(CivilDebateWall.state.activeThread.firstPost.stanceColorDark, CivilDebateWall.state.nextThread.firstPost.stanceColorDark, amount), true);					
						CivilDebateWall.kiosk.view.viewDebateButton.setBackgroundColor(Color.interpolateColor(CivilDebateWall.state.activeThread.firstPost.stanceColorDark, CivilDebateWall.state.nextThread.firstPost.stanceColorDark, amount), true);
						
//						CDW.view.leftQuote.setColor(Utilities.interpolateColorThroughWhite(CDW.state.activeThread.firstPost.stanceColorLight, CDW.state.nextThread.firstPost.stanceColorLight, amount), true);
//						CDW.view.rightQuote.setColor(Utilities.interpolateColorThroughWhite(CDW.state.activeThread.firstPost.stanceColorLight, CDW.state.nextThread.firstPost.stanceColorLight, amount), true);
//						CDW.view.flagButton.setBackgroundColor(Utilities.interpolateColorThroughWhite(CDW.state.activeThread.firstPost.stanceColorDark, CDW.state.nextThread.firstPost.stanceColorDark, amount), true);
//						CDW.view.statsButton.setBackgroundColor(Utilities.interpolateColorThroughWhite(CDW.state.activeThread.firstPost.stanceColorDark, CDW.state.nextThread.firstPost.stanceColorDark, amount), true);
//						CDW.view.likeButton.setBackgroundColor(Utilities.interpolateColorThroughWhite(CDW.state.activeThread.firstPost.stanceColorDark, CDW.state.nextThread.firstPost.stanceColorDark, amount), true);					
//						CDW.view.viewDebateButton.setBackgroundColor(Utilities.interpolateColorThroughWhite(CDW.state.activeThread.firstPost.stanceColorDark, CDW.state.nextThread.firstPost.stanceColorDark, amount), true);
//						CDW.view.debateButton.setBackgroundColor(Utilities.interpolateColorThroughWhite(CDW.state.activeThread.firstPost.stanceColorDark, CDW.state.nextThread.firstPost.stanceColorDark, amount), true);
					}
					
				}
				else if (leftEdge > 0) {
					// going to previous
					CivilDebateWall.kiosk.view.portrait.setIntermediateImage(CivilDebateWall.state.previousThread.firstPost.user.photo, Math2.mapClamp(Math.abs(leftEdge), 0, stage.stageWidth, 0, 1));
					
					if (CivilDebateWall.state.previousThread.firstPost.stance != CivilDebateWall.state.previousThread.firstPost.stance) { 						

						CivilDebateWall.kiosk.view.flagButton.setBackgroundColor(Color.interpolateColor(CivilDebateWall.state.activeThread.firstPost.stanceColorDark, CivilDebateWall.state.previousThread.firstPost.stanceColorDark, amount), true);
						
						CivilDebateWall.kiosk.view.likeButton.setBackgroundColor(Color.interpolateColor(CivilDebateWall.state.activeThread.firstPost.stanceColorDark, CivilDebateWall.state.previousThread.firstPost.stanceColorDark, amount), true);					
						CivilDebateWall.kiosk.view.viewDebateButton.setBackgroundColor(Color.interpolateColor(CivilDebateWall.state.activeThread.firstPost.stanceColorDark, CivilDebateWall.state.previousThread.firstPost.stanceColorDark, amount), true);
						
//						CDW.view.leftQuote.setColor(Utilities.interpolateColorThroughWhite(CDW.state.activeThread.firstPost.stanceColorLight, CDW.state.previousThread.firstPost.stanceColorLight, amount), true);
//						CDW.view.rightQuote.setColor(Utilities.interpolateColorThroughWhite(CDW.state.activeThread.firstPost.stanceColorLight, CDW.state.previousThread.firstPost.stanceColorLight, amount), true);
//						CDW.view.flagButton.setBackgroundColor(Utilities.interpolateColorThroughWhite(CDW.state.activeThread.firstPost.stanceColorDark, CDW.state.previousThread.firstPost.stanceColorDark, amount), true);
//						CDW.view.statsButton.setBackgroundColor(Utilities.interpolateColorThroughWhite(CDW.state.activeThread.firstPost.stanceColorDark, CDW.state.previousThread.firstPost.stanceColorDark, amount), true);
//						CDW.view.likeButton.setBackgroundColor(Utilities.interpolateColorThroughWhite(CDW.state.activeThread.firstPost.stanceColorDark, CDW.state.previousThread.firstPost.stanceColorDark, amount), true);					
//						CDW.view.viewDebateButton.setBackgroundColor(Utilities.interpolateColorThroughWhite(CDW.state.activeThread.firstPost.stanceColorDark, CDW.state.previousThread.firstPost.stanceColorDark, amount), true);
//						CDW.view.debateButton.setBackgroundColor(Utilities.interpolateColorThroughWhite(CDW.state.activeThread.firstPost.stanceColorDark, CDW.state.previousThread.firstPost.stanceColorDark, amount), true);
					}					
				}
									
			}
			
			
		}
		
		private function onMouseUp(e:MouseEvent):void {
			if (mouseDown) {
				mouseDown = false;
				this.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
				
				var vxAverage:Number = ArrayUtil.average(vxSamples);
				
				trace('Mouse up. Velocity average: ' + vxAverage);

				// see if we need to transition
				if ((CivilDebateWall.state.nextThread != null) &&(vxAverage < -vxThreshold) || (leftEdge < (stage.stageWidth / -2))) {
					CivilDebateWall.kiosk.view.nextDebate();
				}
				if ((CivilDebateWall.state.previousThread != null) && (vxAverage > vxThreshold) || (leftEdge > (stage.stageWidth / 2))) {
					CivilDebateWall.kiosk.view.previousDebate();			
				}
				else {
					// spring back to current
					CivilDebateWall.kiosk.view.homeView();					
				}
			}
		}		
	}
}
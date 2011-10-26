package com.civildebatewall.ui {
	
	import com.civildebatewall.*;
	import com.civildebatewall.blocks.BlockBase;
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
			startX = this.mouseX - (CDW.view.nametag.x - CDW.view.nametag.defaultTweenInVars.x);
			currentX = startX;
			leftEdge = 0;			
			
			// Stop tweens
			// TweenMax.killAll();
			TweenMax.killTweensOf(CDW.view.nametag);
			TweenMax.killTweensOf(CDW.view.leftNametag);
			TweenMax.killTweensOf(CDW.view.rightNametag);			
			TweenMax.killTweensOf(CDW.view.opinion);
			TweenMax.killTweensOf(CDW.view.leftOpinion);
			TweenMax.killTweensOf(CDW.view.rightOpinion);			
			TweenMax.killChildTweensOf(CDW.view.portrait);
			TweenMax.killChildTweensOf(CDW.view.quoteLeft);
			TweenMax.killChildTweensOf(CDW.view.quoteRight);
			
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
				if ((leftEdge < 0) && (CDW.state.nextThread == null)) {
					leftEdge = 0;
					difference = 0;
				}
				else if ((leftEdge > 0) && (CDW.state.previousThread == null)) {
					leftEdge = 0;
					difference = 0;
				}
				
				trace("leftEdge: " + leftEdge + " difference: " + difference);
				
				
				difference = Math2.clamp(difference, -stageWidth, stageWidth);
				leftEdge = Math2.clamp(leftEdge, -stageWidth, stageWidth);				
				
				
				
				var amount:Number = Math2.map(Math.abs(leftEdge), 0, stageWidth, 0, 1);
				
				// drag blocks
				CDW.view.nametag.x = CDW.view.nametag.defaultTweenInVars.x - difference;

				
				CDW.view.opinion.x = CDW.view.opinion.defaultTweenInVars.x - difference;
				CDW.view.leftOpinion.x = CDW.view.leftOpinion.defaultTweenInVars.x - difference;
				CDW.view.rightOpinion.x = CDW.view.rightOpinion.defaultTweenInVars.x - difference;
				

				
				CDW.view.leftNametag.x = CDW.view.leftNametag.defaultTweenInVars.x - difference;
				CDW.view.nametag.x = CDW.view.nametag.defaultTweenInVars.x - difference;
				CDW.view.rightNametag.x = CDW.view.rightNametag.defaultTweenInVars.x - difference;					
				
				
				// TODO tween debate overlay
				
				
				// TODO tween label text?				
				

				if (leftEdge < 0) {
					// going to next
					CDW.view.portrait.setIntermediateImage(CDW.state.nextThread.firstPost.user.photo, Math2.mapClamp(Math.abs(leftEdge), 0, stageWidth, 0, 1));
					
					// No tween if no change!
					if (CDW.state.nextThread.firstPost.stance != CDW.state.activeThread.firstPost.stance) {

						CDW.view.quoteLeft.setColor(Color.interpolateColor(CDW.state.activeThread.firstPost.stanceColorLight, CDW.state.nextThread.firstPost.stanceColorLight, amount), true);
						CDW.view.quoteRight.setColor(Color.interpolateColor(CDW.state.activeThread.firstPost.stanceColorLight, CDW.state.nextThread.firstPost.stanceColorLight, amount), true);
						CDW.view.flagButton.setBackgroundColor(Color.interpolateColor(CDW.state.activeThread.firstPost.stanceColorDark, CDW.state.nextThread.firstPost.stanceColorDark, amount), true);
						CDW.view.statsButton.setBackgroundColor(Color.interpolateColor(CDW.state.activeThread.firstPost.stanceColorDark, CDW.state.nextThread.firstPost.stanceColorDark, amount), true);
						CDW.view.likeButton.setBackgroundColor(Color.interpolateColor(CDW.state.activeThread.firstPost.stanceColorDark, CDW.state.nextThread.firstPost.stanceColorDark, amount), true);					
						CDW.view.viewDebateButton.setBackgroundColor(Color.interpolateColor(CDW.state.activeThread.firstPost.stanceColorDark, CDW.state.nextThread.firstPost.stanceColorDark, amount), true);
						CDW.view.debateButton.setBackgroundColor(Color.interpolateColor(CDW.state.activeThread.firstPost.stanceColorDark, CDW.state.nextThread.firstPost.stanceColorDark, amount), true);						
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
					CDW.view.portrait.setIntermediateImage(CDW.state.previousThread.firstPost.user.photo, Math2.mapClamp(Math.abs(leftEdge), 0, stageWidth, 0, 1));
					
					if (CDW.state.previousThread.firstPost.stance != CDW.state.previousThread.firstPost.stance) { 						
						CDW.view.quoteLeft.setColor(Color.interpolateColor(CDW.state.activeThread.firstPost.stanceColorLight, CDW.state.previousThread.firstPost.stanceColorLight, amount), true);
						CDW.view.quoteRight.setColor(Color.interpolateColor(CDW.state.activeThread.firstPost.stanceColorLight, CDW.state.previousThread.firstPost.stanceColorLight, amount), true);
						CDW.view.flagButton.setBackgroundColor(Color.interpolateColor(CDW.state.activeThread.firstPost.stanceColorDark, CDW.state.previousThread.firstPost.stanceColorDark, amount), true);
						CDW.view.statsButton.setBackgroundColor(Color.interpolateColor(CDW.state.activeThread.firstPost.stanceColorDark, CDW.state.previousThread.firstPost.stanceColorDark, amount), true);
						CDW.view.likeButton.setBackgroundColor(Color.interpolateColor(CDW.state.activeThread.firstPost.stanceColorDark, CDW.state.previousThread.firstPost.stanceColorDark, amount), true);					
						CDW.view.viewDebateButton.setBackgroundColor(Color.interpolateColor(CDW.state.activeThread.firstPost.stanceColorDark, CDW.state.previousThread.firstPost.stanceColorDark, amount), true);
						CDW.view.debateButton.setBackgroundColor(Color.interpolateColor(CDW.state.activeThread.firstPost.stanceColorDark, CDW.state.previousThread.firstPost.stanceColorDark, amount), true);
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
				if ((CDW.state.nextThread != null) &&(vxAverage < -vxThreshold) || (leftEdge < (stageWidth / -2))) {
					CDW.view.nextDebate();
				}
				if ((CDW.state.previousThread != null) && (vxAverage > vxThreshold) || (leftEdge > (stageWidth / 2))) {
					CDW.view.previousDebate();			
				}
				else {
					// spring back to current
					CDW.view.homeView();					
				}
			}
		}		
	}
}
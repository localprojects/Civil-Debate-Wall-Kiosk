package net.localprojects.ui {
	
	import com.greensock.TweenMax;
	
	import flash.events.*;
	
	import net.localprojects.*;
	import net.localprojects.blocks.BlockBase;

	
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
		
		// TODO velocity based push-over
		
		private function init():void {
			graphics.beginFill(0x000000, 0);
			graphics.drawRect(0, 0, 1080, 1920);
			graphics.endFill();
			
			this.addEventListener(MouseEvent.MOUSE_DOWN, onMouseDown);
			//this.addEventListener(TouchEvent.TOUCH_BEGIN, onMouseDown);			
			this.addEventListener(MouseEvent.MOUSE_UP, onMouseUp);
			this.addEventListener(MouseEvent.MOUSE_MOVE, onMouseMove);
			mouseDown = false;
			
			vxSampleDepth = 5;
			vxThreshold = 40;
		}
		

		private function onMouseDown(e:MouseEvent):void {
			mouseDown = true;
			vxSamples = new Array(); // clear the history
			
			// refactor startX based on tween progress, for portrait and other things
			startX = this.mouseX - (CDW.view.nametag.x - CDW.view.nametag.defaultTweenInVars.x);
			currentX = startX;
			leftEdge = 0;			
			
			// Stop home tweens
			TweenMax.killTweensOf(CDW.view.nametag);
			TweenMax.killTweensOf(CDW.view.leftNametag);
			TweenMax.killTweensOf(CDW.view.rightNametag);			
			TweenMax.killTweensOf(CDW.view.stance);
			TweenMax.killTweensOf(CDW.view.leftStance);
			TweenMax.killTweensOf(CDW.view.rightStance);			
			TweenMax.killTweensOf(CDW.view.opinion);
			TweenMax.killTweensOf(CDW.view.leftOpinion);
			TweenMax.killTweensOf(CDW.view.rightOpinion);			
			TweenMax.killChildTweensOf(CDW.view.portrait);
			TweenMax.killChildTweensOf(CDW.view.leftQuote);
			TweenMax.killChildTweensOf(CDW.view.rightQuote);
			
			this.addEventListener(Event.ENTER_FRAME, onEnterFrame);
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
				if ((leftEdge < 0) && (CDW.state.nextDebate == null)) {
					leftEdge = 0;
					difference = 0;
				}
				else if ((leftEdge > 0) && (CDW.state.previousDebate == null)) {
					leftEdge = 0;
					difference = 0;
				}				
				
				// drag blocks
				CDW.view.nametag.x = CDW.view.nametag.defaultTweenInVars.x - difference;
				CDW.view.stance.x = CDW.view.stance.defaultTweenInVars.x - difference;
				
				CDW.view.opinion.x = CDW.view.opinion.defaultTweenInVars.x - difference;
				CDW.view.leftOpinion.x = CDW.view.leftOpinion.defaultTweenInVars.x - difference;
				CDW.view.rightOpinion.x = CDW.view.rightOpinion.defaultTweenInVars.x - difference;
				
				CDW.view.leftStance.x = CDW.view.leftStance.defaultTweenInVars.x - difference;
				CDW.view.stance.x = CDW.view.stance.defaultTweenInVars.x - difference;
				CDW.view.rightStance.x = CDW.view.rightStance.defaultTweenInVars.x - difference;
				
				CDW.view.leftNametag.x = CDW.view.leftNametag.defaultTweenInVars.x - difference;
				CDW.view.nametag.x = CDW.view.nametag.defaultTweenInVars.x - difference;
				CDW.view.rightNametag.x = CDW.view.rightNametag.defaultTweenInVars.x - difference;					
				
				// tween colors
				
				
				if (leftEdge < 0) {
					// going to next
					CDW.view.portrait.setIntermediateImage(CDW.database.getDebateAuthorPortrait(CDW.state.nextDebate), Utilities.mapClamp(Math.abs(leftEdge), 0, stageWidth, 0, 1));
				}
				else if (leftEdge > 0) {
					// going to previous
					CDW.view.portrait.setIntermediateImage(CDW.database.getDebateAuthorPortrait(CDW.state.previousDebate), Utilities.mapClamp(Math.abs(leftEdge), 0, stageWidth, 0, 1));						
				}
				
				CDW.view.leftQuote.setIntermediateColor(Assets.COLOR_YES_LIGHT, Assets.COLOR_NO_LIGHT, Utilities.mapClamp(Math.abs(leftEdge), 0, stageWidth, 0, 1));
				CDW.view.rightQuote.setIntermediateColor(Assets.COLOR_YES_LIGHT, Assets.COLOR_NO_LIGHT, Utilities.mapClamp(Math.abs(leftEdge), 0, stageWidth, 0, 1));					
			}
			
			
		}
		
		private function onMouseUp(e:MouseEvent):void {
			if (mouseDown) {
				mouseDown = false;
				this.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
				
				var vxAverage:Number = Utilities.averageArray(vxSamples);
				
				trace('Mouse up. Velocity average: ' + vxAverage);
				
				
				// see if we need to transition
				if ((CDW.state.nextDebate != null) &&(vxAverage < -vxThreshold) || (leftEdge < (stageWidth / -2))) {
					trace('Transition to next.');
					CDW.state.setActiveDebate(CDW.state.nextDebate);
					CDW.view.leftOpinion.x += stageWidth;
					CDW.view.opinion.x += stageWidth;
					CDW.view.rightOpinion.x += stageWidth;
					
					CDW.view.leftStance.x += stageWidth;
					CDW.view.rightStance.x += stageWidth;
					CDW.view.stance.x += stageWidth;
					
					CDW.view.leftNametag.x += stageWidth;
					CDW.view.rightNametag.x += stageWidth;
					CDW.view.nametag.x += stageWidth;				
					
					
				}
				if ((CDW.state.previousDebate != null) && (vxAverage > vxThreshold) || (leftEdge > (stageWidth / 2))) {
					trace('Transition to previous.');
					CDW.state.setActiveDebate(CDW.state.previousDebate);
					CDW.view.leftOpinion.x -= stageWidth;
					CDW.view.opinion.x -= stageWidth;
					CDW.view.rightOpinion.x -= stageWidth;
					
					CDW.view.leftStance.x -= stageWidth;
					CDW.view.rightStance.x -= stageWidth;
					CDW.view.stance.x -= stageWidth;
					
					CDW.view.leftNametag.x -= stageWidth;
					CDW.view.rightNametag.x -= stageWidth;
					CDW.view.nametag.x -= stageWidth;				
				}
				else {
					// spring back to current
				}
				
				// put everything back into place
				CDW.view.homeView();
			}
		}		
	}
}
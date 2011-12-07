package com.civildebatewall.kiosk {
	
	import com.civildebatewall.*;
	import com.civildebatewall.kiosk.legacy.OldBlockBase;

	import com.greensock.TweenMax;
	import com.kitschpatrol.futil.Math2;
	import com.kitschpatrol.futil.utilitites.ArrayUtil;
	
	import flash.events.*;

	
	public class DragLayer extends OldBlockBase {
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
//			
//			mouseDown = true;
//			vxSamples = new Array(); // clear the history
//			
//			// refactor startX based on tween progress, for portrait and other things
//			startX = this.mouseX;
//			currentX = startX;
//			leftEdge = 0;			
//			
//			// Stop tweens
//			// TweenMax.killAll();
//			TweenMax.killTweensOf(CivilDebateWall.kiosk.view.opinion);
//			TweenMax.killChildTweensOf(CivilDebateWall.kiosk.view.portrait);
//			
//			this.addEventListener(Event.ENTER_FRAME, onEnterFrame);
//			//}

			
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

			
			
		}
		
		private function onMouseUp(e:MouseEvent):void {
			if (mouseDown) {
				mouseDown = false;
				this.removeEventListener(Event.ENTER_FRAME, onEnterFrame);
				
				var vxAverage:Number = ArrayUtil.average(vxSamples);
				
				trace("Mouse up. Velocity average: " + vxAverage);

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
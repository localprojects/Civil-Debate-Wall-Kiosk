package com.civildebatewall.kiosk {
	
	import com.civildebatewall.CivilDebateWall;
	import com.civildebatewall.kiosk.legacy.OldBlockBase;
	import com.kitschpatrol.futil.utilitites.ArrayUtil;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	// Formerly used for flick-scrolling the big portraits, currently unused
	// TODO reimplement this functionality
	public class DragLayer extends OldBlockBase {
		
		private var mouseDown:Boolean;		
		private var startX:int;
		private var lastX:int;
		private var currentX:int;
		private var difference:int;
		private var leftEdge:int;	
		private var vxSamples:Array;
		private var vxSampleDepth:int;
		private var vxThreshold:Number; // velocity required until a flick is a transition	
		
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

				// see if we need to transition
				if ((CivilDebateWall.state.nextThread != null) &&(vxAverage < -vxThreshold) || (leftEdge < (stage.stageWidth / -2))) {
					CivilDebateWall.kiosk.nextDebate();
				}
				if ((CivilDebateWall.state.previousThread != null) && (vxAverage > vxThreshold) || (leftEdge > (stage.stageWidth / 2))) {
					CivilDebateWall.kiosk.previousDebate();			
				}
				else {
					// spring back to current
					CivilDebateWall.kiosk.homeView();					
				}
			}
		}		
	}
}
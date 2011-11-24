package com.civildebatewall.staging.overlays.smsfun {
	import com.civildebatewall.Assets;
	import com.civildebatewall.CivilDebateWall;
	import com.greensock.TweenMax;
	import com.kitschpatrol.futil.blocks.BlockText;
	import com.kitschpatrol.futil.constants.Alignment;
	
	import flash.events.Event;
	import flash.events.MouseEvent;
	
	public class NumberKey extends BlockText {
		
		public static const KEY_PRESSED_EVENT:String = "keyPressedEvent";
		
		public function NumberKey(number:String)	{
			
			super({
				width: 149,
				height: 81,
				textFont: Assets.FONT_BOLD,
				textBold: true,
				textSize: 35, // TODO  auto				
				borderThickness: 3,
				backgroundRadius: 0,
				showBorder: true,	
				borderColor: CivilDebateWall.state.userStanceColorLight,
				backgroundColor: CivilDebateWall.state.userStanceColorLight,	
				backgroundAlpha: 0.12,
				textColor: CivilDebateWall.state.userStanceColorDark,
				alignmentPoint: Alignment.CENTER,
				textAlignmentMode: Alignment.TEXT_CENTER,
				text: number,
				buttonMode: true,
				visible: true
			});
			
			onButtonUp.push(onUp);
			onButtonDown.push(onDown);
			onButtonOver.push(onOver);
			onButtonOut.push(onOut);	
		}

		// mouse handling
		private function onDown(e:MouseEvent):void {
			drawDown();
		}
		
		private function onUp(e:MouseEvent):void {
			drawUp();
			this.dispatchEvent(new Event(KEY_PRESSED_EVENT, true)); // send event
		}		
		
		private function onOver(e:MouseEvent):void {
			if (e.buttonDown) drawDown();
		}
		
		private function onOut(e:MouseEvent):void {
			drawUp();
		}
		
		// drawing
		private function drawUp():void {
			TweenMax.to(this, 0.2, {backgroundAlpha: 0.12, textColor: CivilDebateWall.state.userStanceColorDark});			
		}
		
		private function drawDown():void {
			TweenMax.to(this, 0, {backgroundAlpha: 1, textColor: 0xffffff});
		}
		
	}
}
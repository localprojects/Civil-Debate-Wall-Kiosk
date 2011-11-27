package com.civildebatewall.kiosk.buttons {
	import com.civildebatewall.Assets;
	import com.civildebatewall.CivilDebateWall;
	import com.kitschpatrol.futil.blocks.BlockText;
	
	import flash.display.Shape;
	import flash.events.MouseEvent;
	
	public class TermsAndConditionsButton extends BlockText {
		private var underline:Shape;
		
		public function TermsAndConditionsButton(params:Object=null) {
			super({
				text: "Terms and Conditions",
				textFont: Assets.FONT_REGULAR,
				backgroundAlpha: 0,
				textSize: 14,
				buttonMode: true,
				textColor: 0xffffff,
				visible: false
			});
			
			underline = new Shape();
			underline.graphics.beginFill(0xffffff);
			underline.graphics.drawRect(0, 0, this.width - 2, 2);
			underline.graphics.endFill();
			underline.y = this.height + 5;
			underline.x = 3;
			addChild(underline);			
			
			onButtonUp.push(onUp);
		}
		
		private function onUp(e:MouseEvent):void {
			trace("going to terms and conditions view");
			CivilDebateWall.state.setView(CivilDebateWall.kiosk.view.termsAndConditionsView);
		}
		
	}
}
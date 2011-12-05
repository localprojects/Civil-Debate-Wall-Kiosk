package com.civildebatewall.kiosk.elements {

	import com.civildebatewall.Assets;
	import com.kitschpatrol.futil.blocks.BlockText;
	import com.kitschpatrol.futil.constants.Alignment;
	
	import flash.display.Shape;
	
	public class StatsTitleBar extends BlockText {
		
		public var leftDot:Shape;
		public var rightDot:Shape;		
		
		public function StatsTitleBar(params:Object=null)	{
			
			super(params);			
			
			setParams({
				textFont: Assets.FONT_BOLD,
				textBold: true,
				textSize: 18,
				textColor: 0xffffff,
				letterSpacing: -1,
				textAlignmentMode: Alignment.TEXT_CENTER,
				alignmentPoint: Alignment.CENTER,
				width: 1022,
				height: 64,
				backgroundColor: 0x000000				
			});
			
			
			content.mouseChildren = false;
			content.mouseEnabled = false;
			
			leftDot = new Shape();
			leftDot.graphics.beginFill(Assets.COLOR_YES_LIGHT);
			leftDot.graphics.drawCircle(252, 32, 4);
			leftDot.graphics.endFill();
			background.addChild(leftDot);
			
			rightDot = new Shape();
			rightDot.graphics.beginFill(Assets.COLOR_NO_LIGHT);
			rightDot.graphics.drawCircle(770, 32, 4);
			rightDot.graphics.endFill();			
			background.addChild(rightDot);
		}
	}
}
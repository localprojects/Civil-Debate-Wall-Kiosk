package com.civildebatewall.kiosk.elements {
	import com.kitschpatrol.futil.blocks.BlockBase;
	
	public class WordCloudTitleBar extends StatsTitleBar {
		
		public var clearTagButton:ClearTagButton;
		
		public function WordCloudTitleBar(params:Object=null) {
			super(params);
			
			maxSizeBehavior = BlockBase.MAX_SIZE_CLIPS;

			clearTagButton = new ClearTagButton();
			clearTagButton.setDefaultTweenIn(0.5, {x: width - clearTagButton.width});
			clearTagButton.setDefaultTweenOut(1, {x: width});
			background.addChild(clearTagButton);
			
			clearTagButton.mask = clippingMask;			
		}
	}
}
package com.civildebatewall.staging
{
	import com.civildebatewall.Assets;
	import com.civildebatewall.staging.elements.CaratButton;
	import com.civildebatewall.staging.elements.StatsTitleBar;
	
	public class StatsTitleBarSelector extends StatsTitleBar	{
		
		
		private var leftButton:CaratButton;
		private var rightButton:CaratButton;
		
		public function StatsTitleBarSelector(params:Object=null)		{
			super(params);
			leftButton = new CaratButton({bitmap: Assets.getLeftCaratWhite()});
			leftButton.x = 220;
			leftButton.y = 0;
			background.addChild(leftButton);
			
			rightButton = new CaratButton({bitmap: Assets.getRightCaratWhite()});
			rightButton.x = 738;
			rightButton.y = 0;		
			background.addChild(rightButton);
			
			visible = true;
			
			background.removeChild(leftDot);
			background.removeChild(rightDot);	
			
			// TODO
			// updates state
		}
	}
}
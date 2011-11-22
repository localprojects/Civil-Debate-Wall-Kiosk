package com.civildebatewall.smsfun {
	
	
	import com.civildebatewall.Assets;
	
	import flash.display.Sprite;
	
	public class Phone extends Sprite	{
		
		private var handset:Sprite;
		private var bubble:Sprite;
		
		
		public function Phone()	{
			handset = Assets.getYesPhone();
			
			handset.x = -handset.width / 2;
			handset.y = -handset.height / 2;	
			
			addChild(handset);
			
			bubble = Assets.getYesBubble();
			bubble.x = -bubble.width / 2;
			bubble.y = -bubble.height / 2;	
			addChild(bubble);
		}
		
		
		
		
		// yes no timeline
		
		
		
		
		
	}
}
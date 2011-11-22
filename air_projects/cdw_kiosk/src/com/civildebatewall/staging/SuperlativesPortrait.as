package com.civildebatewall.staging
{
	import com.civildebatewall.Assets;
	import com.civildebatewall.CivilDebateWall;
	import com.civildebatewall.State;
	import com.civildebatewall.data.Post;
	import com.civildebatewall.kiosk.elements.Portrait;
	import com.civildebatewall.staging.elements.OpinionTextSuperlative;
	import com.kitschpatrol.futil.blocks.BlockBase;
	import com.kitschpatrol.futil.blocks.BlockBitmap;
	import com.kitschpatrol.futil.utilitites.BitmapUtil;
	
	import flash.events.Event;
	
	public class SuperlativesPortrait extends BlockBase	{
		
		private var post:Post;
		private var opinionText:OpinionTextSuperlative;
		private var portrait:BlockBitmap;
		
		
		public function SuperlativesPortrait(params:Object=null) {
			super(params);

			// listen to state
			width = 504;
			height = 845;			
			
			portrait = new BlockBitmap({bitmap: BitmapUtil.scaleToFill(Assets.getPortraitPlaceholder(), width, height)});
			portrait.visible = true;
			addChild(portrait );
			

			opinionText = new OpinionTextSuperlative();
			opinionText.visible = true;
			opinionText.x = 30;
			opinionText.y = 469;
			addChild(opinionText);
			

			
			// LISTEN TO STATE
			CivilDebateWall.state.addEventListener(State.SUPERLATIVE_POST_CHANGE, onPostChange);
		}
		
		private function onPostChange(e:Event):void {
			setPost(CivilDebateWall.state.superlativePost);
		}
		
		
		public function setPost(post:Post):void {
			this.post = post;
			opinionText.setPost(post);

			// fade in portrait
			
			// update details
			
		}
	}
}
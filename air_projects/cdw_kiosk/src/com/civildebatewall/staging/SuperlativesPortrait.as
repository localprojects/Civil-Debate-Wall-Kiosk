package com.civildebatewall.staging
{
	import com.civildebatewall.data.Post;
	import com.civildebatewall.staging.elements.OpinionTextBase;
	import com.kitschpatrol.futil.blocks.BlockBase;
	
	public class SuperlativesPortrait extends BlockBase
	{
		private var post:Post;
		
		private var opinionText:OpinionTextBase;
		
		public function SuperlativesPortrait(params:Object=null)
		{
			super(params);
			

			opinionText = new OpinionTextBase();
			opinionText.visible = true;
			opinionText.x = 30;
			opinionText.y = 469;
			addChild(opinionText);
			
			
			// listen to state
			width = 504;
			height = 845;
			
		}
		
		
		public function setPost(post:Post) {
			this.post = post;
			opinionText.setPost(post);
			
			
			// fade in portrait
			
			
			// update details
			
			
			
			
		}
	}
}
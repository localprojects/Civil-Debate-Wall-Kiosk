package com.civildebatewall.staging.elements {
	
	import com.civildebatewall.Assets;
	import com.kitschpatrol.futil.blocks.BlockText;
	
	public class QuestionHeader extends BlockText	{
		
		public function QuestionHeader(question:String) {
			super({text: question,
						 textFont: Assets.FONT_BOLD,
						 textSizePixels: 39,		 
						 textColor: 0x000000,
						 paddingTop: 65,
						 paddingLeft: 100,
						 paddingRight: 100,
						 paddingBottom:76,
						 width: 1080,	
						 height: 312
			});
			
			
		}
		
	}
}
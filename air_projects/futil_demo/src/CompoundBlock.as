package {
	import com.kitschpatrol.futil.blocks.BlockBase;
	import com.kitschpatrol.futil.blocks.BlockText;
	import com.kitschpatrol.futil.constants.Alignment;
	
	public class CompoundBlock extends BlockBase {
		
		private var textA:BlockText;
		private var textB:BlockText;
		
		public function CompoundBlock(params:Object=null) {
			super(params);
			//registrationPoint = Alignment.BOTTOM_LEFT;		
			// Test nesting blocks...
			
//			textA = new BlockText({textFont: Assets.FONT_BOLD, text: "textA bla", backgroundColor: 0xff0fff, visible: true});
//			textB = new BlockText({text: "textA bla", backgroundColor: 0xf0f0f, visible: true});			
			
			textA = new BlockText({
				//registrationPoint: Alignment.BOTTOM_LEFT,				
				paddingTop: 25,
				paddingLeft: 35,
				paddingRight: 35,				
				textFont: Assets.FONT_BOLD,
				textBold: true,
				textSize: 30,
				textColor: 0xffffff,
				minWidth: 100,
				maxWidth: 880,

				height: 78,
				
				visible: true
			});
			
			textB = new BlockText({
				//registrationPoint: Alignment.BOTTOM_LEFT,	
				paddingTop: 25,
				paddingLeft: 35,
				paddingRight: 35,
				paddingBottom: 25,				
				textFont: Assets.FONT_REGULAR,
				textSize: 30,
				textColor: 0xffffff,
				minWidth: 100,
				maxWidth: 880,

				maxHeight: 1000,
				
				visible: true
			});
			
			

			
						
			
			addChild(textA);
			textB.y = textA.bottom;
			addChild(textB);
			

			backgroundColor = 0xff0000;
			showRegistrationPoint = true;				
			visible = true;
		}
	}
}
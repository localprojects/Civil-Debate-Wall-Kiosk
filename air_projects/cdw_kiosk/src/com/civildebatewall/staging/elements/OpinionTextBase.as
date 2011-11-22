package com.civildebatewall.staging.elements
{
	import com.civildebatewall.Assets;
	import com.civildebatewall.CivilDebateWall;
	import com.civildebatewall.State;
	import com.civildebatewall.data.Post;
	import com.kitschpatrol.futil.blocks.BlockBase;
	import com.kitschpatrol.futil.blocks.BlockText;
	import com.kitschpatrol.futil.constants.Alignment;
	import com.kitschpatrol.futil.constants.Char;
	
	import flash.events.Event;
	
	
	public class OpinionTextBase extends BlockBase	{
		
		private var opinion:BlockText;
		private var nameTag:BlockText;
		
		public function OpinionTextBase()	{
			super({
				//registrationPoint: Alignment.BOTTOM_LEFT,
				width: 880,
				maxHeight: 1000			
			});
			
			
			nameTag = new BlockText({
				minWidth: 100,
				maxWidth: 880,
				height: 78,
				paddingTop: 25,
				paddingLeft: 35,
				paddingRight: 35,				
				textFont: Assets.FONT_BOLD,
				textBold: true,
				textSize: 30,
				textColor: 0xffffff,
				leading: 20,
				visible: true
			});
			
			opinion = new BlockText({
				minWidth: 100,
				maxWidth: 880,
				maxHeight: 1000,				
				paddingTop: 25,
				paddingLeft: 35,
				paddingRight: 35,
				paddingBottom: 25,	
				textFont: Assets.FONT_REGULAR,
				textSize: 30,
				textColor: 0xffffff,
				leading: 20,
				visible: true
			});
			
			addChild(opinion);
			addChild(nameTag);
		}
		
		public function setPost(post:Post):void {
			nameTag.backgroundColor = post.stanceColorDark;
			nameTag.text = (post.user.username + " SAYS : " + post.stance + "!").toUpperCase();
			
			opinion.backgroundColor = post.stanceColorLight;
			opinion.text = Char.LEFT_QUOTE + post.text + Char.RIGHT_QUOTE;
			
			update();			
		}
		

		
	}
}
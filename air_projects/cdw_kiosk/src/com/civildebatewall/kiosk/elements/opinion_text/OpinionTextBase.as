package com.civildebatewall.kiosk.elements.opinion_text {
	import com.civildebatewall.Assets;
	import com.civildebatewall.data.Post;
	import com.kitschpatrol.futil.blocks.BlockBase;
	import com.kitschpatrol.futil.blocks.BlockText;
	import com.kitschpatrol.futil.constants.Char;
	
	public class OpinionTextBase extends BlockBase	{
		
		protected var opinion:BlockTextOpinion;
		protected var nameTag:BlockText;
		
		public function OpinionTextBase()	{
			super({
				width: 880,
				maxHeight: 1000,
				backgroundAlpha: 0
			});
			
			nameTag = new BlockText({
				minWidth: 100,
				maxWidth: 880,
				height: 78,
				alignmentY: 0.5,
				paddingLeft: 35,
				paddingRight: 35,				
				textFont: Assets.FONT_BOLD,
				textBold: true,
				textSize: 30,
				textColor: 0xffffff,
				leading: 78,
				visible: true
			});
			
			opinion = new BlockTextOpinion({
				minWidth: 100,
				maxWidth: 880,
				maxHeight: 1000,				
				paddingTop: 25,
				paddingLeft: 35,
				paddingRight: 35,
				paddingBottom: 34,	
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
			
			opinion.y = nameTag.bottom;
			
			update();			
		}
		
	}
}
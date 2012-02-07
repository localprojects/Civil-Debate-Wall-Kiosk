/*--------------------------------------------------------------------
Civil Debate Wall Kiosk
Copyright (c) 2012 Local Projects. All rights reserved.

This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as
published by the Free Software Foundation, either version 2 of the
License, or (at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public
License along with this program. 

If not, see <http://www.gnu.org/licenses/>.
--------------------------------------------------------------------*/

package com.civildebatewall.kiosk.elements.opinion_text {
	import com.civildebatewall.Assets;
	import com.civildebatewall.data.containers.Post;
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

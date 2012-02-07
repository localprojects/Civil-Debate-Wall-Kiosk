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

package com.civildebatewall.kiosk.elements {
	
	import com.civildebatewall.Assets;
	import com.civildebatewall.CivilDebateWall;
	import com.civildebatewall.State;
	import com.civildebatewall.data.containers.Post;
	import com.civildebatewall.kiosk.buttons.DebateThisButton;
	import com.civildebatewall.kiosk.buttons.GoToDebateButton;
	import com.civildebatewall.kiosk.elements.opinion_text.OpinionTextSuperlative;
	import com.kitschpatrol.futil.blocks.BlockBase;
	import com.kitschpatrol.futil.utilitites.BitmapUtil;
	
	import flash.events.Event;
	
	public class SuperlativesPortrait extends BlockBase	{
		
		private var post:Post;
		private var opinionText:OpinionTextSuperlative;
		public var portrait:PortraitBase;
		private var debateButton:DebateThisButton;
		private var goToDebateButton:GoToDebateButton;
		
		public function SuperlativesPortrait(params:Object = null) {
			super(params);

			// listen to state
			width = 504;
			height = 845;			
			
			// TODO fix block bitmap tweening...
			portrait = new PortraitBase();
			portrait.visible = true;
			portrait.setImage(BitmapUtil.scaleToFill(Assets.getPortraitPlaceholder(), 504, 845), true);
			addChild(portrait);
		
			opinionText = new OpinionTextSuperlative();
			opinionText.visible = true;
			opinionText.x = 30;
			opinionText.y = 469;
			addChild(opinionText);
			
			debateButton = new DebateThisButton();
			debateButton.x = 362;
			debateButton.y = 345;
			debateButton.visible = true;
			addChild(debateButton);
			
			goToDebateButton = new GoToDebateButton();
			goToDebateButton.x = 30;
			goToDebateButton.visible = true;
			addChild(goToDebateButton);
			
			CivilDebateWall.state.addEventListener(State.SUPERLATIVE_POST_CHANGE, onPostChange);
		}
		
		private function onPostChange(e:Event):void {
			setPost(CivilDebateWall.state.superlativePost);
		}
		
		public function setPost(post:Post):void {
			this.post = post;
			
			// update details			
			opinionText.setPost(post);
			debateButton.targetPost = post;
			goToDebateButton.targetPost = post;
			
			// reposition button
			goToDebateButton.y = opinionText.bottom + 14;
			
			// fade in portrait
			portrait.setImage(BitmapUtil.scaleToFill(post.user.photo, 504, 845));
		}
		
	}
}

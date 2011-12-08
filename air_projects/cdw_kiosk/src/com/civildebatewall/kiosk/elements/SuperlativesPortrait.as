package com.civildebatewall.kiosk.elements {
	
	import com.civildebatewall.Assets;
	import com.civildebatewall.CivilDebateWall;
	import com.civildebatewall.State;
	import com.civildebatewall.data.Post;
	import com.civildebatewall.kiosk.buttons.BalloonButton;
	import com.civildebatewall.kiosk.buttons.GoToDebateButton;
	import com.civildebatewall.kiosk.elements.opinion_text.OpinionTextSuperlative;
	import com.kitschpatrol.futil.blocks.BlockBase;
	import com.kitschpatrol.futil.utilitites.BitmapUtil;
	
	import flash.events.Event;
	
	public class SuperlativesPortrait extends BlockBase	{
		
		private var post:Post;
		private var opinionText:OpinionTextSuperlative;
		public var portrait:PortraitBase;
		private var debateButton:BalloonButton;
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
			
			debateButton = new BalloonButton();
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
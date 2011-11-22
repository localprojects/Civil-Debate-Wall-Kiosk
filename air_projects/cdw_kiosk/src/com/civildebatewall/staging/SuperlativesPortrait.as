package com.civildebatewall.staging
{
	import com.civildebatewall.Assets;
	import com.civildebatewall.CivilDebateWall;
	import com.civildebatewall.State;
	import com.civildebatewall.data.Post;
	import com.civildebatewall.kiosk.elements.Portrait;
	import com.civildebatewall.staging.elements.BalloonButton;
	import com.civildebatewall.staging.elements.DebateButton;
	import com.civildebatewall.staging.elements.GoToDebateButton;
	import com.civildebatewall.staging.elements.OpinionTextSuperlative;
	import com.greensock.TweenMax;
	import com.kitschpatrol.futil.blocks.BlockBase;
	import com.kitschpatrol.futil.blocks.BlockBitmap;
	import com.kitschpatrol.futil.utilitites.BitmapUtil;
	
	import flash.display.Bitmap;
	import flash.events.Event;
	
	public class SuperlativesPortrait extends BlockBase	{
		
		private var post:Post;
		private var opinionText:OpinionTextSuperlative;
		private var portrait:BlockBitmap;
		private var debateButton:BalloonButton;
		private var goToDebateButton:GoToDebateButton;
		
		public function SuperlativesPortrait(params:Object=null) {
			super(params);

			// listen to state
			width = 504;
			height = 845;			
			
			// TODO fix block bitmap tweening...
			portrait = new BlockBitmap({bitmap: BitmapUtil.scaleToFill(Assets.getPortraitPlaceholder(), width, height)});
			portrait.visible = true;
			addChild(portrait );
			

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
			
			// LISTEN TO STATE
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
			TweenMax.to(portrait, 1, {bitmap: new Bitmap(BitmapUtil.scaleDataToFill(post.user.photo.bitmapData, width, height), "auto", true)});
			
			
			
		}
	}
}
package net.localprojects.pages {
	import com.bit101.components.PushButton;
	
	import flash.events.Event;
	import flash.events.TimerEvent;
	
	import net.localprojects.Countdown;
	import net.localprojects.PortraitCamera;
	
	public class PortraitPage extends Page	{

		private var photoBooth:PortraitCamera;
		private var shutterButton:PushButton;		
		private var countdown:Countdown;

		
		public function PortraitPage() {
			super();
			setTitle("Photo Booth");
			
			photoBooth = new PortraitCamera();
			
			photoBooth.x = (Main.stageWidth - photoBooth.width) / 2;
			photoBooth.y = 150;
			addChild(photoBooth);


			
			// shutter button
			shutterButton = new PushButton(this, 0, 0, "SHUTTER", onShutter);
			shutterButton.x = (Main.stageWidth - shutterButton.width) / 2;
			shutterButton.y = Main.stageHeight * .75;		
			
			countdown = new Countdown();
			addChild(countdown);
			countdown.x = Main.stageWidth * .5;
			countdown.y = Main.stageHeight * .7;			

			countdown.addEventListener(Countdown.COUNTER_FINISHED, onCountdownComplete);
			
			this.addEventListener(Event.ADDED_TO_STAGE, onAddToStage);
			this.addEventListener(Event.REMOVED_FROM_STAGE, onRemovedFromStage);
		}
		
		private function onAddToStage(e:Event):void {
			// activate camera
			photoBooth.activateCamera();			
		}
		
		
		private function onRemovedFromStage(e:Event):void {
			// deactivate camera
			photoBooth.deactivateCamera();
		}
		
		
		
		// TODO on face detcted
		
		private function onShutter(e:Event):void {
			trace("shutter");
			countdown.start();
		}
		
		private function onCountdownComplete(e:Event):void {
			trace("page caught timer");
			
			// store photo
			 Main.state.setPhoto(photoBooth.takePhoto());
			
			// enter review mode
			Main.state.setView(Main.reviewOpinionPage);
		}
		
	}
}
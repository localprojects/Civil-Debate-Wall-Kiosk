package net.localprojects.pages {
	import com.bit101.components.PushButton;
	
	import flash.events.Event;
	import flash.events.TimerEvent;
	
	import net.localprojects.Countdown;
	import net.localprojects.PortraitCamera;
	
	public class PhotoBooth extends Page	{

		private var portraitCamera:PortraitCamera;
		private var shutterButton:PushButton;		
		private var countdown:Countdown;


		
		public function PhotoBooth() {
			super();
			setTitle("Photo Booth");
			
			portraitCamera = new PortraitCamera();
			addChild(portraitCamera);
			
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
			portraitCamera.activateCamera();			
		}
		
		
		private function onRemovedFromStage(e:Event):void {
			// deactivate camera
			portraitCamera.deactivateCamera();
		}
		
		
		
		// TODO on face detcted
		
		private function onShutter(e:Event):void {
			trace("shutter");
			countdown.start();
		}
		
		private function onCountdownComplete(e:Event):void {
			trace("page caught timer");
			
			// store photo
			 Main.state.setPhoto(portraitCamera.takePhoto());
			
			// enter review mode
			Main.state.setView(Main.reviewOpinionPage);
		}
		
	}
}
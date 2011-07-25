package net.localprojects {

	
	import com.greensock.events.LoaderEvent;
	
	import flash.display.*;
	import flash.events.*;
	import flash.net.*;	

	public class CivilDebateWall extends Sprite {

		

		public static var database:Database;
		
		
		public function CivilDebateWall() {
			this.addEventListener(Event.ADDED_TO_STAGE, onAddedToStage);
		}

		private function onAddedToStage(event:Event):void {
			// set up the stage
			stage.quality = StageQuality.BEST;
			stage.scaleMode = StageScaleMode.EXACT_FIT;
			
			// temporarily squish screen for laptop development (half size)
			stage.nativeWindow.width = 540;
			stage.nativeWindow.height = 960;
			
			
			// load the wall state
			database = new Database();
			database.addEventListener(LoaderEvent.COMPLETE, onDatabaseLoaded);			
			database.load();
		}
		
		private function onDatabaseLoaded(e:LoaderEvent):void {
			trace("database loaded");
		}
		


		
		
		
		

		
		
		
		


	}
}
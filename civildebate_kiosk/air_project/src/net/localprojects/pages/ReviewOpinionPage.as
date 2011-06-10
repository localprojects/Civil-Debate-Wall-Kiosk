package net.localprojects.pages {
	import com.bit101.components.PushButton;
	
	import flash.display.Bitmap;
	import flash.events.Event;
	import net.localprojects.Utilities;
	
	public class ReviewOpinionPage extends Page	{
		
		private var photo:Bitmap;
		private var retakePhotoButton:PushButton;	
		private var saveButton:PushButton;			
		
		public function ReviewOpinionPage()	{
			super();

			this.setTitle("This week's debate:\n[voting topic]"); 
			this.setPlaceholderText("Review Opinion Page");					
			
			this.addEventListener(Event.ADDED_TO_STAGE, onAddToStage);
		}
		
		private function onAddToStage(e:Event):void {
			trace("review opinion page added to stage");
			photo = Main.state.getPhoto();
			
			this.addChild(photo);
			
			photo.scaleX = 0.5;
			photo.scaleY = 0.5;			
			
			photo.x = 10;
			photo.y = 200;
			
			retakePhotoButton = new PushButton(this, 0, 0, "RETAKE PHOTO", onRetakePhoto);
			retakePhotoButton.x = photo.x + photo.width - retakePhotoButton.width;
			retakePhotoButton.y = 175;
			
			saveButton = new PushButton(this, 0, 0, "SAVE", onSave);
			saveButton.x = photo.x + ((photo.width - retakePhotoButton.width) / 2);
			saveButton.y = photo.y + photo.height + 5;
		}
		
		private function onRetakePhoto(e:Event):void {
			Main.state.setView(Main.portraitPage);
		}
		
		private function onSave(e:Event):void {
			
			
			
			Utilities.saveImageToDisk(photo, "bla");
			
			Main.state.setView(Main.resultsPage);
		}
		
	}
}
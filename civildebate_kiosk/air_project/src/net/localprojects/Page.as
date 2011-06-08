package net.localprojects {
	import flash.display.Sprite;

	// basic class for views
	
	
	public class Page extends Sprite {
		
		
		private var titleText:FixedLabel;
		
		public function Page() {
			super();
			titleText = null;
	
		}
		
		private function setTitle(text:String) {
		
			
			
			
			if (titleText == null) {
				titleText = new FixedLabel(text);
			}
			else {
				titleText.setText(text);
			}
		}
		
		
	}
}
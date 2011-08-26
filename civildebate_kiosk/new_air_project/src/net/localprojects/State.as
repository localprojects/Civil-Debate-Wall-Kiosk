package net.localprojects {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	
	public class State extends Object {
		
		public var activeQuestion:String = '4e2755b50f2e420354000001'; // TODO load from server
		
		public var activeDebate:String = null;
		public var nextDebate:String = null;
		public var previousDebate:String = null;		
		
		public var userStance:String = 'yes';
		public var userName:String = '';
		public var userOpinion:String = '';
		public var userPhoneNumber:String = '#########';
		public var userID:String = '';
		public var userImage:Bitmap = new Bitmap(new BitmapData(1080, 1920));
		public var latestSMSID:String = '';
		
		
		// adds exclamation point
		public var activeStanceText:String = '';
		public var userStanceText:String = '';
		public var nextStanceText:String = '';
		public var previousStanceText:String = '';
		
		
		// color state
		public var userStanceColorLight:uint;
		public var userStanceColorMedium:uint;
		public var userStanceColorDark:uint;
		public var userStanceColorOverlay:uint;
		
		public var activeStanceColorLight:uint;
		public var activeStanceColorMedium:uint;
		public var activeStanceColorDark:uint;
		public var activeStanceColorOverlay:uint;
		
		public var nextStanceColorLight:uint;
		public var nextStanceColorMedium:uint;
		public var nextStanceColorDark:uint;
		public var nextStanceColorOverlay:uint;
		
		public var previousStanceColorLight:uint;
		public var previousStanceColorMedium:uint;
		public var previousStanceColorDark:uint;
		public var previousStanceColorOverlay:uint;				
		
		
		public function clearUser():void {
			userID = '';
			userName = '';
			userImage = new Bitmap(new BitmapData(1920, 1080));
			userPhoneNumber = '';
			userOpinion = '';
		}
		
		public function setStance(s:String):void {
			userStance = s;
			
			userStanceText = formatStanceText(userStance);			
			
			if (userStance == 'yes') {
				userStanceColorLight = Assets.COLOR_YES_LIGHT;
				userStanceColorMedium = Assets.COLOR_YES_MEDIUM;
				userStanceColorDark = Assets.COLOR_YES_DARK;
				userStanceColorOverlay = Assets.COLOR_YES_OVERLAY;				
			}
			else {
				userStanceColorLight = Assets.COLOR_NO_LIGHT;
				userStanceColorMedium = Assets.COLOR_NO_MEDIUM;
				userStanceColorDark = Assets.COLOR_NO_DARK;
				userStanceColorOverlay = Assets.COLOR_NO_OVERLAY;
			}
		}
		
		public function setActiveDebate(debateID:String):void {
			activeDebate = debateID;
			nextDebate = CDW.database.getNextDebate();
			previousDebate = CDW.database.getPreviousDebate();
			
			// set stance text
			activeStanceText = formatStanceText(CDW.database.debates[activeDebate].stance);
						
			// set colors
			if (CDW.database.debates[activeDebate].stance == 'yes') {		
				activeStanceColorLight = Assets.COLOR_YES_LIGHT;
				activeStanceColorMedium = Assets.COLOR_YES_MEDIUM;
				activeStanceColorDark = Assets.COLOR_YES_DARK;
				activeStanceColorOverlay = Assets.COLOR_YES_OVERLAY;				
			}
			else {
				activeStanceColorLight = Assets.COLOR_NO_LIGHT;
				activeStanceColorMedium = Assets.COLOR_NO_MEDIUM;
				activeStanceColorDark = Assets.COLOR_NO_DARK;
				activeStanceColorOverlay = Assets.COLOR_NO_OVERLAY;
			}
			
			
			if(nextDebate != null) {
				nextStanceText = formatStanceText(CDW.database.debates[nextDebate].stance);				
				
				if (CDW.database.debates[nextDebate].stance == 'yes') {			
					nextStanceColorLight = Assets.COLOR_YES_LIGHT;
					nextStanceColorMedium = Assets.COLOR_YES_MEDIUM;
					nextStanceColorDark = Assets.COLOR_YES_DARK;
					nextStanceColorOverlay = Assets.COLOR_YES_OVERLAY;				
				}
				else {
					nextStanceColorLight = Assets.COLOR_NO_LIGHT;
					nextStanceColorMedium = Assets.COLOR_NO_MEDIUM;
					nextStanceColorDark = Assets.COLOR_NO_DARK;
					nextStanceColorOverlay = Assets.COLOR_NO_OVERLAY;
				}
			}
			
			if(previousDebate != null) {
				previousStanceText = formatStanceText(CDW.database.debates[previousDebate].stance);
				
				if (CDW.database.debates[previousDebate].stance == 'yes') {			
					nextStanceColorLight = Assets.COLOR_YES_LIGHT;
					nextStanceColorMedium = Assets.COLOR_YES_MEDIUM;
					nextStanceColorDark = Assets.COLOR_YES_DARK;
					nextStanceColorOverlay = Assets.COLOR_YES_OVERLAY;				
				}
				else {
					nextStanceColorLight = Assets.COLOR_NO_LIGHT;
					nextStanceColorMedium = Assets.COLOR_NO_MEDIUM;
					nextStanceColorDark = Assets.COLOR_NO_DARK;
					nextStanceColorOverlay = Assets.COLOR_NO_OVERLAY;
				}
			}			
						

			trace("Prev: " + previousDebate);
			trace("Active: " + activeDebate);
			trace("Next: " + nextDebate);
		}
		
		private function formatStanceText(s:String):String {
			return s.toUpperCase() + '!';
		}
		
		public function State()	{
		
		}
	}
}
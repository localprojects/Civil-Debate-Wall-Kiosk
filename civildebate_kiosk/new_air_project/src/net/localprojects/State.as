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
		
		public function clearUser():void {
			userID = '';
			userName = '';
			userImage = new Bitmap(new BitmapData(1920, 1080));
			userPhoneNumber = '';
			userOpinion = '';
		}
		
		public function setActiveDebate(debateID:String):void {
			activeDebate = debateID;
			nextDebate = CDW.database.getNextDebate();
			previousDebate = CDW.database.getPreviousDebate();
			
			trace("Prev: " + previousDebate);
			trace("Active: " + activeDebate);
			trace("Next: " + nextDebate);
		}
		
		public function State()	{
		
		}
	}
}
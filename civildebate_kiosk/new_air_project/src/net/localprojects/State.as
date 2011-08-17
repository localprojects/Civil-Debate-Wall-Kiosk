package net.localprojects {
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	
	public class State extends Object {
		
		public var activeQuestion:String = '4e2755b50f2e420354000001';
		
		public var activeDebate:String = '4e2756a20f2e420341000000';
		
		public var nextDebate:String = '';
		public var previousDebate:String = '';		
		
		
		
		
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
		
		public function State()	{
		
		}
	}
}
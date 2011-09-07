package com.civildebatewall.data {
	
	import com.civildebatewall.Assets;
	import com.civildebatewall.CDW;
	
	public class Post extends Object {
		
		public static const ORIGIN_KIOSK:String = 'kiosk';
		public static const ORIGIN_WEB:String = 'web';
		
		public static const STANCE_YES:String = 'yes';
		public static const STANCE_NO:String = 'no';		
		
		private var _id:String;
		private var _likes:uint;
		private var _flags:uint;	
		private var _stance:String;
		private var _origin:String;				
		private var _text:String;
		private var _user:User;
		private var _created:Date;
		
		public var stanceColorLight:uint;
		public var stanceColorMedium:uint;
		public var stanceColorDark:uint;
		public var stanceColorOverlay:uint;
		public var stanceColorDisabled:uint;
		public var stanceColorExtraLight:uint;

		// link back to thread, too?
		
		public function Post(jsonObject:Object)	{
			_id = jsonObject['id'];
			_stance = jsonObject['yesNo'] ? STANCE_NO : STANCE_YES; // todo use static const?
			_flags = jsonObject['flags'];
			_likes = jsonObject['likes'];
			_text = jsonObject['text'];
			_origin = ORIGIN_KIOSK; // todo support other origins
			_user = CDW.database.getUserByID(jsonObject['author']['id']);
			_created = new Date(jsonObject['created']['$date']);
			
			if (stance == STANCE_YES) {
				stanceColorExtraLight = Assets.COLOR_YES_EXTRA_LIGHT;
				stanceColorLight = Assets.COLOR_YES_LIGHT;
				stanceColorMedium = Assets.COLOR_YES_MEDIUM;
				stanceColorDark = Assets.COLOR_YES_DARK;
				stanceColorOverlay = Assets.COLOR_YES_OVERLAY;
				stanceColorDisabled = Assets.COLOR_YES_DISABLED;
			}
			else {
				stanceColorExtraLight = Assets.COLOR_NO_EXTRA_LIGHT;				
				stanceColorLight = Assets.COLOR_NO_LIGHT;
				stanceColorMedium = Assets.COLOR_NO_MEDIUM;
				stanceColorDark = Assets.COLOR_NO_DARK;
				stanceColorOverlay = Assets.COLOR_NO_OVERLAY;
				stanceColorDisabled = Assets.COLOR_NO_DISABLED;
			}
			
			// anything else? capitalization... dates
		}

		public function get id():String	{ return _id;	}
		public function get likes():uint{	return _likes; }
		public function get flags():uint { return _flags; }
		public function get stance():String { return _stance;	}		
		public function get origin():String{ return _origin; }				
		public function get text():String{ return _text; }		
		public function get user():User {	return _user;	}
		public function get created():Date { return _created; }
		
	}
}	
package com.civildebatewall.data {
	
	import com.civildebatewall.Assets;
	import com.civildebatewall.CDW;
	import com.civildebatewall.Utilities;
		
	
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
		public var stanceColorWatermark:uint;
		
		public var stanceFormatted:String;

		// link back to thread, too?
		
		public function Post(jsonObject:Object)	{
			_id = jsonObject['id'];
			_stance = jsonObject['yesNo'] ? STANCE_NO : STANCE_YES; // todo use static const?
			_flags = jsonObject['flags'];
			_likes = jsonObject['likes'];
			_text = jsonObject['text'];
			_origin = ORIGIN_KIOSK; // todo support other origins
			_user = CDW.database.getUserByID(jsonObject['author']['id']);
			_created = new Date(jsonObject['created']);
			
			
			// A bunch of conveniences
			if (stance == STANCE_YES) {
				stanceColorExtraLight = Assets.COLOR_YES_EXTRA_LIGHT;
				stanceColorLight = Assets.COLOR_YES_LIGHT;
				stanceColorMedium = Assets.COLOR_YES_MEDIUM;
				stanceColorDark = Assets.COLOR_YES_DARK;
				stanceColorOverlay = Assets.COLOR_YES_OVERLAY;
				stanceColorDisabled = Assets.COLOR_YES_DISABLED;
				stanceColorWatermark = Assets.COLOR_YES_WATERMARK;				
			}
			else {
				stanceColorExtraLight = Assets.COLOR_NO_EXTRA_LIGHT;				
				stanceColorLight = Assets.COLOR_NO_LIGHT;
				stanceColorMedium = Assets.COLOR_NO_MEDIUM;
				stanceColorDark = Assets.COLOR_NO_DARK;
				stanceColorOverlay = Assets.COLOR_NO_OVERLAY;
				stanceColorDisabled = Assets.COLOR_NO_DISABLED;
				stanceColorWatermark = Assets.COLOR_NO_WATERMARK;				
			}
			
			stanceFormatted = _stance.toUpperCase() + '!';			
			
			// anything else? capitalization... dates
		}

		public function get id():String	{ return _id;	}
		
		public function get likes():uint{	return _likes; }
		public function set likes(n:uint):void { _likes = n; }

		
		
		public function incrementLikes():void {
			Utilities.postRequest(CDW.settings.serverPath + '/api/posts/' + _id + '/like', {}, onLikeUpdated);						
		}
		
		private function onLikeUpdated(r:Object):void {
			trace("likes updated server side for post " + _id);
			// TODo bring it back down
		}
		
		public function incrementFlags():void {
			Utilities.postRequest(CDW.settings.serverPath + '/api/posts/' + _id + '/flag', {}, onFlagUpdated);						
		}		
		
		private function onFlagUpdated(r:Object):void {
			trace("flags updated server side for post " + _id);
			// TODo bring it back down
		}
		
		
		public function get flags():uint { return _flags; }
		public function get stance():String { return _stance;	}		
		public function get origin():String{ return _origin; }				
		public function get text():String{ return _text; }		
		public function get user():User {	return _user;	}
		public function get created():Date { return _created; }
		
		
	}
}	
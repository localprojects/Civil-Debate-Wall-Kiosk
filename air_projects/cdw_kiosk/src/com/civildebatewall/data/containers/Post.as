package com.civildebatewall.data.containers {
	
	import com.civildebatewall.Assets;
	import com.civildebatewall.CivilDebateWall;
	import com.kitschpatrol.futil.utilitites.DateUtil;
	
	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.getLogger;

	public class Post {
		
		private static const logger:ILogger = getLogger(Post);	
		
		public static const ORIGIN_KIOSK:String = "kiosk";
		public static const ORIGIN_WEB:String = "web";
		
		public static const STANCE_YES:String = "yes";
		public static const STANCE_NO:String = "no";	
		
		private var _id:String;
		private var _likes:uint;
		private var _flags:uint;	
		private var _stance:String;
		private var _origin:String;				
		private var _text:String;
		private var _user:User;
		private var _created:Date;
		private var _thread:Thread;

		private var userID:String; // Temp
		public var responseToID:String; // Temp, This turns into responseTo Post object, accessible through getter		
		
		// Just for convenience
		public var stanceColorLight:uint;
		public var stanceColorMedium:uint;
		public var stanceColorDark:uint;
		public var stanceColorOverlay:uint;
		public var stanceColorDisabled:uint;
		public var stanceColorExtraLight:uint;
		public var stanceColorWatermark:uint;
		public var stanceColorHighlight:uint;

		public function Post(jsonObject:Object, parentThread:Thread = null)	{
			_id = jsonObject["id"];
			_stance = jsonObject["yesNo"] ? STANCE_YES : STANCE_NO;
			_flags = jsonObject["flags"];
			_likes = jsonObject["likes"];
			_text = jsonObject["text"];
			_origin = jsonObject["origin"];
			_user = null;
			_created = DateUtil.parseJsonDate(jsonObject["created"]);
			_thread = parentThread;
			
			userID = jsonObject["author"]["id"];
			responseToID = jsonObject["responseTo"];
			
			// A bunch of conveniences
			if (stance == STANCE_YES) {
				stanceColorExtraLight = Assets.COLOR_YES_EXTRA_LIGHT;
				stanceColorLight = Assets.COLOR_YES_LIGHT;
				stanceColorMedium = Assets.COLOR_YES_MEDIUM;
				stanceColorDark = Assets.COLOR_YES_DARK;
				stanceColorOverlay = Assets.COLOR_YES_OVERLAY;
				stanceColorDisabled = Assets.COLOR_YES_DISABLED;
				stanceColorWatermark = Assets.COLOR_YES_WATERMARK;
				stanceColorHighlight = Assets.COLOR_YES_HIGHLIGHT;
			}
			else if (stance == STANCE_NO) {
				stanceColorExtraLight = Assets.COLOR_NO_EXTRA_LIGHT;				
				stanceColorLight = Assets.COLOR_NO_LIGHT;
				stanceColorMedium = Assets.COLOR_NO_MEDIUM;
				stanceColorDark = Assets.COLOR_NO_DARK;
				stanceColorOverlay = Assets.COLOR_NO_OVERLAY;
				stanceColorDisabled = Assets.COLOR_NO_DISABLED;
				stanceColorWatermark = Assets.COLOR_NO_WATERMARK;
				stanceColorHighlight = Assets.COLOR_NO_HIGHLIGHT;				
			}
			else {
				logger.error("Invalid stance \"" + stance + "\"");
			}

		}

		public function get id():String	{ return _id;	}
		public function get likes():uint {	return _likes; }
		public function set likes(n:uint):void { _likes = n; }
		public function get flags():uint { return _flags; }
		public function get stance():String { return _stance;	}
		public function get opposingStance():String { return (_stance == Post.STANCE_YES) ? Post.STANCE_NO : Post.STANCE_YES; }
		public function get origin():String { return _origin; }				
		public function get text():String { return _text; }
		public function get user():User {	return _user;	}
		public function set user(user:User):void { _user = user; }		
		public function get created():Date { return _created; }
		public function get responseTo():Post {	return (responseToID != null) ? CivilDebateWall.data.getPostByID(responseToID) : null; }
		public function get thread():Thread { return _thread; }
		
		public function get textAt():String {
			if (responseTo != null) {
				logger.info("Text is @");
				return "@" + responseTo.user.usernameFormatted + " " +  _text;
			}
			return 	_text;
		}				
		
	}
}	
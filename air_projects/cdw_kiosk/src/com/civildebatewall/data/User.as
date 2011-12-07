package com.civildebatewall.data {
	
	import com.civildebatewall.Assets;
	import com.civildebatewall.CivilDebateWall;
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.ImageLoader;
	import com.greensock.loading.LoaderMax;
	import com.greensock.loading.display.ContentDisplay;
	import com.kitschpatrol.futil.utilitites.StringUtil;
	
	import flash.display.Bitmap;
	import flash.display.PixelSnapping;
	import flash.filesystem.File;
	
	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.getLogger;
	
	public class User extends Object {
		
		private static const logger:ILogger = getLogger(User);		
		
		private var _username:String;
		private var _phoneNumber:String;
		private var _id:String;
		private var _photo:Bitmap;
		// TODO more photo sizes?
		
		public function User(jsonObject:Object) 	{
			_username = jsonObject["username"];
			_phoneNumber = jsonObject["phoneNumber"]
			_id = jsonObject["id"];
			_photo = Assets.portraitPlaceholder; // assume placeholder
			
			// try to load portrait
			var imageFile:File = new File(CivilDebateWall.settings.imagePath + "kiosk/" + _id + ".jpg");
			
			if (imageFile.exists) {
				// load the portrait, estimate it at 150k
				logger.info("Loading photo for " + _username + " from " + imageFile.url + "...");
				CivilDebateWall.data.photoQueue.append(new ImageLoader(imageFile.url, {name: _id, estimatedBytes: 15000, onComplete: onImageLoaded}));
			}
			else {
				logger.info("No photo found, using placeholder for " + _username + " (" + _id + ")");
			}
		}
		
		//private function onImageLoaded(e:LoaderEvent):void {
		private function onImageLoaded(e:LoaderEvent):void {
			logger.info("...Loaded image for " + _username + " (" + _id + ")");
			_photo = new Bitmap(((LoaderMax.getContent(_id) as ContentDisplay).rawContent as Bitmap).bitmapData, PixelSnapping.AUTO, true);
		
			// search and update, use some kind of bitmap binding instead?
			// wallsaver, updates through data once	
			// carousell
			CivilDebateWall.kiosk.debateStrip.updateUserPhoto(this);
			
			// main portrait
			if (CivilDebateWall.state.activeThread.firstPost.user == this) {
				CivilDebateWall.kiosk.portrait.setImage(_photo);
			}
			
			// stats?
			if (CivilDebateWall.state.superlativePost.user == this) {
				CivilDebateWall.kiosk.statsOverlay.superlativesPortrait.portrait.setImage(_photo);
			}
			
			// Update comment thumbs. (Otherwise, they're updated on tween in.)
			if (CivilDebateWall.state.activeView == CivilDebateWall.kiosk.threadView) {
				for (var i:int = 0; i < CivilDebateWall.state.activeThread.posts.length; i++) {
					if (CivilDebateWall.state.activeThread.posts[i].user.id == _id) {
						// We're in this thread
						logger.info("Latest loaded photo is in the active thread  overlay browser, refreshing the browser");
						CivilDebateWall.kiosk.threadOverlayBrowser.refreshContent();		
						break;
					}
				}
			}

			// generate thumbnails for web... uncomment this to run the batch
			/*
			// web full
			var webFull:Bitmap = new Bitmap(new BitmapData(550, 650, false));
			webFull.bitmapData.copyPixels(BitmapUtil.scaleDataToFill(_photo.bitmapData, 550, 978), new Rectangle(0, 51, 550, 650), new Point(0, 0));
			FileUtil.saveJpeg(webFull, CivilDebateWall.settings.imagePath + "web/", _id + ".jpg");
			
			// web thumb
			var webThumb:Bitmap = new Bitmap(new BitmapData(71, 96, false));
			webThumb.bitmapData.copyPixels(BitmapUtil.scaleDataToFill(_photo.bitmapData, 118, 210), new Rectangle(24, 35, 71, 96), new Point(0, 0));
			FileUtil.saveJpeg(webThumb, CivilDebateWall.settings.imagePath + "thumbnails/", _id + ".jpg");			
			*/
		}
		
		public function get username():String {	return _username;	}
		public function get phoneNumber():String { return _phoneNumber; }		
		public function get id():String { return _id; }				
		public function get photo():Bitmap { return _photo;	}
		public function get usernameFormatted():String { return StringUtil.capitalize(_username); }		
		
	}
}
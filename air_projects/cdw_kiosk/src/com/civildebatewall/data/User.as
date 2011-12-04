package com.civildebatewall.data {
	
	import com.civildebatewall.Assets;
	import com.civildebatewall.CivilDebateWall;
	import com.demonsters.debugger.MonsterDebugger;
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.ImageLoader;
	import com.greensock.loading.LoaderMax;
	import com.greensock.loading.display.ContentDisplay;
	import com.kitschpatrol.futil.utilitites.StringUtil;
	
	import flash.display.Bitmap;
	import flash.display.PixelSnapping;
	import flash.filesystem.File;
	
	public class User extends Object {
		
		private var _username:String;
		private var _phoneNumber:String;
		private var _id:String;
		private var _photo:Bitmap;
		// TODO more photo sizes
		
		public function User(jsonObject:Object) 	{
			_username = jsonObject['username'];
			_phoneNumber = jsonObject['phoneNumber']
			_id = jsonObject['id'];
			_photo = Assets.portraitPlaceholder;
			
			// try to load portrait 
			// then load at leisure, "data" is all here
			var imageFile:File = new File(CivilDebateWall.settings.imagePath + _id + '.jpg');
			
			if (imageFile.exists) {
				// load the portrait, estimate it at 150k
				trace('Loading image from file for ' + _username + "\t(" + _id + ")");
				// TEMP off for performance
				//CivilDebateWall.data.photoQueue.append(new ImageLoader(imageFile.url, {name: _id, estimatedBytes: 150000, onComplete: onImageLoaded}) );
			}
			else {
				trace('Using placeholder for ' + _username + "\t(" + _id + ")");
			}
		}
		
		private function onImageLoaded(e:LoaderEvent):void {
			trace("Loaded image for " + _username);
			_photo = new Bitmap(((LoaderMax.getContent(_id) as ContentDisplay).rawContent as Bitmap).bitmapData, PixelSnapping.AUTO, true);
			
			// search and update, use some kind of bitmap binding instead?
			// wallsaver
			if (!CivilDebateWall.wallSaver.timeline.active) {
				CivilDebateWall.wallSaver.rebuildFaceGrid();
			}
			
			// carousell
			CivilDebateWall.kiosk.view.debateStrip.updateUserPhoto(this);
			
			// main portrait
			if (CivilDebateWall.state.activeThread.firstPost.user == this) {
				CivilDebateWall.kiosk.view.portrait.setImage(_photo);
			}
			
			// stats?
			if (CivilDebateWall.state.superlativePost.user == this) {
				CivilDebateWall.kiosk.view.statsOverlay.superlativesPortrait.portrait.setImage(_photo);
			}
		}
		
		
		// TODO set photo...
		// TODo save photo...
		public function get username():String {	return _username;	}
		public function get phoneNumber():String { return _phoneNumber; }		
		public function get id():String { return _id; }				
		public function get photo():Bitmap { return _photo;	}
		public function get usernameFormatted():String { return StringUtil.capitalize(_username); }		
		
		
	}
}
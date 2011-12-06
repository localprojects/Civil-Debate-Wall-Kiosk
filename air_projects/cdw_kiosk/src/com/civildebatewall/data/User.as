package com.civildebatewall.data {
	
	import com.civildebatewall.Assets;
	import com.civildebatewall.CivilDebateWall;
	import com.demonsters.debugger.MonsterDebugger;
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.ImageLoader;
	import com.greensock.loading.LoaderMax;
	import com.greensock.loading.display.ContentDisplay;
	import com.kitschpatrol.futil.utilitites.BitmapUtil;
	import com.kitschpatrol.futil.utilitites.FileUtil;
	import com.kitschpatrol.futil.utilitites.StringUtil;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.PixelSnapping;
	import flash.filesystem.File;
	import flash.geom.Point;
	import flash.geom.Rectangle;
	
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
			var imageFile:File = new File(CivilDebateWall.settings.imagePath + "kiosk/" + _id + '.jpg');
			
			if (imageFile.exists) {
				// load the portrait, estimate it at 150k
				MonsterDebugger.trace(null, 'Loading image from file for ' + _username + "\t(" + _id + ")");
				// TEMP off for performance
				//CivilDebateWall.data.photoQueue.append(new ImageLoader(imageFile.url, {name: _id, estimatedBytes: 15000, onComplete: onImageLoaded}) );
				
				FileUtil.loadImageAsync(imageFile.url, onImageLoaded);
				
			}
			else {
				trace('Using placeholder for ' + _username + "\t(" + _id + ")");
			}
		}
		
		//private function onImageLoaded(e:LoaderEvent):void {
		private function onImageLoaded(b:Bitmap):void {
			MonsterDebugger.trace(null, "Loaded image for " + _username + "\t(" + _id + ")");
			//_photo = new Bitmap(((LoaderMax.getContent(_id) as ContentDisplay).rawContent as Bitmap).bitmapData, PixelSnapping.AUTO, true);
			_photo = b;
			
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
			
			// TODO update comment thumbs!


			// generate thumbnails... uncomment this to run the batch
//			// web full
//			var webFull:Bitmap = new Bitmap(new BitmapData(550, 650, false));
//			webFull.bitmapData.copyPixels(BitmapUtil.scaleDataToFill(_photo.bitmapData, 550, 978), new Rectangle(0, 51, 550, 650), new Point(0, 0));
//			FileUtil.saveJpeg(webFull, CivilDebateWall.settings.imagePath + "web/", _id + '.jpg');
//			
//			// web thumb
//			var webThumb:Bitmap = new Bitmap(new BitmapData(71, 96, false));
//			webThumb.bitmapData.copyPixels(BitmapUtil.scaleDataToFill(_photo.bitmapData, 118, 210), new Rectangle(24, 35, 71, 96), new Point(0, 0));
//			FileUtil.saveJpeg(webThumb, CivilDebateWall.settings.imagePath + "thumbnails/", _id + '.jpg');			
		}
		
		
		public function get username():String {	return _username;	}
		public function get phoneNumber():String { return _phoneNumber; }		
		public function get id():String { return _id; }				
		public function get photo():Bitmap { return _photo;	}
		public function get usernameFormatted():String { return StringUtil.capitalize(_username); }		
		
		
	}
}
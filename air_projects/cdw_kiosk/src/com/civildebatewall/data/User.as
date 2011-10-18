package com.civildebatewall.data {
	
	import com.civildebatewall.Assets;
	import com.civildebatewall.CDW;
	import com.civildebatewall.MetaBitmap;
	import com.greensock.events.LoaderEvent;
	import com.greensock.loading.ImageLoader;
	import com.greensock.loading.LoaderMax;
	import com.greensock.loading.display.ContentDisplay;
	import com.kitschpatrol.futil.utilitites.StringUtil;
	
	import flash.display.Bitmap;
	import flash.display.PixelSnapping;
	import flash.display.Sprite;
	import flash.filesystem.File;

	
	public class User extends Object {
		
		private var _username:String;
		private var _phoneNumber:String;
		private var _id:String;
		private var _photo:MetaBitmap;
		
		public function User(jsonObject:Object) 	{
			_username = jsonObject['username'];
			_phoneNumber = jsonObject['phoneNumber']
			_id = jsonObject['id'];
			trace (_id);
				
			// load portrait image, first see if it exists
			var imageFile:File = new File(CDW.settings.imagePath + _id + '.jpg');
			
			if (imageFile.exists) {
				// load the portrait
				trace('Loading image from file for ' + _username);
				CDW.data.photoQueue.append(new ImageLoader(imageFile.url, {name: _id, estimatedBytes:2400, onComplete: onImageLoaded}) );
			}
			else {
				// use placeholder
				trace('Using placeholder for ' + _username);
				_photo = new MetaBitmap(Assets.portraitPlaceholder.bitmapData, PixelSnapping.AUTO, true);
			}			
			
			trace("Loaded user " + _username);
		}
		
		private function onImageLoaded(e:LoaderEvent):void {
			trace("Loaded image for " + _username);
			_photo = new MetaBitmap(((LoaderMax.getContent(_id) as ContentDisplay).rawContent as Bitmap).bitmapData, PixelSnapping.AUTO, true);			
		}
		
		// TODO set photo...
		// TODo save photo...
		public function get username():String {	return _username;	}
		public function get phoneNumber():String { return _phoneNumber; }		
		public function get id():String { return _id; }				
		public function get photo():MetaBitmap { return _photo;	}
		public function get usernameFormatted():String { return StringUtil.capitalize(_username); }		
	}
}
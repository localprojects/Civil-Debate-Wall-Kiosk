package net.localprojects {
	import flash.display.Bitmap;
	import flash.display.Sprite;
	import flash.geom.Matrix;
	import flash.geom.Transform;
	import flash.filesystem.File;
	import flash.filesystem.FileStream;
	import flash.filesystem.FileMode;
	import flash.utils.ByteArray;
	
	import mx.graphics.codec.JPEGEncoder;
	import mx.graphics.codec.PNGEncoder;	
	
	public class Utilities {
		public function Utilities()	{
		}
		
		public static function setRegistrationPoint(s:Sprite, regx:Number, regy:Number, showRegistration:Boolean):void {
			//translate movieclip 
			s.transform.matrix = new Matrix(1, 0, 0, 1, -regx, -regy);
			
			//registration point.
			if (showRegistration)
			{
				var mark:Sprite = new Sprite();
				mark.graphics.lineStyle(1, 0x000000);
				mark.graphics.moveTo(-5, -5);
				mark.graphics.lineTo(5, 5);
				mark.graphics.moveTo(-5, 5);
				mark.graphics.lineTo(5, -5);
				s.parent.addChild(mark);
			}
		}
		
		
		//Format to save the image
		public static const FORMAT_JPEG:uint = 0x00;
		public static const FORMAT_PNG:uint = 0x01;
		
		//Extensions for the file
		private static const EXT_JPEG:String = ".jpg";
		private static const EXT_PNG:String = ".png";		
		
		
		public static function getNewImageFile(ext:String):File {
			//Create a new unique filename based on date/time
			var fileName:String = "image"+getNowTimestamp()+ext;
			
			//Create a reference to a new file on app folder
			//We use resolvepath to get a file object that points to the correct 
			//image folder - [USER]/[Documents]/[YOUR_APP_NAME]/images/
			//it also creates any directory that does not exists in the path
			
			var file:File = File.desktopDirectory.resolvePath(fileName);
			
			trace("saving ");
			trace(file.nativePath);
			
			
			//verify that the file really does not exist
			if (file.exists){
				//if exists , tries to get a new one using recursion
				return getNewImageFile(ext);
			}
			
			return file;
		}	
		
		//Returns a string in the format
		//200831415144243
		private static function getNowTimestamp():String{
			var d:Date = new Date();
			var tstamp:String = d.getFullYear().toString()+d.getMonth()+d.getDate()+d.getHours()+d.getMinutes()+d.getSeconds()+d.getMilliseconds();
			return 	tstamp;			
		}		
		
		
		
		
		public static function saveImageToDisk(bitmap:Bitmap, path:String):void {
			var fl:File = File.desktopDirectory.resolvePath("snapshot.jpg");
				
			//Bytearray of the final image
			var imgByteArray:ByteArray;
				
			//extension to save the file
			var ext:String;
				
			
			switch (format) {
				case FORMAT_JPEG:
					ext = ".jpg";
					var jpgenc:JPEGEncoder = new JPEGEncoder(80);
					imgByteArray = jpgenc.encode(bitmap.bitmapData);
					break;
				case FORMAT_PNG:
					ext = ".png";
					var pngenc:PNGEncoder = new PNGEncoder();
					imgByteArray = pngenc.encode(bitmap.bitmapData);
					break;
			}			
			
			
			// temp always use png
			var format:uint = FORMAT_PNG;

				
				//gets a reference to a new empty image file 
				var file:File = getNewImageFile(ext);
				
				//Use a FileStream to save the bytearray as bytes to the new file
				var fs:FileStream = new FileStream();
				try {
					//open file in write mode
					fs.open(file, FileMode.WRITE);
					//write bytes from the byte array
					fs.writeBytes(imgByteArray);
					//close the file
					fs.close();
				} catch(e:Error) {
					trace(e.message);
				}
			}
			
			
		}
	}

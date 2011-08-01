package net.localprojects {
	import flash.display.*;
	import flash.filesystem.*;
	import flash.geom.*;
	import flash.utils.*;
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
		
		
		// a la processing
		public static function color(r:int, g:int, b:int):uint {
			return r << 16 | g << 8 | b;
		}

		
		
		public static function arrayContains(needle:Object, haystack:Array):Boolean {
			return (haystack.indexOf(needle) > -1);
		}
			
		public static function centerWithin(a:DisplayObject, b:DisplayObject):void {
			a.x = (b.width / 2) - (a.width / 2);
			a.y = (b.height / 2) - (a.height / 2);			
		}
		
		// returns a point at the center of a rectangle
		public static function centerPoint(rect:Rectangle):Point {
			return new Point(rect.x + (rect.width / 2), rect.y + (rect.height / 2));
		}
		
		public static function randRange(low:int, high:int):int {
			return Math.floor(Math.random() * (high - low + 1) + low);			
		}		
		
		public static function getClassName(o:Object):String {
			var fullClassName:String = getQualifiedClassName(o);
			return fullClassName.slice(fullClassName.lastIndexOf("::") + 2);			
		}
		
		public static function averageArray(a:Array):Number {
			var sum:Number = 0;
			
			for (var i:int = 0; i < a.length; i++) {
				sum += a[i];
			}
			
			return sum / a.length;
		}
		
		
		// adapted from http://stackoverflow.com/questions/5350907/merging-objects-in-as3
		// if both objects have the same field, object 2 overrides object 1 
		public static function mergeObjects(o1:Object, o2:Object):Object {
			var o:Object = {};
			
			for(var p1:String in o1)	{
				o[p1] = o1[p1];								
			}
			
			for(var p2:String in o2)	{
				// overwrite with o2
				o[p2] = o2[p2];				
			}
			
			return o;
		}
		
		
		// scales down a bitmap data object so it fits with the width and height specified
		public static function scaleToFit(b:BitmapData, maxWidth:int, maxHeight:int):BitmapData {
			var widthRatio:Number = maxWidth / b.width;
			var heightRatio:Number = maxHeight / b.height;
			var scaleRatio:Number = Math.min(widthRatio, heightRatio);
			
			var matrix:Matrix = new Matrix();
			matrix.scale(scaleRatio, scaleRatio);
			
			var o:BitmapData = new BitmapData(b.width * scaleRatio, b.height * scaleRatio);
			o.draw(b, matrix);
			return o;
		}
		
		// scales down a bitmap data object so it fills the width and height specified, even if it has to crop		
		public static function scaleToFill(b:BitmapData, newWidth:int, newHeight:int):BitmapData {
			// scale
			var widthRatio:Number = newWidth / b.width;
			var heightRatio:Number = newHeight / b.height;
			var scaleRatio:Number = Math.max(widthRatio, heightRatio);
			
			var matrix:Matrix = new Matrix();
			matrix.scale(scaleRatio, scaleRatio);
			
			// crop and center
			matrix.tx = ((b.width * scaleRatio) - newWidth) / -2;
			matrix.ty = ((b.height * scaleRatio) - newHeight) / -2;			
			
			var o:BitmapData = new BitmapData(newWidth, newHeight);
			o.draw(b, matrix);
			return o;
		}			

	}
}

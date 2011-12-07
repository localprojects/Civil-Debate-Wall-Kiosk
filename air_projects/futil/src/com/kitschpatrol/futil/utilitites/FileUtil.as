package com.kitschpatrol.futil.utilitites {
	
	import cmodule.aircall.CLibInit;
	
	import com.kitschpatrol.futil.jpeg.JPEGDecoder;
	
	import flash.display.Bitmap;
	import flash.display.BitmapData;
	import flash.display.Loader;
	import flash.display.PixelSnapping;
	import flash.events.Event;
	import flash.filesystem.File;
	import flash.filesystem.FileMode;
	import flash.filesystem.FileStream;
	import flash.net.URLRequest;
	import flash.utils.ByteArray;
	
	import org.as3commons.logging.api.ILogger;
	import org.as3commons.logging.api.getLogger;
	
	
	// TODO break this out of Main Futil?
	public class FileUtil	{
		
		private static const logger:ILogger = getLogger(FileUtil);
		
		// loads a bitmap, passes it to the callback
		// TODO blocking version version?
		public static function loadImageAsync(path:String, callback:Function):void {
			var file:File = new File(path);
			
			var imageLoader:Loader = new Loader();
			imageLoader.contentLoaderInfo.addEventListener(Event.COMPLETE, function(e:Event):void {
				callback(imageLoader.content as Bitmap);
			});
			
			imageLoader.load(new URLRequest(file.url));
		}
		
		
		public static function createFolderIfNecessary(path:String):void {
			var directory:File = new File(path);
			
			if (!directory.exists) {
				// logger.info("Directory \"" + path + "\" does not exist. Creating it.");
				directory.createDirectory();
			}
		}		
		
		
		// Synchronous!
		public static function loadJpeg(path:String):Bitmap {
			// Uses Alchemy Jpeg Decoder so we can do this synchronously
			// Via Thibault Imbert http://www.bytearray.org/?p=1089			
			
			// Open the file
			var file:File = new File(path);				
			var stream:FileStream = new FileStream();
			stream.open(file, FileMode.READ);
			
			// Copy file stream into byte array
			var imageBytes:ByteArray = new ByteArray();
			stream.readBytes(imageBytes); 
			
			// Clean up
			stream.close();
			
			// Decode JPEG
			var decoder:JPEGDecoder = new JPEGDecoder();
			decoder.parse(imageBytes);
							
			var bitmapData:BitmapData = new BitmapData(decoder.width, decoder.height, false);
			bitmapData.setVector (bitmapData.rect, decoder.pixels);

			return new Bitmap(bitmapData, PixelSnapping.AUTO, true);
		}

					
//		// Synchronous, uses Alchemy for speed
//		public static function saveJpeg(bitmap:Bitmap, path:String, name:String, quality:int = 80):String {
//			var file:File = new File(path + name);
//			logger.info("Saving image to " + file.nativePath);			
//			
//			var encoder:JPEGEncoder = new JPEGEncoder();
//			var bytes:ByteArray = encoder.parse(bitmap.bitmapData, quality);
//			
//			
//			//Use a FileStream to save the bytearray as bytes to the new file
//			var fs:FileStream = new FileStream();
//			try {
//				fs.open(file, FileMode.WRITE);
//				fs.writeBytes(bytes);
//				fs.close();
//			}
//			catch(e:Error) {
//				logger.info(e.message);
//			}
//			
//			return name;
//		}
		
		
		// for passing as arg into the command line app, it needs two forward slashes between folders
		public static function fileToWindowsPath(f:File):String {
			// double the slashes and add trailing
			return f.nativePath.replace("\\", "//") + "//"; // TODO did this get messed up in the grand " to ' conversion?
		}		
		
		// faster jpeg encoding
		// via http://segfaultlabs.com/devlogs/alchemy-asynchronous-jpeg-encoding-2		
		/// init alchemy object
		public static var jpeginit:CLibInit = new CLibInit(); // get library			
		public static var jpeglib:Object = jpeginit.init(); // initialize library exported class to an object					
		
		public static function saveJpeg(bitmap:Bitmap, path:String, name:String, quality:int = 80):String {
			var file:File = new File(path + name);
			
			logger.info("Saving image to " + file.nativePath);
			
			var targetBytes:ByteArray = new ByteArray();
			var sourceBytes:ByteArray = bitmap.bitmapData.getPixels(bitmap.bitmapData.rect);			
			sourceBytes.position = 0; 			
			
			jpeglib.encode(sourceBytes, targetBytes, bitmap.bitmapData.width, bitmap.bitmapData.height, quality);
			
			//Use a FileStream to save the bytearray as bytes to the new file
			var fs:FileStream = new FileStream();
			try {
				//open file in write mode
				fs.open(file, FileMode.WRITE);
				//write bytes from the byte array
				fs.writeBytes(targetBytes);
				//close the file
				fs.close();
			}
			catch(error:Error) {
				logger.error("Image save error: " + error.errorID + " "  + error.message);
			}
			
			return name;
		}			
				

		public static function loadString(path:String):String {
				var file:File = new File(path);				
				var stream:FileStream = new FileStream();
				stream.open(file, FileMode.READ);
				var content:String = stream.readUTFBytes(stream.bytesAvailable);
				stream.close();
				
				return content;
		}
		
		
		// Reads a text file, each line in an array
		public static function loadStrings(path:String):Array {
			return loadString(path).split(/\n/);
		}		
		
		// Writes a string (Synchronous)
		public static function saveString(string:String, path:String):void {
			var file:File;
			file = new File(path);
			
			// TODO save to default location if path is just a name
			
			var stream:FileStream = new FileStream();
			stream.open(file, FileMode.WRITE);
			stream.writeUTFBytes(string);
			stream.close();
		}
		
		
		// Writes an array of lines to a string (Synchronous)
		public static function saveStrings(strings:Array, path:String):void {
			saveString(strings.join("\n"), path);
		}
		
	}
}
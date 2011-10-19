package com.kitschpatrol.futil.utilitites
{
	import com.kitschpatrol.futil.JPEGDecoder;
	import com.kitschpatrol.futil.JPEGEncoder;
	
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
		
	
	
	// TODO break this out of Main Futil?
	public class FileUtil	{
		
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

					
		// Synchronous, uses Alchemy for speed
		public static function saveJpeg(bitmap:Bitmap, path:String, name:String, quality:int = 80):String {
			var file:File = new File(path + name);
			trace("Saving image to " + file.nativePath);			
			
			var encoder:JPEGEncoder = new JPEGEncoder();
			var bytes:ByteArray = encoder.parse(bitmap.bitmapData, quality);
			
			
			//Use a FileStream to save the bytearray as bytes to the new file
			var fs:FileStream = new FileStream();
			try {
				fs.open(file, FileMode.WRITE);
				fs.writeBytes(bytes);
				fs.close();
			}
			catch(e:Error) {
				trace(e.message);
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
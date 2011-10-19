package com.kitschpatrol.futil {
	
	import cmodule.aircall.CLibInit;
	import flash.display.BitmapData;
	import flash.utils.ByteArray;
	
	public final class JPEGEncoder	{
		
		public function JPEGEncoder()	{

		}
		
		public function parse(bitmapData:BitmapData, quality:int = 80):ByteArray {
			
			var targetBytes:ByteArray = new ByteArray();
			var sourceBytes:ByteArray = bitmapData.getPixels(bitmapData.rect);			
			
			sourceBytes.position = 0; 			
			
			// faster jpeg encoding
			// via http://segfaultlabs.com/devlogs/alchemy-asynchronous-jpeg-encoding-2		
			/// init alchemy object
			var jpeginit:CLibInit = new CLibInit(); // get library
			var jpeglib:Object = jpeginit.init(); // initialize library exported class to an object			
			
			jpeglib.encode(sourceBytes, targetBytes, bitmapData.width, bitmapData.height, quality);			
			return targetBytes;
		}
	}
}